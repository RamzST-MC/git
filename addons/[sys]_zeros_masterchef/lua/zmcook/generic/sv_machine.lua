if CLIENT then return end

zmc = zmc or {}
zmc.Machine = zmc.Machine or {}

function zmc.Machine.Spawn(Machine, tr, ply)
    local SpawnPos = tr.HitPos + tr.HitNormal * 1
    local ent = ents.Create(Machine.ClassName)
    if not IsValid(ent) then return end
    ent:SetPos(SpawnPos)
    local angle = ply:GetAimVector():Angle()
    angle = Angle(0, angle.yaw, 0)
    ent:SetAngles(angle)
    ent:Spawn()
    ent:Activate()
    //local min, max = ent:GetModelBounds()
    //ent:SetPos(SpawnPos - ((min - max) / 2))
    zclib.Player.SetOwner(ent, ply)
    return ent
end

function zmc.Machine.Initialize(Machine)
    zclib.EntityTracker.Add(Machine)

    // If we dont use fuel tanks then lets still enable the fuel tank bodygroup because it looks nice
    if zmc.config.Gastank.enabled == false and Machine.GetFuel then
        Machine:SetBodygroup(2,1)
    end
end

function zmc.Machine.StartTouch(Machine, other)
    if not IsValid(Machine) then return end
    if not IsValid(other) then return end
    if other:GetClass() ~= "zmc_item" and other:GetClass() ~= "zmc_gastank" then return end
    if zclib.util.CollisionCooldown(other) then return end

	if zclib.Entity.GettingRemoved(other) then return end

    if other:GetClass() == "zmc_gastank" and zmc.config.Gastank.enabled == true and Machine.GetFuel and Machine:GetFuel() <= 0 then
        zmc.Machine.AddFuel(Machine, other)
    elseif other:GetClass() == "zmc_item" and other:GetIsRotten() == false and Machine.OnItemPickUp and Machine:OnItemPickUp(other) == true then
        zclib.Entity.SafeRemove(other)
    end
end

function zmc.Machine.AddFuel(Machine, other)
    Machine:SetFuel(zmc.config.Gastank.fuel)
    Machine:SetBodygroup(2,1)
    zclib.Entity.SafeRemove(other)
    Machine:EmitSound("zmc_gastank_installed")
end

function zmc.Machine.RemoveFuel(Machine, amount)
    if zmc.config.Gastank.enabled == false then return end
    Machine:SetFuel(Machine:GetFuel() - amount)

    if Machine:GetFuel() <= 0 then
        Machine:SetBodygroup(2, 0)

        if Machine.SetTemperatur then
            Machine:SetTemperatur(0)

            if Machine.OnTemperaturChange then
                Machine:OnTemperaturChange(0)
            end
        end
    end
end

util.AddNetworkString("zmc_machine_open")
function zmc.Machine.Open(Machine, ply)
    if zmc.Player.IsCook(ply) == false then return end

    net.Start("zmc_machine_open")
    net.WriteEntity(Machine)
    net.Send(ply)
end

util.AddNetworkString("zmc_machine_selectrecipe")
net.Receive("zmc_machine_selectrecipe", function(len,ply)
    zclib.Debug_Net("zmc_machine_selectrecipe", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local ItemID = net.ReadUInt(16)
    if not IsValid(Machine) then return end
    if zclib.util.InDistance(Machine:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if ItemID == nil then return end
// 181085724
    if Machine.CanSelectRecipe and Machine:CanSelectRecipe(ItemID) then
        // Set the item we are trying to mix
        Machine:SetItemID(ItemID)

        // Any other player gets informed too
        timer.Simple(zmc.config.NetDelay,function()
            net.Start("zmc_machine_selectrecipe")
            net.WriteEntity(Machine)
            net.Broadcast()
        end)
    end
end)

util.AddNetworkString("zmc_machine_cancel")
net.Receive("zmc_machine_cancel", function(len,ply)
    zclib.Debug_Net("zmc_machine_cancel", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    if not IsValid(Machine) then return end
    if zclib.util.InDistance(Machine:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if Machine.CanCancel and Machine:CanCancel() then

        // Set the item we are trying to mix
        Machine:SetItemID(-1)

        // Any other player gets informed too
        timer.Simple(zmc.config.NetDelay,function()
            net.Start("zmc_machine_cancel")
            net.WriteEntity(Machine)
            net.Broadcast()
        end)
    end
end)


util.AddNetworkString("zmc_machine_start")
net.Receive("zmc_machine_start", function(len,ply)
    zclib.Debug_Net("zmc_machine_start", len)

    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    if not IsValid(Machine) then return end
    if zclib.util.InDistance(Machine:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if zmc.config.Gastank.enabled == true and Machine.GetFuel and Machine:GetFuel() <= 0 then
        zclib.Notify(ply, zmc.language["Missing Gastank"], 1)
        return
    end

    if Machine.Start and Machine:Start(ply) == true then
        // Any other player gets informed too
        timer.Simple(zmc.config.NetDelay,function()
            net.Start("zmc_machine_start")
            net.WriteEntity(Machine)
            net.Broadcast()
        end)
    end
end)

util.AddNetworkString("zmc_machine_changetemperatur")
net.Receive("zmc_machine_changetemperatur", function(len,ply)
    zclib.Debug_Net("zmc_machine_changetemperatur", len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local NewTemp = net.ReadUInt(16)
    if not IsValid(Machine) then return end
    if zclib.util.InDistance(Machine:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

    if zmc.Player.IsCook(ply) == false then return end

    if zmc.config.Gastank.enabled == true and Machine.GetFuel and Machine:GetFuel() <= 0 then
        zclib.Notify(ply, zmc.language["Missing Gastank"], 1)
        return
    end

    if Machine.SetTemperatur then Machine:SetTemperatur(NewTemp) end

    if Machine.OnTemperaturChange then
        Machine:OnTemperaturChange(NewTemp)
    end
end)
