if CLIENT then return end

zclib.Player.CleanUp_Add("zmc_dish")
zclib.Player.CleanUp_Add("zmc_item")

zclib.Player.CleanUp_Add("zmc_boilpot")
zclib.Player.CleanUp_Add("zmc_customertable")
zclib.Player.CleanUp_Add("zmc_dishtable")
zclib.Player.CleanUp_Add("zmc_fridge")
zclib.Player.CleanUp_Add("zmc_garbagepin")
zclib.Player.CleanUp_Add("zmc_gastank")
zclib.Player.CleanUp_Add("zmc_grill")
zclib.Player.CleanUp_Add("zmc_mixer")
zclib.Player.CleanUp_Add("zmc_ordertable")
zclib.Player.CleanUp_Add("zmc_oven")
zclib.Player.CleanUp_Add("zmc_souppot")
zclib.Player.CleanUp_Add("zmc_wok")
zclib.Player.CleanUp_Add("zmc_worktable")
zclib.Player.CleanUp_Add("zmc_washtable")
zclib.Player.CleanUp_Add("zmc_cookbook")
zclib.Player.CleanUp_Add("zmc_buildkit")

zclib.Gamemode.AssignOwnerOnBuy("zmc_boilpot")
zclib.Gamemode.AssignOwnerOnBuy("zmc_customertable")
zclib.Gamemode.AssignOwnerOnBuy("zmc_dishtable")
zclib.Gamemode.AssignOwnerOnBuy("zmc_fridge")
zclib.Gamemode.AssignOwnerOnBuy("zmc_garbagepin")
zclib.Gamemode.AssignOwnerOnBuy("zmc_gastank")
zclib.Gamemode.AssignOwnerOnBuy("zmc_grill")
zclib.Gamemode.AssignOwnerOnBuy("zmc_mixer")
zclib.Gamemode.AssignOwnerOnBuy("zmc_ordertable")
zclib.Gamemode.AssignOwnerOnBuy("zmc_oven")
zclib.Gamemode.AssignOwnerOnBuy("zmc_souppot")
zclib.Gamemode.AssignOwnerOnBuy("zmc_wok")
zclib.Gamemode.AssignOwnerOnBuy("zmc_worktable")
zclib.Gamemode.AssignOwnerOnBuy("zmc_washtable")
zclib.Gamemode.AssignOwnerOnBuy("zmc_cookbook")
zclib.Gamemode.AssignOwnerOnBuy("zmc_buildkit")

zclib.Hook.Add("zclib_PlayerJoined", "zmc_PlayerJoined", function(ply)

    timer.Simple(0.5, function()
        if not IsValid(ply) then return end
        zclib.Data.Send("zmc_item_config",ply)
        zclib.Data.Send("zmc_dish_config",ply)
    end)

    // Send entity inventories to player
    timer.Simple(1, function()
        if not IsValid(ply) then return end
        //zmc.Print("Sending entity inventories to " .. tostring(ply))

        for k, v in pairs(zclib.EntityTracker.GetList()) do
            if IsValid(v) and v.zmc_inv then
                zmc.Inventory.SynchForPlayer(v, ply)
            end
        end

        for k, v in pairs(zclib.EntityTracker.GetList()) do
            if IsValid(v) and v:GetClass() == "zmc_customertable" then
                zmc.Customertable.SynchForPlayer(v,ply)
            end
        end
    end)
end)
