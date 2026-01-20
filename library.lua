-- // nahbro.lua | Skeet Library Ultimate Edition (Fixed Intro)
local SkeetLib = {
    Themes = {
        Accent = Color3.fromRGB(162, 203, 63),
        Background = Color3.fromRGB(12, 12, 12),
        Sidebar = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(200, 200, 200)
    },
    Config = {},
    Folder = "nahbro_configs"
}

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- // 1. СИСТЕМА КОНФІГІВ
function SkeetLib:SaveConfig(name)
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    writefile(self.Folder.."/"..name..".json", HttpService:JSONEncode(self.Config))
end

function SkeetLib:LoadConfig(name)
    local path = self.Folder.."/"..name..".json"
    if isfile(path) then
        self.Config = HttpService:JSONDecode(readfile(path))
    end
end

-- // 2. ВАТЕРМАРКА
local function CreateWatermark(enabled)
    if not enabled then return end
    local WaterGui = Instance.new("ScreenGui", LP.PlayerGui)
    WaterGui.Name = "nahbro_watermark"
    WaterGui.DisplayOrder = 999999
    WaterGui.ResetOnSpawn = false
    
    local Holder = Instance.new("Frame", WaterGui)
    Holder.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    Holder.BorderSizePixel = 1
    Holder.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Holder.Position = UDim2.new(0, 20, 0, 20)
    
    local Line = Instance.new("Frame", Holder)
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.BackgroundColor3 = SkeetLib.Themes.Accent
    Line.BorderSizePixel = 0
    
    local Text = Instance.new("TextLabel", Holder)
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Code
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.TextSize = 13
    
    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1 / task.wait())
            local str = " nahbro.lua | " .. LP.Name .. " | fps: " .. fps .. " "
            Text.Text = str
            local s = game:GetService("TextService"):GetTextSize(str, 13, Enum.Font.Code, Vector2.new(1000, 1000))
            Holder.Size = UDim2.new(0, s.X + 10, 0, 26)
        end
    end)
end

local function PlayIntro(enabled)
    if not enabled then return end
    
    local IntroGui = Instance.new("ScreenGui", LP.PlayerGui)
    IntroGui.Name = "nahbro_intro"
    IntroGui.DisplayOrder = 1000001 -- Найвищий пріоритет
    IntroGui.IgnoreGuiInset = true

    -- Контейнер для центрування
    local Holder = Instance.new("Frame", IntroGui)
    Holder.Size = UDim2.new(1, 0, 1, 0)
    Holder.BackgroundTransparency = 1

    -- Сама лінія
    local Line = Instance.new("Frame", Holder)
    Line.Size = UDim2.new(0, 0, 0, 2)
    Line.Position = UDim2.new(0.5, 0, 0.5, 0)
    Line.BackgroundColor3 = SkeetLib.Themes.Accent
    Line.BorderSizePixel = 0
    Line.ZIndex = 100
    
    -- ТЕКСТ (Який не малювався)
    local Text = Instance.new("TextLabel", Holder)
    Text.Text = "nahbro.lua" -- Можеш змінити на свою назву
    Text.Font = Enum.Font.Code
    Text.TextSize = 20
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.Position = UDim2.new(0.5, -150, 0.5, -30) -- Трохи вище лінії
    Text.Size = UDim2.new(0, 300, 0, 30)
    Text.BackgroundTransparency = 1
    Text.TextTransparency = 1 -- Починаємо з прозорого
    Text.ZIndex = 101

    -- Анімація лінії
    local lineTween = TS:Create(Line, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 2),
        Position = UDim2.new(0.5, -150, 0.5, 0)
    })
    
    -- Анімація тексту (плавна поява)
    local textTween = TS:Create(Text, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        TextTransparency = 0
    })

    lineTween:Play()
    task.wait(0.4) -- Текст з'являється трохи пізніше за лінію
    textTween:Play()
    
    task.wait(1.5) -- Час на помилуватися

    -- Все зникає
    TS:Create(Line, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(Text, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    
    task.wait(0.6)
    IntroGui:Destroy()
end

-- // 4. ГОЛОВНЕ ВІКНО
function SkeetLib:CreateWindow(options)
    task.spawn(function() PlayIntro(options.Intro) end) -- Запуск інтро в окремому потоці
    CreateWatermark(options.Watermark)
    
    local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
    ScreenGui.Name = "nahbro_main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999998
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 380)
    Main.Position = UDim2.new(0.5, -250, 0.5, -190)
    Main.BackgroundColor3 = self.Themes.Background
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Main.Visible = false
    
    -- Modal Fix для курсору
    local ModalBtn = Instance.new("TextButton", Main)
    ModalBtn.Size = UDim2.new(0, 0, 0, 0)
    ModalBtn.Modal = true 
    ModalBtn.Visible = true

    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BackgroundColor3 = self.Themes.Accent
    TopLine.BorderSizePixel = 0

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 100, 1, -2)
    Sidebar.Position = UDim2.new(0, 0, 0, 2)
    Sidebar.BackgroundColor3 = self.Themes.Sidebar
    Sidebar.BorderSizePixel = 0

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -110, 1, -10)
    Container.Position = UDim2.new(0, 110, 0, 10)
    Container.BackgroundTransparency = 1

    -- Керування меню (G)
    UIS.InputBegan:Connect(function(i, chat)
        if chat then return end
        if i.KeyCode == Enum.KeyCode.G then
            Main.Visible = not Main.Visible
            UIS.MouseIconEnabled = Main.Visible
            UIS.MouseBehavior = Main.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
    end)

    local lib = {}
    local tabCount = 0

    function lib:CreateTab(name)
        tabCount = tabCount + 1
        local TabPage = Instance.new("ScrollingFrame", Container)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = (tabCount == 1)
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 5)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.Position = UDim2.new(0, 0, 0, (tabCount-1)*40)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextColor3 = TabPage.Visible and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabPage.Visible = true
            TabBtn.TextColor3 = Color3.new(1,1,1)
        end)

        local tab_ops = {}
        function tab_ops:CreateToggle(text, id, callback)
            local f = Instance.new("Frame", TabPage)
            f.Size = UDim2.new(1, 0, 0, 30)
            f.BackgroundTransparency = 1
            
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(0, 14, 0, 14)
            b.Position = UDim2.new(0, 5, 0, 8)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.Text = ""
            
            local l = Instance.new("TextLabel", f)
            l.Text = text
            l.Position = UDim2.new(0, 25, 0, 0)
            l.Size = UDim2.new(0, 150, 1, 0)
            l.TextColor3 = SkeetLib.Themes.Text
            l.Font = Enum.Font.Code
            l.BackgroundTransparency = 1
            l.TextXAlignment = "Left"

            b.MouseButton1Click:Connect(function()
                SkeetLib.Config[id] = not SkeetLib.Config[id]
                b.BackgroundColor3 = SkeetLib.Config[id] and SkeetLib.Themes.Accent or Color3.fromRGB(40, 40, 40)
                callback(SkeetLib.Config[id])
            end)
        end
        return tab_ops
    end

    -- Драг (перетягування)
    local dragStart, startPos, dragging
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return lib
end

return SkeetLib

