--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.SeedLibary = zgo2.SeedLibary or {}

/*

	The seedlibary stores the players seeds

*/

local SeedList = {}
local SeedLibary
net.Receive("zgo2.SeedLibary.Open", function(len, ply)
	zclib.Debug_Net("zgo2.SeedLibary.Open", len)

	SeedLibary = net.ReadEntity()

	SeedList = {}
	local count = net.ReadUInt(32)
	for i = 1, count do
		SeedList[ net.ReadUInt(32) ] = {
			id = net.ReadString(),
			count = net.ReadUInt(32),
		}
	end

	zgo2.SeedLibary.Open()
end)

net.Receive("zgo2.SeedLibary.ResetInactivity", function(len)
	zclib.Debug_Net("zgo2.SeedLibary.ResetInactivity", len)
	zgo2.SeedLibary.Open()
end)

function zgo2.SeedLibary.Open()
	zclib.vgui.Page(zgo2.language[ "SeedLibary" ], function(main, top)
		main:SetSize(1000 * zclib.wM, 700 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		if zgo2.config.SeedLibary.InactivityReset then
			zgo2.vgui.ImageButton(top, zclib.Materials.Get("refresh"), zclib.colors[ "blue02" ], function()
				// Send net message to reset any spliced weed seed in the players libary
				net.Start("zgo2.SeedLibary.ResetInactivity")
				net.SendToServer()
			end, function() return false end, zgo2.language["seedlibary_reset_tooltip"])
		end

		local content = vgui.Create("DPanel", main)
		content:Dock(FILL)
		content:DockMargin(50 * zclib.wM, 0 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		content.Paint = function(s, w, h) end
		content:InvalidateLayout(true)
		content:InvalidateParent(true)


		local list, scroll = zclib.vgui.List(content)
		list:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll:DockMargin(0 * zclib.wM, 5 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h) end
		list.Paint = function(s, w, h) end

		for i = 1, 10 do
			local itm = list:Add("DPanel")
			itm:SetSize(171 * zclib.wM, 265 * zclib.hM)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])
			end

			local SlotData = SeedList[i]
			if not SlotData then continue end

			local PlantData = zgo2.Plant.GetData(SlotData.id)
			if not PlantData then
				continue
			end

			local imgpnl = vgui.Create("DImageButton", itm)
			imgpnl:SetTall(166 * zclib.wM)
			imgpnl:Dock(TOP)
			local img = zclib.Snapshoter.Get({
				class = "zgo2_seed",
				model = "models/zerochain/props_growop2/zgo2_weedseeds.mdl",
				PlantID = SlotData.id,
			}, imgpnl)
			imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")

			imgpnl.PaintOver = function(s, w, h)
				surface.SetDrawColor(zclib.colors[ "black_a200" ])
				surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
				surface.DrawTexturedRectRotated(w / 2, h / 2, h, w, -90)

				draw.SimpleText("x"..SlotData.count, zclib.GetFont("zclib_font_mediumsmall"), w - (10 * zclib.wM), 0 * zclib.hM, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

				if s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a15" ]) end
			end
			imgpnl.DoClick = function()
				zclib.vgui.PlaySound("UI/buttonclick.wav")

				// Call net message to drop this seed entity from the libary
				net.Start("zgo2.SeedLibary.Drop")
				net.WriteEntity(SeedLibary)
				net.WriteUInt(i,32)
				net.SendToServer()

				imgpnl:SetDisabled(true)

				timer.Simple(1.5,function()
					if IsValid(imgpnl) then
						imgpnl:SetDisabled(false)
					end
				end)
			end

			if PlantData.SplicedConfig then

				local function AddLabel(txt,font,color)
					local lbl = vgui.Create("DLabel", itm)
					lbl:SetSize(500, 30 * zclib.hM)
					lbl:Dock(TOP)
					//lbl:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM,5 * zclib.hM)
					lbl:SetFont(font)
					lbl:SetTextColor(color)
					lbl:SetText(txt)
					lbl:SetContentAlignment(5)
					lbl.Paint = function(s, w, h)
						draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "black_a100" ])
					end
				end

				AddLabel(tostring(PlantData.name),zclib.GetFont("zclib_font_small"),color_white)

				AddLabel(tostring(PlantData.creator_name),zclib.GetFont("zclib_font_small"),zclib.colors[ "text01" ])

				local Activity = PlantData.Activity

				local lbl = vgui.Create("DLabel", itm)
				lbl:SetSize(500, 30 * zclib.hM)
				lbl:Dock(FILL)
				lbl:SetFont(zclib.GetFont("zclib_font_small"))
				lbl:SetTextColor(zclib.colors[ "text01" ])
				lbl:SetText("")
				lbl:SetContentAlignment(5)
				lbl.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "black_a100" ]) end
				lbl.PaintOver = function(s, w, h)

					local SecondsLeft = (Activity + zgo2.Plant.GetLifeTime(SlotData.id)) - os.time()
					SecondsLeft = string.FormattedTime( SecondsLeft )

					local hours,minutes,seconds = SecondsLeft.h,SecondsLeft.m,SecondsLeft.s
					if hours < 10 then hours = "0"..hours end
					if minutes < 10 then minutes = "0"..minutes end
					if seconds < 10 then seconds = "0"..seconds end

					lbl:SetText(hours .. ":" .. minutes .. ":" .. seconds)
				end
			else
				local lbl = vgui.Create("DLabel", itm)
				lbl:Dock(FILL)
				lbl:SetFont(zclib.GetFont("zclib_font_small"))
				lbl:SetTextColor(color_white)
				lbl:SetText("-")
				lbl:SetContentAlignment(5)
				lbl.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "black_a100" ]) end
			end
		end
	end)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher