-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_jarpack.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "JarPack"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "JarCount")

    if (SERVER) then
        self:SetJarCount(6)
    end
end
-- leak by lordee