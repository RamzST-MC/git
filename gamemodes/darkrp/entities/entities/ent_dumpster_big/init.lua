AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local open_sound = "physics/metal/metal_solid_strain5.wav"

util.AddNetworkString('rp:dumpster:Scavenge')

local chances = {
    { chance = 10, type = "weapon" },
    { chance = 15, type = "drug" },
    { chance = 20, type = "food" },
    { chance = 20, type = "money" },
    { chance = 5, type = "money_printer" },
    { chance = 10,  type = "printer_plate" },
    { chance = 20,  type = "nothing" }
}

function ENT:Initialize()
    self:SetModel('models/props_junk/trashdumpster01a.mdl')
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self.CD = {}
    self.ZAD = 120
end

function ENT:OnTakeDamage(dmginfo)
    return
end

function ENT:Use(ply)
    local id = ply:SteamID64()
    if not rp.teams[ply:Team()] or not rp.teams[ply:Team()].hobo then
        rp.Notify(ply, NOTIFY_ERROR, 'Вы не можете обыскивать мусорный контейнер!')
        return
    end

    if self.CD[id] and self.CD[id] > CurTime() then
        rp.Notify(ply, NOTIFY_ERROR, 'Контейнер ещё не восстановился!')
        return
    end

    self.CD[id] = CurTime() + self.ZAD
    self:EmitItems(ply)

    net.Start('rp:dumpster:Scavenge')
    net.WriteEntity(self)
    net.WriteUInt(self.CD[id], 32)
    net.Send(ply)
    
    rp.achievements.AddProgress(ply, ACHIEVEMENT_SCAVENGER, 1)
end

function ENT:EmitItems(searcher)
    self:EmitSound(open_sound, 300, 100)
    local pos = self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 20))

    local rand = math.random(1, 100)
    local accum = 0
    local dropType = "nothing"

    for _, item in ipairs(chances) do
        accum = accum + item.chance
        if rand <= accum then
            dropType = item.type
            break
        end
    end

    if dropType == "weapon" then
        local ent = ents.Create('spawned_weapon')
        local wep = rp.Weapons[math.random(1, #rp.Weapons)]
        local class = wep.Class
        ent.weaponclass = class
        ent:SetModel(weapons.Get(class).WorldModel)
        ent:SetPos(pos)
        ent:Spawn()

    elseif dropType == "drug" then
        local ent1 = ents.Create(rp.Drugs[math.random(1, #rp.Drugs)].Class)
        ent1:SetPos(pos)
        ent1:Spawn()

    elseif dropType == "food" then
        local ent = ents.Create('spawned_food')
        local ran = math.random(1, #rp.Foods)
        ent:SetModel(rp.Foods[ran].model)
        ent.FoodEnergy = rp.Foods[ran].energy
        ent:SetPos(pos)
        ent:Spawn()

    elseif dropType == "money" then
        local ent = ents.Create('spawned_money')
        ent:Setamount(math.random(5, 1321))
        ent:SetPos(pos)
        ent:Spawn()

    elseif dropType == "money_printer" then
        local ent = ents.Create('money_printer')
        ent:SetPos(pos)
        ent:Spawn()

    elseif dropType == "printer_plate" then
        local ent = ents.Create('money_printer_plate')
        ent:SetPos(pos)
        ent:Spawn()

    else
        rp.Notify(searcher, NOTIFY_ERROR, 'Вы ничего не нашли!')
    end
end

function ENT:Think()
    for id, cooldown in pairs(self.CD) do
        if cooldown < CurTime() then
            self.CD[id] = nil
        end
    end

    self:NextThink(CurTime() + 1)
    return true
end

local function Respawn()
    for _, v in pairs(ents.GetAll()) do
        if v:GetClass() == 'ent_dumpster_big' then
            v:Remove()
        end
    end

    local mapDumpsters = rp.cfg.Dumpsters[game.GetMap()]
    if not mapDumpsters then
        ErrorNoHalt("[DarkRP] WARNING: No dumpster positions defined for map '" .. game.GetMap() .. "' in rp.cfg.Dumpsters\n")
        return
    end

    for _, v in pairs(mapDumpsters.big or {}) do
        local pos = v[1]
        pos.z = pos.z + 27

        local dump = ents.Create('ent_dumpster_big')
        dump:SetPos(pos)
        dump:SetAngles(v[2])
        dump:Spawn()
    end
end

hook.Add('InitPostEntity', 'SpawnDumpstersBig', function()
    timer.Simple(8, function()
        Respawn()
    end)
end)

concommand.Add('moneym', function(pl)
    if not pl:IsRoot() then return end
    local pos = pl:GetEyeTrace().HitPos

    local ent = ents.Create('money_printer')
    ent:SetPos(pos)
    ent:Spawn()
end)
