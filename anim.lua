local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

local Anim = {}

function Anim:Tween(o,t,p,style,dir)
    local tw = TS:Create(
        o,
        TweenInfo.new(
            t or 0.15,
            style or Enum.EasingStyle.Quad,
            dir or Enum.EasingDirection.Out
        ),
        p
    )
    tw:Play()
    return tw
end

function Anim:Fade(o,alpha,t)
    return self:Tween(o,t,{BackgroundTransparency=alpha})
end

function Anim:TextFade(o,alpha,t)
    return self:Tween(o,t,{TextTransparency=alpha})
end

function Anim:Hover(o,from,to)
    o.MouseEnter:Connect(function()
        self:Tween(o,0.12,from)
    end)
    o.MouseLeave:Connect(function()
        self:Tween(o,0.12,to)
    end)
end

function Anim:Pop(o)
    local s = o.Size
    o.Size = UDim2.new(s.X.Scale,s.X.Offset-6,s.Y.Scale,s.Y.Offset-6)
    self:Tween(o,0.12,{Size=s})
end

function Anim:Drag(frame,handle)
    handle = handle or frame
    local dragging,off

    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            off = Vector2.new(
                i.Position.X-frame.AbsolutePosition.X,
                i.Position.Y-frame.AbsolutePosition.Y
            )
        end
    end)

    RS.RenderStepped:Connect(function()
        if dragging then
            local m = game:GetService("UserInputService"):GetMouseLocation()
            frame.Position = UDim2.fromOffset(m.X-off.X,m.Y-off.Y)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)
end

function Anim:Pulse(o,min,max,speed)
    task.spawn(function()
        while o.Parent do
            self:Tween(o,speed,{BackgroundTransparency=min})
            task.wait(speed)
            self:Tween(o,speed,{BackgroundTransparency=max})
            task.wait(speed)
        end
    end)
end

function Anim:Rainbow(o,prop,speed)
    task.spawn(function()
        local h = 0
        while o.Parent do
            h = (h + speed) % 1
            o[prop] = Color3.fromHSV(h,1,1)
            RS.RenderStepped:Wait()
        end
    end)
end

return Anim
