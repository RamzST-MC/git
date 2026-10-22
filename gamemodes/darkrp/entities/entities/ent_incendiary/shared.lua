ENT.Type 		= 'anim'
ENT.PrintName	= 'Incen'
ENT.Author		= 'нек'
ENT.Spawnable 	= false

game.AddParticles 'particles/vman_explosion.pcf'

function ENT:Initialize()
	self:EmitSound('C4.Plant')
end