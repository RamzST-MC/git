INV = INV or {}
INV.Items = INV.Items or {}

local Items = {'base_food', 'base_seed', 'bp_pill_bottle', 'sent_drug_bag', 'spawned_shipment', 'spawned_weapon', 'zgo2_baggy', 'zgo2_weedblock', 'zgo2_jar', 'zgo2_edible', 'zmlab2_item_crate', 'zmlab2_item_meth', 'drug_base'}
local String = {'OpenInventory', 'OpenEntity', 'Delete', 'Use', 'RefreshPlyInv', 'RefreshEntInv', 'MoreDrop', 'BuyItem', 'AddItemItem'}

if SERVER then
	AddCSLuaFile()

	for i=1, #Items do
		AddCSLuaFile('inventory/items/'..Items[i]..'.lua')
	end

	include('inventory/server/sv_inv.lua')

	for i=1, #String do
		util.AddNetworkString('INV.'..String[i])
	end

	AddCSLuaFile('inventory/sh_inv.lua')
	AddCSLuaFile('inventory/client/cl_inv.lua')
end

include('inventory/sh_inv.lua')

for i=1, #Items do
	include('inventory/items/'..Items[i]..'.lua')
end

if CLIENT then
	include('inventory/client/cl_inv.lua')
end