SWEP.PrintName = "Вы оглушены"
SWEP.Category = 'RP'
SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.HoldType = "normal"
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.AdminOnly = true
SWEP.UseHands = true
SWEP.Base = "weapon_rp_base"
function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack()
end
function SWEP:Holster()
return false
end