dash.IncludeCL'cl_init.lua'
dash.IncludeSH'shared.lua'

function ENT:Initialize()
    self:SetModel('models/craphead_scripts/advanced_mayor/props/safe_01.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(pl)
	net.Start('kazna::ask')
	net.WriteEntity(self)
	net.Send(pl)
end
