-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

// Used for Debug
function zyb.f.Debug(mgs)
	if (zyb.config.Debug) then
		print("[    DEBUG    ] " .. mgs)
	end
	// 416932157
end

if SERVER then
	concommand.Add("zyb_debug_GetSoldMoonshineJars", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			PrintTable(aply:zyb_GetMetalBarsSold())
		end
	end)

	concommand.Add("zyb_debug_MashFillEffect", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr and tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zyb_distillery" then
				zyb.f.CreateNetEffect("add_mash", tr.Entity)
			end
		end
	end)

	concommand.Add("zyb_npc_save", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			zyb.f.Save_BuyerNPC(ply)
		end
	end)

	concommand.Add("zyb_npc_remove", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			zyb.f.Remove_BuyerNPC(ply)
		end
	end)


	concommand.Add("zyb_debug_spawn_jarcrate", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr and tr.Hit and tr.HitPos then
				local ent = ents.Create("zyb_jarcrate")
				ent:SetAngles(Angle(0, 0, 0))
				ent:SetPos(tr.HitPos + Vector(0, 0, 25))
				ent:Spawn()
				ent:Activate()
				ent:SetJarCount(6)
				//ent:SetJarCount(math.random(1,6))
			end
		end
	end)

	concommand.Add("zyb_debug_spawn_jar", function(ply, cmd, args)
		if zyb.f.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr and tr.Hit and tr.HitPos then
				local ent = ents.Create("zyb_jar")
				ent:SetAngles(Angle(0, 0, 0))
				ent:SetPos(tr.HitPos + Vector(0, 0, 25))
				ent:Spawn()
				ent:Activate()
				ent:SetMoonShine(zyb.config.Jar.MoonshineAmount)
				//ent:SetMoonShine(math.random(1,zyb.config.Jar.MoonshineAmount))
				ent:UpdateVisuals()
			end
		end
	end)
end
-- leak by lordee