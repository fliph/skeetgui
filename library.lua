local SkeetLib = {
    Themes = { 
        Accent = Color3.fromRGB(55, 177, 218), 
        Background = Color3.fromRGB(12, 12, 12), 
        Sidebar = Color3.fromRGB(18, 18, 18),
        Outline = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Config = {},
    Elements = {},
    Folder = "nahbro_configs"
}

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

-- // ФУНКЦІЯ ВИЗВОЛЕННЯ КУРСОРУ (АНТИ-ТЕПОРТ)
local function ToggleMouse(visible)
    if visible then
        -- Блокуємо камеру, щоб вона не тепала мишу в центр
        CAS:BindAction("MouseUnlock", function() return Enum.ContextActionResult.Sink end, false, unpack(Enum.PlayerActions:GetEnumItems()))
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    else
        -- Повертаємо контроль грі
        CAS:UnbindAction("MouseUnlock")
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        UIS.MouseIconEnabled = false
    end
end

function SkeetLib:UpdateTheme()
    for _, data in pairs(self.Elements) do
        if data.Type == "Accent" then data.Obj.BackgroundColor3 = self.Themes.Accent
        elseif data.Type == "TextAccent" then data.Obj.TextColor3 = self.Themes.Accent end
    end
end

function SkeetLib:SaveConfig(name)
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    writefile(self.Folder.."/"..name..".json", HttpService:JSONEncode(self.Config))
end

function SkeetLib:LoadConfig(name)
    local path = self.Folder.."/"..name..".json"
    if isfile(path) then
        self.Config = HttpService:JSONDecode(readfile(path))
        return true
    end
    return false
end

-- // ВАТЕРМАРКА
local function CreateWatermark(enabled)
    if not enabled then return end
    local WaterGui = Instance.new("ScreenGui", LP.PlayerGui)
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

-- // ІНТРО
local function PlayIntro(enabled, title)
    if not enabled then return end
    local IntroGui = Instance.new("ScreenGui", LP.PlayerGui)
    local Line = Instance.new("Frame", IntroGui)
    Line.Size, Line.Position = UDim2.new(0, 0, 0, 2), UDim2.new(0.5, 0, 0.5, 0)
    Line.BackgroundColor3 = SkeetLib.Themes.Accent
    Line.BorderSizePixel = 0
    
    local T = Instance.new("TextLabel", IntroGui)
    T.Text, T.Font, T.TextSize = title or "nahbro.lua", Enum.Font.Code, 20
    T.TextColor3, T.Position, T.Size = Color3.new(1,1,1), UDim2.new(0.5, -150, 0.5, -30), UDim2.new(0, 300, 0, 20)
    T.BackgroundTransparency, T.TextTransparency = 1, 1

    TS:Create(Line, TweenInfo.new(0.7), {Size = UDim2.new(0, 300, 0, 2), Position = UDim2.new(0.5, -150, 0.5, 0)}):Play()
    task.wait(0.5)
    TS:Create(T, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(1.5)
    IntroGui:Destroy()
end

-- // ВІКНО
function SkeetLib:CreateWindow(options)
    task.spawn(function() PlayIntro(options.Intro, options.Title) end)
    CreateWatermark(options.Watermark)
    
    local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
    ScreenGui.IgnoreGuiInset = true
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 420)
    Main.Position = UDim2.new(0.5, -250, 0.5, -210)
    Main.BackgroundColor3 = self.Themes.Background
    Main.BorderColor3 = Color3.new(0,0,0)
    Main.BorderSizePixel = 2
    Main.Visible = false

    local InnerOutline = Instance.new("Frame", Main)
    InnerOutline.Size = UDim2.new(1, -2, 1, -2)
    InnerOutline.Position = UDim2.new(0, 1, 0, 1)
    InnerOutline.BackgroundColor3 = self.Themes.Background
    InnerOutline.BorderColor3 = self.Themes.Outline
    InnerOutline.BorderSizePixel = 1

    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 5
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

    -- Toggle G
    UIS.InputBegan:Connect(function(i, chat)
        if not chat and i.KeyCode == Enum.KeyCode.G then
            Main.Visible = not Main.Visible
            ToggleMouse(Main.Visible)
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
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)

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
            Page.Visible, TabBtn.TextColor3 = true, Color3.new(1,1,1)
        end)

        local tab_ops = {}
        function tab_ops:CreateToggle(text, id, callback)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -10, 0, 20)
            f.BackgroundTransparency = 1
            
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(0, 12, 0, 12)
            b.Position = UDim2.new(0, 5, 0, 4)
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            b.BorderColor3 = Color3.new(0,0,0)
            b.Text = ""
            
            local l = Instance.new("TextLabel", f)
            l.Text = text
            l.Position = UDim2.new(0, 25, 0, 0)
            l.Size = UDim2.new(1, -30, 1, 0)
            l.TextColor3 = Color3.fromRGB(220, 220, 220)
            l.Font = Enum.Font.Code
            l.TextSize = 13
            l.BackgroundTransparency = 1
            l.TextXAlignment = "Left"

            b.MouseButton1Click:Connect(function()
                SkeetLib.Config[id] = not SkeetLib.Config[id]
                b.BackgroundColor3 = SkeetLib.Config[id] and SkeetLib.Themes.Accent or Color3.fromRGB(35, 35, 35)
                callback(SkeetLib.Config[id])
            end)
        end

        function tab_ops:CreateSlider(text, min, max, id, callback)
            local s_f = Instance.new("Frame", Page)
            s_f.Size = UDim2.new(1, -10, 0, 35)
            s_f.BackgroundTransparency = 1
            
            local l = Instance.new("TextLabel", s_f)
            l.Text = text:lower() .. ": " .. min
            l.Size = UDim2.new(1, 0, 0, 15)
            l.Font, l.TextSize = Enum.Font.Code, 13
            l.TextColor3, l.BackgroundTransparency = Color3.new(1,1,1), 1
            l.TextXAlignment = "Left"

            local bar = Instance.new("TextButton", s_f)
            bar.Size = UDim2.new(1, -20, 0, 6)
            bar.Position = UDim2.new(0, 5, 0, 20)
            bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            bar.BorderColor3 = Color3.new(0,0,0)
            bar.Text = ""

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BorderSizePixel = 0
            table.insert(SkeetLib.Elements, {Obj = fill, Type = "Accent"})

            local function update(input)
                local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor((min + (max - min) * pos) * 10) / 10
                fill.Size = UDim2.new(pos, 0, 1, 0)
                l.Text = text:lower() .. ": " .. val
                callback(val)
            end

            local drag = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true update(i) end end)
            UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
        end
        return tab_ops
    end
    
    -- Драг системи
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
