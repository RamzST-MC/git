nw.Register 'eventInfo'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()
local tb = {'root', 'helper', 'naboradmin', 'downer'}
ba.cmd.Create('event', function(pl, args)
	if table.HasValue(tb, pl:GetRank()) then
		net.Start("eventMenu")
		net.Send(pl)
	else
		rp.Notify(pl, NOTIFY_ERROR, 'Вы не можете создавать ивенты ;(')
	end
end)
:SetFlag('h')
:SetHelp('Открыть ивент меню')

if SERVER then
	util.AddNetworkString( "PlayerDisplayChat" )
	local PLAYER = FindMetaTable( "Player" )
	if PLAYER then
	    function PLAYER:SendMessageFD( ... )
	         local args = { ... }
	         net.Start( "PlayerDisplayChat" )
	             net.WriteTable( args )
	         net.Send( self )
	    end
	end
end

if CLIENT then
	net.Receive( "PlayerDisplayChat", function()
	    local args = net.ReadTable()
	    chat.AddText( unpack( args ) )
	end )
end