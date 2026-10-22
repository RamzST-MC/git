-- leak by lordee
if not CLIENT then return end

zyb = zyb or {}
zyb.f = zyb.f or {}

local zyb_constructionkit_model

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

-- This tells the client that we start building
net.Receive("zyb_Constructionkit_Start_net", function(len)
	local ent = net.ReadEntity()
	local id = net.ReadInt(16)
	LocalPlayer().zyb_ConstructionKit = ent
	LocalPlayer().zyb_ConstructionData = zyb.config.ConstructionKit.Data[id]
end)

-- This handels the build ui
hook.Add("PostDrawHUD", "ZYB.PostDrawHUD.CL.MachineCrateBuilder", function()
	local ent = LocalPlayer().zyb_ConstructionKit

	if (IsValid(ent)) then
		local AcceptKey = language.GetPhrase(input.GetKeyName(zyb.config.ConstructionKit.AcceptKey))
		local CancelKey = language.GetPhrase(input.GetKeyName(zyb.config.ConstructionKit.CancelKey))
		draw.WordBox(4, wMod * 800, hMod * 900, tostring(AcceptKey), "zyb_construction_vgui_font01", zyb.default_colors["grey06"], zyb.default_colors["white01"])
		draw.WordBox(4, wMod * 1100, hMod * 900, tostring(CancelKey), "zyb_construction_vgui_font01", zyb.default_colors["grey06"], zyb.default_colors["white01"])

		surface.SetDrawColor(zyb.default_colors["green03"])
		surface.SetMaterial(zyb.default_materials["build"])
		surface.DrawTexturedRect(wMod * 690, hMod * 880, wMod * 100, hMod * 100)

		surface.SetDrawColor(zyb.default_colors["red06"])
		surface.SetMaterial(zyb.default_materials["cancel"])
		surface.DrawTexturedRect(wMod * 990, hMod * 880, wMod * 100, hMod * 100)
	end
end)

function zyb.f.BuildAction_net(ent)
	net.Start("zyb_Constructionkit_BuildEntity_net")
	net.WriteEntity(ent)
	net.SendToServer()
	LocalPlayer().zyb_ConstructionKit = nil

	if IsValid(zyb_constructionkit_model) then
		zyb_constructionkit_model:Remove()
	end

	zyb.f.Debug("Building Action")
end

function zyb.f.CancelAction_net(ent)
	net.Start("zyb_Constructionkit_Cancel_net")
	net.WriteEntity(ent)
	net.SendToServer()

	if IsValid(zyb_constructionkit_model) then
		zyb_constructionkit_model:Remove()
	end

	LocalPlayer().zyb_ConstructionKit = nil
	zyb.f.Debug("Cancel Action")
end

-- Handels the model hologram logic
hook.Add("Think", "zyb.think.cl.ConstructionKit", function()
	local ent = LocalPlayer().zyb_ConstructionKit

	if (IsValid(ent)) then
		-- Do we want do abbord the action?
		if (input.IsButtonDown(zyb.config.ConstructionKit.AcceptKey)) then
			zyb.f.BuildAction_net(ent)
		end

		-- Do we want do cancel the action?
		if (input.IsButtonDown(zyb.config.ConstructionKit.CancelKey) or not LocalPlayer():Alive()) then
			zyb.f.CancelAction_net(ent)
		end

		local tr = LocalPlayer():GetEyeTrace()
		local trHit = tr.HitPos
		local validPos,validang = zyb.f.ConstructionKit_ValidPos(tr, LocalPlayer(), ent)

		if zyb.f.InDistance(trHit, LocalPlayer():GetPos(), zyb.config.ConstructionKit.BuildDistance) and zyb.f.InDistance(trHit, ent:GetPos(), zyb.config.ConstructionKit.BuildDistance) then
			if not IsValid(zyb_constructionkit_model) then
				zyb_constructionkit_model = ClientsideModel(LocalPlayer().zyb_ConstructionData.model, RENDERMODE_TRANSALPHA)
				zyb_constructionkit_model:SetPos(trHit)
				zyb_constructionkit_model:SetAngles(Angle(0, LocalPlayer():EyeAngles().y + -90, 0))
				zyb_constructionkit_model:Spawn()
				zyb_constructionkit_model:SetColor(validPos and zyb.default_colors["green04"] or zyb.default_colors["red07"])
				zyb_constructionkit_model:SetRenderMode(RENDERMODE_TRANSALPHA)
				zyb_constructionkit_model:SetNoDraw(false) -- Bypass the nodraw function when an entity is spawned

				if ent.ConstructionID == 1 then
					zyb_constructionkit_model:SetBodygroup(1,1)
				elseif ent.ConstructionID == 2 then
					zyb_constructionkit_model:SetBodygroup(2,1)
				end
			else
				zyb_constructionkit_model:SetColor(validPos and zyb.default_colors["green04"] or zyb.default_colors["red07"])

				if (validPos) then
					zyb_constructionkit_model:SetAngles(validang)
					zyb_constructionkit_model:SetPos(validPos)
				else
					if (trHit) then
						zyb_constructionkit_model:SetAngles(Angle(0, LocalPlayer():EyeAngles().y-180 , 0))
						zyb_constructionkit_model:SetPos(trHit)
					end
				end
			end
		else
			zyb.f.CancelAction_net(ent)
		end
	end
end)
-- leak by lordee