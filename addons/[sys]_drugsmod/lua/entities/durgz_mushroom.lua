
--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: addons/drugsmod/lua/entities/durgz_mushroom.lua ~

]]

/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/ --  saf
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Mushrooms'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/jellik/shroom.mdl'
ENT.ID				= 'Mushroom'

local DRUG = {}
DRUG.Name = 'Mushroom'
DRUG.Duration = 30

function DRUG:StartHighServer(pl)
	if (math.random(0, 22) == 0) then
		pl:Ignite(5, 0)
		pl:ConCommand('say AAAAAAAAAAAAAAAAAAAAAA')
		return
	end

	pl:SetGravity(0.15)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetGravity(1)
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
	local ColorModify = {
		['$pp_colour_addr'] 		= 0,
		['$pp_colour_addg'] 		= 0,
		['$pp_colour_addb'] 		= 0,
		['$pp_colour_mulr'] 		= 0,
		['$pp_colour_mulg'] 		= 0,
		['$pp_colour_mulb'] 		= 0,
		['$pp_colour_colour'] 		= 0.63,
		['$pp_colour_brightness'] 	= -0.15,
		['$pp_colour_contrast'] 	= 2.57
	}

	DrawColorModify(ColorModify)
	DrawSharpen(8.32, 1.03)
end

RegisterDrug(DRUG)