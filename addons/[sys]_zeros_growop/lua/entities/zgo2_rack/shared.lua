--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Rack"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = false
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_rack.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "RackID")

	if (SERVER) then
		self:SetRackID(1)
	end
end

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end

function ENT:GravGunPickupAllowed( ply )
	return false
end

function ENT:GravGunPunt( ply )
	return false
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher