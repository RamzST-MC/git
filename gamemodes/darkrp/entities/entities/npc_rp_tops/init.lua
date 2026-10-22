dash.IncludeCL'cl_init.lua'
dash.IncludeSH'shared.lua'
util.AddNetworkString('rp.LeaderBoard')
util.AddNetworkString('rp.GetScoreEblan')
util.AddNetworkString('rp.SetScoreEblan')
function ENT:Initialize()
	self:SetModel("models/gman_high.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	self:SetMaxYawSpeed(90)
	self:SetTrigger(true)
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') and activator:IsPlayer() then
		local db = rp._Stats
		db:Query('SELECT DISTINCT * FROM player_data ORDER BY money desc LIMIT 0,10', function(data)
			net.Start('rp.LeaderBoard')
			net.WriteTable(data)
			net.Send(activator)
		end)
	end
end