local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Over = {}
Over.Items = {}

function Over:Init()
    local lp = Players.LocalPlayer

    local sg = Instance.new("ScreenGui")
    sg.Name = "Overlay"
    sg.ResetOnSpawn = false
    sg.Parent = lp:WaitForChild("PlayerGui")

    self.Gui = sg
    self:Watermark()
    self:Keybinds()
end

function Over:Watermark()
    local f = Instance.new("Frame", self.Gui)
    f.Size = UDim2.fromOffset(260, 22)
    f.Position = UDim2.fromOffset(10, 10)
    f.BackgroundColor3 = Color3.fromRGB(18,18,18)

    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(1,-10,1,0)
    t.Position = UDim2.fromOffset(5,0)
    t.TextXAlignment = Left
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(235,235,235)

    local fps = 0
    local last = tick()
    local frames = 0

    RS.RenderStepped:Connect(function()
        frames += 1
        if tick() - last >= 1 then
            fps = frames
            frames = 0
            last = tick()
        end
        t.Text = "menu | fps: "..fps.." | "..os.date("%H:%M:%S")
    end)

    self.WatermarkFrame = f
end

function Over:Keybinds()
    local f = Instance.new("Frame", self.Gui)
    f.Size = UDim2.fromOffset(180, 0)
    f.Position = UDim2.fromOffset(10, 40)
    f.BackgroundColor3 = Color3.fromRGB(18,18,18)
    f.ClipsDescendants = true
    f.Visible = true

    local list = Instance.new("UIListLayout", f)
    list.Padding = UDim.new(0,2)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.Size = UDim2.fromOffset(180, list.AbsoluteContentSize.Y + 6)
    end)

    self.KeybindFrame = f
end

function Over:AddKeybind(name, key, mode)
    local l = Instance.new("TextLabel", self.KeybindFrame)
    l.Size = UDim2.new(1,-8,0,18)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Left
    l.Font = Enum.Font.RobotoMono
    l.TextSize = 12
    l.TextColor3 = Color3.fromRGB(220,220,220)

    local active = false

    UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == key then
            if mode == "toggle" then
                active = not active
            elseif mode == "hold" then
                active = true
            end
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == key and mode == "hold" then
            active = false
        end
    end)

    RS.RenderStepped:Connect(function()
        if active then
            l.Text = name.." ["..key.Name.."]"
            l.TextTransparency = 0
        else
            l.TextTransparency = 1
        end
    end)

    return {
        Set=function(v) active=v end,
        Get=function() return active end
    }
end

return Over
