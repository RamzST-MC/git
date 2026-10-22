AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Milk'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/props_junk/garbage_milkcarton001a.mdl'
ENT.ID				= 'Milk'

local DRUG = {}
DRUG.Name = 'Milk'

function DRUG:StartHighServer(pl)
	pl:AddHealth(50)
	pl:AddHunger(50)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
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