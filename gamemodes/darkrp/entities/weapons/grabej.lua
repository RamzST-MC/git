function PLAYER:IsAFK()
	return false
end

if CLIENT then
	SWEP.PrintName = "Украсть деньги"
	SWEP.Instructions = ""
	SWEP.Slot = 1
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author 				= "я"
SWEP.Category 				= "RP"

SWEP.ViewModelFOV    		= 62
SWEP.ViewModelFlip    		= false

SWEP.ViewModel        		= ""
SWEP.WorldModel        		= ""

SWEP.HoldType 				= "normal"

SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= ""

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= ""

SWEP.CheckTime 				= 10
SWEP.AllowedClass 			= "player"
SWEP.ModelDraw 				= false

SWEP.CheckTime 				= 5
SWEP.StealDetection 		= 10
SWEP.MoneyToSteal 			= {1000, 2500}
SWEP.StealTreshold 			= 1500

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsStealing")
    self:NetworkVar("Float", 0, "StartCheckTime")
    self:NetworkVar("Float", 1, "EndCheckTime")
end

function SWEP:Deploy()
	if not self.ModelDraw then
		self.Owner:DrawViewModel(false)
		if SERVER then
			self.Owner:DrawWorldModel(false)
			self:SetHoldType( self.HoldType )
		end
	end
end

function SWEP:EntityCheck(ply)
	if not (IsValid(ply) and ply:IsPlayer() and ply:GetPos():Distance(self.Owner:GetPos()) < 100) then
		return true
	end
	return false
end

local pi 						= math.pi
local cos 						= math.cos
local sin 						= math.sin
local floor 					= math.floor
local ceil 						= math.ceil
local sqrt 						= math.sqrt
local clamp 					= math.Clamp
local rad 						= math.rad
local round 					= math.Round
local Color 					= Color
local draw 						= draw

-- true, если игрок в безопасной зоне (спаун) или под защитой спауна
local function InSafeZone(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return false end
	return ply:GetNWBool('SpawnProtected') or (ply:GetNWInt('SH_SZ.Safe', 0) ~= 0)
end

local SAFEZONE_MSG = 'На спауне (в безопасной зоне) грабить нельзя!'

function SWEP:PrimaryAttack()
	if self:GetIsStealing() then return end

	self:SetNextPrimaryFire(CurTime() + 0.3)

    self:GetOwner():LagCompensation(true)
    local trace = self:GetOwner():GetEyeTrace()
    self:GetOwner():LagCompensation(false)

	if self:EntityCheck(trace.Entity) then return end
	if trace.Entity:Team() == TEAM_ADMIN then return rp.Notify(self.Owner, NOTIFY_ERROR, 'Вы не можете ограбить администратора!') end
	if trace.Entity:Team() == TEAM_HOBO and TEAM_HOBOKING then return rp.Notify(self.Owner, NOTIFY_ERROR, 'Вы не можете ограбить бомжа!') end
	if InSafeZone(self.Owner) or InSafeZone(trace.Entity) then
		if SERVER then rp.Notify(self.Owner, NOTIFY_ERROR, SAFEZONE_MSG) end
		return
	end

	if not IsFirstTimePredicted() then return end

	self:SetIsStealing(true)
    self:SetStartCheckTime(CurTime())
    self:SetEndCheckTime(CurTime() + self.CheckTime)

    if CLIENT then
        self.Dots = ""
        self.NextDotsTime = CurTime() + 0.5
    end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Reload()
	self:PrimaryAttack()
end

function SWEP:Holster()
    self:SetIsStealing(false)
    return true
end

function SWEP:Done(victim, ply)
	if CLIENT then return end

	if InSafeZone(self.Owner) or InSafeZone(victim) then
		rp.Notify(self.Owner, NOTIFY_ERROR, SAFEZONE_MSG)
		return
	end
	local money_to_steal = math.random(self.MoneyToSteal[1], self.MoneyToSteal[2])

	if not victim:CanAfford(money_to_steal) then
		rp.Notify(self.Owner, NOTIFY_ERROR, "У игрока не достаточно денег!" )
		return
	end
	if (victim.nextSteal and victim.nextSteal > CurTime()) or not victim:CanAfford(self.StealTreshold) then
		rp.Notify(self.Owner, NOTIFY_ERROR, "Ты хочешь чтобы тебя поймали?! Подожди немного перед повторной попыткой!" )
		return
	end

	victim.nextSteal = CurTime() + 30

	rp.Notify(self.Owner, 3, "Ты украл #!", rp.FormatMoney(money_to_steal) )

	timer.Simple(self.StealDetection, function()
		if IsValid(victim) then
			rp.Notify(victim, NOTIFY_ERROR, "Кто-то украл # из вашего кармана!", rp.FormatMoney(money_to_steal))
		end
	end)

	victim:TakeMoney(money_to_steal)
	self.Owner:AddMoney(money_to_steal)

	rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_PAYCHECK_ROBBER, 1)
end

function SWEP:Succeed(victim, ply)
	self:SetIsStealing(false)
	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)
	if self:EntityCheck(trace.Entity) then return end

	self:Done(trace.Entity)
end

function SWEP:Fail()
	self:SetIsStealing(false)
end

function SWEP:Think()
	if self:GetIsStealing() and self:GetEndCheckTime() ~= 0 then
        self:GetOwner():LagCompensation(true)
        local trace = self:GetOwner():GetEyeTrace()
        self:GetOwner():LagCompensation(false)

        if self:EntityCheck(trace.Entity) or InSafeZone(self:GetOwner()) or InSafeZone(trace.Entity) then
            self:Fail()
            return
        end

        if self:GetEndCheckTime() <= CurTime() then
            self:Succeed()
        end
    end

    if CLIENT and self.NextDotsTime and CurTime() >= self.NextDotsTime then
        self.NextDotsTime = CurTime() + 0.5
        self.Dots = self.Dots or ""
        local len = string.len(self.Dots)
        local dots = {
            [0] = ".",
            [1] = "..",
            [2] = "...",
            [3] = ""
        }
        self.Dots = dots[len]
    end
end

function SWEP:DrawHUD()
    if self:GetIsStealing() and self:GetEndCheckTime() ~= 0 then
        self.Dots = self.Dots or ""

		local x, y = (ScrW() *.5) - 150, (ScrH() *.5) - 25
		local w, h  = 300, 50

		local time = self:GetEndCheckTime() - self:GetStartCheckTime()
		local status = (CurTime() - self:GetStartCheckTime())/time

		rp.ui.DrawProgress(x, y, w, h, status, true)
		draw.SimpleTextOutlined("Лазим по карманам"..self.Dots, 'ui.24', ScrW()*.5, ScrH()*.5, Color(255,255,255,255), 1, 1, 1, Color(0,0,0,255))
    end
end