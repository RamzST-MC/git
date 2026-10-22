--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
if CLIENT then
    zclib.Convar.Create("zgo2_cl_smoothgrow", "1", {FCVAR_ARCHIVE})

	zclib.Convar.Create("zgo2_cl_dynlight", "0", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_lightsprite", "1", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_lightbeam", "1", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_drawskank", "1", {FCVAR_ARCHIVE})


else
	zclib.Convar.Create("zgo2_sv_growspeed", "1", {FCVAR_ARCHIVE})
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher