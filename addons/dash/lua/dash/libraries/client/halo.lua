-- "addons\\cosmic\\lua\\dash\\libraries\\client\\halo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
halo = {
	Add = function() end,
	RenderedEntity = function() return NULL end
}

hook.Add("PostDrawEffects", "rp.RenderHalos", function()
	hook.Run("PreDrawHalos")
end)