rp      = rp or {} 
rp.util = rp.util or {}
rp.cfg 	= rp.cfg or {} 
rp.inv 	= rp.inv or {Data = {}, Wl = {}} 

PLAYER	= FindMetaTable 'Player'
ENTITY	= FindMetaTable 'Entity'
VECTOR	= FindMetaTable 'Vector'

if SERVER then
	require'mysql'
else
    require'texture'
    require'imgui'
    texture.SetProxy'https://gmod-api.superiorservers.co/api/imageproxy/?url=%s&width=%i&height=%i&format=%s'
end

require'cvar'
require'hash'
require'nw'
require'pon'
require'term'
require'cmd'
require 'keybind'

rp.include = function(f)
	if string.find(f, '_sv.lua') then
		return dash.IncludeSV(f)
	elseif string.find(f, '_cl.lua') then
		return dash.IncludeCL(f)
	else
		return dash.IncludeSH(f)
	end
end
rp.include_dir = function(dir, recursive)
	local fol = dir .. '/'
	local files, folders = file.Find(fol .. '*', 'LUA')
	for _, f in ipairs(files) do
		rp.include(fol .. f)
	end
	if (recursive ~= false) then
		for _, f in ipairs(folders) do
			rp.include_dir(dir .. '/' .. f)
		end
	end
end

local loadmsg = {
	[[discord: tgmain]],
}

GM.Name 	= 'DarkRP'
dash.IncludeSV 'darkrp/gamemode/db.lua'

dash.IncludeSH 'darkrp/gamemode/cfg/cfg.lua'
dash.IncludeSH 'darkrp/gamemode/cfg/colors.lua'
dash.IncludeCL'darkrp/gamemode/cfg/renderoffsets.lua'

rp.include_dir 'darkrp/gamemode/util'

rp.include_dir('darkrp/gamemode/core', false)
rp.include_dir 'darkrp/gamemode/core/sandbox'
rp.include_dir('darkrp/gamemode/core/chat', false)
rp.include_dir 'darkrp/gamemode/core/player'
rp.include_dir'darkrp/gamemode/core/orgs'
rp.include_dir('darkrp/gamemode/core/events')
rp.include_dir 'darkrp/gamemode/core/ui'
rp.include_dir('darkrp/gamemode/core/prop_protect', false)
rp.include_dir'darkrp/gamemode/core/cosmetics/hats'
rp.include_dir'darkrp/gamemode/core/cosmetics/misc'
rp.include_dir'darkrp/gamemode/core/emotes'
rp.include_dir('darkrp/gamemode/core/makethings', false)
rp.include_dir 'darkrp/gamemode/core/robevents'
rp.include_dir('darkrp/gamemode/core/commands', false)
rp.include_dir('darkrp/gamemode/core/smallscripts', false)
rp.include_dir('darkrp/gamemode/core/hud', true)

rp.include_dir'darkrp/gamemode/core/achievements'
rp.include_dir 'darkrp/gamemode/core/somemodules'
dash.IncludeSH('darkrp/gamemode/cfg/jobs.lua')
dash.IncludeSH('darkrp/gamemode/cfg/doors/' .. game.GetMap() .. '.lua')
rp.include_dir('darkrp/gamemode/core/doors', false)
dash.IncludeSH'darkrp/gamemode/cfg/achievements.lua'
dash.IncludeSH'darkrp/gamemode/cfg/skills.lua'

dash.IncludeSH 'darkrp/gamemode/cfg/entities.lua'
dash.IncludeSH 'darkrp/gamemode/cfg/cosmetics.lua'
dash.IncludeSV 'darkrp/gamemode/cfg/events.lua'
dash.IncludeSH 'darkrp/gamemode/cfg/terms.lua'
dash.IncludeSV 'darkrp/gamemode/cfg/limits.lua'
dash.IncludeSH'darkrp/gamemode/cfg/emotes.lua'

for _, v in next, loadmsg do
	MsgC(Color(255, 217, 0), v .. '\n')
	MsgC(Color(255, 217, 0), v .. '\n')
	MsgC(Color(255, 217, 0), v .. '\n')
	MsgC(Color(255, 217, 0), v .. '\n')
	MsgC(Color(255, 217, 0), v .. '\n')
end