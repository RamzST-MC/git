-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_water.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Cold Water"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:SetupDataTables()

    self:NetworkVar("Bool", 0, "Filling")

    if (SERVER) then
        self:SetFilling(false)
    end
end
-- leak by lordee