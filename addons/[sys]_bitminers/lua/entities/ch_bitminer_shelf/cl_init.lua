include( "shared.lua" )

function ENT:Initialize()
end

local col_white = Color( 255, 255, 255, 255 )
local col_blue = Color( 62, 173, 229, 255 )

local col_bar_bg = Color( 62, 62, 62, 100 )
local col_bar_bg_notrans = Color( 30, 30, 30, 255 )

local button_col_green = Color( 0, 70, 0, 255 )
local button_col_green_hovered = Color( 0, 110, 0, 255 )

-- Rect colors
local rect_col_green = Color( 0, 100, 0, 255 )
local rect_col_orange = Color( 240, 137, 19, 50 )
local rect_col_red = Color( 100, 0, 0, 255 )

local col_red = Color( 150, 0, 0, 255 )

-- Img
local mat_rgb_btn
local rgb_col
local power_btn_col

local mat_rgb_btn_on = Material( "craphead_scripts/bitminers/rgb_on.png" )
local mat_rgb_btn_off = Material( "craphead_scripts/bitminers/rgb_off.png" )
local mat_power_btn = Material( "craphead_scripts/bitminers/icon_power.png" )

local mat_low_battery = Material( "craphead_scripts/bitminers/low_battery.png" )
local mat_full_battery = Material( "craphead_scripts/bitminers/full_battery.png" )

net.Receive( "CH_BITMINERS_UpdateBitcoinRates", function( length, ply )
	if ply then
		if not ply:IsSuperAdmin() then
			return
		end
	end
	
	local rate = net.ReadInt( 32 )
	CH_Bitminers.Config.BitcoinRate = math.Clamp( rate, CH_Bitminers.Config.MinBitcoinRate, CH_Bitminers.Config.MaxBitcoinRate )
end )

local function BITMINERS_DrawCircle(x, y, ang, seg, p, rad, color)
	local cirle = {}

	table.insert( cirle, { x = x, y = y} )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -p + ang )
		table.insert( cirle, { x = x + math.sin( a ) * rad, y = y + math.cos( a ) * rad } )
	end
	surface.SetDrawColor( color )
	draw.NoTexture()
	surface.DrawPoly( cirle )
end

function ENT:DrawTranslucent()
	self:DrawModel()

	local Pos = self:GetAttachment( 1 ).Pos
	local Ang = self:GetAttachment( 1 ).Ang
	
	local tr = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos )
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > CH_Bitminers.Config.ShowScreenDistance then
		return
	end
	
	local bitcoin_rate = CH_Bitminers.Config.BitcoinRate

	--print( tr )
	cam.Start3D2D( Pos, Ang, 0.01 )
		if not self:GetIsMining() and self:GetHasPower() then
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_one, CH_Bitminers.Config.ScreenPositions.power_btn_two ) then
				if self:GetHasPower() then
					power_btn_col = button_col_green
				end
			else
				power_btn_col = col_white
			end
			
			surface.SetDrawColor( power_btn_col )
			surface.SetMaterial( mat_power_btn )
			surface.DrawTexturedRect( 700, 250, 750, 750 )
		elseif self:GetHasPower() then
			--Background for 76561198125171585
			--surface.SetDrawColor( rect_col_orange )
			--surface.DrawRect( 0, 0, 2145, 1275 )
			
			-- DRAW HEALTH
			draw.DrawText( "ЗДОРОВЬЕ", "BITMINER_ScreenText23b", 70, 10, col_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetHP() .."%", "BITMINER_ScreenText23b", 995, 10, col_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing vents level
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 70, 100, 925, 50 )
			
			if self:GetHP() >= 75 then
				surface.SetDrawColor( rect_col_green )
			elseif self:GetHP() >= 50 then
				surface.SetDrawColor( rect_col_orange )
			elseif self:GetHP() >= 50 then
				surface.SetDrawColor( rect_col_orange )
			else
				surface.SetDrawColor( rect_col_red )
			end
			surface.DrawRect( 70, 100, math.Clamp( self:GetHP() * 9.25, 0, 925), 50 )
			
			-- DRAW MONEY MINED
			draw.DrawText( "ДОБЫТО", "BITMINER_ScreenText20b", 295, 160, col_white, TEXT_ALIGN_CENTER )
			if bitcoin_rate then
				draw.DrawText( "1BTC = "..DarkRP.formatMoney( bitcoin_rate ), "BITMINER_ScreenText20b", 295, 210, col_white, TEXT_ALIGN_CENTER )
			end
			BITMINERS_DrawCircle( 290, 515, 180, 80, 360, 230, col_bar_bg ) -- Back circle
			BITMINERS_DrawCircle( 290, 515, 180, 80, 361 * self:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined, 230, col_blue ) -- Money circle
			BITMINERS_DrawCircle( 290, 515, 180, 40, 360, 210, col_bar_bg_notrans ) -- Front circle
			
			draw.DrawText( "Ёмкость", "BITMINER_ScreenText23b", 290, 400, col_white, TEXT_ALIGN_CENTER )
			draw.DrawText( math.Round( self:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined * 100, 1 ) .."%", "BITMINER_ScreenText30b", 290, 475, col_white, TEXT_ALIGN_CENTER )
			
			-- DRAW WATTS
			draw.DrawText( "ВАТТЫ", "BITMINER_ScreenText23b", 770, 340, col_white, TEXT_ALIGN_CENTER )
			
			BITMINERS_DrawCircle( 765, 680, 180, 80, 360, 230, col_bar_bg ) -- Back circle
			BITMINERS_DrawCircle( 765, 680, 180, 80, 361 * self:GetWattsGenerated() / self:GetWattsRequired(), 230, col_blue ) -- Money circle
			BITMINERS_DrawCircle( 765, 680, 180, 40, 360, 210, col_bar_bg_notrans ) -- Front circle
			
			draw.DrawText( "Имеется", "BITMINER_ScreenText20b", 770, 510, col_white, TEXT_ALIGN_CENTER )
			draw.DrawText( string.Comma( math.Round( self:GetWattsGenerated() ) ), "BITMINER_ScreenText23b", 770, 570, col_white, TEXT_ALIGN_CENTER )
			
			draw.DrawText( "Требуется", "BITMINER_ScreenText20b", 770, 670, col_white, TEXT_ALIGN_CENTER )
			draw.DrawText( string.Comma( math.Round( self:GetWattsRequired() ) ), "BITMINER_ScreenText23b", 770, 730, col_white, TEXT_ALIGN_CENTER )
			
			-- WITHDRAW BUTTON
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.withdraw_one, CH_Bitminers.Config.ScreenPositions.withdraw_two ) then
				draw.RoundedBox( 0, 70, 970, 925, 250, button_col_green_hovered )
			else
				draw.RoundedBox( 0, 70, 970, 925, 250, button_col_green )
			end
			
			draw.DrawText( "Продать (" ..math.Round( self:GetBitcoinsMined(), 4 ) .." BTC)", "BITMINER_ScreenText23b", 525, 985, col_white, TEXT_ALIGN_CENTER )
			if bitcoin_rate then
				draw.DrawText( DarkRP.formatMoney( math.Round( self:GetBitcoinsMined() * bitcoin_rate ) ), "BITMINER_ScreenText30b", 525, 1070, col_white, TEXT_ALIGN_CENTER )
			end
			
			-- SPLIT CENTER LINE
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1065, 0, 15, 1275 )
			
			-- BITMINERS
			draw.DrawText( "МАЙНЕРЫ", "BITMINER_ScreenText23b", 1150, 10, col_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetMinersInstalled() .." / ".. self:GetMinersAllowed(), "BITMINER_ScreenText23b", 2075, 10, col_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing amount of bitminers
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 100, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			local multiple_rate = 0
			
			
			if self:GetMinersAllowed() <= 4 then
				multiple_rate = 231.250
			elseif self:GetMinersAllowed() <= 8 then
				multiple_rate = 115.625
			elseif self:GetMinersAllowed() <= 12 then
				multiple_rate = 77.0833
			elseif self:GetMinersAllowed() <= 16 then
				multiple_rate = 57.8125
			end
			
			surface.DrawRect( 1150, 100, self:GetMinersInstalled() * multiple_rate, 50 )

			-- UPS'S INSTALLED
			draw.DrawText( "ИСТ. ПИТАНИЯ", "BITMINER_ScreenText23b", 1150, 175, col_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetUPSInstalled() .." / 4", "BITMINER_ScreenText23b", 2075, 175, col_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing amount of ups's installed
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 265, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			surface.DrawRect( 1150, 265, self:GetUPSInstalled() * 231.25, 50 )
			
			-- VENTILATION
			draw.DrawText( "ОХЛАЖДЕНИЕ", "BITMINER_ScreenText23b", 1150, 340, col_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetFansInstalled() .." / 3", "BITMINER_ScreenText23b", 2075, 340, col_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing vents level
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 430, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			surface.DrawRect( 1150, 430, self:GetFansInstalled() * 308.33, 50 )
			
			-- TEMPERATURE
			draw.DrawText( "ТЕМПЕРАТУРА", "BITMINER_ScreenText23b", 1150, 505, col_white, TEXT_ALIGN_LEFT )
			draw.DrawText( math.Round( self:GetTemperature(), 3 ) .."C", "BITMINER_ScreenText23b", 2075, 505, col_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing temp
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 595, 925, 50 )
			
			if self:GetTemperature() <= 33 then
				surface.SetDrawColor( rect_col_green )
			elseif self:GetTemperature() <= 66 then
				surface.SetDrawColor( rect_col_orange )
			elseif self:GetTemperature() <= 100 then
				surface.SetDrawColor( rect_col_red )
			end
			surface.DrawRect( 1150, 595, self:GetTemperature() * 9.25, 50 )
			
			-- Show RGB Button
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.rgb_btn_one, CH_Bitminers.Config.ScreenPositions.rgb_btn_two ) then
				if self:GetRGBInstalled() then
					rgb_col = col_white
					
					if self:GetRGBEnabled() then
						mat_rgb_btn = mat_rgb_btn_off
					else
						mat_rgb_btn = mat_rgb_btn_on
					end
				else
					rgb_col = col_bar_bg
					mat_rgb_btn = mat_rgb_btn_off
				end
			else
				if self:GetRGBInstalled() then
					rgb_col = col_white
					
					if self:GetRGBEnabled() then
						mat_rgb_btn = mat_rgb_btn_on
					else
						mat_rgb_btn = mat_rgb_btn_off
					end
				else
					rgb_col = col_bar_bg
					mat_rgb_btn = mat_rgb_btn_off
				end
			end
			
			draw.RoundedBox( 0, 1150, 970, 250, 250, col_bar_bg_notrans )
			
			surface.SetDrawColor( rgb_col )
			surface.SetMaterial( mat_rgb_btn )
			surface.DrawTexturedRectRotated( 1275, 1095, 220, 220, CurTime() * 360 )
			
			draw.RoundedBox( 0, 1470, 970, 280, 250, col_bar_bg_notrans )
			
			-- Draw battery
			if self:GetWattsGenerated() < self:GetWattsRequired() then
				draw.DrawText( "НИЗКИЙ", "BITMINER_ScreenText20b", 1610, 976, col_white, TEXT_ALIGN_CENTER )
				draw.DrawText( "ЗАРЯД", "BITMINER_ScreenText20b", 1610, 1152, col_white, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( Color( 255, 255, 255, 150 * math.abs( math.sin( CurTime() * 1.5 ) ) ) )
				surface.SetMaterial( mat_low_battery )
				surface.DrawTexturedRect( 1505, 985, 220, 220 )
			else
				draw.DrawText( "ПОЛНЫЙ", "BITMINER_ScreenText20b", 1610, 976, col_white, TEXT_ALIGN_CENTER )
				draw.DrawText( "ЗАРЯД", "BITMINER_ScreenText20b", 1610, 1152, col_white, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( col_white )
				surface.SetMaterial( mat_full_battery )
				surface.DrawTexturedRect( 1505, 985, 220, 220 )
			end
			
			-- Draw power button
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_small_one, CH_Bitminers.Config.ScreenPositions.power_btn_small_two ) then
				power_btn_col = col_red
			else
				power_btn_col = col_white
			end
			
			draw.RoundedBox( 0, 1825, 970, 250, 250, col_bar_bg_notrans )
			
			surface.SetDrawColor( power_btn_col )
			surface.SetMaterial( mat_power_btn )
			surface.DrawTexturedRect( 1823, 968, 256, 256 )
		end
	cam.End3D2D()
end