
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
~ file: addons/drugsmod/lua/entities/drug_base.lua ~

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
ENT.Base			= 'base_anim'

ENT.Category		= 'RP Drugs'
ENT.PrintName		= 'Drug'
ENT.Author			= 'The D3vine'
ENT.Information		= ''
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.HighLagRisk = true

ENT.Model			= 'models/props_c17/briefcase001a.mdl'
ENT.ID				= ''

function ENT:Initialize()
	self:SetModel(self.Model)
	
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		self:PhysWake()
		
		self:GetPhysicsObject():SetMass(2)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

function ENT:Use(activator, caller)
	if (self.ID and self.ID != '') then
		activator:AddHigh(self.ID)
	else
		activator:ChatPrint('Этот наркотик не существует!')
	end
    self:Remove()
end