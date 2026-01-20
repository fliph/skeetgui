local SkeetLib = {
    Themes = {
        Accent = Color3.fromRGB(55, 177, 218),
        Background = Color3.fromRGB(12, 12, 12),
        Sidebar = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Config = {},
    Elements = {},
    Folder = "nahbro_configs"
}

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

function SkeetLib:UpdateTheme()
    for _, data in pairs(self.Elements) do
        if data.Type == "Accent" then data.Obj.BackgroundColor3 = self.Themes.Accent end
    end
end

local function PlayIntro(enabled, title)
    if not enabled then return end
    local IntroGui = Instance.new("ScreenGui", LP.PlayerGui)
    IntroGui.DisplayOrder = 2000000
    
    local Line = Instance.new("Frame", IntroGui)
    Line.Size = UDim2.new(0, 0, 0, 2)
    Line.Position = UDim2.new(0.5, 0, 0.5, 0)
    Line.BackgroundColor3 = SkeetLib.Themes.Accent
    Line.BorderSizePixel = 0
    Line.ZIndex = 100

    local Text = Instance.new("TextLabel", IntroGui)
    Text.Text = title or "nahbro.lua"
    Text.Font = Enum.Font.Code
    Text.TextSize = 22
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.Position = UDim2.new(0.5, -150, 0.5, -35)
    Text.Size = UDim2.new(0, 300, 0, 30)
    Text.BackgroundTransparency = 1
    Text.TextTransparency = 1
    Text.ZIndex = 101

    TS:Create(Line, TweenInfo.new(0.8, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, 2), Position = UDim2.new(0.5, -150, 0.5, 0)}):Play()
    task.wait(0.4)
    TS:Create(Text, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(1.5)
    TS:Create(Text, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TS:Create(Line, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    IntroGui:Destroy()
end

function SkeetLib:CreateWindow(options)
    task.spawn(function() PlayIntro(options.Intro, options.Title) end)
    
    local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
    ScreenGui.Name = "nahbro_main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999998
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 400)
    Main.Position = UDim2.new(0.5, -250, 0.5, -200)
    Main.BackgroundColor3 = self.Themes.Background
    Main.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Main.Visible = false
    
    local ModalBtn = Instance.new("TextButton", Main)
    ModalBtn.Size = UDim2.new(0,0,0,0)
    ModalBtn.Modal = true 

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
    Container.Size = UDim2.new(1, -110, 1, -10)
    Container.Position = UDim2.new(0, 110, 0, 10)
    Container.BackgroundTransparency = 1

    UIS.InputBegan:Connect(function(i, chat)
        if not chat and i.KeyCode == Enum.KeyCode.G then
            Main.Visible = not Main.Visible
            UIS.MouseIconEnabled = Main.Visible
            UIS.MouseBehavior = Main.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
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
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.Position = UDim2.new(0, 0, 0, (tabs-1)*40)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextColor3 = Page.Visible and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1,1,1)
        end)

        local tab_ops = {}
        function tab_ops:CreateToggle(text, id, callback)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, 0, 0, 30)
            f.BackgroundTransparency = 1
            
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(0, 14, 0, 14)
            b.Position = UDim2.new(0, 5, 0, 8)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.Text = ""
            
            b.MouseButton1Click:Connect(function()
                SkeetLib.Config[id] = not SkeetLib.Config[id]
                b.BackgroundColor3 = SkeetLib.Config[id] and SkeetLib.Themes.Accent or Color3.fromRGB(40, 40, 40)
                callback(SkeetLib.Config[id])
            end)
        end

        function tab_ops:CreateSlider(text, min, max, id, callback)
            local s_frame = Instance.new("Frame", Page)
            s_frame.Size = UDim2.new(1, 0, 0, 45)
            s_frame.BackgroundTransparency = 1
            
            local lbl = Instance.new("TextLabel", s_frame)
            lbl.Text = text .. ": " .. min
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.Font = Enum.Font.Code
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = "Left"

            local bar = Instance.new("TextButton", s_frame)
            bar.Size = UDim2.new(1, -20, 0, 6)
            bar.Position = UDim2.new(0, 10, 0, 25)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            bar.Text = ""

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BorderSizePixel = 0
            table.insert(SkeetLib.Elements, {Obj = fill, Type = "Accent"})

            local function update(input)
                local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = min + (max - min) * pos
                val = math.floor(val * 10) / 10 -- Округлення до 0.1
                fill.Size = UDim2.new(pos, 0, 1, 0)
                lbl.Text = text .. ": " .. tostring(val)
                callback(val)
            end

            local dragging = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(i) end end)
            UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end
        return tab_ops
    end
    return lib
end
return SkeetLib
