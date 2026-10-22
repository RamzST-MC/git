--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Seed"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = false
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_weedseeds.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:SetupDataTables()

	// Id to the plant config
	self:NetworkVar("Int", 0, "PlantID")
	self:NetworkVar("Int", 1, "Count")

	if (SERVER) then
		self:SetPlantID(0)
		self:SetCount(zgo2.config.Seedbox.Count)
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
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher