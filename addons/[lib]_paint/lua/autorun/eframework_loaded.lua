if CLIENT and BRANCH ~= 'x64-86' then
	local vec = Vector()
	local vecSetUnpacked = vec.SetUnpacked


	mesh.OldPosition = mesh.OldPosition or mesh.Position

    function mesh.Position(x, y, z)
		if y == nil then
			mesh.OldPosition(x)
			return
		end

        vecSetUnpacked(vec, x, y, z)
		mesh.OldPosition(vec)
	end
end

local function load(path)
	AddCSLuaFile(path)
	if CLIENT then
		include(path)
	end
end

load('paint/main_cl.lua')
load('paint/batch_cl.lua')
load('paint/lines_cl.lua')
load('paint/rects_cl.lua')
load('paint/rounded_boxes_cl.lua')
load('paint/outlines_cl.lua')
load('paint/blur_cl.lua')
load('paint/circles_cl.lua')

hook.Add('OnGamemodeLoaded', 'eui:LoadedMain', function()
    load('paint/main_cl.lua')
    load('paint/batch_cl.lua')
    load('paint/lines_cl.lua')
    load('paint/rects_cl.lua')
    load('paint/rounded_boxes_cl.lua')
    load('paint/outlines_cl.lua')
    load('paint/blur_cl.lua')
    load('paint/circles_cl.lua')

    hook.Call('eui.Loaded')
end)