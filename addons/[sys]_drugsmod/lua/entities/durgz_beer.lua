
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
~ file: addons/drugsmod/lua/entities/durgz_beer.lua ~

]]

/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/
-- пацаны я тут был, и ето тупо отредаченые наркотяки
-- наркотяки вред
AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Beer'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/drug_mod/alcohol_can.mdl'
ENT.ID				= 'Beer'

local DRUG = {}
DRUG.Name = 'Beer'
DRUG.Duration = 45

function DRUG:StartHighServer(pl)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
end

function DRUG:StartHighClient(pl)
	pl:ConCommand('say подожди, подожди. парни-х. мне нужно рассказать тебе о microsoft excel!11!')
	
	local movecommands = {'left', 'right', 'moveleft', 'moveright', 'attack'}
	local numcommands = math.random(1, 5)

	for i = 0, numcommands-1 do
		timer.Simple(i * 7 + math.Rand(2, 7), function()
			local cmd = movecommands[math.random(1, #movecommands)]
			
			pl:ConCommand('+' .. cmd)
			
			timer.Simple(1, function()
				pl:ConCommand('-' .. cmd)
			end)
		end)
	end
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawMotionBlur(0.03, 0.4, 0.05)
end

RegisterDrug(DRUG)