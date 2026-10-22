-- "gamemodes\\darkrp\\gamemode\\util\\binds\\binds_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.binds = rp.binds or {}
rp.binds.TooltipBinds = {}
rp.binds.EntityTooltipBinds = {}

local BINDER = FindMetaTable 'Keybind'

function BINDER:SetCustom(val)
    self.Custom = val
    return self
end

function BINDER:IsCustom()
    return self.Custom
end

function BINDER:SetDefaultKey(key)
    self.DefaultKey = key

    return self
end

function BINDER:GetDefaultKey()
    return self.DefaultKey
end

function BINDER:EnableTooltip(bool)
    table.Filter(rp.binds.TooltipBinds, function(e) return e ~= self end)

    if bool then
        rp.binds.TooltipBinds[#rp.binds.TooltipBinds + 1] = self
    end

    return self
end

function BINDER:EnableEntityTooltip(bool)
    table.Filter(rp.binds.EntityTooltipBinds, function(e) return e ~= self end)

    if bool then
        rp.binds.EntityTooltipBinds[#rp.binds.EntityTooltipBinds + 1] = self
    end

    return self
end

function BINDER:ShouldDrawTooltip(bool)
    return true
end

function BINDER:SetShouldDrawTooltip(bool)
    self.ShouldDrawTooltip = bool
    return self
end

function BINDER:SetTooltipText(text)
    self.TooltipText = text
    return self
end

function BINDER:GetTooltipText()
    return self.TooltipText
end

function BINDER:SetGetTooltipText(text)
    self.GetTooltipText = text
    return self
end