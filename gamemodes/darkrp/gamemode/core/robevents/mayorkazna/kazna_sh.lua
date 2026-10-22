local ENTITY = FindMetaTable('Entity')

function ENTITY:SetKaznaMoney(num)
    nw.SetGlobal('Kazna::Money', num)
end

function ENTITY:GetKaznaMoney()
    return nw.GetGlobal('Kazna::Money') or 0
end

function ENTITY:IsRobbing()
    return nw.GetGlobal("Kazna::EstTime") > 0
end

function ENTITY:GetRobTime()
    return nw.GetGlobal("Kazna::EstTime") > 0 and nw.GetGlobal("Kazna::EstTime") or 0
end