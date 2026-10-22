--[[
Server Name: ★ Русский FustRP#3 [Быстрая загрузка]
Server IP:   46.174.55.246:27015
File Path:   gamemodes/darkrp/entities/entities/metal_detector/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type 		= 'anim' 
ENT.Base		= 'base_anim' 
ENT.PrintName	= 'Metal Detector'
ENT.Author		= 'aStonedPenguin'
ENT.Spawnable	= true
ENT.Category 	= 'RP'
ENT.MaxHealth 	= 150

function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Mode')
end