--[[
Server Name: !💠⇛SuperiorServers.co - Danktown | Crafting, Gambling, VIP, Package, Printer Event
Server IP:   208.103.169.12:27015
File Path:   addons/!lpakr_out/gamemodes/rp_base/gamemode/core/player/weapons/weapons_sh.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]
function PLAYER:GetStagedWeapons()
    if self.StagedWeaponsQueue then return self.StagedWeaponsQueue end
    return self:GetNetVar('StagedWeapons') or {}
end

function PLAYER:HasStagedWeapon(a)
    for b, c in ipairs(self:GetStagedWeapons()) do
        if c.Class == a then return true end
    end
    return false
end

PLAYER._HasWeapon = PLAYER._HasWeapon or PLAYER.HasWeapon
function PLAYER:HasWeapon(a)
    return self:HasStagedWeapon(a) or self:_HasWeapon(a)
end

function PLAYER:HasWeaponEntity(a)
    return self:_HasWeapon(a)
end