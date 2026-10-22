if CLIENT then return end
zmc = zmc or {}
zmc.Public = zmc.Public or {}

local SaveClass = {
    ["zmc_boilpot"] = true,
    ["zmc_customertable"] = true,
    ["zmc_dishtable"] = true,
    ["zmc_fridge"] = true,
    ["zmc_garbagepin"] = true,
    ["zmc_grill"] = true,
    ["zmc_mixer"] = true,
    ["zmc_ordertable"] = true,
    ["zmc_oven"] = true,
    ["zmc_souppot"] = true,
    ["zmc_wok"] = true,
    ["zmc_worktable"] = true,
    ["zmc_cookbook"] = true,
    ["zmc_washtable"] = true,
}
function zmc.Public.Save(ply)
    local data = {}

    for k, v in pairs(ents.GetAll()) do
        if IsValid(v) and SaveClass[v:GetClass()] then

            local dat = {
                class = v:GetClass(),
                pos = v:GetPos(),
                ang = v:GetAngles()
            }

            if v:GetClass() == "zmc_customertable" then
                dat.seatid = v:GetSeatID()
                dat.tableid = v:GetTableID()
            end

            if v:GetClass() == "zmc_dishtable" and v.DishWhitelist then
                dat.DishWhitelist = v.DishWhitelist
            end

            if v:GetClass() == "zmc_ordertable" then
                if v.DishWhitelist then
                    dat.DishWhitelist = v.DishWhitelist
                end

                dat.customorders = v:GetCustomOrders()
            end

            if v:GetClass() == "zmc_fridge" and v.BuyWhitelist then
                dat.BuyWhitelist = v.BuyWhitelist
            end

            table.insert(data, dat)
        end
    end

    file.CreateDir( "zmc" )
    file.Write("zmc/" .. "ents_" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(data,true))
    zclib.Notify(ply, "All Entities have been saved for " .. game.GetMap(), 0)
end

concommand.Add("zmc_save", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        zmc.Public.Save(ply)
    end
end)

function zmc.Public.Load()
    local path = "zmc/" .. "ents_" .. string.lower(game.GetMap()) .. ".txt"

    if file.Exists(path, "DATA") then
        local data = file.Read(path, "DATA")
        data = util.JSONToTable(data)

        if data and table.Count(data) > 0 then
            for k, v in pairs(data) do
                if v == nil then continue end
                local ent = ents.Create(v.class)
                if not IsValid(ent) then return end
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent:Activate()

                if v.class == "zmc_fridge" and v.BuyWhitelist then
                    zmc.Fridge.SetWhitelist(ent,v.BuyWhitelist)
                end

                if v.class == "zmc_customertable" then
                    ent:SetSeatID(v.seatid)
                    ent:SetTableID(v.tableid)
                end

                if v.class == "zmc_dishtable" then
                    zmc.Dishtable.SetWhitelist(ent,v.DishWhitelist)
                end

                if v.class == "zmc_ordertable" then

                    if v.customorders then
                        ent:SetCustomOrders(v.customorders)
                    end

                    zmc.Ordertable.SetWhitelist(ent,v.DishWhitelist)
                end

                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then phys:EnableMotion(false) end

                ent.IsPublicEntity = true
            end

            zmc.Print("Finished loading Entities!")
        end
    end
end

timer.Simple(3, function()
    zmc.Public.Load()
end)

zclib.Hook.Add("PostCleanupMap", "zmc_PublicSetup_Load", zmc.Public.Load)

function zmc.Public.Remove(ply)
    zclib.Debug("zmc.Public.Remove")

    for k, v in pairs(ents.GetAll()) do
        if IsValid(v) and SaveClass[v:GetClass()] then
            v:Remove()
        end
    end

    local path = "zmc/" .. "ents_" .. string.lower(game.GetMap()) .. ".txt"

    if file.Exists(path, "DATA") then
        file.Delete(path)
        zclib.Notify(ply, "All Entities have been removed for " .. game.GetMap(), 0)
    else
        zclib.Notify(ply, "No Entities could be found!", 1)
    end
end

concommand.Add("zmc_remove", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        zmc.Public.Remove(ply)
    end
end)
