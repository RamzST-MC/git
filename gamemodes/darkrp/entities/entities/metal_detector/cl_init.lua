--[[
Server Name: ★ Русский FustRP#3 [Быстрая загрузка]
Server IP:   46.174.55.246:27015
File Path:   gamemodes/darkrp/entities/entities/metal_detector/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include 'shared.lua'

local colors = {
	rp.col.Black,
	rp.col.Green,
	rp.col.Red,
}

function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(self:GetPos() + ang:Up() * 0.65, ang, 0.1)
		draw.Box(-225, -606, 460, 144, colors[self:GetMode()])
	cam.End3D2D()
end