ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.PrintName = 'Money Basket'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.Category = 'RP Printing Devices'
ENT.MaxHealth = 100
ENT.PressE = true
ENT.PressKeyText = 'Взять деньги'

function ENT:SetupDataTables()
    self:NetworkVar('Entity', 1, 'owning_ent')
    self:NetworkVar('Float', 0, 'money')
end