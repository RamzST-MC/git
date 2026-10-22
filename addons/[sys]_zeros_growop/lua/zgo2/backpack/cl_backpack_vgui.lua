--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.Backpack = zgo2.Backpack or {}

/*

	The backpack swep can be used to transport weed

*/

local BackpackEntity
local BackpackPanel

net.Receive("zgo2.Backpack.Open", function(len, ply)
	zclib.Debug_Net("zgo2.Backpack.Open", len)

	BackpackEntity = net.ReadEntity()

	local dataLength = net.ReadUInt(16)
	local dataDecompressed = util.Decompress(net.ReadData(dataLength))

	LocalPlayer().zgo2_backpack = util.JSONToTable(dataDecompressed) or {}

	zgo2.Backpack.Open(Backpack)
end)

net.Receive("zgo2.Backpack.Update", function(len, ply)
	zclib.Debug_Net("zgo2.Backpack.Update", len)

	BackpackEntity = net.ReadEntity()

	local dataLength = net.ReadUInt(16)
	local dataDecompressed = util.Decompress(net.ReadData(dataLength))

	LocalPlayer().zgo2_backpack = util.JSONToTable(dataDecompressed) or {}
end)

net.Receive("zgo2.Backpack.ForceClose", function(len, ply)
	zclib.Debug_Net("zgo2.Backpack.ForceClose", len)
	if IsValid(BackpackPanel) then BackpackPanel:Close() end
end)


function zgo2.Backpack.Open()
	zclib.vgui.Page(zgo2.language[ "Backpack" ], function(main, top)

		main:SetSize(800 * zclib.wM, 610 * zclib.hM)

		BackpackPanel = main

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local content = vgui.Create("DPanel", main)
		content:Dock(FILL)
		content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
		content:SetSize(700 * zclib.wM, 300 * zclib.hM)
		content.Paint = function(s, w, h)
			draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "black_a100" ])
		end

		local list, scroll = zclib.vgui.List(content)
		list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h) end
		list.Paint = function(s, w, h) end

		for i = 1, zgo2.config.Backpack.SlotCount do

			local size = 105
			if zgo2.config.Backpack.SlotCount > 24 then size = 102 end

			local itm = list:Add("DPanel")
			itm:SetSize(size * zclib.wM, size * zclib.hM)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "black_a100" ])
			end

			local SlotData = LocalPlayer().zgo2_backpack[i]
			if not SlotData then continue end

			local TargetData = zgo2.Backpack.Items[SlotData.Class]
			local DisplayPanel
			if TargetData and TargetData.DisplayOverwrite then
				DisplayPanel = TargetData.DisplayOverwrite(itm,SlotData)
			else
				DisplayPanel = zclib.vgui.ModelPanel({model = SlotData.Model,skin = SlotData.Skin})
			end
			DisplayPanel:SetParent(itm)
			DisplayPanel:Dock(FILL)

			local btnPnl = vgui.Create("DButton", DisplayPanel)
			btnPnl:Dock(FILL)
			btnPnl:SetText("")
			btnPnl.Paint = function(s,w,h)
				if s:IsHovered() then
					draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "white_a15" ])
				end
			end
			btnPnl.DoClick = function()
				zclib.vgui.PlaySound("UI/buttonclick.wav")

				net.Start("zgo2.Backpack.Drop")
				net.WriteEntity(BackpackEntity)
				net.WriteUInt(i,32)
				net.SendToServer()

				btnPnl:SetDisabled(true)
				timer.Simple(1.5,function() if IsValid(btnPnl) then btnPnl:SetDisabled(false) end end)
			end
		end
	end)
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher