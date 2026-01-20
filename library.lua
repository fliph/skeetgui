local SkeetLib = {
    Themes = { 
        Accent = Color3.fromRGB(55, 177, 218), 
        Background = Color3.fromRGB(12, 12, 12), 
        Sidebar = Color3.fromRGB(18, 18, 18) 
    },
    Config = {}
}

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

function SkeetLib:CreateWindow(cfg)
    -- Спрощене інтро (лінія)
    if cfg.Intro then
        task.spawn(function()
            local SG = Instance.new("ScreenGui", LP.PlayerGui)
            local L = Instance.new("Frame", SG)
            L.Size, L.Position, L.BackgroundColor3 = UDim2.new(0,0,0,2), UDim2.new(0.5,0,0.5,0), self.Themes.Accent
            L.BorderSizePixel = 0
            TS:Create(L, TweenInfo.new(0.8), {Size = UDim2.new(0,300,0,2), Position = UDim2.new(0.5,-150,0.5,0)}):Play()
            task.wait(1.2) SG:Destroy()
        end)
    end

    local MainSG = Instance.new("ScreenGui", LP.PlayerGui)
    MainSG.Name = "nahbro_gui"
    MainSG.ResetOnSpawn = false
    MainSG.DisplayOrder = 999
    
    local Main = Instance.new("Frame", MainSG)
    Main.Size, Main.Position = UDim2.new(0, 500, 0, 380), UDim2.new(0.5, -250, 0.5, -190)
    Main.BackgroundColor3, Main.Visible = self.Themes.Background, false
    Main.BorderSizePixel = 0

    -- // ФІКС КУРСОРУ (MODAL БАЙПАС)
    local MouseFix = Instance.new("TextButton", Main)
    MouseFix.Size = UDim2.new(1, 0, 1, 0)
    MouseFix.BackgroundTransparency = 1
    MouseFix.Text = ""
    MouseFix.Modal = true -- Цей рядок "звільняє" мишу від камери гри

    local Container = Instance.new("Frame", Main)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(1, -110, 1, -10), UDim2.new(0, 110, 0, 10), 1

    local Side = Instance.new("Frame", Main)
    Side.Size, Side.BackgroundColor3, Side.BorderSizePixel = UDim2.new(0, 100, 1, 0), self.Themes.Sidebar, 0

    -- Керування меню на G
    UIS.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.G then 
            Main.Visible = not Main.Visible
            -- Повертаємо контроль над мишею
            UIS.MouseBehavior = Main.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
            UIS.MouseIconEnabled = Main.Visible
        end 
    end)

    local lib = {}
    function lib:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size, Page.BackgroundTransparency, Page.Visible = UDim2.new(1,0,1,0), 1, (#Container:GetChildren() == 0)
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        -- Кнопка вкладки
        local TabBtn = Instance.new("TextButton", Side)
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.Position = UDim2.new(0, 0, 0, (#Side:GetChildren() * 40))
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextColor3 = Page.Visible and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1,1,1)
        end)

        local tab_ops = {}
        function tab_ops:CreateToggle(txt, id, cb)
            local f = Instance.new("Frame", Page)
            f.Size, f.BackgroundTransparency = UDim2.new(1,0,0,30), 1
            
            local b = Instance.new("TextButton", f)
            b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0,14,0,14), UDim2.new(0,5,0,8), Color3.fromRGB(40,40,40), ""
            
            local l = Instance.new("TextLabel", f)
            l.Text, l.Position, l.Size, l.TextColor3, l.BackgroundTransparency = txt, UDim2.new(0,25,0,0), UDim2.new(1,0,1,0), Color3.new(1,1,1), 1
            l.Font, l.TextXAlignment = Enum.Font.Code, "Left"

            b.MouseButton1Click:Connect(function()
                SkeetLib.Config[id] = not SkeetLib.Config[id]
                b.BackgroundColor3 = SkeetLib.Config[id] and SkeetLib.Themes.Accent or Color3.fromRGB(40,40,40)
                cb(SkeetLib.Config[id])
            end)
        end

        function tab_ops:CreateSlider(txt, min, max, id, cb)
            local f = Instance.new("Frame", Page)
            f.Size, f.BackgroundTransparency = UDim2.new(1,0,0,40), 1
            
            local l = Instance.new("TextLabel", f)
            l.Text, l.Size, l.TextColor3, l.BackgroundTransparency = txt..": "..min, UDim2.new(1,0,0,20), Color3.new(1,1,1), 1
            l.Font, l.TextXAlignment, l.Position = Enum.Font.Code, "Left", UDim2.new(0,5,0,0)
            
            local bar = Instance.new("TextButton", f)
            bar.Size, bar.Position, bar.BackgroundColor3, bar.Text = UDim2.new(1,-20,0,6), UDim2.new(0,10,0,22), Color3.fromRGB(40,40,40), ""
            
            local fill = Instance.new("Frame", bar)
            fill.Size, fill.BackgroundColor3, fill.BorderSizePixel = UDim2.new(0,0,1,0), SkeetLib.Themes.Accent, 0
            
            local function update(i)
                local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local v = math.floor((min + (max - min) * p) * 10) / 10
                fill.Size = UDim2.new(p, 0, 1, 0)
                l.Text = txt..": "..v
                cb(v)
            end
            
            local d = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true update(i) end end)
            UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
        end
        return tab_ops
    end
    return lib
end
return SkeetLib
