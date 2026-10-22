-- leak by lordee
AddCSLuaFile()

game.AddParticles("particles/zyb_vfx.pcf")
game.AddParticles("particles/zyb_clean.pcf")

PrecacheParticleSystem( "yb_yeast" )
PrecacheParticleSystem( "yb_yeastgrinding" )
PrecacheParticleSystem( "yb_steamjet" )
PrecacheParticleSystem( "yb_heaterflame" )
PrecacheParticleSystem( "yb_mash" )
PrecacheParticleSystem( "yb_moonshine" )
PrecacheParticleSystem( "yb_water" )
PrecacheParticleSystem( "yb_sugar" )
PrecacheParticleSystem( "yb_yeast_fill" )
PrecacheParticleSystem( "yb_overheat" )

PrecacheParticleSystem( "zyb_cleaning" )
PrecacheParticleSystem( "yb_fermenting" )
PrecacheParticleSystem( "yb_jar_explode" )
PrecacheParticleSystem( "yb_explosion" )
PrecacheParticleSystem( "yb_explosion_spill" )

game.AddParticles("particles/zyb_sell.pcf")
PrecacheParticleSystem( "zyb_sell" )


util.PrecacheModel("models/zerochain/props_yeastbeast/yb_barrel_liquid.mdl")
util.PrecacheModel("models/zerochain/props_yeastbeast/yb_jar.mdl")
util.PrecacheModel("models/zerochain/props_yeastbeast/yb_firepit.mdl")
util.PrecacheModel("models/zerochain/props_yeastbeast/yb_yeastblock.mdl")
util.PrecacheModel("models/zerochain/props_yeastbeast/yb_jarcrate_full.mdl")
-- leak by lordee