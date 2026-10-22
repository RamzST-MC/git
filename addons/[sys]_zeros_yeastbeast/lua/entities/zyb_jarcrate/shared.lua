-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_jarcrate.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Jar Crate"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "JarCount")

    if SERVER then
        self:SetJarCount(0)
    end
end

function ENT:OnCollectButton(ply)
    local trace = ply:GetEyeTrace()
    if zyb.f.InDistance(self:LocalToWorld(Vector(0, 11, 9)), trace.HitPos, 3) then
        return true
    else
        return false
    end
end

function ENT:OnExtractButton(ply)
    local trace = ply:GetEyeTrace()
    if zyb.f.InDistance(self:LocalToWorld(Vector(0, 11, 3)), trace.HitPos, 3) then
        return true
    else
        return false
    end
end
-- leak by lordee