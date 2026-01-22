return function(M)
    local UI = {}

    UI.Gui  = assert(M.gui,  "missing module: gui")
    UI.Anim = assert(M.anim, "missing module: anim")
    UI.Comp = assert(M.comp, "missing module: comp")
    UI.Over = assert(M.over, "missing module: over")

    function UI:Init()
        self.Gui:Init()
        self.Over:Init()
    end

    function UI:Tab(name) return self.Gui:CreateTab(name) end
    function UI:Section(tab, title) return self.Gui:Section(tab, title) end

    function UI:Checkbox(parent, ...) return self.Comp:Checkbox(parent, ...) end
    function UI:Button(parent, ...) return self.Comp:Button(parent, ...) end
    function UI:Slider(parent, ...) return self.Comp:Slider(parent, ...) end
    function UI:Dropdown(parent, ...) return self.Comp:Dropdown(parent, ...) end
    function UI:Keybind(parent, ...) return self.Comp:Keybind(parent, ...) end
    function UI:ColorPicker(parent, ...) return self.Comp:ColorPicker(parent, ...) end

    function UI:AddKeybind(name, key, mode)
        return self.Over:AddKeybind(name, key, mode)
    end

    return UI
end
