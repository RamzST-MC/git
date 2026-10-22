AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

AddCSLuaFile()

function ENT:Initialize()
	self:SetModel( "models/props_c17/display_cooler01a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self.inventory = {}

	if self.ItemOwner then
		self:CPPISetOwner(self.ItemOwner)
	end
end

util.AddNetworkString("openPrilavok")
util.AddNetworkString("AddItemToKiosk")
util.AddNetworkString("BuyItemFromKiosk")

function ENT:Use( pl )
	self:OpenEntity(pl)
end