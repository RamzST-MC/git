ENT.Type 		= 'anim'
ENT.Base 		= 'gambling_machine_base'
ENT.PrintName 	= 'Spin Wheel'
ENT.Spawnable 	= true
ENT.Category 	= 'RP Machines'
ENT.RemoveOnJobChange = true

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)

	self:NetworkVar('Int', 1, 'Roll')
end