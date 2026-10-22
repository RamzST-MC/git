AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

dash.IncludeSH'shared.lua'

util.AddNetworkString('rp.OpenBail')
util.AddNetworkString('rp.OpenBailMer')

net.Receive('rp.OpenBailMer', function(len, pl)
	local tbl = {}
	for k, v in ipairs(player.GetAll()) do 
		if v:IsArrested() then
			tbl[#tbl + 1] = v
		end
	end
	
	net.Start('rp.OpenBail')
		net.WriteUInt(#tbl, 8)
		for k, v in ipairs(tbl) do
			net.WriteEntity(v)
			net.WriteUInt(5000, 16)
		end
	net.Send(pl)
end)

function ENT:Initialize()
	self:SetModel('models/props/cs_office/offcorkboarda.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:PhysWake()
end

function ENT:Use(pl)
	local tbl = {}
	for k, v in ipairs(player.GetAll()) do 
		if v:IsArrested() then
			tbl[#tbl + 1] = v
		end
	end
	
	net.Start('rp.OpenBail')
		net.WriteUInt(#tbl, 8)
		for k, v in ipairs(tbl) do
			net.WriteEntity(v)
			net.WriteUInt(5000, 16)
		end
	net.Send(pl)
end

rp.AddCommand('bail', function(pl, targ)
	local exploiter = true
	for k, v in ipairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if IsValid(v) and (v:GetClass() == 'npc_rp_bailer' or (pl:IsMayor() and v:GetClass() == 'mayor_machine')) then
			exploiter = false
			break
		end
	end

	if exploiter then return end

	if (not IsValid(targ)) or (not targ:IsArrested()) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotInJail'), targ)
		return
	end

	if (targ == pl) then
	--	pl:ConCommand('rp 911 Hello I\'m trying to escape from jail please come arrest me!')
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerFuckedBailing'))
		return
	end

	if IsValid(targ) then
		local cost = pl:IsMayor() and 0 or 5000
		pl:TakeMoney(cost)
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('PlayerBailedPlayer'), targ, rp.FormatMoney(cost))
		targ:UnArrest(targ)
		targ:FlashNotify('Новости', term.Get('YouWereBailed'), pl)

		rp.achievements.AddProgress(targ, ACHIEVEMENT_BAILED, 1)

		hook.Call('PlayerBailPlayer', nil, pl, targ, cost)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)