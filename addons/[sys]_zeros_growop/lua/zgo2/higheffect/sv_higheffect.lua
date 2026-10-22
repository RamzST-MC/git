--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
zgo2 = zgo2 or {}
zgo2.HighEffect = zgo2.HighEffect or {}

/*
	Starts the player being high
*/
function zgo2.HighEffect.Start(WeedID,WeedTHC,Duration,ply)

    // Is the last duration we had already over?
    if ply.zgo2_HighEffect_start and ply.zgo2_HighEffect_duration and CurTime() > (ply.zgo2_HighEffect_start + ply.zgo2_HighEffect_duration) then
        ply.zgo2_HighEffect_start = nil
        ply.zgo2_HighEffect_duration = nil
    end

    // If we already are on weed then check how much time has passed since we started using it and substract it from the duration
    if ply.zgo2_HighEffect_duration then
        local time_passed = math.Clamp(CurTime() - ply.zgo2_HighEffect_start,0,99999999999999999)
        ply.zgo2_HighEffect_duration = math.Clamp(ply.zgo2_HighEffect_duration - time_passed,0,zgo2.config.HighEffect.MaxDuration)
    end

	// Start or increase the weed duration
	if ply.zgo2_HighEffect_start == nil then
		ply.zgo2_HighEffect_duration = Duration
	else
		// Here we clamp to make sure the effect cant be longer then zgo2.config.HighEffect.MaxDuration seconds
		ply.zgo2_HighEffect_duration = math.Clamp(ply.zgo2_HighEffect_duration + Duration,0,zgo2.config.HighEffect.MaxDuration)
	end

    ply.zgo2_HighEffect_start = CurTime()

    // Lets store the weedID
    ply.zgo2_HighEffect_id = WeedID

	// Start the screeneffect
	zgo2.ScreenEffect.Start(WeedID,WeedTHC,ply.zgo2_HighEffect_duration,ply)

    // Start effect end timer
    local timerid = "zgo2_hightime_" .. ply:SteamID64()
    zclib.Timer.Remove(timerid)
    zclib.Timer.Create(timerid,ply.zgo2_HighEffect_duration,1,function()
		if not IsValid(ply) then return end
        zgo2.HighEffect.End(ply)
        zclib.Timer.Remove(timerid)
    end)
end

/*
	Stops the player being high
*/
function zgo2.HighEffect.End(ply)
    if not IsValid(ply) then return end

    // Remove timer
    zclib.Timer.Remove("zgo2_hightime_" .. ply:SteamID64())

    // Clear vars
    ply.zgo2_HighEffect_start = nil
    ply.zgo2_HighEffect_duration = nil
    ply.zgo2_HighEffect_id = nil
end

/*
	Returns if the player is being high
*/
function zgo2.HighEffect.IsActive(ply)
	return ply.zgo2_HighEffect_id ~= nil
end

zclib.Hook.Add("PlayerDeath", "zgo2_HighEffect", function(ply) if zgo2.HighEffect.IsActive(ply) then zgo2.HighEffect.End(ply) end end)
zclib.Hook.Add("PlayerSilentDeath", "zgo2_HighEffect", function(ply) if zgo2.HighEffect.IsActive(ply) then zgo2.HighEffect.End(ply) end end)

/*
	Reverses the players sentences in chat
*/
zclib.Hook.Add("PlayerSay", "zgo2_HighEffect_Babble", function(ply, txt,teamchat)
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher