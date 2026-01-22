local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Gui = {}
Gui.Tabs = {}
Gui.ActiveTab = nil

function Gui:Init()
    local lp = Players.LocalPlayer

    local sg = Instance.new("ScreenGui")
    sg.Name = "UI"
    sg.ResetOnSpawn = false
    sg.Parent = lp:WaitForChild("PlayerGui")

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.fromOffset(640, 420)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(14,14,14)

    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,36)
    top.BackgroundColor3 = Color3.fromRGB(18,18,18)

    local title = Instance.new("TextLabel", top)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1,-12,1,0)
    title.Position = UDim2.fromOffset(12,0)
    title.TextXAlignment = Left
    title.Text = "menu"
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(230,230,230)

    local body = Instance.new("Frame", main)
    body.Position = UDim2.fromOffset(0,36)
    body.Size = UDim2.new(1,0,1,-36)
    body.BackgroundTransparency = 1

    local sidebar = Instance.new("Frame", body)
    sidebar.Size = UDim2.fromOffset(140, body.AbsoluteSize.Y)
    sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)

    local sideList = Instance.new("UIListLayout", sidebar)
    sideList.Padding = UDim.new(0,2)

    local pages = Instance.new("Frame", body)
    pages.Position = UDim2.fromOffset(140,0)
    pages.Size = UDim2.new(1,-140,1,0)
    pages.BackgroundTransparency = 1

    self.Gui = sg
    self.Main = main
    self.Sidebar = sidebar
    self.Pages = pages
end

function Gui:CreateTab(name)
    local tab = {}
    local btn = Instance.new("TextButton", self.Sidebar)
    btn.Size = UDim2.new(1,0,0,32)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.BackgroundColor3 = Color3.fromRGB(22,22,22)

    local page = Instance.new("ScrollingFrame", self.Pages)
    page.Size = UDim2.fromScale(1,1)
    page.CanvasSize = UDim2.fromOffset(0,0)
    page.ScrollBarImageTransparency = 1
    page.Visible = false
    page.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    btn.MouseButton1Click:Connect(function()
        if self.ActiveTab then
            self.ActiveTab.Page.Visible = false
            self.ActiveTab.Button.BackgroundColor3 = Color3.fromRGB(22,22,22)
        end
        self.ActiveTab = tab
        tab.Page.Visible = true
        tab.Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
    end)

    tab.Button = btn
    tab.Page = page

    if not self.ActiveTab then
        self.ActiveTab = tab
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    end

    table.insert(self.Tabs, tab)
    return tab
end

function Gui:Section(tab, titleText)
    local s = Instance.new("Frame", tab.Page)
    s.Size = UDim2.new(1,-10,0,28)
    s.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local t = Instance.new("TextLabel", s)
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(1,-10,0,20)
    t.Position = UDim2.fromOffset(10,4)
    t.TextXAlignment = Left
    t.Text = titleText
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(200,200,200)

    local c = Instance.new("Frame", tab.Page)
    c.Size = UDim2.new(1,-10,0,0)
    c.BackgroundTransparency = 1

    local l = Instance.new("UIListLayout", c)
    l.Padding = UDim.new(0,6)

    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        c.Size = UDim2.new(1,-10,0,l.AbsoluteContentSize.Y)
    end)

    return c
end

return Gui
