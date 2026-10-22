PLAYER.SteamName = PLAYER.SteamName or PLAYER.Name

function PLAYER:Name()
    if IsValid(self) then return self:GetNetVar('Name') or self:SteamName() end
    return 'Unknown'
end

PLAYER.Nick = PLAYER.Name
PLAYER.GetName = PLAYER.Name

function PLAYER:GetMoney()
    return (self:GetNetVar('Money') or (rp.cfg and rp.cfg.StartMoney or 0))
end

-- Переменные объявлены ДО их использования
local math_round = math.Round
local math_max = math.max
local math_floor = math.floor
local math_min = math.min
local CurTime = CurTime

function PLAYER:GetHunger()
    if not self:Alive() then return 100 end
    local hungerRate = (rp.cfg and rp.cfg.HungerRate or 300)
    local energy = self:GetNetVar('Energy') or (CurTime() + hungerRate)
    return math_max(math_round(((energy - CurTime()) / hungerRate) * 100, 0), 0)
end

function PLAYER:Wealth(min, max)
    min = min or 0
    max = max or 100
    return math_min(math_floor(min + ((max - min) * (self:GetMoney() / 25000000))), max)
end

function PLAYER:HasLicense()
    if not IsValid(self) then return false end
    if self:GetNetVar('HasGunlicense') then return true end
    local jobTable = self:GetJobTable()
    if jobTable and jobTable.hasLicense then return true end
    return false
end

function PLAYER:GetZarobotok() return self:GetNetVar('GamblingZarobotok') or 0 end
function PLAYER:GetUbitok() return self:GetNetVar('GamblingUbitok') or 0 end
function PLAYER:GetProfit() return self:GetZarobotok() - self:GetUbitok() end