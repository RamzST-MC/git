AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Coffee'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/props_junk/garbage_coffeemug001a.mdl'
ENT.ID				= 'Coffee'

local DRUG = {}
DRUG.Name = 'Coffee'
DRUG.Duration = 30

function DRUG:StartHighServer(pl)
	pl:AddHealth(2)
	pl:AddHunger(2)

	pl:EmitSound('vo/npc/male01/moan0' .. math.random(4, 5) .. '.wav')

	pl.DrugOldWalkSpeed = pl.DrugOldWalkSpeed or pl:GetWalkSpeed()
	pl.DrugOldRunSpeed = pl.DrugOldRunSpeed or pl:GetRunSpeed()

	pl:SetWalkSpeed(pl:GetWalkSpeed() * 1.3)
	pl:SetRunSpeed(pl:GetRunSpeed() * 1.3)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	if !IsValid(pl) then return end
	-- GAMEMODE:SetPlayerSpeed(pl, pl.DrugOldWalkSpeed, pl.DrugOldRunSpeed)
	pl:SetWalkSpeed(pl.DrugOldWalkSpeed or rp.cfg.WalkSpeed)
	pl:SetRunSpeed(pl.DrugOldRunSpeed or rp.cfg.RunSpeed)
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
end

RegisterDrug(DRUG)