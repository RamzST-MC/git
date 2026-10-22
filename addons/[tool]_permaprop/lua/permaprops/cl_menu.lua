surface.CreateFont( "pp_font", {
	font = "Arial",
	size = 20,
	weight = 700,
	shadow = false
} )

local Main
local function pp_open_menu()

	local Len = net.ReadFloat()
	local Data = net.ReadData( Len )
	local UnCompress = util.Decompress( Data )
	local Content = util.JSONToTable( UnCompress )
	local permaversion = '0.1'

	if IsValid(Main) then Main:Remove() end
 	Main = vgui.Create( "ui_frame" )
	Main:SetSize( 600, 355 )
	Main:Center()
	Main:SetTitle("ПермаПропы")
	Main:SetVisible( true )
	Main:SetDraggable( true )
	Main:ShowCloseButton( true )
	Main:MakePopup()

	local BSelect
	local PSelect
	
	local MainPanel = vgui.Create( "ui_panel", Main )
	MainPanel:SetPos( 190, 51 )
	MainPanel:SetSize( 390, 275 )
	PSelect = MainPanel

	local MainLabel = vgui.Create("DLabel", MainPanel)
	MainLabel:SetFont("pp_font")
	MainLabel:SetPos(140, 25) 
	MainLabel:SetColor(Color(255, 255, 255)) 
	MainLabel:SetText("") 
	MainLabel:SizeToContents()

	local MainLabel2 = vgui.Create("DLabel", MainPanel)
	MainLabel2:SetFont("pp_font")
	MainLabel2:SetPos(80, 80) 
	MainLabel2:SetColor(Color(255, 255, 255)) 
	MainLabel2:SetText("Находится ".. ( Content.MProps or 0 ) .." пропов на карте.\n\nНаходится ".. ( Content.TProps or 0 ) .." пропов в БД.") 
	MainLabel2:SizeToContents()

	local RemoveMapProps = vgui.Create( "ui_button", MainPanel )
	RemoveMapProps:SetText( " Очистить пропы карты " )
	RemoveMapProps:SetFont("pp_font")
	RemoveMapProps:SetSize( 370, 30)
	RemoveMapProps:SetPos( 10, 160 )
	RemoveMapProps:SetTextColor(Color(255, 255, 255)) 
	RemoveMapProps.DoClick = function()
		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "CLR_MAP"})
		net.SendToServer()
	end

	local ClearMapProps = vgui.Create( "ui_button", MainPanel )
	ClearMapProps:SetText( " Очистить пропы карты в БД " )
	ClearMapProps:SetFont("pp_font")
	ClearMapProps:SetSize( 370, 30)
	ClearMapProps:SetPos( 10, 200 )
	ClearMapProps:SetTextColor(Color(255, 255, 255)) 
	ClearMapProps.DoClick = function()
		net.Start("rp::permaprop_sendinfo") 
			net.WriteTable({CMD = "DEL_MAP"}) 
		net.SendToServer()
	end

	local ClearAllProps = vgui.Create( "ui_button", MainPanel )
	ClearAllProps:SetText( " Очистить все пропы в БД " )
	ClearAllProps:SetFont("pp_font")
	ClearAllProps:SetSize( 370, 30)
	ClearAllProps:SetPos( 10, 240 )
	ClearAllProps:SetTextColor(Color(255, 255, 255)) 
	ClearAllProps.DoClick = function()
		net.Start("rp::permaprop_sendinfo") 
			net.WriteTable({CMD = "DEL_ALL"}) 
		net.SendToServer()
	end

	local BMain = vgui.Create("ui_button", Main)
	BSelect = BMain
	BMain:SetText("Главное")
	BMain:SetFont("pp_font")
	BMain:SetSize(160, 50)
	BMain:SetPos(15, 27 + 25)
	BMain:SetTextColor(Color(255, 255, 255)) 
	BMain.PaintColor = Color(17, 148, 240, 100)
	BMain.DoClick = function( self )
		if BSelect then BSelect.PaintColor = Color(0, 0, 0, 0) end
		BSelect = self
		self.PaintColor = Color(17, 148, 240, 100)

		if PSelect then PSelect:Hide() end
		MainPanel:Show()
		PSelect = MainPanel
	end

	local ConfigPanel = vgui.Create( "DPanel", Main )
	ConfigPanel:SetPos( 190, 51 )
	ConfigPanel:SetSize( 390, 275 )
	ConfigPanel:Hide()

	local GroupsList = vgui.Create( "DComboBox", ConfigPanel )
	GroupsList:SetPos( 5, 5 )
	GroupsList:SetSize( 125, 20 )
	GroupsList:SetValue( "Выберите ранг..." )

	local CheckCustom = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckCustom:SetPos( 5, 30 )
	CheckCustom:SetText( "Кастом Разрешения" )
	CheckCustom:SetValue( 0 )
	CheckCustom:SizeToContents()
	CheckCustom:SetTextColor(Color(255, 255, 255)) 
	CheckCustom:SetDisabled( true )

	local CheckBox1 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox1:SetPos( 150, 10 )
	CheckBox1:SetText( "Меню" )
	CheckBox1:SizeToContents()
	CheckBox1:SetTextColor(Color(255, 255, 255)) 
	CheckBox1:SetDisabled( true )
	CheckBox1.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Menu", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox2 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox2:SetPos( 150, 30 )
	CheckBox2:SetText( "Редактировать разрешения" )
	CheckBox2:SizeToContents()
	CheckBox2:SetTextColor(Color(255, 255, 255)) 
	CheckBox2:SetDisabled( true )
	CheckBox2.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Permissions", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox3 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox3:SetPos( 150, 50 )
	CheckBox3:SetText( "Доступ PermaProps к Физгану" )
	CheckBox3:SizeToContents()
	CheckBox3:SetTextColor(Color(255, 255, 255)) 
	CheckBox3:SetDisabled( true )
	CheckBox3.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Physgun", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox4 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox4:SetPos( 150, 70 )
	CheckBox4:SetText( "Инструмент PermaProps" )
	CheckBox4:SizeToContents()
	CheckBox4:SetTextColor( Color( 0, 0, 0, 255) )
	CheckBox4:SetDisabled( true )
	CheckBox4.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Tool", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox5 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox5:SetPos( 150, 90 )
	CheckBox5:SetText( "Property permaprops" )
	CheckBox5:SizeToContents()
	CheckBox5:SetTextColor( Color( 0, 0, 0, 255) )
	CheckBox5:SetDisabled( true )
	CheckBox5.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Property", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox6 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox6:SetPos( 150, 110 )
	CheckBox6:SetText( "Сохранить Пропы" )
	CheckBox6:SizeToContents()
	CheckBox6:SetTextColor( Color( 0, 0, 0, 255) )
	CheckBox6:SetDisabled( true )
	CheckBox6.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Save", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox7 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox7:SetPos( 150, 130 )
	CheckBox7:SetText( "Удалить ПермаПропы" )
	CheckBox7:SizeToContents()
	CheckBox7:SetTextColor( Color( 0, 0, 0, 255) )
	CheckBox7:SetDisabled( true )
	CheckBox7.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Delete", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local CheckBox8 = vgui.Create( "DCheckBoxLabel", ConfigPanel )
	CheckBox8:SetPos( 150, 150 )
	CheckBox8:SetText( "Обновить ПермаПропы" )
	CheckBox8:SizeToContents()
	CheckBox8:SetTextColor( Color( 0, 0, 0, 255) )
	CheckBox8:SetDisabled( true )
	CheckBox8.OnChange = function(Self, Value)

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Update", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	GroupsList.OnSelect = function( panel, index, value )
		
		CheckCustom:SetDisabled( false )
		CheckCustom:SetChecked( Content.Permissions[value].Custom )

		CheckBox1:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox1:SetChecked( Content.Permissions[value].Menu )
		CheckBox2:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox2:SetChecked( Content.Permissions[value].Permissions )
		CheckBox3:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox3:SetChecked( Content.Permissions[value].Physgun )
		CheckBox4:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox4:SetChecked( Content.Permissions[value].Tool )
		CheckBox5:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox5:SetChecked( Content.Permissions[value].Property )
		CheckBox6:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox6:SetChecked( Content.Permissions[value].Save )
		CheckBox7:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox7:SetChecked( Content.Permissions[value].Delete )
		CheckBox8:SetDisabled( !Content.Permissions[value].Custom )
		CheckBox8:SetChecked( Content.Permissions[value].Update )

	end

	for k, v in pairs(Content.Permissions) do
		
		GroupsList:AddChoice(k)

	end

	CheckCustom.OnChange = function(Self, Value)

		CheckBox1:SetDisabled( !Value )
		CheckBox2:SetDisabled( !Value )
		CheckBox3:SetDisabled( !Value )
		CheckBox4:SetDisabled( !Value )
		CheckBox5:SetDisabled( !Value )
		CheckBox6:SetDisabled( !Value )
		CheckBox7:SetDisabled( !Value )
		CheckBox8:SetDisabled( !Value )

		net.Start("rp::permaprop_sendinfo")
			net.WriteTable({CMD = "VAR", Val = Value, Data = "Custom", Name = GroupsList:GetValue()})
		net.SendToServer()

	end

	local BConfig = vgui.Create("ui_button", Main)
	BConfig:SetText("Конфиг")
	BConfig:SetFont("pp_font")
	BConfig:SetSize(160, 50)
	BConfig:SetPos(15, 71 + 55)
	BConfig:SetTextColor( Color( 255, 255, 255, 255 ) )
	BConfig.PaintColor = Color(0, 0, 0, 0)
	BConfig.DoClick = function( self )
		if BSelect then BSelect.PaintColor = Color(0, 0, 0, 0) end
		BSelect = self
		self.PaintColor = Color(17, 148, 240, 100)

		if PSelect then PSelect:Hide() end
		ConfigPanel:Show()
		PSelect = ConfigPanel
	end

	local PropsPanel = vgui.Create( "ui_panel", Main )
	PropsPanel:SetPos( 190, 51 )
	PropsPanel:SetSize( 390, 275 )
	PropsPanel.Paint = function( self )
		surface.SetDrawColor( 50, 50, 50, 200 ) 
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	PropsPanel:Hide()

	local PropsList = vgui.Create( "DListView", PropsPanel )
	PropsList:SetMultiSelect( false )
	PropsList:SetSize( 390, 275 )
	local ColID = PropsList:AddColumn( "ID" )
	local ColEnt = PropsList:AddColumn( "Entity" )
	local ColMdl = PropsList:AddColumn( "Model" )
	ColID:SetMinWidth(50)
	ColID:SetMaxWidth(50)
	PropsList.Paint = function( self )
		surface.SetDrawColor(17, 148, 240, 255)
	end

	PropsList.OnRowRightClick = function(panel, line)

		local MenuButtonOptions = DermaMenu()
	    MenuButtonOptions:AddOption("Draw entity", function() 

	    	if not LocalPlayer().DrawPPEnt or not istable(LocalPlayer().DrawPPEnt) then LocalPlayer().DrawPPEnt = {} end

	    	if LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] and LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)]:IsValid() then return end

		    local ent = ents.CreateClientProp( Content.PropsList[PropsList:GetLine(line):GetValue(1)].Model ) 
			ent:SetPos( Content.PropsList[PropsList:GetLine(line):GetValue(1)].Pos )
			ent:SetAngles( Content.PropsList[PropsList:GetLine(line):GetValue(1)].Angle )

			LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] = ent

		end )

		if LocalPlayer().DrawPPEnt and LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] then
			
			MenuButtonOptions:AddOption("Stop Drawing", function() 

				LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)]:Remove()
				LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] = nil

			end )

		end

		if LocalPlayer().DrawPPEnt != nil and istable(LocalPlayer().DrawPPEnt) and table.Count(LocalPlayer().DrawPPEnt) > 0 then

			MenuButtonOptions:AddOption("Stop Drawing All", function() 

				for k, v in pairs(LocalPlayer().DrawPPEnt) do
					
					LocalPlayer().DrawPPEnt[k]:Remove()
					LocalPlayer().DrawPPEnt[k] = nil

				end

			end )
			
		end

	    MenuButtonOptions:AddOption("Remove", function()

	    	net.Start("rp::permaprop_sendinfo")
	    		net.WriteTable({CMD = "DEL", Val = PropsList:GetLine(line):GetValue(1)})
	    	net.SendToServer()

	    	if LocalPlayer().DrawPPEnt and LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] != nil then

	    		LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)]:Remove()
				LocalPlayer().DrawPPEnt[PropsList:GetLine(line):GetValue(1)] = nil
				
	    	end

	    	PropsList:RemoveLine(line)


		end )
	    MenuButtonOptions:Open()
		
	end

	for k, v in pairs(Content.PropsList) do
		
		PropsList:AddLine(k, v.Class, v.Model)

	end

	local BProps = vgui.Create("ui_button", Main)
	BProps:SetText("Список Пропов")
	BProps:SetFont("pp_font")
	BProps:SetSize(160, 50)
	BProps:SetPos(15, 115 + 85)
	BProps:SetTextColor( Color( 255, 255, 255, 255 ) )
	BProps.PaintColor = Color(0, 0, 0, 0)
	BProps.DoClick = function( self )
		if BSelect then BSelect.PaintColor = Color(0, 0, 0, 0) end
		BSelect = self
		self.PaintColor = Color(17, 148, 240, 100)

		if PSelect then PSelect:Hide() end
		PropsPanel:Show()
		PSelect = PropsPanel
	end

	local AboutPanel = vgui.Create( "ui_panel", Main )
	AboutPanel:SetPos( 190, 51 )
	AboutPanel:SetSize( 390, 275 )
	AboutPanel:Hide()

	local AboutLabel = vgui.Create("DLabel", AboutPanel)
	AboutLabel:SetFont("pp_font")
	AboutLabel:SetPos(140, 25) 
	AboutLabel:SetColor(Color(255, 255, 255))
	AboutLabel:SetText("PermaProps") 
	AboutLabel:SizeToContents()

	local AboutLabel2 = vgui.Create("DLabel", AboutPanel)
	AboutLabel2:SetFont("pp_font")
	AboutLabel2:SetPos(30, 80) 
	AboutLabel2:SetColor(Color(255, 255, 255)) 
	AboutLabel2:SetText("Автор: vegaban") 
	AboutLabel2:SizeToContents()

	local AboutLabel2 = vgui.Create("DLabel", AboutPanel)
	AboutLabel2:SetFont("pp_font")
	AboutLabel2:SetPos(30, 110) 
	AboutLabel2:SetColor(Color(255, 255, 255)) 
	AboutLabel2:SetText("Версия аддона: "..permaversion) 
	AboutLabel2:SizeToContents()

	local DonationsTxT = vgui.Create( "ui_button", AboutPanel )
	DonationsTxT:SetText( " Donate " )
	DonationsTxT:SetFont("pp_font")
	DonationsTxT:SetSize( 370, 30)
	DonationsTxT:SetPos( 10, 240 )
	DonationsTxT:SetTextColor( Color( 255,255,255 ) )
	DonationsTxT.DoClick = function() RunConsoleCommand('say', '/donate') end
	local BAbout = vgui.Create("ui_button", Main)
	BAbout:SetText("Об Аддоне")
	BAbout:SetFont("pp_font")
	BAbout:SetSize(160, 50)
	BAbout:SetPos(15, 159 + 115)
	BAbout:SetTextColor( Color( 255, 255, 255, 255 ) )
	BAbout.PaintColor = Color(255,255,255)
	BAbout.DoClick = function( self )
		if BSelect then BSelect.PaintColor = Color(255,255,255) end
		BSelect = self
		self.PaintColor = Color(255,255,255)

		if PSelect then PSelect:Hide() end
		AboutPanel:Show()
		PSelect = AboutPanel
	end
end
net.Receive("rp::permaprop_openmenu", pp_open_menu)