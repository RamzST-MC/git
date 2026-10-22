if CLIENT then return end
zmc = zmc or {}
zmc.Buildkit = zmc.Buildkit or {}

function zmc.Buildkit.OnUse(Buildkit, ply)

    if zmc.Player.IsCook(ply) == false then return end

    zmc.Buildkit.OpenInterface(Buildkit, ply)
end

util.AddNetworkString("zmc_Buildkit_OpenInterface")
function zmc.Buildkit.OpenInterface(Buildkit,ply)
    net.Start("zmc_Buildkit_OpenInterface")
    net.WriteEntity(Buildkit)
    net.Send(ply)
end

util.AddNetworkString("zmc_Buildkit_Place")
net.Receive("zmc_Buildkit_Place", function(len,ply)
    zclib.Debug_Net("zmc_Buildkit_Place",len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Buildkit = net.ReadEntity()
    local BuildPos = net.ReadVector()
    local BuildAng = net.ReadAngle()
    local BuildkitID = net.ReadUInt(16)

    if not IsValid(Buildkit) then return end

    // Run a distance check on BuildkitBox and BuildPos
    if zclib.util.InDistance(ply:GetPos(), Buildkit:GetPos(), 1000) == false then return end

    if BuildPos and zclib.util.InDistance(ply:GetPos(), BuildPos, 1000) == false then return end

    if zclib.Player.IsAdmin(ply) == false and Buildkit.ItemOwner != ply then zclib.Notify(ply,zmc.language["YouDontOwnThis"], 1) return end

    zmc.Buildkit.Place(Buildkit,ply,BuildkitID,BuildPos,BuildAng)
end)
function zmc.Buildkit.LimitCheck(ply,ItemID)
    local BuildkitData = zmc.config.Buildkit.List[ItemID]
    local class = BuildkitData.class
    local limit = hook.Run("zmc_Buildkit_GetItemLimit",ply,ItemID) or BuildkitData.limit

    local count = 0
    for k, v in pairs(zclib.EntityTracker.GetList()) do
        if IsValid(v) and v:GetClass() == class and zclib.Player.IsOwner(ply, v) then
            count = count + 1
        end
    end

    if count >= limit then
        return false
    else
        return true
    end
end
function zmc.Buildkit.Place(Buildkit,ply,BuildkitID,BuildPos,BuildAng)
    if BuildPos == nil then return end
    if BuildAng == nil then return end

    local BuildkitData = zmc.config.Buildkit.List[BuildkitID]
    if BuildkitData == nil then return end

    // Can the player build any more of this machine?
    if zmc.Buildkit.LimitCheck(ply,BuildkitID) == false then
        local str = zmc.language["ItemLimit"]
        str = string.Replace(str,"$ItemName",zmc.Buildkit.GetName(BuildkitID))
        zclib.Notify(ply, str, 1)
        return
    end

    // Is some player in the way?
    if zmc.Buildkit.AreaOccupied(BuildPos) then return end

    if zclib.Money.Has(ply, BuildkitData.price) == false then
        zclib.Notify(ply, zmc.language["NotEnoughMoney"], 1)
        return
    end

    local ent = ents.Create(BuildkitData.class)
    if not IsValid(ent) then return end
    ent:SetPos(BuildPos)
    ent:SetAngles(BuildAng)
    ent:Spawn()
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    zclib.Gamemode.SimulateBuy(ply,ent,zmc.Buildkit.GetName(BuildkitID),BuildkitData.price)

    zclib.Money.Take(ply, BuildkitData.price)
    zclib.Notify(ply, "-" .. zclib.Money.Display(math.Round(BuildkitData.price)), 0)

    zclib.Player.SetOwner(ent, ply)
    zclib.Sound.EmitFromEntity("cash", ent)
end


util.AddNetworkString("zmc_Buildkit_Deconstruct")
net.Receive("zmc_Buildkit_Deconstruct", function(len,ply)
    zclib.Debug_Net("zmc_Buildkit_Deconstruct",len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()

    if not IsValid(Machine) then return end
    if zmc.Buildkit_Classes[Machine:GetClass()] == nil then return end

    if zclib.Player.IsAdmin(ply) == false and zclib.Player.IsOwner(ply, Machine) == false then zclib.Notify(ply,zmc.language["YouDontOwnThis"], 1) return end

    if zmc.config.Buildkit.Refund > 0 then
        local refund_money = zmc.config.Buildkit.List[zmc.Buildkit_Classes[Machine:GetClass()]].price * zmc.config.Buildkit.Refund
        if refund_money > 0 then

            zclib.Sound.EmitFromPosition(Machine:GetPos(),"cash")

            // Give the player the Cash
            zclib.Money.Give(ply, refund_money)

            // Notify the player
            zclib.Notify(ply, "+" .. zclib.Money.Display(math.Round(refund_money)), 0)
        end
    end

    SafeRemoveEntity(Machine)
end)


util.AddNetworkString("zmc_Buildkit_Move")
net.Receive("zmc_Buildkit_Move", function(len,ply)
    zclib.Debug_Net("zmc_Buildkit_Move",len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    local BuildPos = net.ReadVector()
    local BuildAng = net.ReadAngle()

    if not IsValid(Machine) then return end

    // Run a distance check on BuildkitBox and BuildPos
    if zclib.util.InDistance(ply:GetPos(), Machine:GetPos(), 1000) == false then return end
    if BuildPos and zclib.util.InDistance(ply:GetPos(), BuildPos, 1000) == false then return end

    if zclib.Player.IsAdmin(ply) == false and zclib.Player.IsOwner(ply, Machine) == false then zclib.Notify(ply,zmc.language["YouDontOwnThis"], 1) return end

    zmc.Buildkit.Move(Machine,ply,BuildPos,BuildAng)
end)
function zmc.Buildkit.Move(Machine,ply,BuildPos,BuildAng)
    if BuildPos == nil then return end
    if BuildAng == nil then return end

    // Is some player in the way?
    if zmc.Buildkit.AreaOccupied(BuildPos,Machine) then return end

    if zmc.Buildkit_Classes[Machine:GetClass()] == nil then return end

    Machine:SetPos(BuildPos)
    Machine:SetAngles(BuildAng)

    zclib.Sound.EmitFromEntity("throw",Machine)
end


util.AddNetworkString("zmc_Buildkit_Repair")
net.Receive("zmc_Buildkit_Repair", function(len,ply)
    zclib.Debug_Net("zmc_Buildkit_Repair",len)
    if zclib.Player.Timeout(nil,ply) == true then return end

    local Machine = net.ReadEntity()
    if not IsValid(Machine) then return end

    zclib.Sound.EmitFromEntity("cash", Machine)

    zclib.Damage.Repair(Machine)
end)
