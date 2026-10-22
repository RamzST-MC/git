-- Notifications
ba.include_dir 'core/util/notifications'
dash.IncludeSH 'terms_sh.lua'
-- Data
dash.IncludeSV 'data_sv.lua'

-- Http
ba.include_dir 'core/util/http'

-- Util
ba.include_dir 'core/util'

-- Player
dash.IncludeSH 'player_sh.lua'

-- Ranks
dash.IncludeSH 'ranks/groups_sh.lua'
dash.IncludeSV 'ranks/groups_sv.lua'
dash.IncludeSH 'ranks/setup_sh.lua'

-- Commands
dash.IncludeSH 'commands/commands_sh.lua'
dash.IncludeSV 'commands/commands_sv.lua'
dash.IncludeSH 'commands/parser_sh.lua'

-- Bans
dash.IncludeSV 'bans_sv.lua'

-- UI
dash.IncludeCL 'ui/main_cl.lua'
dash.IncludeSH 'ui/main_sh.lua'
local files, _ = file.Find('ba/core/ui/vgui/*.lua', 'LUA')
for k, v in ipairs(files) do
	dash.IncludeCL('ui/vgui/' .. v)
end

-- Logging
dash.IncludeSH 'logging/logs_sh.lua'
dash.IncludeSV 'logging/logs_sv.lua'
dash.IncludeCL 'logging/logs_cl.lua'

-- Modules
dash.IncludeSH 'module_loader.lua'

-- Plugins
ba.include_dir 'plugins'