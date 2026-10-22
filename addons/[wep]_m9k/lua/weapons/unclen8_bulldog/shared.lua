-- Variables that are used on both client and server
SWEP.Gun = ("unclen8_bulldog") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Uncle Nate's Shotguns" --Category where you will find your weapons
SWEP.Author				= "Uncle Nate"
SWEP.Contact				= ""
SWEP.Purpose				= "To shoot and kill stuff"
SWEP.Instructions				= ""
SWEP.PrintName				= "Bulldog"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 40		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles
if CLIENT then
killicon.Add("m9k_draggo_bulldog", "vgui/draggo/maulkill", Color(255, 80, 0, 150))
SWEP.SelectIcon = surface.GetTextureID("vgui/draggo/maul")
end

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_draggo_maul.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_draggo_maul.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base				= "unclen8_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.UseHands = true

SWEP.Primary.Sound			= Sound("draggo_maul_fire")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 550			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8		-- Size of a clip
SWEP.Primary.DefaultClip		= 56		-- Bullets you start with
SWEP.Primary.KickUp				= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "Buckshot"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire		= false
SWEP.CanBeSilenced		= false

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 12		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 6	-- Base damage per bullet
SWEP.Primary.Spread		= .05	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .05	-- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-4.623, -3.735, 1.286)
SWEP.SightsAng = Vector(-0.264, -0.082, 0)

SWEP.RunSightsPos = Vector(0.234, 0, -1.7)
SWEP.RunSightsAng = Vector(-7.949, 35.187, -20.82)


--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = -1,
Right = 1,
Forward = 5,
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


