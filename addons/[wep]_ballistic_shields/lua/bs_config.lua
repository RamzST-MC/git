include( "ballistic_shields/sh_bs_util.lua" )

--------------------- BALLISTIC SHIELDS V1.1.9 -------------------------

---- CONFIG ----
-- AVALAIBLE LANGUAGES - English, German, French, Danish, Turkish
bshields.config.language = "Russian"
-- DISABLE HUD
bshields.config.disablehud = false
-- MINIMUM RIOT SHIELD DAMAGE
bshields.config.rshielddmgmin = 10
-- MAXIMUM RIOT SHIELD DAMAGE
bshields.config.rshielddmgmax = 10
-- HEAVY SHIELD EXPLOSION DAMAGE REDUCITON (IN %)
bshields.config.hshieldexpl = 50
-- HEAVY SHIELD MELEE DAMAGE REDUCTION (IN %)
bshields.config.hshieldmelee = 100
-- RIOT SHIELD MELEE DAMAGE REDUCTION (IN %)
bshields.config.rshieldmelee = 100
-- HEAVY SHIELD BREACH COOLDOWN (IN SECONDS)
bshields.config.hshieldcd = 20
-- DOOR RESPAWN TIMER (IN SECONDS)
bshields.config.doorrespawn = 60
-- MAXIMUM AMOUNT OF DEPLOYED SHIELDS
bshields.config.maxshields = 1
-- SHOULD FADING DOORS BE BREACHABLE?
bshields.config.breachfdoors = true
-- ALLOW BREACHING UNOWNED DOORS
bshields.config.breachudoors = false
-- REMOVE DEPLOYED SHIELDS ON JOB CHANGE
bshields.config.removeonjobchange = true

-------- CUSTOM TEXTURES, LEAVE "" FOR DEFAULT "POLICE" TEXT. ----------
--- FOR EDITING USE THE 256x256 TEMPLATE INCLUDED IN THE MAIN FOLDER ---

-- HEAVY SHIELD
bshields.config.hShieldTexture = ""
-- RIOT SHIELD
bshields.config.rShieldTexture = ""
-- DEPLOYABLE SHIELD
bshields.config.dShieldTexture = "" 
-- PLAYERS MIGHT HAVE TO RECONNECT IN ORDER TO SEE THE NEW TEXTURES! ---

-- [CW2 ONLY] YOU NEED THIS ADDON: https://steamcommunity.com/sharedfiles/filedetails/?id=1771994451
-- SHOULD RIOT SHIELD BE BULLETPROOF? --
bshields.config.rshieldbp = false

bshields.config.pmodels = {
	["models/player/ven/tk_501_01/tk_501.mdl"] = true,
	["models/player/ven/tk_501_02/tk_501.mdl"] = true,
	["models/player/ven/tk_incinerator_01/tk_incinerator.mdl"] = true,
	["models/player/ven/tk_incinerator_02/tk_incinerator.mdl"] = true,
	["models/cso2/player/ct_helga_player.mdl"] = true
}