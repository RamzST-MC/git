dash.IncludeCL 'cl_init.lua'
dash.IncludeCL 'menu_cl.lua'
dash.IncludeSH 'shared.lua'

util.AddNetworkString('rp.GunBuyerMenu')

function ENT:Initialize()
	self:SetModel('models/Humans/Group01/male_03.mdl')

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
	if (input == 'Use') and activator:IsPlayer() then
		net.Start('rp.GunBuyerMenu')
		net.Send(activator)
	end
end

function ENT:StartTouch(ent)
	local owner = ent.GunOwner
	
	if IsValid(ent) and IsValid(owner) then
		local info = ent.GunInfo
		local price = math.Round(info.BuyPrice * .95)
		ent:Remove()
		owner:AddMoney(price)
		rp.Notify(owner, NOTIFY_SUCCESS, 'Вы продали ' .. info.Name .. ' за ' .. rp.FormatMoney(price))
			
		rp.achievements.AddProgress(owner, ACHIEVEMENT_GUNRUNNER, 1)
	end
end

hook.Add('GravGunOnPickedUp', 'rp.gunbuyer.GravGunOnPickedUp', function(pl, ent)
	local tab = rp.WeaponsMap[ent:GetClass()] or rp.WeaponsMap[ent.weaponclass]
	if tab then
		ent.GunOwner = pl
		ent.GunInfo = tab
	end
end)

hook.Add('GravGunOnDropped', 'rp.gunbuyer.GravGunOnDropped', function(pl, ent)
	local tab = rp.WeaponsMap[ent:GetClass()] or rp.WeaponsMap[ent.weaponclass]
	if tab then
		ent.GunOwner = nil
		ent.GunInfo = nil
	end
end)