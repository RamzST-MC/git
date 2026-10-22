ENT.Type 		= 'anim'
ENT.PrintName	= 'Picture'
ENT.Author		= 'TravkaCode'
ENT.Base 		= 'base_anim'
ENT.Category 	= 'RP'

ENT.Spawnable	= true

function ENT:SetupDataTables()
	self:NetworkVar('String', 1, 'URL')
end