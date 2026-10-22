rp.carry = rp.carry or {}

keybind.Add('Carry Item', KEY_G, function(self, a) end)

:EnableTooltip(true)
:EnableEntityTooltip(true)

:SetShouldDrawTooltip(function(self, b)
    if not LocalPlayer():IsCarryingItem() and b and not IsValid(b:GetParent()) then
        return b.CanCarry
    elseif LocalPlayer():IsCarryingItem() then
        return not b
    end
    return false
end)

:SetGetTooltipText(function(self, b)
    return LocalPlayer():IsCarryingItem() and 'Выкинуть' or 'Взять'
end)