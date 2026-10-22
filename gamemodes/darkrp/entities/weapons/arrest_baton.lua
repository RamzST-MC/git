AddCSLuaFile()

local BaseClass = baseclass.Get('baton_base')

if CLIENT then
	SWEP.PrintName = 'Арестовать'
	SWEP.Instructions = 'Left click to arrest\nRight click to switch to unarrest'
	SWEP.Slot = 3
    SWEP.SlotPos = 1
end

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.Color = Color(255, 0, 0, 255)

function SWEP:PrimaryAttack()
	local own = self.Owner

	if not IsValid(own) then return end

	BaseClass.PrimaryAttack(self)

	if CLIENT then return end

	local ent = self:GetTrace().Entity

	if ent.WantReason and own:IsCP() then
		local owner = ent.ItemOwner

		if (IsValid(owner)) then
			if (not owner:IsWanted()) and (not owner:IsArrested()) then
				owner:Wanted(own, ent.WantReason)
			end
		end

		hook.Call('PlayerArrestedEntity', nil, own, ent, owner)

		ent:Remove()
		own:AddMoney(ent.SeizeReward)
		rp.Notify(own, NOTIFY_SUCCESS, term.Get('ArrestBatonBonus'), rp.FormatMoney(ent.SeizeReward))
		return
	end

	if (not ent:IsPlayer()) then return end
	if (not ent:IsCuffed()) then
		return rp.Notify(own, NOTIFY_ERROR, 'Игрок должен быть в наручниках, чтобы арестовать его.')
	end

	ent:Arrest(own)

	rp.Notify(ent, NOTIFY_ERROR, term.Get('ArrestBatonArrested'), own)
	rp.Notify(own, NOTIFY_SUCCESS, term.Get('ArrestBatonYouArrested'), ent)
	rp.achievements.AddProgress(own, ACHIEVEMENT_COPMAIN, 1)
	rp.achievements.AddProgress(ent, ACHIEVEMENT_ARRESTED, 1)
end