AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local ent_percentage = 30
local money_percentage = 15
local weapon_percentage = 8
local moneyprinter = 2
local food_percentage = 15
local plateperc = 5

local open_sound = "physics/metal/metal_solid_strain5.wav"

util.AddNetworkString('rp:dumpster:Scavenge:Small')

function ENT:Initialize()
    self:SetModel('models/props_junk/trashbin01a.mdl')
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
	
    net.Start('rp:dumpster:Scavenge:Small')
    net.WriteEntity(self)
    net.WriteUInt(self.CD[id], 32)
    net.Send(ply)
    
    rp.achievements.AddProgress(ply, ACHIEVEMENT_SCAVENGER, 1)
end

function ENT:EmitItems(searcher)
    self:EmitSound(open_sound, 300, 100)
    local pos = self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 20))
    
    for i = 1, math.random(1, 1) do
        local rand = math.random(1, 100)

        if rand <= weapon_percentage then
            local ent = ents.Create('spawned_weapon')
            local wep = rp.Weapons[math.random(1, #rp.Weapons)]
            local class = wep.Class
            ent.weaponclass = class
            ent:SetModel(weapons.Get(class).WorldModel)
            ent:SetPos(pos)
            ent:Spawn()
        elseif rand <= ent_percentage then
            local ent1 = ents.Create(rp.Drugs[math.random(1, #rp.Drugs)].Class)
            ent1:SetPos(pos)
            ent1:Spawn()
        elseif rand <= food_percentage then
            local ent = ents.Create('spawned_food')
            ent:SetPos(pos)
            local ran = math.random(1, #rp.Foods)
            ent:SetModel(rp.Foods[ran].model)
            ent.FoodEnergy = rp.Foods[ran].energy
            ent:Spawn()
        elseif rand <= money_percentage then
            local ent = ents.Create('spawned_money')
            ent:Setamount(math.random(5, 1321))
            ent:SetPos(pos)
            ent:Spawn()
        elseif rand <= moneyprinter then
            local ent = ents.Create('money_printer')
            ent:SetPos(pos)
            ent:Spawn()
        elseif rand <= plateperc then
            local ent = ents.Create('money_printer_plate')
            ent:SetPos(pos)
            ent:Spawn()
        else
            rp.Notify(searcher, NOTIFY_ERROR, 'Вы ничего не нашли!')
        end
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
    -- Удаляем старые контейнеры
    for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == 'ent_dumpster_small' then 
            v:Remove() 
        end
    end

    -- БЕЗОПАСНОЕ получение конфигурации для текущей карты
    local mapDumpsters = rp.cfg.Dumpsters[game.GetMap()] or {}
    
    for k, v in pairs(mapDumpsters.small or {}) do
        -- Безопасное смещение по Z, не изменяющее исходный вектор в конфиге
        local pos = v[1] + Vector(0, 0, 21)

        local dump = ents.Create('ent_dumpster_small')
        dump:SetPos(pos)
        dump:SetAngles(v[2])
        dump:Spawn() -- Исправлена поврежденная строка
    end
end

hook.Add('InitPostEntity', 'spawnsmol:)', function() 
    timer.Simple(8, function() 
        Respawn() 
    end) 
end)