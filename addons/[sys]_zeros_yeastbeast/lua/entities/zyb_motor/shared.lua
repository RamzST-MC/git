-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_yeastbeast/yb_motor.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Grinder Motor"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Running")


    if (SERVER) then
        self:SetRunning(false)
    end
end
-- leak by lordee