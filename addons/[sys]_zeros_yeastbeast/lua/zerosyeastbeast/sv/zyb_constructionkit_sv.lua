-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}
util.AddNetworkString("zyb_Constructionkit_Start_net")
util.AddNetworkString("zyb_Constructionkit_BuildEntity_net")
util.AddNetworkString("zyb_Constructionkit_Cancel_net")

function zyb.f.StartConstruction(ply, crate)
    net.Start("zyb_Constructionkit_Start_net")
    net.WriteEntity(crate)
    net.WriteInt(crate.ConstructionID, 16)
    net.Send(ply)
    zyb.f.Debug("zyb.f.StartConstruction")
end

net.Receive("zyb_Constructionkit_BuildEntity_net", function(len, ply)
    if zyb.f.Player_Timeout(ply) then return end
    local ent = net.ReadEntity()
    if IsValid(ent) and IsValid(ply) and zyb.f.InDistance(ply:GetPos(), ent:GetPos(), 200) then
        zyb.f.BuildEntity(ply, ent)
    end
end)

net.Receive("zyb_Constructionkit_Cancel_net", function(len, ply)
    if zyb.f.Player_Timeout(ply) then return end
    local ent = net.ReadEntity()

    if IsValid(ent) and (ent:GetClass() == "zyb_constructionkit_condenser" or ent:GetClass() == "zyb_constructionkit_cooler") and IsValid(ply) and zyb.f.InDistance(ply:GetPos(), ent:GetPos(), zyb.config.ConstructionKit.BuildDistance) then
        zyb.f.CancelBuilding(ply, ent)
    end
end)

function zyb.f.CancelBuilding(ply, crate)
    crate.InUse = false
    zyb.f.Debug("zyb.f.CancelBuilding")
    zyb.f.Notify(ply, zyb.language.General["ConstrtuctionCancelled"], 1)
end

function zyb.f.BuildEntity(ply, crate)
    local tr = ply:GetEyeTrace()
    local trEnt, trHit = tr.Entity, tr.HitPos
    local validPos,validang = zyb.f.ConstructionKit_ValidPos(tr, ply, crate)
    local kitData = zyb.config.ConstructionKit.Data[crate.ConstructionID]

    if trHit and trEnt:GetClass() == "zyb_distillery" and validPos then


        local m_phys = trEnt:GetPhysicsObject()
    	if IsValid(m_phys) then
    		m_phys:Wake()
    		m_phys:EnableMotion(false)
    	end

        local cooler =  trEnt:GetCooler()
        if IsValid(cooler) then
            local c_phys = cooler:GetPhysicsObject()
            if IsValid(c_phys) then
                c_phys:Wake()
                c_phys:EnableMotion(false)
            end
        end

        validPos = zyb.f.ConstructionKit_ValidPos(tr, ply, crate)

        local ent = ents.Create(kitData.class)
        ent:SetAngles(validang)
        ent:SetPos(validPos)
        ent:Spawn()
        ent:Activate()

        trEnt:DeleteOnRemove(ent)

        if crate.ConstructionID == 1 then
            zyb.f.Distillery_AddCondenser(trEnt,ent)
            // 416932157
            ent:SetPos(validPos)
            constraint.Axis(cooler, ent, 0, 0, cooler:WorldToLocal(cooler:GetPos() + cooler:GetUp() * 147  - cooler:GetRight() * 5), cooler:WorldToLocal(cooler:GetPos() + cooler:GetUp() * 150  - cooler:GetRight() * 5),0,0,0,1, cooler:GetUp(), false )
        elseif crate.ConstructionID == 2 then
            zyb.f.Distillery_AddCooler(trEnt,ent)
            ent:SetPos(validPos)
            constraint.Axis(trEnt, ent, 0, 0, trEnt:WorldToLocal(trEnt:GetPos() + trEnt:GetUp() * 147), trEnt:GetPos() + trEnt:GetUp() * 150,0,0,0,1, trEnt:GetUp(), false )
        end

        zyb.f.CreateNetEffect("sfx_building",trEnt)

        zyb.f.SetOwner(ent, ply)
        ent.Distillery = trEnt

        SafeRemoveEntity(crate)

        zyb.f.Debug("zyb.f.BuildEntity")
    else
        zyb.f.CancelBuilding(ply, crate)
    end
end
-- leak by lordee