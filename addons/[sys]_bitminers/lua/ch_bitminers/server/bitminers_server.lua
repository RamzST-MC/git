function CH_BITMINERS_RandomizeBitcoinRate()
	timer.Create( "ch_bitminers_randomize_rate", CH_Bitminers.Config.RateRandomizeInterval, 0, function()
		local current_rate = CH_Bitminers.Config.BitcoinRate
		local randomized_change = math.random( -CH_Bitminers.Config.RateUpdateInterval, CH_Bitminers.Config.RateUpdateInterval )
		
		-- Update bitcoin rate
		CH_Bitminers.Config.BitcoinRate = math.Clamp( CH_Bitminers.Config.BitcoinRate + randomized_change, CH_Bitminers.Config.MinBitcoinRate, CH_Bitminers.Config.MaxBitcoinRate )

		-- Network bitcoin rate
		net.Start( "CH_BITMINERS_UpdateBitcoinRates" )
			net.WriteInt( CH_Bitminers.Config.BitcoinRate, 32 )
		net.Broadcast()
	end )
end