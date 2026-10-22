-- Variables that are used on both client and server
SWEP.Gun = ("unclen8_saiga12")					-- must be the name of your swep
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "Uncle Nate's Shotguns"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Saiga-12"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 35			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon

SWEP.SelectiveFire		= true

SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_notmic_saiga.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_saiga_chan.mdl"	-- Weapon world model
SWEP.Base				= "bobs_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands				 = false

SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater 			= true

SWEP.Primary.Sound			= Sound("weapons/saiga12k/12k_fire.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 400			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 9		-- Size of a clip
SWEP.Primary.DefaultClip		= 32		-- Bullets you start with
SWEP.Primary.KickUp				= 0.8		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.8		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 8		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage	= 10	-- Base damage per bullet
SWEP.Primary.Spread	= .035	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .035 -- Ironsight accuracy, should be the same for shotguns1
-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-2.03, 0, 0.449)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3, 0, -0.5)
SWEP.RunSightsAng = Vector(-4, 45.5, 0)

if GetConVar("M9KDefaultClip") == nil then
	print("M9KDefaultClip is missing! You may have hit the lua limit!")
else
	if GetConVar("M9KDefaultClip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("M9KDefaultClip"):GetInt()
	end
end


if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end

--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = 0.3,
Right = 1,
Forward = 3,
},
Ang = {
Up = 0,
Right = -9,
Forward = 177,
}
}

function SWEP:DrawWorldModel( )
        local hand, offset, rotate

        local pl = self:GetOwner()

        if IsValid( pl ) then
                        local boneIndex = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
                        if boneIndex then
                                local pos, ang = pl:GetBonePosition( boneIndex )
                                pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right + ang:Up() * self.Offset.Pos.Up

                                ang:RotateAroundAxis( ang:Up(), self.Offset.Ang.Up)
                                ang:RotateAroundAxis( ang:Right(), self.Offset.Ang.Right )
                                ang:RotateAroundAxis( ang:Forward(),  self.Offset.Ang.Forward )

                                self:SetRenderOrigin( pos )
                                self:SetRenderAngles( ang )
                                self:DrawModel()
                        end
        else
                self:SetRenderOrigin( nil )
                self:SetRenderAngles( nil )
                self:DrawModel()
        end
end