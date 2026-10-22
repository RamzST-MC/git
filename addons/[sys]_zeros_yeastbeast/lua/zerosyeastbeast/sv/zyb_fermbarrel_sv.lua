-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Fermbarrel_Initialize(barrel)
    barrel.IsBusy = false
    barrel.LastCleanPos = barrel:GetPos()

    zyb.f.EntList_Add(barrel)
end

function zyb.f.Fermbarrel_OnTouch(barrel, other)
    if barrel.IsBusy then return end
    if not IsValid(other) then return end
    if zyb.f.CollisionCooldown(other) then return end

    if barrel:GetStage() == 0 then
        if other:GetClass() == "zyb_paperbag" and other:GetYeastAmount() > 0 and barrel:GetYeastAmount() < zyb.config.FermBarrel.YeastAmount then
            barrel.IsBusy = true
            zyb.f.Fermbarrel_AddIngredient(barrel,other, 1)
            zyb.f.CreateNetEffect("fx_yeast_fill", other)
        elseif other:GetClass() == "zyb_water" and barrel:GetWaterAmount() < zyb.config.FermBarrel.WaterAmount then
            barrel.IsBusy = true
            zyb.f.Fermbarrel_AddIngredient(barrel,other, 2)
            zyb.f.CreateNetEffect("fx_water_fill", other)
        elseif other:GetClass() == "zyb_sugar" and barrel:GetSugarAmount() < zyb.config.FermBarrel.SugarAmount then
            barrel.IsBusy = true
            zyb.f.Fermbarrel_AddIngredient(barrel,other, 3)
            zyb.f.CreateNetEffect("fx_sugar_fill", other)
        end
    end
end

function zyb.f.Fermbarrel_OnUse(barrel, ply)
    if barrel:GetStage() == 4 then
        local trace = ply:GetEyeTrace()

        if trace and trace.Hit and trace.HitPos then
            barrel.LastCleanPos = trace.HitPos
            barrel:SetDirtLevel(math.Clamp(barrel:GetDirtLevel() - zyb.config.FermBarrel.CleanPerClick, 0, zyb.config.FermBarrel.DirtAmount))
            zyb.f.CreateNetEffect("fx_clean", trace.HitPos)

            if barrel:GetDirtLevel() <= 0 then
                barrel:SetSkin(0)
                barrel:SetStage(0)
                barrel:SetDirtLevel(0)
            end
        end
    end
end

function zyb.f.Fermbarrel_OnRemove(barrel)
    zyb.f.Timer_Remove("zyb_ShakeTimer_" .. barrel:EntIndex())
    zyb.f.Timer_Remove("zyb_FermentTimer_" .. barrel:EntIndex())
end




function zyb.f.Fermbarrel_AddIngredient(barrel, ent, itype)
    barrel:SetHideUI(true)

    DropEntityIfHeld(ent)

    local ang = barrel:GetAngles()
    ang:RotateAroundAxis(barrel:GetRight(), 180)
    ent:SetAngles(ang)

    local up = 65

    if itype == 1 then
        up = 75
    elseif itype == 2 then
        up = 80
        zyb.f.CreateNetEffect("fx_water_fill", ent)
    elseif itype == 3 then
        up = 65
        ent:SetBodygroup(0, 1)
    end

    barrel:SetFilling(true)
    ent:SetPos(barrel:GetPos() + barrel:GetUp() * up)
    ent:SetParent(barrel)
    barrel:SetBodygroup(3, 1)
    local fillTime = 2

    if itype == 1 then
        fillTime = 3 / zyb.config.PaperBag.Capacity * ent:GetYeastAmount()
    end

    timer.Simple(fillTime, function()
        if IsValid(barrel) and IsValid(ent) then
            if itype == 1 then
                barrel:SetYeastAmount(math.Clamp(barrel:GetYeastAmount() + ent:GetYeastAmount(), 0, zyb.config.FermBarrel.YeastAmount))
            elseif itype == 2 then
                barrel:SetWaterAmount(math.Clamp(barrel:GetWaterAmount() + zyb.config.Water.Amount, 0, zyb.config.FermBarrel.WaterAmount))
            elseif itype == 3 then
                barrel:SetSugarAmount(math.Clamp(barrel:GetSugarAmount() + zyb.config.Sugar.Amount, 0, zyb.config.FermBarrel.SugarAmount))
            end

            barrel:SetFilling(false)
            barrel:SetBodygroup(3, 0)

            SafeRemoveEntity(ent)

            barrel.IsBusy = false
            zyb.f.Fermbarrel_CheckProgress(barrel)
            barrel:SetHideUI(false)
        end
    end)
end

function zyb.f.Fermbarrel_CheckProgress(barrel)
    local stage = barrel:GetStage()

    if stage == 0 then
        local amount = barrel:GetYeastAmount() + barrel:GetWaterAmount() + barrel:GetSugarAmount()
        local maxCap = zyb.config.FermBarrel.YeastAmount + zyb.config.FermBarrel.WaterAmount + zyb.config.FermBarrel.SugarAmount

        if amount >= maxCap then
            barrel:SetBodygroup(2, 1)
            barrel:SetStage(1)

            zyb.f.Timer_Create("zyb_ShakeTimer_" .. barrel:EntIndex(), 1, 0, function()
                if IsValid(barrel) then
                    if barrel:GetStage() == 1 and barrel:GetVelocity():Length() > 50 then
                        barrel:SetShakeProgress(barrel:GetShakeProgress() + 1)
                        zyb.f.Fermbarrel_CheckProgress(barrel)
                    end
                else
                    zyb.f.Timer_Remove("zyb_ShakeTimer_" .. barrel:EntIndex())
                end
            end)
        end
    elseif stage == 1 then
        if barrel:GetShakeProgress() >= zyb.config.FermBarrel.ShakeCount then

            zyb.f.Timer_Remove("zyb_ShakeTimer_" .. barrel:EntIndex())

            barrel:SetStage(2)
            zyb.f.Fermbarrel_StartFermenting(barrel)
        end
    end
end

function zyb.f.Fermbarrel_StartFermenting(barrel)
    barrel:SetBodygroup(2, 0)
    barrel:SetBodygroup(1, 1)
    barrel:SetFermentingTime(CurTime() + zyb.config.FermBarrel.FermentingTime)

    zyb.f.Timer_Create("zyb_FermentTimer_" .. barrel:EntIndex(),  zyb.config.FermBarrel.FermentingTime, 1,function()
        if IsValid(barrel) then
            zyb.f.Fermbarrel_FinishFermenting(barrel)
        else
            zyb.f.Timer_Remove("zyb_FermentTimer_" .. barrel:EntIndex())
        end
    end)
end

function zyb.f.Fermbarrel_FinishFermenting(barrel)
    zyb.f.Timer_Remove("zyb_FermentTimer_" .. barrel:EntIndex())

    barrel:SetBodygroup(2, 1)
    barrel:SetBodygroup(1, 0)
    barrel:SetFermentingTime(-1)
    barrel:SetYeastStew(zyb.config.FermBarrel.YeastStew)
    barrel:SetStage(3)
end

function zyb.f.Fermbarrel_Reset(barrel)
    if zyb.config.FermBarrel.DirtAmount > 0 then
        barrel:SetStage(4)
        barrel:SetDirtLevel(zyb.config.FermBarrel.DirtAmount)
        barrel:SetSkin(1)
    else
        barrel:SetStage(0)
    end

    barrel:SetBodygroup(0, 0)
    barrel:SetBodygroup(1, 0)
    barrel:SetBodygroup(2, 0)
    barrel:SetBodygroup(3, 0)
    barrel:SetYeastAmount(0)
    barrel:SetWaterAmount(0)
    barrel:SetSugarAmount(0)
    barrel:SetShakeProgress(0)
    barrel:SetFermentingTime(-1)
    barrel:SetYeastStew(0)
end
-- leak by lordee