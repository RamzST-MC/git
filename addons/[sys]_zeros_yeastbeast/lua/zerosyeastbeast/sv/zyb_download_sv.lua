-- leak by lordee
if CLIENT then return end

if zyb.config.EnableResourceAddfile then
	zyb = zyb or {}
	zyb.force = zyb.force or {}

	function zyb.force.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zyb.force.AddDir(path .. "/" .. v)
		end
	end

	zyb.force.AddDir("sound/zyb")
	zyb.force.AddDir("models/zerochain/props_yeastbeast")
	zyb.force.AddDir("materials/particle/zyb")
	zyb.force.AddDir("materials/zerochain/particles_yeastbeast")
	zyb.force.AddDir("materials/zerochain/props_yeastbeast")
	zyb.force.AddDir("materials/zerochain/zyb")

	resource.AddSingleFile("particles/zyb_clean.pcf")
	resource.AddSingleFile("particles/zyb_sell.pcf")
	resource.AddSingleFile("particles/zyb_vfx.pcf")

	resource.AddSingleFile("resource/fonts/bebasneue.ttf")

	resource.AddSingleFile("materials/entities/zyb_constructionkit_condenser.png")
	resource.AddSingleFile("materials/entities/zyb_constructionkit_cooler.png")
	resource.AddSingleFile("materials/entities/zyb_distillery.png")
	resource.AddSingleFile("materials/entities/zyb_fermbarrel.png")
	resource.AddSingleFile("materials/entities/zyb_fuel.png")
	resource.AddSingleFile("materials/entities/zyb_jar.png")
	resource.AddSingleFile("materials/entities/zyb_jarcrate.png")
	resource.AddSingleFile("materials/entities/zyb_jarpack.png")
	resource.AddSingleFile("materials/entities/zyb_motor.png")
	resource.AddSingleFile("materials/entities/zyb_paperbag.png")
	resource.AddSingleFile("materials/entities/zyb_sugar.png")
	resource.AddSingleFile("materials/entities/zyb_water.png")
	resource.AddSingleFile("materials/entities/zyb_yeast.png")
	resource.AddSingleFile("materials/entities/zyb_yeastgrinder.png")
else
	resource.AddWorkshop("1626509911") -- Zeros Yeastbeast Contentpack
end
-- leak by lordee