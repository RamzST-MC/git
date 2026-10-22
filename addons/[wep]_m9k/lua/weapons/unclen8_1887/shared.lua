-- Variables that are used on both client and server
SWEP.Gun = ("unclen8_1887") -- must be the name of your swep
SWEP.Category				= "Uncle Nate's Shotguns" --Category where you will find your weapons
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Winchester Model 1887 Lever-Action"		-- Weapon name (Shown on HUD)	
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

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/cwc_1887/v_draggo_model1887.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/cwc_1887/w_draggo_model1887.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "unclen8_shotty_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("CWC_M1887_FIRE")		-- script that calls the primary fire sound
SWEP.Primary.RPM			= 45		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 7		-- Size of a clip
SWEP.Primary.DefaultClip			= 25	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 8				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.7		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 2.1	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 

SWEP.ShellTime			= .36

SWEP.Primary.NumShots	= 8		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 17	-- Base damage per bullet
SWEP.Primary.Spread		= .03	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .03	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.06, 0, 0.9)
SWEP.SightsAng = Vector(-0.09, 0.02, 0)
SWEP.RunSightsPos = Vector(6, 0, 1)
SWEP.RunSightsAng = Vector(-10.778, 40, 0)



--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = -5.4,
Right = 2,
Forward = 17,
},
Ang = {
Up = 0,
Right = -6,
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
