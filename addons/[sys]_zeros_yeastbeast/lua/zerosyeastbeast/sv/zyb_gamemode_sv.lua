-- leak by lordee
if not SERVER then return end

local entTable = {
    ["zyb_distillery"] = true,
    ["zyb_constructionkit_cooler"] = true,
    ["zyb_constructionkit_condenser"] = true,
    ["zyb_fermbarrel"] = true,
    ["zyb_fuel"] = true,
    ["zyb_jarpack"] = true,
    ["zyb_jarcrate"] = true,
    ["zyb_yeastgrinder"] = true,
    ["zyb_motor"] = true,
    ["zyb_paperbag"] = true,
    ["zyb_sugar"] = true,
    ["zyb_water"] = true,
    ["zyb_yeast"] = true,
    ["zyb_distillery_cooler"] = true,
    ["zyb_distillery_condenser"] = true,
    ["zyb_palette"] = true,
}

hook.Add("playerBoughtCustomEntity", "zyb_SetOwnerOnEntBuy", function(ply, enttbl, ent, price)
    if entTable[ent:GetClass()] then
        zyb.f.SetOwner(ent, ply)
    end
end)

hook.Add("BaseWars_PlayerBuyEntity", "zyb_basewars_SetOwnerOnEntBuy", function(ply, ent)
    if entTable[ent:GetClass()] then
        zyb.f.SetOwner(ent, ply)
    end
end)
-- leak by lordee