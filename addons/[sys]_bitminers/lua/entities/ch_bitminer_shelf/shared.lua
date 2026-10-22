ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bitminer Shelf"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RemoveOnJobChange = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "HP" )
	self:NetworkVar( "Int", 1, "MinersInstalled" )
	self:NetworkVar( "Int", 2, "MinersAllowed" )
	self:NetworkVar( "Int", 3, "UPSInstalled" )
	self:NetworkVar( "Int", 4, "FansInstalled" )
	
	self:NetworkVar( "Float", 0, "Temperature" )
	self:NetworkVar( "Float", 1, "BitcoinsMined" )
	self:NetworkVar( "Float", 2, "WattsRequired" )
	self:NetworkVar( "Float", 3, "WattsGenerated" )
	
	self:NetworkVar( "Bool", 0, "RGBInstalled" )
	self:NetworkVar( "Bool", 1, "RGBEnabled" )
	self:NetworkVar( "Bool", 2, "HasPower" )
	self:NetworkVar( "Bool", 3, "IsMining" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end
