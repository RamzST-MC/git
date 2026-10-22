-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

if SERVER then
	//Screeneffects
	util.AddNetworkString("zyb_start_screeneffect")
	function zyb.f.CreateDrunkEffect(duration,ply)
		net.Start("zyb_start_screeneffect")
		net.WriteFloat(duration)
		net.Send(ply)
	end

	util.AddNetworkString("zyb_stop_screeneffect")
	function zyb.f.RemoveDrunkEffect(duration,ply)
		net.Start("zyb_stop_screeneffect")
		net.Send(ply)
	end
end

if CLIENT then

	// Screeneffects
	local screeneffect_duration = 0
	local ScreenEffectAmount = 0
	local PlayerIsDrunk = false

	//Starts our screeneffect
	net.Receive("zyb_start_screeneffect", function(len)
		local duration = net.ReadFloat()
		screeneffect_duration = duration
		ScreenEffectAmount = ScreenEffectAmount + ( 100 * screeneffect_duration)
		PlayerIsDrunk = true
	end)

	//Stops our screeneffect
	net.Receive("zyb_stop_screeneffect", function(len)
		screeneffect_duration = 0
		ScreenEffectAmount = 0
	end)


	zyb.f.Timer_Create("zyb_screeneffect_timer", 0.1, 0, function()
		if (ScreenEffectAmount or 0) > 0 then
			ScreenEffectAmount = ScreenEffectAmount - 10
		else
			if PlayerIsDrunk then
				if (screeneffect_duration > 0) then
					screeneffect_duration = 0
				end

				if (ScreenEffectAmount > 0) then
					ScreenEffectAmount = 0
				end

				if IsValid(LocalPlayer()) then
					LocalPlayer():SetDSP(0)
				end
				PlayerIsDrunk = false
			end
		end
	end)

	hook.Add("RenderScreenspaceEffects", "zyb_RenderScreenspaceEffects", function()
		if (ScreenEffectAmount or 0) > 0 then
			local alpha = 1 / 500 * ScreenEffectAmount
			LocalPlayer():SetDSP(3)

			DrawBloom( 0.1, 0.1 * alpha, 0.2,0.2, 15, 0.1, 1, 0.3, 0)

			DrawMotionBlur(math.Clamp(0.3 / alpha,0,0.1), math.Clamp(0.2 * alpha,0,0.8),0.01)

			DrawSharpen(math.Clamp(0.1 * alpha,0,1.9),math.Clamp(0.1 * alpha,0,1.9))

			DrawMaterialOverlay("effects/water_warp01", math.Clamp(0.01 * alpha,0,0.1))


			local tab = {
				[ "$pp_colour_addr" ] = math.Clamp(0.1 * alpha,0,0.3),
				[ "$pp_colour_addg" ] = math.Clamp(0.05 * alpha,0,0.1),
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = 0,
				[ "$pp_colour_contrast" ] = 1,
				[ "$pp_colour_colour" ] = 1,
				[ "$pp_colour_mulr" ] = math.Clamp(0.1 * alpha,0,0.3),
				[ "$pp_colour_mulg" ] =  math.Clamp(0.05 * alpha,0,0.1),
				[ "$pp_colour_mulb" ] = 0
			}
			DrawColorModify(tab)
		end
	end)
end

// Here we define diffrent effect groups which later make it pretty optimized to create Sound/Particle effects over the network
// The key will be used as the NetworkString
zyb.NetEffectGroups = {

	["sfx_condensing"] = {
		_type = "entity",
		action = function(ent)
			ent:EmitSound("zyb_condensing")
		end,
	},
	["sfx_cooling"] = {
		_type = "entity",
		action = function(ent)
			ent:EmitSound("zyb_cooling")
		end,
	},
	["sfx_jar"] = {
		_type = "entity",
		action = function(ent)
			ent:EmitSound("zyb_jar")
		end,
	},
	["add_mash"] = {
		_type = "entity",
		action = function(ent)

			zyb.f.PlayAnimation(ent, "cap_open", 2)
			timer.Simple(3, function()
				if IsValid(ent) then
					zyb.f.PlayAnimation(ent, "cap_close", 2)
				end
			end)
			zyb.f.ParticleEffect("yb_mash", ent:LocalToWorld(Vector(30,0,75)), Angle(0,0,0), ent)
		end,
	},
	["boiler_explo"] = {
		_type = "entity",
		action = function(ent)

			ent:EmitSound("zyb_explosion")

			zyb.f.ParticleEffect("yb_explosion",  ent:GetPos() + ent:GetUp() * 50, Angle(0,0,0), ent)
			zyb.f.ParticleEffectAttach("yb_explosion_spill", ent, 2)

			zyb.f.PlayAnimation(ent, "cap_open", 8)

			timer.Simple(2, function()
				if IsValid(ent) then
					zyb.f.PlayAnimation(ent, "cap_close", 2)
				end
			end)
		end,
	},
	["fx_clean"] = {
		action = function(pos)

			sound.Play(zyb.Sounds["clean"][math.random(#zyb.Sounds["clean"])], pos, 55, 100, 0.85)
			zyb.f.ParticleEffect("zyb_cleaning",  pos, Angle(0,0,0), Entity(1))
		end,
	},
	["fx_yeast_fill"] = {
		_type = "entity",
		action = function(ent)
			zyb.f.ParticleEffectAttach("yb_yeast_fill", ent, 1)
		end,
	},
	["fx_water_fill"] = {
		_type = "entity",
		action = function(ent)
			zyb.f.ParticleEffectAttach("yb_water", ent, 1)

			ent:SetBodygroup(1,1)

			timer.Simple(0.40, function()
				if IsValid(ent) then
					ent:SetBodygroup(2,1)
				end
			end)

			timer.Simple(0.80, function()
				if IsValid(ent) then
					ent:SetBodygroup(2,2)
				end
			end)

			timer.Simple(1.20, function()
				if IsValid(ent) then
					ent:SetBodygroup(2,3)
				end
			end)

			timer.Simple(1.60, function()
				if IsValid(ent) then
					ent:SetBodygroup(2,4)
				end
			end)

			timer.Simple(1.80, function()
				if IsValid(ent) then
					ent:SetBodygroup(2,5)
				end
			end)

		end,
	},
	["fx_sugar_fill"] = {
		_type = "entity",
		action = function(ent)
			zyb.f.ParticleEffectAttach("yb_sugar", ent, 1)
		end,
	},
	["jar_explode"] = {
		action = function(pos)

			sound.Play(zyb.Sounds["jar_broke"][math.random(#zyb.Sounds["jar_broke"])], pos, 55, 100, 0.85)
			zyb.f.ParticleEffect("yb_jar_explode",  pos, Angle(0,0,0), Entity(1))
		end,
	},
	["crate_explode"] = {
		action = function(pos)

			sound.Play(zyb.Sounds["crate_broke"][math.random(#zyb.Sounds["crate_broke"])], pos, 55, 100, 0.85)
			zyb.f.ParticleEffect("yb_jar_explode",  pos, Angle(0,0,0), Entity(1))
		end,
	},
	["sfx_building"] = {
		_type = "entity",
		action = function(ent)

			ent:EmitSound("zyb_building")
		end,
	},
	["boiler_destroyed"] = {
		_type = "entity",
		action = function(ent)

			ent:EmitSound("zyb_explosion")
			zyb.f.ParticleEffect("yb_explosion",  ent:GetPos() + ent:GetUp() * 50, Angle(0,0,0), ent)
		end,
	},
	["vfx_sell"] = {
		action = function(pos)

			sound.Play(zyb.Sounds["zyb_cash"], pos, 55, 100, 0.85)
			zyb.f.ParticleEffect("zyb_sell",  pos, Angle(0,0,0), Entity(1))
		end,
	},
}

function zyb.f.PlayAnimation(ent,anim, speed)
	local sequence = ent:LookupSequence(anim)
	ent:SetCycle(0)
	ent:ResetSequence(sequence)
	ent:SetPlaybackRate(speed)
	ent:SetCycle(0)
end

if SERVER then

	// Creates a network string for all the effect groups
	for k, v in pairs(zyb.NetEffectGroups) do
		util.AddNetworkString("zyb_fx_" .. k)
	end

	// Sends a Net Effect Msg to all clients
	function zyb.f.CreateNetEffect(id,data)

		// Data can be a entity or position

		local EffectGroup = zyb.NetEffectGroups[id]

		// Some events should be called on server to
		if EffectGroup._server then
			EffectGroup.action(data)
		end

		net.Start("zyb_fx_" .. id)
		if EffectGroup._type == "entity" then
			net.WriteEntity(data)
		else
			net.WriteVector(data)
		end
		net.Broadcast()
	end
end

if CLIENT then

	for k, v in pairs(zyb.NetEffectGroups) do
		net.Receive("zyb_fx_" .. k, function(len)
			//zyb.f.Debug("zyb_fx_" .. k .. " Len: " .. len)

			if v._type == "entity" then
				local ent = net.ReadEntity()

				if IsValid(ent) then

					zyb.NetEffectGroups[k].action(ent)
				end
			else
				local pos = net.ReadVector()
				if pos then
					zyb.NetEffectGroups[k].action(pos)
				end
			end
		end)
	end

	function zyb.f.ParticleEffect(effect, pos, ang, ent)
		if GetConVar("zyb_cl_particleeffects"):GetInt() == 1 then
			ParticleEffect(effect, pos, ang, ent)
		end
	end

	function zyb.f.ParticleEffectAttach(effect, ent, attachid)
		if GetConVar("zyb_cl_particleeffects"):GetInt() == 1 then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, attachid)
		end
	end
end
-- leak by lordee