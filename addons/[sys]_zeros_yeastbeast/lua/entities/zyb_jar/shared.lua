-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_jar.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Jar"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MoonShine")

    if (SERVER) then
        self:SetMoonShine(0)
    end
end
-- leak by lordee