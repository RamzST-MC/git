-- Variables that are used on both client and server
SWEP.Gun = ("unclen8_1897") -- must be the name of your swep
SWEP.Category				= "Uncle Nate's Shotguns" --Category where you will find your weapons
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Winchester Model 1897"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 2			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 15			-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_shot_1897winch.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_shot_1897winch.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= true
SWEP.Base 				= "unclen8_shotty_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("1897_shot_sound")		-- script that calls the primary fire sound
SWEP.Primary.RPM			= 85		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip		= 30	-- Default number of bullets in a clip
SWEP.Primary.KickUp				= 4				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 1	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 

SWEP.ShellTime			= .45

SWEP.Primary.NumShots	= 8		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 15	-- Base damage per bullet
SWEP.Primary.Spread		= .0270	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0270	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.381, 0, 2.089)
SWEP.SightsAng = Vector(0.495, 0, 0)
SWEP.RunSightsPos = Vector(5.079, -2.32, 1.889)
SWEP.RunSightsAng = Vector(-15.433, 34.347, 0)


--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = 1.5,
Right = 1,
Forward = 3,
},
Ang = {
Up = 0,
Right = -11,
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
