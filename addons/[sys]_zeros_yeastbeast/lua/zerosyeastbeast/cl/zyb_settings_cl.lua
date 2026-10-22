-- leak by lordee
if not CLIENT then return end
local Created = false


zyb = zyb or {}
zyb.f = zyb.f or {}

CreateConVar("zyb_cl_particleeffects", "1", {FCVAR_ARCHIVE})


local function zyb_OptionPanel(name, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:SetSize(250 , 40 + (35 * table.Count(cmds)))
	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zyb.default_colors["grey_light"])
	end

	local title = vgui.Create("DLabel", panel)
	title:SetPos(10, 2.5)
	title:SetText(name)
	title:SetFont("zyb_settings_font01")
	title:SetSize(panel:GetWide(), 30)
	title:SetTextColor(zyb.default_colors["brown08"])

	for k, v in pairs(cmds) do
		if v.class == "DNumSlider" then

			local item = vgui.Create("DNumSlider", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)
			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
			item:ResetToDefaultValue()

			item.OnValueChanged = function(self, val)

				if (not Created) then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
				end
			end)
		elseif v.class == "DCheckBoxLabel" then

			local item = vgui.Create("DCheckBoxLabel", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( v.name )
			item:SetConVar( v.cmd )
			item:SetValue(0)
			item.OnChange = function(self, val)

				if (not Created) then
					if ((bVal and 1 or 0) == cvars.Number(v.cmd)) then return end
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(GetConVar(v.cmd):GetInt())
				end
			end)
		elseif v.class == "DButton" then
			local item = vgui.Create("DButton", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( "" )
			//item:SetConsoleCommand( v.cmd )
			item.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["grey_lighter"])
				draw.SimpleText(v.name, "zyb_settings_font02", w / 2, h / 2, zyb.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if s.Hovered then
					draw.RoundedBox(5, 0, 0, w, h, zyb.default_colors["white02"])
				end
			end
			item.DoClick = function()

				if zyb.f.IsAdmin(LocalPlayer()) == false then return end

				LocalPlayer():EmitSound("zyb_ui_click")

				if v.notify then

					notification.AddLegacy(  v.notify, NOTIFY_GENERIC, 2 )
				end
				LocalPlayer():ConCommand( v.cmd )

			end
		end
	end

	CPanel:AddPanel(panel)
end


local function YeastBeast_settings(CPanel)
	Created = true
	CPanel:AddControl("Header", {
		Text = "Client Settings",
		Description = ""
	})

	zyb_OptionPanel("VFX",CPanel,{
		[1] = {name = "ParticleEffects",class = "DCheckBoxLabel", cmd = "zyb_cl_particleeffects"},
	})

	timer.Simple(0.2, function()
		Created = false
	end)
end

local function YeastBeast_admin_settings(CPanel)

	CPanel:AddControl("Header", {
		Text = "Admin Commands",
		Description = ""
	})

	zyb_OptionPanel("NPC",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zyb_npc_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zyb_npc_remove"},
	})

	zyb_OptionPanel("Public Setup",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zyb_public_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zyb_public_remove"},
	})


	zyb_OptionPanel("Usefull Commands",CPanel,{
		[1] = {name = "Moonshine Crate",class = "DButton", cmd = "zyb_debug_spawn_jarcrate"},
		[2] = {name = "Moonshine Jar",class = "DButton", cmd = "zyb_debug_spawn_jar"},
	})
end

hook.Add("AddToolMenuCategories", "zyb_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "YeastBeast", "YeastBeast")
end)

hook.Add("PopulateToolMenu", "zyb_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "YeastBeast", "zyb_Settings", "Client Settings", "", "", YeastBeast_settings)
	spawnmenu.AddToolMenuOption("Options", "YeastBeast", "zyb_Admin_Settings", "Admin Settings", "", "", YeastBeast_admin_settings)
end)
-- leak by lordee