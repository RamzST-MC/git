-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_yeastbeast/yb_distillery_cooler.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Cooler"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "YeastStewSteam")
    self:NetworkVar("Int", 1, "WeakMoonShine")
    self:NetworkVar("Int", 2, "Water")
    self:NetworkVar("Int", 3, "WaterTemperatur")
    self:NetworkVar("Bool", 0, "DeflowWater")

    if (SERVER) then
        self:SetYeastStewSteam(0)
        self:SetWeakMoonShine(0)
        self:SetWater(zyb.config.Cooler.WaterAmount / 2)
        self:SetWaterTemperatur(0)
        self:SetDeflowWater(false)

    end
end

function ENT:OnWaterValve(ply)
    local trace = ply:GetEyeTrace()

    if zyb.f.InDistance(self:LocalToWorld(Vector(15, 0, 60)), trace.HitPos, 15) then
        return true
    else
        return false
    end
end
-- leak by lordee