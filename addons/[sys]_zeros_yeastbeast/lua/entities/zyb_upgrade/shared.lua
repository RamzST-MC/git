-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_distillery_filter.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Upgrade - Speed"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "UpgradeID")
    self:NetworkVar("Bool", 0, "IsDirty")


    if (SERVER) then
        self:SetIsDirty(false)
        self:SetUpgradeID(1)
    end
end
-- leak by lordee