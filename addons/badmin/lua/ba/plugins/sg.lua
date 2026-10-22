term.Add('ScreengrabStarted', 'Начался скринграб игрока #, пожалуйста подождите до 30 секунд для окончания')
term.Add('ScreengrabCooldown', '# имеет активную загрузка скринграба, пожалуйста, подождите!')

ba.cmd.Create('Screengrab', function(pl, args)
	args.target.ScreenGrabber = pl
 
	net.Start( "bScreenGrabStart" )
	net.Send( args.target )

	ba.notify(pl, term.Get('ScreengrabStarted'), args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('o')
:SetHelp('Сделать скриншот экрана')
:AddAlias('sg')

if (SERVER) then
	util.AddNetworkString( "bScreenGrabStop" )
	util.AddNetworkString( "bScreenGrabFailed" )
	util.AddNetworkString( "bScreenGrabSuccess" )
	util.AddNetworkString( "bScreenGrabStart" )
	util.AddNetworkString( "bScreenGrabWarning" )
	
	net.Receive( "bScreenGrabSuccess", function( len, ply )
		if not IsValid( ply.ScreenGrabber ) then return end
	
		local url = net.ReadString()
		if url:gsub( ".+i%.imgur%.com/%w+%.jpg", "" ) != "" then
			ba.notify( ply.ScreenGrabber, ply:Nick() .. ": Tampered with screenshot." )
			ply.ScreenGrabber:ChatPrint('Скриншот игрока ' .. ply:Nick() .. ': ' .. url)
			net.Start( "bScreenGrabSuccess" )
				net.WriteString( url )
			net.Send( ply.ScreenGrabber )
			ply.ScreenGrabber = nil
			return
		end
	
		ba.notify(ply.ScreenGrabber, "Экран игрока " .. ply:Nick() .. ": " .. url )

		if ( ply.ScreenGrabber.ScreenGrabTime or math.huge ) > CurTime() then
			net.Start( "bScreenGrabSuccess" )
				net.WriteString( url )
			net.Send( ply.ScreenGrabber )
		end
	
		ply.ScreenGrabber = nil
	end )
	
	net.Receive( "bScreenGrabFailed", function( len, ply )
		if not IsValid( ply.ScreenGrabber ) then return end
	
		ba.notify_err( ply.ScreenGrabber, "Ошибка скринграба " .. ply:Name() .. ". " .. net.ReadString() )
		ply.ScreenGrabber = nil
	end )

	net.Receive( "bScreenGrabWarning", function( len, ply )
		if not IsValid( ply.ScreenGrabber ) then return end
	
		ba.notify_err( ply.ScreenGrabber, "Будьте осторожны, возможно игрок " .. ply:Name() .. " читер!" )
	end )
else
	local capturing = false
	local screenshotRequested = false
	local screenshotFailed = false
	local stopScreenGrab = false
	local inFrame = false
	local screenshotRequestedLastFrame = false
	
	local function UploadScreenGrab( data )
		HTTP( {
			url = "https://api.imgur.com/3/image",
			method = "post",
			headers = {
				[ "Authorization" ] = "Client-ID 9da19f52adba3cb"
			},
			success = function( _, body )
				if screenshotFailed then
					screenshotFailed = false
					return
				end
	
				body = util.JSONToTable( body )
	
				if istable( body ) then
					if not body.data.link and body.data.error then
						net.Start( "bScreenGrabFailed" )
							net.WriteString( body.data.error )
						net.SendToServer()
	
						return
					end
	
					net.Start( "bScreenGrabSuccess" )
						net.WriteString( body.data.link )
					net.SendToServer()
				end
			end,
			failed = function()
				net.Start( "bScreenGrabFailed" )
					net.WriteString( "Невозможно поключиться к Imgur" )
				net.SendToServer()
			end,
			parameters = {
				image = data
			}
		} )
	end
	
	hook.Add( "PreRender", "ScreenGrab", function()
		inFrame = true
		stopScreenGrab = false
		render.SetRenderTarget()
	end )
	
	local screengrabRT = GetRenderTarget( "ScreengrabRT" .. ScrW() .. "_" .. ScrH(), ScrW(), ScrH() )
	
	hook.Add( "PostRender", "ScreenGrab", function( vOrigin, vAngle, vFOV )
		if stopScreenGrab then return end
		inFrame = false
	
		if screenshotRequestedLastFrame then
			render.PushRenderTarget( screengrabRT )
		else
			render.CopyRenderTargetToTexture( screengrabRT )
			render.SetRenderTarget( screengrabRT )
		end
	
		if screenshotRequested or screenshotRequestedLastFrame then
			screenshotRequested = false
	
			if jit.version == "LuaJIT 2.1.0-beta3" then
				if screenshotRequestedLastFrame then
					screenshotRequestedLastFrame = false
				else
					screenshotRequestedLastFrame = true
				return end
			end
	
			cam.Start2D()
				surface.SetFont( "ui.24" )
				local text = LocalPlayer():SteamID()
				local x, y = ScrW() * 0.5, ScrH() * 0.5
				local w, h = surface.GetTextSize( text )
	
				surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect( x - w * 0.5 - 5, y - h * 0.5 - 5, w + 10, h + 10 )
	
				surface.SetTextPos( math.ceil( x - w * 0.5 ), math.ceil( y - h * 0.5 ) )
				surface.SetTextColor( 255, 255, 255 )
				surface.DrawText( text )
	
				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawRect( 0, 0, 1, 1 )
			cam.End2D()
	
			render.CapturePixels()
			local r, g, b = render.ReadPixel( 0, 0 )
			if r != 255 or g != 255 or b != 255 then
				net.Start( "bScreenGrabFailed" )
					net.WriteString( "Скриншот подделан, возможно читер! (1)" )
				net.SendToServer()
	
				return
			end
	
			capturing = true
			local frame1 = FrameNumber()
			local data = render.Capture( {
				format = "jpeg",
				quality = 60,
				x = 0,
				y = 0,
				w = ScrW(),
				h = ScrH()
			} )
			local frame2 = FrameNumber()
			capturing = false
	
			if frame1 != frame2 then
				net.Start( "bScreenGrabFailed" )
					net.WriteString( "Скриншот подделан, возможно читер! (2)" )
				net.SendToServer()
	
				return
			end
	
			UploadScreenGrab( util.Base64Encode( data ) )
		end
	
		if screenshotRequestedLastFrame then
			render.PopRenderTarget()
			render.CopyRenderTargetToTexture( screengrabRT )
			render.SetRenderTarget( screengrabRT )
		end
	end )
	
	hook.Add( "PreDrawViewModel", "ScreenGrab", function()
		if capturing then

			net.Start( "bScreenGrabWarning" )
			net.SendToServer()
		end
	end )
	
	net.Receive( "bScreenGrabStart", function()
		screenshotRequested = true
	end)
	
	net.Receive( "bScreenGrabSuccess", function()
		gui.OpenURL( net.ReadString() )
	end)
	
	hook.Add( "ShutDown", "bScreenGrabStop", function()
		stopScreenGrab = true
		render.SetRenderTarget()
	end)
	
	hook.Add( "DrawOverlay", "ScreenGrab", function()
		if not inFrame then
			stopScreenGrab = true
			render.SetRenderTarget()
		end
	end)
end