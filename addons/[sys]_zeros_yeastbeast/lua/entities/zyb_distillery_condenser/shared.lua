-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_yeastbeast/yb_distillery_condenser.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Condenser"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_OPAQUE



function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "WeakMoonShine")
    self:NetworkVar("Int", 1, "MoonShine")
    self:NetworkVar("Bool", 0, "FillingJar")

    self:NetworkVar("Float", 0, "SpeedBoost")
    self:NetworkVar("Float", 1, "ProductionBoost")


    if (SERVER) then
        self:SetWeakMoonShine(0)
        self:SetMoonShine(0)
        self:SetFillingJar(false)
        self:SetSpeedBoost(0)
        self:SetProductionBoost(0)
    end
end

function ENT:OnUpgradeMenu(ply)
    local trace = ply:GetEyeTrace()
    //debugoverlay.Sphere( self:LocalToWorld(Vector(15, 0, 69)), 1, 1, Color( 255, 255, 255 ),false )
    if zyb.f.InDistance(self:LocalToWorld(Vector(15, 0, 69)), trace.HitPos, 6) then
        return true
    else
        return false
    end
end
-- leak by lordee