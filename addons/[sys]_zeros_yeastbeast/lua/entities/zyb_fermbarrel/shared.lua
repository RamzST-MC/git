-- leak by lordee
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_yeastbeast/yb_barrel.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Fermentation Barrel"
ENT.Category = "Zeros YeastBeast"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "YeastAmount")
    self:NetworkVar("Int", 1, "WaterAmount")
    self:NetworkVar("Int", 3, "SugarAmount")

    self:NetworkVar("Int", 4, "Stage")
    self:NetworkVar("Int", 5, "ShakeProgress")

    self:NetworkVar("Float", 0, "FermentingTime")
    self:NetworkVar("Int", 6, "YeastStew")

    self:NetworkVar("Bool", 0, "HideUI")

    self:NetworkVar("Int", 7, "DirtLevel")
    self:NetworkVar("Bool", 1, "Filling")


    if (SERVER) then
        self:SetFilling(false)
        self:SetHideUI(false)
        self:SetYeastAmount(0)
        self:SetWaterAmount(0)
        self:SetSugarAmount(0)
        self:SetStage(0)
        self:SetDirtLevel(0)
        self:SetShakeProgress(0)
        self:SetFermentingTime(-1)
        self:SetYeastStew(0)
    end
end
-- leak by lordee