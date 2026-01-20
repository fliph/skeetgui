local SkeetLib = {
    Themes = { 
        Accent = Color3.fromRGB(55, 177, 218), 
        Background = Color3.fromRGB(12, 12, 12), 
        Sidebar = Color3.fromRGB(18, 18, 18),
        Outline = Color3.fromRGB(45, 45, 45)
    },
    Config = {},
    Elements = {}
}

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- // ВАТЕРМАРКА (Жирна версія)
local function CreateWatermark(enabled)
    if not enabled then return end
    local WaterGui = Instance.new("ScreenGui", LP.PlayerGui)
    WaterGui.Name = "nahbro_water"
    local Holder = Instance.new("Frame", WaterGui)
    Holder.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    Holder.BorderSizePixel = 1
    Holder.BorderColor3 = SkeetLib.Themes.Outline
    Holder.Position = UDim2.new(0, 20, 0, 10)
    
    local Line = Instance.new("Frame", Holder)
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.BorderSizePixel = 0
    table.insert(SkeetLib.Elements, {Obj = Line, Type = "Accent"})
    
    local Text = Instance.new("TextLabel", Holder)
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Code
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.TextSize = 13
    
    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1/task.wait())
            Text.Text = string.format(" nahbro.lua | %s | fps: %d ", LP.Name, fps)
            local s = game:GetService("TextService"):GetTextSize(Text.Text, 13, Enum.Font.Code, Vector2.new(1000, 1000))
            Holder.Size = UDim2.new(0, s.X + 10, 0, 24)
        end
    end)
end

-- // ГОЛОВНЕ ВІКНО
function SkeetLib:CreateWindow(options)
    CreateWatermark(options.Watermark)
    
    local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
    ScreenGui.Name = "nahbro_permanent"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 420)
    Main.Position = UDim2.new(0.5, -250, 0.5, -210)
    Main.BackgroundColor3 = self.Themes.Background
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.new(0,0,0)
    Main.Visible = false

    -- MODAL FIX (ЄДИНИЙ РОБОЧИЙ)
    local Modal = Instance.new("TextButton", Main)
    Modal.Size = UDim2.new(1,0,1,0)
    Modal.BackgroundTransparency = 1
    Modal.Text = ""
    Modal.Modal = true

    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    table.insert(self.Elements, {Obj = TopLine, Type = "Accent"})

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 100, 1, -2)
    Sidebar.Position = UDim2.new(0, 0, 0, 2)
    Sidebar.BackgroundColor3 = self.Themes.Sidebar
    Sidebar.BorderSizePixel = 0

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -115, 1, -15)
    Container.Position = UDim2.new(0, 110, 0, 10)
    Container.BackgroundTransparency = 1

    local menu_open = false
    UIS.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.G then
            Main.Visible = not Main.Visible
            menu_open = Main.Visible
            UIS.MouseBehavior = menu_open and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
    end)

    RunService.RenderStepped:Connect(function()
        if menu_open then UIS.MouseBehavior = Enum.MouseBehavior.Default end
    end)

    local lib = {}
    local tabs = 0
    function lib:CreateTab(name)
        tabs = tabs + 1
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = (tabs == 1)
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.Position = UDim2.new(0, 0, 0, (tabs-1)*40)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name:upper()
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextColor3 = Page.Visible and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 13

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1,1,1)
        end)

        local tab_ops = {}
        function tab_ops:CreateToggle(text, id, callback)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -10, 0, 25)
            f.BackgroundTransparency = 1
            local b = Instance.new("TextButton", f)
            b.Size, b.Position = UDim2.new(0, 14, 0, 14), UDim2.new(0, 5, 0, 5)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.Text = ""
            local l = Instance.new("TextLabel", f)
            l.Text, l.Position, l.Size = text, UDim2.new(0, 25, 0, 0), UDim2.new(1, 0, 1, 0)
            l.TextColor3, l.Font, l.TextSize = Color3.new(1,1,1), Enum.Font.Code, 13
            l.BackgroundTransparency, l.TextXAlignment = 1, "Left"

            b.MouseButton1Click:Connect(function()
                SkeetLib.Config[id] = not SkeetLib.Config[id]
                b.BackgroundColor3 = SkeetLib.Config[id] and SkeetLib.Themes.Accent or Color3.fromRGB(40, 40, 40)
                callback(SkeetLib.Config[id])
            end)
        end

        function tab_ops:CreateSlider(text, min, max, id, callback)
            local s_f = Instance.new("Frame", Page)
            s_f.Size = UDim2.new(1, -10, 0, 35)
            s_f.BackgroundTransparency = 1
            local l = Instance.new("TextLabel", s_f)
            l.Text = text:lower() .. ": " .. min
            l.Size, l.Font, l.TextSize = UDim2.new(1, 0, 0, 15), Enum.Font.Code, 13
            l.TextColor3, l.BackgroundTransparency, l.TextXAlignment = Color3.new(1,1,1), 1, "Left"

            local bar = Instance.new("TextButton", s_f)
            bar.Size, bar.Position = UDim2.new(1, -20, 0, 6), UDim2.new(0, 5, 0, 20)
            bar.BackgroundColor3, bar.Text = Color3.fromRGB(40, 40, 40), ""
            local fill = Instance.new("Frame", bar)
            fill.Size, fill.BorderSizePixel = UDim2.new(0, 0, 1, 0), 0
            table.insert(SkeetLib.Elements, {Obj = fill, Type = "Accent"})

            local function update(input)
                local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor((min + (max - min) * pos) * 100) / 100
                fill.Size = UDim2.new(pos, 0, 1, 0)
                l.Text = text:lower() .. ": " .. tostring(val)
                callback(val)
            end
            local dragging = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(i) end end)
            UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end
        return tab_ops
    end
    
    -- DRAG SYSTEM
    local dS, sP, dG
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = true dS = i.Position sP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dG then
        local delta = i.Position - dS
        Main.Position = UDim2.new(sP.X.Scale, sP.X.Offset + delta.X, sP.Y.Scale, sP.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = false end end)

    return lib
end

return SkeetLib
