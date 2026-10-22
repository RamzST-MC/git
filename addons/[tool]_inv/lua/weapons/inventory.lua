SWEP.DrawWeaponInfoBox = true
SWEP.Author			= "Ozor"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "ЛКМ: Подобрать вещи\nПКМ: Открыть инвентарь"

SWEP.Category			= "Инвентарь"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

if CLIENT then
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true

	SWEP.PrintName = "Инвентарь"
	SWEP.Slot = 2
	SWEP.SlotPos = 99
	SWEP.DrawAmmo = false
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 3

SWEP.ViewModel = Model('')
SWEP.WorldModel = ""

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPickuping")
	self:NetworkVar("Float", 0, "StartPickTime")
	self:NetworkVar("Float", 1, "EndPickTime")
	self:NetworkVar("Entity", 0, "TargetItem" )
end

function SWEP:Initialize()
	self:SetHoldType('normal')
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	if not SERVER then return end

	if not self.NextPrimaryAttack then self.NextPrimaryAttack = 0 end
	if self.NextPrimaryAttack > CurTime() then return end

	local ent = self.Owner:GetEyeTrace().Entity	

	if not IsValid(ent) then return end

	if self.Owner:GetPos():Distance(ent:GetPos()) > INV.pickup_distance then return end

	if not ent:FCanPickUp(self.Owner) then
		self.Owner:Notify(NOTIFY_ERROR, "Вы не можете положить это в инвентарь")
		return 
	end

	self.Owner:PickUpItem(ent)

	self.NextPrimaryAttack = CurTime() + 0.5
end

function SWEP:SecondaryAttack()
	if CLIENT then
		RunConsoleCommand('openinv')
	end
end