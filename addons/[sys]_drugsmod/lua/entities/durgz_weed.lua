
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
~ file: addons/drugsmod/lua/entities/durgz_weed.lua ~

]]

/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Weed'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl'
ENT.ID				= 'Weed'

local DRUG = {}
DRUG.Name = 'Weed'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	if (math.random(0, 10) == 0) then
		pl:Ignite(5, 0)
		pl:ConCommand('say AAAAAAAAAAAAAAAAAAAAAA')
		return
	end

	pl:SetDSP(6)
	pl:SetGravity(0.2)
	pl:TakeHunger(10)
	pl:AddHealth(25)
	
	local sayings = {
		'есть ли1 у золотых рыбок!?1 я хочу золотую рыбку плз тхх',
		'Мои глаза не красные. О чем ты говоришь?',
		'чуууууууувааааааааааааааак',
		'привет, как мне написать в чате, я не знаю как это сделать'
	}
	pl:ConCommand('say ' .. sayings[math.random(1, #sayings)])
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetDSP(1)
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
		['$pp_colour_colour'] 		= 0.77,
		['$pp_colour_brightness'] 	= -0.11,
		['$pp_colour_contrast'] 	= 2.62
	}

	DrawMotionBlur(0.03, 0.77, 0)
	DrawColorModify(ColorModify)
end

RegisterDrug(DRUG)