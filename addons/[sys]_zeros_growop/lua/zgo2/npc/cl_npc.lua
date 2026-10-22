surface.CreateFont('fon',{font = 'Golos Text',size = 130,weight = 1700,shadow = true, antialias = true})

zgo2 = zgo2 or {}
zgo2.NPC = zgo2.NPC or {}
zgo2.NPC.List = zgo2.NPC.List or {}

/*

	Players can buy bongs and sell weed at the npc

*/

function zgo2.NPC.Initialize(NPC)

end

function zgo2.NPC.Draw(NPC)

	local name = NPC:GetClass() == "zgo2_npc" and zgo2.language[ "Weed Dealer" ] or zgo2.language[ "Export Manager" ]
	local material = NPC:GetClass() == "zgo2_npc" and Material("divergent/entities/drug.png") or Material("divergent/ui/npc/delivery_person.png")

	zgo2.HUD.Draw(NPC,function()
		draw.SimpleTextOutlined(name, 'fon', 0, 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(material)
		surface.DrawTexturedRect(-64, -80, 128, 128)
	end, 0.03)
end