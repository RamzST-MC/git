ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Solar Panel"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RemoveOnJobChange = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "HP" )
	
	self:NetworkVar( "Bool", 0, "PowerOn" )
	
	self:NetworkVar( "Float", 0, "WattsGenerated" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end