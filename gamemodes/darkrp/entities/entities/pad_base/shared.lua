--[[
Server Name: !💠⇛SuperiorServers.co - Danktown | Crafting, Gambling, VIP, Package, Printer Event
Server IP:   208.103.169.12:27015
File Path:   addons/!lpakr_out/gamemodes/rp_base/entities/entities/pad_base/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]
ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.Spawnable = false
function ENT:SetupDataTables()
    self:NetworkVar('Int', 0, 'Status')
    self:NetworkVar('Int', 1, 'DetectiveWindow')
end

function ENT:CanDetect()
    return self:GetDetectiveWindow() > CurTime()
end

function ENT:IsPropsFaded()
    return self:GetStatus() == 1
end

function ENT:IsBusy()
    return self:GetStatus() >= 1
end