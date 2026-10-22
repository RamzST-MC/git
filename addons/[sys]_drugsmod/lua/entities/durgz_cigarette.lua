
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
~ file: addons/drugsmod/lua/entities/durgz_cigarette.lua ~

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
ENT.PrintName		= 'Cigarettes'
ENT.Author			= 'The D3vine'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= 'models/boxopencigshib.mdl'
ENT.ID				= 'Cigarettes'

local DRUG = {}
DRUG.Name = 'Cigarettes'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	local smoke = EffectData()
	smoke:SetOrigin(pl:EyePos())
	util.Effect('drug_weed_smoke', smoke)

	if (math.random(0, 10) == 0) then
		pl:Ignite(5, 0)
		pl:ConCommand('say я думаю у меня рак')
	else
		pl:ConCommand('say Я классный.')
	end
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
	draw.SimpleTextOutlined('Ты куришь. Поэтому ты крутой.','Trebuchet24', ScrW()/2, ScrH() * 0.6, Color(255,255,255,math.sin(SysTime() / math.pi) * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ui.col.Red)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawSharpen(1, 1)
end

RegisterDrug(DRUG)