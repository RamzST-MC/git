if CLIENT then return end
zmc = zmc or {}
zmc.RotSystem = zmc.RotSystem or {}

/*

    The RotSystem keeps track on items spawned in the world and rots items which got the rot component

*/

zmc.RotSystem.Items = zmc.RotSystem.Items or {}


function zmc.RotSystem.Add(Item)
    if zmc.config.Item.RotTime <= 0 then return end

    if Item:GetIsRotten() == true then return end

    table.insert(zmc.RotSystem.Items, {
        ent = Item,
        time = CurTime(),
        default_color = Item:GetColor()
    })

    if timer.Exists("zmc_item_rotsystem") == false then
        zclib.Timer.Create("zmc_item_rotsystem",1,0,function()
            zmc.RotSystem.Check()
        end)
    end
end

function zmc.RotSystem.Check()

    if zmc.RotSystem.Items == nil then
        zclib.Timer.Remove("zmc_item_rotsystem")
        return
    end

    if table.Count(zmc.RotSystem.Items) <= 0 then
        zclib.Timer.Remove("zmc_item_rotsystem")
        return
    end

    for k, v in pairs(zmc.RotSystem.Items) do
        if v == nil then
            zmc.RotSystem.Items[k] = nil
            continue
        end

        if not IsValid(v.ent) then
            zmc.RotSystem.Items[k] = nil
            continue
        end
        // 181085724
        if CurTime() > (v.time + zmc.config.Item.RotTime) then
            zmc.Item.Spoil(v.ent)
            zmc.RotSystem.Items[k] = nil
        else
            local fract = (v.time + zmc.config.Item.RotTime) - CurTime()
            local new_col = zclib.util.LerpColor(math.Clamp((1 / zmc.config.Item.RotTime) * fract, 0, 1), zclib.colors["rot_color"],v.default_color)
            v.ent:SetColor(new_col)
        end
    end
end
