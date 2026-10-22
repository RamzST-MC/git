dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self:SetModel('models/props_combine/combine_intmonitor003.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
	if !rp.teams[activator:Team()].genome then
		rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете изменять геном!')
		return
	end

	activator.def,activator.spe,activator.ata = nil,nil,nil
	net.Start('rp.ApplyGenome')
	net.WriteUInt(30,6)
	net.WriteBool(true)
	net.WriteFloat(10)
	net.Send(activator)
end