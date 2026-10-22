ENT.Type 				= 'anim'
ENT.Base 				= 'base_rp'
ENT.PrintName 			= 'Mayor Machine'
ENT.Author 				= 'KingofBeast'
ENT.Spawnable 			= true
ENT.Category 			= 'RP'
ENT.PressE 				= true
ENT.NetworkPlayerUse 	= true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Hacker")
end

function ENT:CanHack(hacker)
	return false
end

function ENT:CanUse(pl)
	local isHacker = (pl == self:GetHacker())
	return isHacker or pl:IsMayor()
end