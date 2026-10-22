local _b = ScrW()
local function ss(a)
	return a / 1920 * _b
end

local f4_crosshairs = {
	{
		name = "Круглый",
		id = "circle"
	},
	{
		name = "Круглый пустой",
		id = "circle_empty"
	},
	{
		name = "Круглый с перекрестием",
		id = "circle_empty_cross"
	},
	{
		name = "Квадратный",
		id = "rect"
	},
	{
		name = "Квадратный пустой",
		id = "rect_empty"
	},
	{
		name = "Перекрёстный",
		id = "cross"
	}
}

CreateClientConVar("eclipsecross", "circle", true)
CreateClientConVar("eclipsecross_size", "6", true, false, "", 5, 100)

CreateClientConVar("eclipsecross_r", "255", true, false, "", 0, 255)
CreateClientConVar("eclipsecross_g", "255", true, false, "", 0, 255)
CreateClientConVar("eclipsecross_b", "255", true, false, "", 0, 255)

function rp.CrosshairMenu()
	local fr = vgui.Create("ui_frame")
	fr:SetTitle("Настройка прицела")
	fr:SetSize(ss(300), ss(28))
	fr:Center()
	fr:MakePopup()
	do
		local tall, dock = ss(200), ss(2)
		local section_color = vgui.Create("ui_collapsible_section", fr)
		section_color:SetText("Цвет")
		section_color:Dock(TOP)
		section_color:DockMargin(dock, dock, dock, dock)
		section_color:Collapse(true)
		local colopts = vgui.Create("EditablePanel", section_color)
		colopts:Dock(FILL)
		colopts:DockMargin(dock, dock, dock, dock)
		local color_picker = vgui.Create("DRGBPicker", colopts)
		color_picker:Dock(RIGHT)
		color_picker:DockMargin(0, 0, ss(3), 0)
		color_picker:SetWide(ss(30))
		local color_cube = vgui.Create("DColorCube", colopts)
		color_cube:Dock(FILL)
		color_cube:SetColor(Color(GetConVar("eclipsecross_r"):GetInt(), GetConVar("eclipsecross_g"):GetInt(), GetConVar("eclipsecross_b"):GetInt()))
		color_picker.OnChange = function(s, col)
			local _h = ColorToHSV(col)
			local _, _s, _v = ColorToHSV(color_cube:GetRGB())
			col = HSVToColor(_h, _s, _v)
			color_cube:SetColor(col)
			RunConsoleCommand("eclipsecross_r", col.r)
			RunConsoleCommand("eclipsecross_g", col.g)
			RunConsoleCommand("eclipsecross_b", col.b)
		end

		color_cube.OnUserChanged = function(s, col)
			RunConsoleCommand("eclipsecross_r", col.r)
			RunConsoleCommand("eclipsecross_g", col.g)
			RunConsoleCommand("eclipsecross_b", col.b)
		end

		section_color:AddItem(colopts)
		section_color:SetTall(tall)
		fr:SetTall(fr:GetTall() + section_color:GetTall())
	end

	do
		local tall, dock = ss(24), ss(2)
		local section_size = vgui.Create("ui_collapsible_section", fr)
		section_size:SetText("Размер")
		section_size:Dock(TOP)
		section_size:DockMargin(dock, dock, dock, dock)
		section_size:Collapse(true)
		local slider = vgui.Create("ui_slider", section_size)
		slider:Dock(TOP)
		slider:DockMargin(dock, dock, dock, dock)
		slider:SetTall(tall)
		slider:SetValue(GetConVar("eclipsecross_size"):GetInt() / 100)
		slider.OnChange = function(s, val)
			local size = math.Round(val * 100)
			if size < 5 then
				size = 5
				s:SetValue(0.05)
			end

			RunConsoleCommand("eclipsecross_size", size)
		end

		section_size:AddItem(slider)
		section_size:SetTall(tall)
		fr:SetTall(fr:GetTall() + section_size:GetTall())
	end

	do
		local tall, dock = ss(40), ss(2)
		local section_types = vgui.Create("ui_collapsible_section", fr)
		section_types:SetText("Тип")
		section_types:Dock(TOP)
		section_types:DockMargin(dock, dock, dock, dock)
		section_types:Collapse(true)
		for _, data in ipairs(f4_crosshairs) do
			local btn = vgui.Create("ui_button", section_types)
			btn:SetText(data.name)
			btn:SetTall(tall)
			btn:Dock(TOP)
			btn:DockMargin(dock, dock, dock, dock)
			btn.DoClick = function() RunConsoleCommand("eclipsecross", data.id) end
			btn.Think = function() btn:SetEnabled(GetConVar("eclipsecross"):GetString() ~= data.id) end
			section_types:AddItem(btn)
		end

		section_types:SetTall(section_types:GetTall() + ((tall + dock) * #f4_crosshairs))
		fr:SetTall(fr:GetTall() + section_types:GetTall())
	end

	fr:Center()
	fr:SetX(fr:GetX() + ss(256))
end

concommand.Add('rpCrosshairMenu', rp.CrosshairMenu)