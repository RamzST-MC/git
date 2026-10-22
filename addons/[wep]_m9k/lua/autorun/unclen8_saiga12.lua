/*------------------------------------------------------

If you're reading this, then that mean's you've extracted this addon, probably with intentions 
of editing it for your own needs, or that you're using a legacy addon.

I have no problem with that, but you must understand that I cannot offer support for legacy addons.
If you've extracted this addon, I cannot offer any help fixing problems that come up. It's impossible
to know what you've changed, and thus impossible to know what to fix.

"But Bob!" you might say. "I only changed one thing!" 

Well, that's a shame. Everybody is going to say this, and I know that some of those people will be
lying to me. The only thing I can do is to refuse support to everyone using legacy addons.

So, by using a legacy addon, you accept the fact that I cannot help fix anything that might be broken.

I know it's tough love, but that's the way it's got to be.

------------------------------------------------------*/
local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
	killicon.Add( "unclen8_saiga12", "vgui/hud/unclen8_saiga12", icol  )
end

game.AddAmmoType( {
	name = "cssc4",
	dmgtype = DMG_BULLET
} )

--I'm pretty sure we don't need these anymore...
--Almost 99 percent sure that's I'm 100 percent sure...
	
-- if GetConVar("M9KDisableHolster") == nil then
	-- CreateConVar("M9KDisableHolster", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable my totally worthless and broken holster system? Won't hurt my feelings any. 1 for true, 2 for false. A map change may be required.")
	-- print("Holster Disable con var created")
-- end

if GetConVar("DebugM9K") == nil then
	CreateConVar("DebugM9K", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Debugging for some m9k stuff, turning it on won't change much.")
end

if GetConVar("M9KWeaponStrip") == nil then
	CreateConVar("M9KWeaponStrip", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Allow empty weapon stripping? 1 for true, 0 for false")
	print("Weapon Strip con var created")
end
	
if GetConVar("M9KDisablePenetration") == nil then
	CreateConVar("M9KDisablePenetration", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable Penetration and Ricochets? 1 for true, 0 for false")
	print("Penetration/ricochet con var created")
end
	
if GetConVar("M9KDynamicRecoil") == nil then
	CreateConVar("M9KDynamicRecoil", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use Aim-modifying recoil? 1 for true, 0 for false")
	print("Recoil con var created")
end
	
if GetConVar("M9KAmmoDetonation") == nil then
	CreateConVar("M9KAmmoDetonation", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Enable detonatable M9K Ammo crates? 1 for true, 0 for false.")
	print("Ammo crate detonation con var created")
end

if GetConVar("M9KDamageMultiplier") == nil then
	CreateConVar("M9KDamageMultiplier", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Multiplier for M9K bullet damage.")
	print("Damage Multiplier con var created")
end

if GetConVar("M9KDefaultClip") == nil then
	CreateConVar("M9KDefaultClip", "-1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "How many clips will a weapon spawn with? Negative reverts to default values.")
	print("Default Clip con var created")
end
	
if GetConVar("M9KUniqueSlots") == nil then
	CreateConVar("M9KUniqueSlots", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Give M9K Weapons unique slots? 1 for true, 2 for false. A map change may be required.")
	print("Unique Slots con var created")
end
	
if !game.SinglePlayer() then

	if GetConVar("M9KClientGasDisable") == nil then
		CreateConVar("M9KClientGasDisable", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Turn off gas effect for all clients? 1 for yes, 0 for no. ")
	end
	
	if SERVER then
	
		function ClientSideGasDisabler()
			timer.Create("ClientGasBroadcastTimer", 15, 0, 
				function() BroadcastLua("RunConsoleCommand(\"M9KGasEffect\", \"0\")") end )
		end
	
		if GetConVar("M9KClientGasDisable"):GetBool() then
			ClientSideGasDisabler()
		end

		function M9K_Svr_Gas_Change_Callback(cvar, previous, new)
			if tobool(new) == true then
				ClientSideGasDisabler()
				BroadcastLua("print(\"Gas effects disabled on this server!\")")
			elseif tobool(new) == false then
				BroadcastLua("print(\"Gas effects re-enabled on this server.\")")
				BroadcastLua("print(\"You may turn on M9KGasEffect if you wish.\")")
				if timer.Exists("ClientGasBroadcastTimer") then
					timer.Destroy("ClientGasBroadcastTimer")
				end
			end				
		end
		cvars.AddChangeCallback("M9KClientGasDisable", M9K_Svr_Gas_Change_Callback)
	
	end
	
	if CLIENT then
		if GetConVar("M9KGasEffect") == nil then
			CreateClientConVar("M9KGasEffect", "1", true, true)
			print("Client-side Gas Effect Con Var created")
		end		
	end

else
	if GetConVar("M9KGasEffect") == nil then
		CreateConVar("M9KGasEffect", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
		print("Gas effect con var created")
	end
end
	
--deprecated, but left for legacy purposes
if GetConVar("M9KUnified_CSS_vms") == nil then
	CreateConVar("M9KUnified_CSS_vms", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "deprecated, left for legacy purposes.")
end

//Saiga12k
sound.Add({
	name = 			"12k.Handle",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_handle.wav"
})

sound.Add({
	name = 			"12k.Magpouch",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_magdraw.wav"
})

sound.Add({
	name = 			"12k.Click",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_click.wav"
})

sound.Add({
	name = 			"12k.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_deploy.wav"
})

sound.Add({
	name = 			"12k.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_magout.wav"
})

sound.Add({
	name = 			"12k.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_magin.wav"
})

sound.Add({
	name = 			"12k.Boltback",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_boltback.wav"
})

sound.Add({
	name = 			"12k.Boltforward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_boltforward.wav"
})

sound.Add({
	name = 			"12k.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/saiga12k/12k_boltpull.wav"
})

m9knpw = {}
table.insert(m9knpw, "m9k_davy_crockett_explo")
table.insert(m9knpw, "m9k_gdcwa_matador_90mm")
table.insert(m9knpw, "m9k_gdcwa_rpg_heat")
table.insert(m9knpw, "m9k_improvised_explosive")
table.insert(m9knpw, "m9k_launched_davycrockett")
table.insert(m9knpw, "m9k_launched_ex41")
table.insert(m9knpw, "m9k_launched_m79")
table.insert(m9knpw, "m9k_m202_rocket")
table.insert(m9knpw, "m9k_mad_c4")
table.insert(m9knpw, "m9k_milkor_nade")
table.insert(m9knpw, "m9k_nervegasnade")
table.insert(m9knpw, "m9k_nitro_vapor")
table.insert(m9knpw, "m9k_oribital_cannon")
table.insert(m9knpw, "m9k_poison_parent")
table.insert(m9knpw, "m9k_proxy")
table.insert(m9knpw, "m9k_released_poison")
table.insert(m9knpw, "m9k_sent_nuke_radiation")
table.insert(m9knpw, "m9k_thrown_harpoon")
table.insert(m9knpw, "m9k_thrown_knife")
table.insert(m9knpw, "m9k_thrown_m61")
table.insert(m9knpw, "m9k_thrown_nitrox")
table.insert(m9knpw, "m9k_thrown_spec_knife")
table.insert(m9knpw, "m9k_thrown_sticky_grenade")
table.insert(m9knpw, "bb_dod_bazooka_rocket")
table.insert(m9knpw, "bb_dod_panzershreck_rocket")
table.insert(m9knpw, "bb_garand_riflenade")
table.insert(m9knpw, "bb_k98_riflenade")
table.insert(m9knpw, "bb_planted_dod_tnt")
table.insert(m9knpw, "bb_thrownalliedfrag")
table.insert(m9knpw, "bb_thrownaxisfrag")
table.insert(m9knpw, "bb_thrownsmoke_axis")
table.insert(m9knpw, "bb_thrownaxisfrag")
table.insert(m9knpw, "bb_planted_alt_c4")
table.insert(m9knpw, "bb_planted_css_c4")
table.insert(m9knpw, "bb_throwncssfrag")
table.insert(m9knpw, "bb_throwncsssmoke")
table.insert(m9knpw, "m9k_ammo_40mm")
table.insert(m9knpw, "m9k_ammo_40mm_single")
table.insert(m9knpw, "m9k_ammo_357")
table.insert(m9knpw, "m9k_ammo_ar2")
table.insert(m9knpw, "m9k_ammo_buckshot")
table.insert(m9knpw, "m9k_ammo_c4")
table.insert(m9knpw, "m9k_ammo_frags")
table.insert(m9knpw, "m9k_ammo_ieds")
table.insert(m9knpw, "m9k_ammo_nervegas")
table.insert(m9knpw, "m9k_ammo_nuke")
table.insert(m9knpw, "m9k_ammo_pistol")
table.insert(m9knpw, "m9k_ammo_proxmines")
table.insert(m9knpw, "m9k_ammo_rockets")
table.insert(m9knpw, "m9k_ammo_smg")
table.insert(m9knpw, "m9k_ammo_sniper_rounds")
table.insert(m9knpw, "m9k_ammo_stickynades")
table.insert(m9knpw, "m9k_ammo_winchester")

function PocketM9KWeapons(ply, wep)

	if not IsValid(wep) then return end
	class = wep:GetClass()
	m9knopocket = false
	
	for k, v in pairs(m9knpw) do
		if v == class then
			m9knopocket = true
			break
		end
	end
	
	if m9knopocket then
		return false
	end
	
	--goddammit i hate darkrp
	
end
hook.Add("canPocket", "PocketM9KWeapons", PocketM9KWeapons )


-- ak47
-- http://css.gamebanana.com/skins/54505

-- sg550
-- http://css.gamebanana.com/skins/19431

-- mac 10
-- http://css.gamebanana.com/skins/31715

-- p90
-- http://css.gamebanana.com/skins/23732

-- AUG
-- http://css.gamebanana.com/skins/71190

-- awp
-- http://css.gamebanana.com/skins/1667

-- Dual elites
-- http://css.gamebanana.com/skins/11355

-- desert eagle
-- http://css.gamebanana.com/skins/36711

-- famas
-- http://css.gamebanana.com/skins/46179

-- fiveseven
-- http://css.gamebanana.com/skins/46853

-- Glock 18
-- http://css.gamebanana.com/skins/54536

-- M249
-- http://css.gamebanana.com/skins/54536

-- M3 Super 90
-- http://css.gamebanana.com/skins/108640

-- mp5
-- http://css.gamebanana.com/skins/116746

-- scout
-- http://css.gamebanana.com/skins/116746

-- SG552
-- http://css.gamebanana.com/skins/31958

-- p228
-- http://css.gamebanana.com/skins/33694

-- tmp
-- http://css.gamebanana.com/skins/12912

-- xm1014
-- http://css.gamebanana.com/skins/22365

-- c4
-- http://css.gamebanana.com/skins/24548

-- m4a1
-- http://css.gamebanana.com/skins/86056

-- g3sg1
-- http://css.gamebanana.com/skins/20265

-- Galil
-- http://css.gamebanana.com/skins/39422

-- ump45
-- http://css.gamebanana.com/skins/115036

-- usp
-- http://css.gamebanana.com/skins/15019

-- knife
-- http://css.gamebanana.com/skins/34915

-- gloves
-- http://css.gamebanana.com/skins/27915

-- shells
-- http://css.gamebanana.com/skins/28796

m9kcss_autorun_mounted = true