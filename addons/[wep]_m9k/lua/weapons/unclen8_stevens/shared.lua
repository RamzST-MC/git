-- Variables that are used on both client and server
SWEP.Gun = ("unclen8_stevens") -- must be the name of your swep
SWEP.Category				= "Uncle Nate's Shotguns" --Category where you will find your weapons
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Stevens M620"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"

SWEP.ViewModelFOV			= 73
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_shot_stevem620.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_shot_stevem620.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "unclen8_shotty_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("nathan_m620_shot")		-- script that calls the primary fire sound
SWEP.Primary.RPM			= 85		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip		= 25	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 5				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 1	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 

SWEP.ShellTime			= .3

SWEP.Primary.NumShots	= 8		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 14	-- Base damage per bullet
SWEP.Primary.Spread		= .035	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .035	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector (0, 0, 0)
SWEP.IronSightsAng = Vector (0, 0, 0)
SWEP.SightsPos = Vector(-1.821, -0.65, 0.7)
SWEP.SightsAng = Vector(1.5, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-14.07, 23.215, -11.256)

--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = -0.5,
Right = 1.5,
Forward = 1.8,
},
Ang = {
Up = 0,
Right = -7,
Forward = 180,
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