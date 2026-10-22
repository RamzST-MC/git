dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.CopshopMenu')

function ENT:Initialize()
	self:SetModel('models/Barney.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') then		-- and activator:IsPlayer() and (activator:IsCP() or activator:IsMayor()) 
		net.Start('rp.CopshopMenu')
		net.Send(activator)
	end
end

hook.Add('InitPostEntity', function()
	local mapData = rp.cfg.CopShops and rp.cfg.CopShops[game.GetMap()]
	if not mapData then
		MsgC(Color(255,165,0), '[CopShop] No CopShop config for map: ' .. game.GetMap() .. '\n')
		return
	end
	local npc = ents.Create('npc_rp_copshop')
	npc:SetPos(mapData.Pos)
	npc:SetAngles(mapData.Ang)
	npc:Spawn()
end)