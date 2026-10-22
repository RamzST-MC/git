//this part is for making kill icons
local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then

	killicon.Add(  "unclen8_1887",		"vgui/hud/unclen8_1887", icol  )
	--			weapon name			location of weapon's kill icon, I just used the hud icon

end

//these are some variables we need to keep for stuff to work
//that means don't delete them

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
	
if GetConVar("M9KUniqueSlots") == nil then
	CreateConVar("M9KUniqueSlots", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Give M9K Weapons unique slots? 1 for true, 2 for false. A map change may be required.")
	print("Unique Slots con var created")
end
	
if GetConVar("M9KDisableHolster") == nil then
	CreateConVar("M9KDisableHolster", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable my totally worthless and broken holster system? Won't hurt my feelings any. 1 for true, 2 for false. A map change may be required.")
	print("Holster Disable con var created")
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

if GetConVar("DebugM9K") == nil then
	CreateConVar("DebugM9K", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Debugging for some m9k stuff, turning it on won't change much.")
end
	
if !game.SinglePlayer() then

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

//I always leave a note reminding me which weapon these sounds are for
//weapon name
sound.Add({
	name = 			"CWC_M1887_FIRE",
	channel = 		CHAN_USER_BASE+10, --see how this is a different channel? Gunshots go here
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/firesub.wav"
})

sound.Add({
	name = 			"CWC_1887_CLICK",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/click.wav"
})

sound.Add({
	name = 			"CWC_1887_CLICK2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/click2.wav"
})


sound.Add({
	name = 			"m1887.Pull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/open1.wav"
})


sound.Add({
	name = 			"m1887.Back",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/close.wav"
})

sound.Add({
	name = 			"m1887.Insert",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/cwc_1887/insert1.wav"
})

