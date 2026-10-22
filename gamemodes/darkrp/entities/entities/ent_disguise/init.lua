AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('Disguise')
util.AddNetworkString('UnDisguiseSWEP')
util.AddNetworkString('DisguiseMenu')
util.AddNetworkString('NoOpen')
util.AddNetworkString('YesOpen')

ENT.SeizeReward = 250
ENT.WantReason = 'Нелегальный предмет (Маскировка)'

function ENT:Initialize()
	self:SetModel('models/props_c17/SuitCase_Passenger_Physics.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

end

function ENT:Use(pl)

	if pl:IsBanned() then return end
	if !IsValid(self) and pl:GetPos():Distance(self:GetPos()) < 120 then return end

	self:Remove()
	pl:SendLua([[rp.DisguiseMenu()]])
	pl:Give('maskirovka')
end

net.Receive('UnDisguiseSWEP', function(len, pl)
	timer.Destroy(pl:SteamID64())

	if pl:GetNetVar('IsDisguise') == false then
		rp.Notify(pl,NOTIFY_ERROR,'У вас нет маскировки!')
		return false
	end	

	pl:SetNetVar('IsDisguise',false)
	pl:SetModel(pl.MainModel)
	pl:SetNetVar('DisguiseJob', nil)
	pl:SetNetVar('DisguiseTeam', nil)
	rp.Notify(pl,NOTIFY_ERROR,'Вы сняли маскировку.')	
end)

rp.AddCommand('undisguise', function(pl)
	timer.Destroy(pl:SteamID64())

	if pl:GetNetVar('IsDisguise') == false then
		rp.Notify(pl,NOTIFY_ERROR,'У вас нет маскировки!')
		return false
	end	

	pl:SetNetVar('IsDisguise',false)
	pl:SetModel(pl.MainModel)
	pl:SetNetVar('DisguiseJob', nil)
	pl:SetNetVar('DisguiseTeam', nil)
	rp.Notify(pl,NOTIFY_ERROR,'Вы сняли маскировку.')	
end)

net.Receive('NoOpen',function(len,pl)
	local x = net.ReadEntity()
	x:SetNWInt('OpenOrNot',1)
end)

net.Receive('YesOpen',function(len,pl)
	local x = net.ReadEntity()
	x:SetNWInt('OpenOrNot',0)
end)	

net.Receive('Disguise', function(len, pl)
	local DisguiseTime = rp.cfg.DisguiseTime

	if pl:GetNetVar('IsDisguise') == true then
		rp.Notify(pl,NOTIFY_ERROR,'Вы уже используете маскировку!')
		return false
	end

	if pl:IsArrested() or pl:IsBanned() then
		rp.Notify(pl,NOTIFY_ERROR,'У вас нет прав на использование маскировки')
		return false		
	end

	if (pl:Team() == TEAM_ADMIN) then
		return
	end

	if !rp.teams[tonumber(pl:Team())].candisguise then pl:Notify(NOTIFY_ERROR, 'Вы не можете маскироваться за эту работу!') return end

	job = net.ReadString()
	tb = rp.teams[tonumber(job)]

	if tb.name == 'Администратор' then return end

	pl:SetNetVar('DisguiseTime', CurTime() + DisguiseTime)

	pl:SetNetVar('IsDisguise',true)
	pl:SetNetVar('DisguiseJob',job)

	pl.MainModel = pl:GetModel()

	if istable(tb.model) then
		pl:SetModel(table.Random(tb.model))
	else
		pl:SetModel(tb.model)
	end

	rp.Notify(pl,NOTIFY_SUCCESS,'Вы успешно замаскировались!')
end)

hook.Add('PlayerDeath','StopD',function(pl)
	if pl:GetNetVar('IsDisguise') then
		timer.Destroy(pl:SteamID64())
		pl:SetNetVar('IsDisguise',false)
		pl:SetNetVar('DisguiseJob', nil)
		-- pl:SetNetVar('Name',pl.MainName)
	end
end)
