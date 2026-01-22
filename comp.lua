local UIS = game:GetService("UserInputService")
local TS  = game:GetService("TweenService")

local Comp = {}

Comp.Theme = {
    Accent    = Color3.fromRGB(55,177,218),
    Bg        = Color3.fromRGB(15,15,15),
    Panel     = Color3.fromRGB(22,22,22),
    Panel2    = Color3.fromRGB(26,26,26),
    Stroke    = Color3.fromRGB(45,45,45),
    Text      = Color3.fromRGB(235,235,235),
    Muted     = Color3.fromRGB(170,170,170)
}

Comp.Font = Enum.Font.Gotham
Comp.FontMono = Enum.Font.RobotoMono

local function tween(o,t,p)
    TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play()
end

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = o
end

local function stroke(o,c)
    local s = Instance.new("UIStroke")
    s.Color = c
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = o
end

function Comp:Label(parent,text)
    local l = Instance.new("TextLabel",parent)
    l.Size = UDim2.new(1,-10,0,18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextXAlignment = Left
    l.TextColor3 = self.Theme.Muted
    l.Font = self.Font
    l.TextSize = 13
    return l
end

function Comp:Button(parent,text,cb)
    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.new(1,-10,0,26)
    b.Text = text
    b.Font = self.Font
    b.TextSize = 14
    b.TextColor3 = self.Theme.Text
    b.BackgroundColor3 = self.Theme.Panel
    corner(b,4)
    stroke(b,self.Theme.Stroke)

    b.MouseEnter:Connect(function()
        tween(b,0.12,{BackgroundColor3=self.Theme.Panel2})
    end)
    b.MouseLeave:Connect(function()
        tween(b,0.12,{BackgroundColor3=self.Theme.Panel})
    end)
    b.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
    return b
end

function Comp:Checkbox(parent,text,def)
    local v = def or false

    local f = Instance.new("Frame",parent)
    f.Size = UDim2.new(1,-10,0,26)
    f.BackgroundColor3 = self.Theme.Panel
    corner(f,4)

    local box = Instance.new("Frame",f)
    box.Size = UDim2.fromOffset(18,18)
    box.Position = UDim2.fromOffset(4,4)
    box.BackgroundColor3 = self.Theme.Bg
    corner(box,4)
    stroke(box,self.Theme.Stroke)

    local fill = Instance.new("Frame",box)
    fill.Size = UDim2.fromScale(1,1)
    fill.BackgroundColor3 = self.Theme.Accent
    fill.Visible = v
    corner(fill,4)

    local l = Instance.new("TextLabel",f)
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(28,0)
    l.Size = UDim2.new(1,-30,1,0)
    l.Text = text
    l.TextXAlignment = Left
    l.TextColor3 = self.Theme.Text
    l.Font = self.Font
    l.TextSize = 14

    local b = Instance.new("TextButton",f)
    b.Size = UDim2.fromScale(1,1)
    b.BackgroundTransparency = 1
    b.Text = ""

    b.MouseButton1Click:Connect(function()
        v = not v
        fill.Visible = v
        tween(fill,0.12,{BackgroundTransparency = v and 0 or 1})
    end)

    return {
        Get=function() return v end,
        Set=function(x) v=x fill.Visible=x end,
        Object=f
    }
end

function Comp:Slider(parent,text,min,max,def)
    local v = def or min

    local f = Instance.new("Frame",parent)
    f.Size = UDim2.new(1,-10,0,38)
    f.BackgroundTransparency = 1

    local l = Instance.new("TextLabel",f)
    l.Size = UDim2.new(1,0,0,14)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Left
    l.TextColor3 = self.Theme.Text
    l.Font = self.Font
    l.TextSize = 13
    l.Text = text..": "..v

    local bar = Instance.new("Frame",f)
    bar.Position = UDim2.fromOffset(0,18)
    bar.Size = UDim2.new(1,0,0,8)
    bar.BackgroundColor3 = self.Theme.Panel
    corner(bar,4)

    local fill = Instance.new("Frame",bar)
    fill.Size = UDim2.new((v-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = self.Theme.Accent
    corner(fill,4)

    local drag = false

    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local x = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            v = math.floor(min+(max-min)*x)
            fill.Size = UDim2.new(x,0,1,0)
            l.Text = text..": "..v
        end
    end)

    return {
        Get=function() return v end,
        Set=function(x)
            v=x
            local k=(x-min)/(max-min)
            fill.Size=UDim2.new(k,0,1,0)
            l.Text=text..": "..x
        end,
        Object=f
    }
end

function Comp:Dropdown(parent,text,list)
    local sel = list[1]
    local open = false

    local f = Instance.new("Frame",parent)
    f.Size = UDim2.new(1,-10,0,26)
    f.BackgroundColor3 = self.Theme.Panel
    corner(f,4)

    local l = Instance.new("TextLabel",f)
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(6,0)
    l.Size = UDim2.new(1,-10,1,0)
    l.TextXAlignment = Left
    l.TextColor3 = self.Theme.Text
    l.Font = self.Font
    l.TextSize = 14
    l.Text = text..": "..sel

    local b = Instance.new("TextButton",f)
    b.Size = UDim2.fromScale(1,1)
    b.BackgroundTransparency = 1
    b.Text = ""

    local listF = Instance.new("Frame",parent)
    listF.Size = UDim2.new(1,-10,0,0)
    listF.BackgroundColor3 = self.Theme.Panel2
    listF.Visible = false
    listF.ClipsDescendants = true
    corner(listF,4)

    local lay = Instance.new("UIListLayout",listF)
    lay.Padding = UDim.new(0,2)

    for _,v in ipairs(list) do
        local o = Instance.new("TextButton",listF)
        o.Size = UDim2.new(1,0,0,22)
        o.Text = v
        o.Font = self.Font
        o.TextSize = 13
        o.TextColor3 = self.Theme.Text
        o.BackgroundColor3 = self.Theme.Panel

        o.MouseButton1Click:Connect(function()
            sel=v
            l.Text=text..": "..v
            open=false
            tween(listF,0.15,{Size=UDim2.new(1,-10,0,0)})
            task.delay(0.15,function() listF.Visible=false end)
        end)
    end

    b.MouseButton1Click:Connect(function()
        open=not open
        listF.Visible=true
        tween(listF,0.15,{Size=open and UDim2.new(1,-10,0,#list*24) or UDim2.new(1,-10,0,0)})
        if not open then
            task.delay(0.15,function() listF.Visible=false end)
        end
    end)

    return {
        Get=function() return sel end,
        Object=f,
        List=listF
    }
end

function Comp:Keybind(parent,text,def)
    local key = def
    local wait = false

    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.new(1,-10,0,26)
    b.Text = text..": "..(key and key.Name or "None")
    b.Font = self.FontMono
    b.TextSize = 13
    b.TextColor3 = self.Theme.Text
    b.BackgroundColor3 = self.Theme.Panel
    corner(b,4)

    b.MouseButton1Click:Connect(function()
        wait=true
        b.Text=text..": ..."
    end)

    UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if wait then
            if i.KeyCode~=Enum.KeyCode.Unknown then
                key=i.KeyCode
                b.Text=text..": "..key.Name
                wait=false
            end
        end
    end)

    return {
        Get=function() return key end,
        Set=function(k) key=k b.Text=text..": "..(k and k.Name or "None") end,
        Object=b
    }
end

function Comp:ColorPicker(parent,text,def)
    local col = def or self.Theme.Accent

    local f = Instance.new("Frame",parent)
    f.Size = UDim2.new(1,-10,0,26)
    f.BackgroundColor3 = self.Theme.Panel
    corner(f,4)

    local l = Instance.new("TextLabel",f)
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(6,0)
    l.Size = UDim2.new(1,-40,1,0)
    l.TextXAlignment = Left
    l.Text = text
    l.Font = self.Font
    l.TextSize = 14
    l.TextColor3 = self.Theme.Text

    local p = Instance.new("Frame",f)
    p.Size = UDim2.fromOffset(18,18)
    p.Position = UDim2.new(1,-22,0.5,-9)
    p.BackgroundColor3 = col
    corner(p,4)
    stroke(p,self.Theme.Stroke)

    p.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            col = Color3.fromHSV(math.random(),1,1)
            p.BackgroundColor3 = col
        end
    end)

    return {
        Get=function() return col end,
        Set=function(c) col=c p.BackgroundColor3=c end,
        Object=f
    }
end

return Comp
