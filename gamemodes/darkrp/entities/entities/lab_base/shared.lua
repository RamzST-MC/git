ENT.Type 		= 'anim'
ENT.Base 		= 'base_rp'
ENT.PrintName 	= 'Item Lab Base'
ENT.Author 		= 'KingofBeast'
ENT.Spawnable 	= false
ENT.Category 	= 'RP'
ENT.PressE 		= true
ENT.IsItemLab	= true

ENT.NetworkPlayerUse = true

ENT.MainModel = "models/props/cs_italy/it_mkt_table3.mdl"

ENT.MetalPrice = 500

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'CraftTime')
	self:NetworkVar("Int", 0, "Metal")
	self:NetworkVar("Int", 1, "CraftID")
	self:NetworkVar("Bool", 0, "Repeating")
end

function ENT:IsCrafting()
	return self:GetCraftTime() != 0
end

function ENT:GetCraftName()
	local shipID = rp.ShipmentMap[self:GetCraftables()[self:GetCraftID()].Class]
	local tblEnt = rp.shipments[shipID]
	return tblEnt and tblEnt.name or "N/A"
end

function ENT:GetCraftables()
	return {}
end

function ENT:CanCraftEntity(pl, tblEnt)
	return true
end

function ENT:GetCraftingTime(plCrafter, itemPrice)
	return (itemPrice / rp.cfg.ItemLabTimeFactor) * (hook.Call('calcCraftSpeed', nil, 1) or 1)
end