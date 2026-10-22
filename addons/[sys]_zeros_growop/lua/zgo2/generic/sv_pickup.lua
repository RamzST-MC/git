--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
	NOTE This system can be used to Pickup Objects but its kinda meh so its disabled for now
*/

/*
local AllowedClass = {
	[ "zgo2_jar" ] = true,
	//[ "zgo2_crate" ] = true,
	//[ "zgo2_weedbranch" ] = true,
}

hook.Add("KeyPress", "zgo2_custom_pickup", function(ply, key)
	if key == IN_USE then
		local tr = ply:GetEyeTrace()

		if tr and tr.Hit and IsValid(tr.Entity) and AllowedClass[ tr.Entity:GetClass() ] and not tr.Entity:IsPlayerHolding() then

			-- Enable physics
			local phys = tr.Entity:GetPhysicsObject()

			if IsValid(phys) then
				phys:Wake()
				phys:EnableMotion(true)
			end

			-- We need to delay the pickup action for one frame because reasons
			timer.Simple(0, function()
				if IsValid(ply) and IsValid(tr.Entity) then
					ply:PickupObject(tr.Entity)
				end
			end)
		end
	end
end)
*/
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher