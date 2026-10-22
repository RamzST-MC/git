AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if SERVER then
	util.AddNetworkString('DB_plyanim')
end

if CLIENT then
	net.Receive('DB_plyanim',function()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end
		if not ply:IsPlayer() then return end
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, true)		
	end)
	SWEP.PrintName = 'Таран'
	SWEP.Slot = 2
	SWEP.Instructions = 'Left click to open doors and unfreeze props\nRight click to ready the ram'
end

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.ViewModel = Model('models/sterling/c_enhanced_batteringram.mdl')
SWEP.WorldModel = Model('models/sterling/w_enhanced_batteringram.mdl')

SWEP.Primary.Sound = Sound('Canals.d1_canals_01a_wood_box_impact_hard3')

SWEP.Primary.Delay = 1.5

function SWEP:Initialize()
	self:SetHoldType('shotgun')
end

function SWEP:Deploy()
	if (not IsValid(self.Owner)) then return end

	self.HasDeployed = true
	self.Ironsights = false

	if SERVER then
	end
end

function SWEP:OnRemove()
	if (not IsValid(self.Owner)) or (not self.HasDeployed) or CLIENT then return end
end

function GetDoorCategoray( door )
	for k, v in pairs( rp.cfg.Doors ) do 
		if table.HasValue(v.MapIDs,door:GetDoorID()) then 
			return v
		end
	end
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end

	self.Owner:LagCompensation(true)
	local tr = self.Owner:GetEyeTrace()
	self.Owner:LagCompensation(false)

	local ent = tr.Entity
	if (not IsValid(ent)) or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end

	if ent:IsDoor() then
		local tar = ent:DoorGetOwner() 
		if IsValid(tar) and tar:IsWarranted() or (istable(GetDoorCategoray(tr.Entity)) and (( GetDoorCategoray( tr.Entity ).Hotel == true ) or GetDoorCategoray(tr.Entity).Name:find("Отель")) )  then
			if ent.Locked then
				ent:DoorLock(false)
			end
			ent:Fire('open', '', .6)
			ent:Fire('setanimation', 'open', .6)
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

			self:Ram()
		end
	elseif ent:GetClass() == "zmlab2_tent_door" and ent:CPPIGetOwner():IsWarranted() then
		ent:SetNextInteraction(CurTime() + 10)

        ent:EmitSound("zmlab2_ui_click")
        ent:SetIsLocked(false)
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent:SetTrigger(true)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		self:Ram()
	elseif ent:IsProp() and ent:GetNWBool("FadingDoorBool") then
		local owner = ent:CPPIGetOwner()
		if not owner then return end
		if owner and not owner:IsWarranted() then return end

		ent:Fade()
		timer.Simple(30, function()
			if IsValid(ent) then
				ent:UnFade()
			end
		end)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:Ram()
	end
end

function SWEP:SecondaryAttack()
	if (not IsValid(self.Owner)) or CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:Ram()
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
	if SERVER then net.Start('DB_plyanim') net.WriteEntity(self.Owner) net.Broadcast() end
	self:GetOwner():ViewPunch(Angle(-10, math.Round(-5,5), 0))
end

if CLIENT then
	function SWEP:DrawHUD()
		if (not LocalPlayer():Alive()) then return end
		local w, h = 150, 25
		local x, y = ScrW() / 2 - w / 2, ScrH() - h - 30
		rp.ui.DrawProgress(x, y, w, h, (self.Primary.Delay - math.max(0, (self:GetNextPrimaryFire() - CurTime())))/self.Primary.Delay, true)
	end
end