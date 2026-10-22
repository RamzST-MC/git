ENT.Type = 'anim'
ENT.Base = 'pad_base'
ENT.PrintName = 'Biometric Scanner'
ENT.Spawnable = false
ENT.MaxUseDistance = math.huge
function ENT:SetupDataTables()
    self.BaseClass.SetupDataTables(self)
    self:NetworkVar('String', 2, 'Org')
    self:NetworkVar('String', 3, 'Party')
    self:NetworkVar('Bool', 7, 'Access')
end

function ENT:CanHack(a)
    return true
end