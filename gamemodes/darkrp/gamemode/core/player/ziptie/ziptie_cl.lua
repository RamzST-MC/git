rp.ziptie = rp.ziptie or {}
rp.ziptie.Ents = rp.ziptie.Ents or {}

local a = Material("cable/rope")
local b = ui.col.Black
local c = render.SetMaterial
local d = render.DrawBeam
local e = Vector(0, 0, 6)

hook('PostPlayerDraw', 'rp.Zipties.PostPlayerDraw', function(f)
    if f:IsZiptied() and f:Alive() then
        local g = f:LookupBone("ValveBiped.Bip01_R_Hand")
        if not g then return end
        local h = f:LookupBone("ValveBiped.Bip01_L_Hand")
        local i = f:LookupBone("ValveBiped.Bip01_R_Foot")
        local j = f:LookupBone("ValveBiped.Bip01_L_Foot")
        local k = f:LookupBone("ValveBiped.Bip01_Neck1")
        local l = f:GetBonePosition(g)
        local m = f:GetBonePosition(h)
        local n = f:GetBonePosition(i)
        local o = f:GetBonePosition(j)
        local p = f:GetBonePosition(k)
        c(a)
        d(l, m, 0.7, 0, 5, b)
        d(m, o, -0.7, 0, 5, b)
        d(l, n, -0.7, 0, 5, b)
        d(o, n, -0.7, 0, 5, b)
        d(l, o, -0.7, 0, 5, b)
        d(m, n, -0.7, 0, 5, b)
        d(l, p, -0.7, 0, 5, b)
        d(m, p, -0.7, 0, 5, b)
    end

    if f:IsCarrying() then
        local q = f:GetCarried()
        if not IsValid(f.Ragdoll) and IsValid(q) then
            f.Ragdoll = ClientsideModel(q:GetModel(), RENDERGROUP_BOTH)
            local r = f.Ragdoll
            if not IsValid(r) then return end
            r.Carrier = f
            r.Carried = q
            rp.ziptie.Ents[r] = true
            r:SetSequence(r:LookupSequence('sit'))
        end

        local g = f:LookupBone("ValveBiped.Bip01_R_Hand") or f:LookupBone("ValveBiped.Bip01_L_Hand") or f:LookupBone("ValveBiped.Bip01_Neck1")
        if not g or not IsValid(f.Ragdoll) then return end
        local s, t = f:GetBonePosition(g)
        local t = f:EyeAngles()
        t.pitch = 90
        t.roll = 180
        s.z = s.z + 15
        f.Ragdoll:SetPos(s)
        f.Ragdoll:SetAngles(t)
        f.Ragdoll:SetRenderOrigin(s)
        f.Ragdoll:SetRenderAngles(t)
        f.Ragdoll:SetupBones()
        f.Ragdoll:DrawModel()
        f.Ragdoll:SetRenderOrigin()
        f.Ragdoll:SetRenderAngles()
    elseif IsValid(f.Ragdoll) then
        f.Ragdoll:Remove()
        f.Ragdoll = nil
    end

    if IsValid(f:GetActiveWeapon()) and f:GetActiveWeapon():GetClass() == "weapon_ziptie" then
        local g = f:LookupBone("ValveBiped.Bip01_R_Hand")
        if not g then return end
        local h = f:LookupBone("ValveBiped.Bip01_L_Hand")
        local l = f:GetBonePosition(g) + f:EyeAngles():Forward() * 4
        local m = f:GetBonePosition(h) + f:EyeAngles():Forward() * 4
        c(a)
        d(l, m, 0.7, 0, 5, b)
        d(l, l - e, -0.7, 0, 5, b)
        d(m, m - e, -0.7, 0, 5, b)
    end

    for u, v in pairs(rp.ziptie.Ents) do
        if not IsValid(u) or not IsValid(u.Carrier) or not IsValid(u.Carried) or not u.Carried:IsBeingCarried() then
            rp.ziptie.Ents[u] = nil
            SafeRemoveEntity(u)
        end
    end
end)

hook('PrePlayerDraw', 'rp.Zipties.PrePlayerDraw', function(f) if f:IsBeingCarried() and IsValid(f:GetCarrier()) and f:GetCarrier() == LocalPlayer() and not rp.thirdPerson.isEnabled() then return true end end)
local w = Vector(-25, -15, 10)
hook('GetPlayerInfoPos', 'rp.Zipties.GetPlayerInfoPos', function(f)
    if not f:IsBeingCarried() then return end
    local x = f:GetCarrier()
    if not IsValid(x) then return end
    local s = hook.Run('GetPlayerInfoPos', x)
    return x:LocalToWorld(x:WorldToLocal(s) + w)
end)