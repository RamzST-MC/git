if CLIENT then return end
zmc = zmc or {}
zmc.Mixer = zmc.Mixer or {}


function zmc.Mixer.Initialize(Mixer)
    zmc.Inventory.Setup(Mixer,12)
    zclib.EntityTracker.Add(Mixer)

    Mixer:SetMaxHealth( zmc.config.Damageable[Mixer:GetClass()] )
    Mixer:SetHealth(Mixer:GetMaxHealth())
end

function zmc.Mixer.OnUse(Mixer, ply)

    if zmc.Player.IsCook(ply) == false then return end

    if zmc.Machine.InProgress(Mixer) then
        if Mixer:OnIncrease(ply) then
            Mixer:SetMixLevel(math.Clamp(Mixer:GetMixLevel() + 1,0,10))
            Mixer:EmitSound("zmc_button")
        elseif Mixer:OnDecrease(ply) then
            Mixer:SetMixLevel(math.Clamp(Mixer:GetMixLevel() - 1,0,10))
            Mixer:EmitSound("zmc_button")
        end
        return
    end
    zmc.Machine.Open(Mixer, ply)
end

function zmc.Mixer.OnRemove(Mixer)
    zclib.EntityTracker.Remove(Mixer)
    zclib.Timer.Remove("zmc_Mixer_timer_" .. Mixer:EntIndex())
end

function zmc.Mixer.StartTouch(Mixer,other)
    if not IsValid(Mixer) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_item" then return end
    if zclib.util.CollisionCooldown(other) then return end

	if zclib.Entity.GettingRemoved(other) then return end

    if Mixer:GetItemID() <= 0 then return end
    if zmc.Machine.InProgress(Mixer) then return end

    local ItemID = other:GetItemID()

    if Mixer:CanPickUp(ItemID) ~= true then return end

    if zmc.Inventory.Give(Mixer, ItemID) == false then return end
    zclib.Entity.SafeRemove(other)
end

function zmc.Mixer.CanSelectRecipe(Mixer,ItemID)
    if zmc.Machine.InProgress(Mixer) then return false end
    local itemData = zmc.Item.GetData(ItemID)
    if itemData == nil then return false end

    // Can it even be mixed
    if itemData.mix == nil then return false end
    Mixer:SetBodygroup(0,1)
    return true
end

function zmc.Mixer.CanCancel(Mixer)
    if zmc.Machine.InProgress(Mixer) then return false end
    Mixer:SetBodygroup(0,0)
    return true
end

function zmc.Mixer.Start(Mixer,ply)
    local ItemData = zmc.Item.GetData(Mixer:GetItemID())
    if ItemData == nil then return end
    if ItemData.mix == nil then return end
    local missing = zmc.Inventory.GetMissing(Mixer,ItemData.mix.items)
    if table.IsEmpty(missing) then

        // Remove all the ingredients which are needed
        zmc.Inventory.TakeItems(Mixer, ItemData.mix.items)

        Mixer:SetProgress(0)

        local timerid = "zmc_Mixer_timer_" .. Mixer:EntIndex()
        zclib.Timer.Remove(timerid)
        zclib.Timer.Create(timerid,1,0,function()
            if not IsValid(Mixer) then zclib.Timer.Remove(timerid) return end

            // Only progress if mix speed is correct
            if Mixer:GetMixLevel() ~= ItemData.mix.speed then return end
			// 181085724
            if Mixer:GetProgress() >= ItemData.mix.time then

                if zmc.Inventory.Give(Mixer, tostring(ItemData.uniqueid)) == false then
                    // Spawn the food
                    local item_ent = zmc.Item.Spawn(Mixer:LocalToWorld(Vector(25,0,50)),tostring(ItemData.uniqueid))
                    if not IsValid(item_ent) then return end
                    zclib.Player.SetOwner(item_ent, ply)
                end

                zclib.Timer.Remove(timerid)
                Mixer:SetProgress(-1)
                return
            end

            Mixer:SetProgress(Mixer:GetProgress() + 1)
        end)

        return true
    end
end
