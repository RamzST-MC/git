-- leak by lordee

zyb = zyb or {}
zyb.f = zyb.f or {}

-- This checks if we are lookinga t a valid space for building a entity
function zyb.f.ConstructionKit_ValidPos(tr, ply, crate)
    local trEnt = tr.Entity
    local validpos = false
    local validang
    local ConstructionID = crate.ConstructionID

    if IsValid(crate) and zyb.f.InDistance(tr.HitPos, ply:GetPos(),  zyb.config.ConstructionKit.BuildDistance) and zyb.f.InDistance(tr.HitPos, crate:GetPos(),  zyb.config.ConstructionKit.BuildDistance)  then
        if IsValid(trEnt) and trEnt:GetClass() == "zyb_distillery" then
            local cooler = trEnt:GetCooler()
            local condenser = trEnt:GetCondenser()

            if ConstructionID == 2 and not IsValid(cooler) and not IsValid(condenser) then
                validpos = trEnt:GetPos() - trEnt:GetRight() * 69.5
                validang = trEnt:GetAngles()
            elseif ConstructionID == 1 and IsValid(cooler) and not IsValid(condenser) then
                validpos = cooler:GetPos() - cooler:GetRight() * 45
                validang = cooler:GetAngles()
            else
                validpos = false
            end
        else
            validpos = false
        end
    else
        validpos = false
    end

    return validpos,validang
end
-- leak by lordee