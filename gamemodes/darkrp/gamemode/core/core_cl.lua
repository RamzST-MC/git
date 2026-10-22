timer.Simple(0.5, function()
	local GM = GAMEMODE
end)


local Talkers = {}
hook('PlayerStartVoice', 'rp.PlayerStartVoice', function(pl)
	Talkers[pl] = true
end)

hook('PlayerEndVoice', 'rp.PlayerEndVoice', function(pl)
	Talkers[pl] = nil
end)


local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
function GM:ShowSpare1()
	if LocalPlayer():IsBanned() then return end
	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	if LocalPlayer():IsBanned() then return end

	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] and GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end
	return
end

hook('PlayerCloseLoadInScreen', 'rp.spawn.PlayerCloseLoadInScreen',function()
	cmd.Run('spawn')
end)

local g, h
function GM:DrawPhysgunBeam(a, i, j, k, l, b)
    if a == LocalPlayer() then
        g = i
        h = k
    end
    return true
end

local m = ui.col.SUP
hook('SetupOutlines', 'rp.physgun.SetupOutlines', function()
	if IsValid(h) then
		outline.Add(h, m, outline.MODE_VISIBLE)
	end
end)
