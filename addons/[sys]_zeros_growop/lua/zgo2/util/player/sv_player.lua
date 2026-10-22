--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

// Add the entity clases to the cleanup and darkrp owner list
for class,v in pairs(zgo2.util.ClassList) do
	zclib.Player.CleanUp_Add(class)
	zclib.Gamemode.AssignOwnerOnBuy(class)
end

zclib.Hook.Add("zclib_PlayerJoined", "zgo2_PlayerJoined", function(ply)
	timer.Simple(1.5, function()
		if IsValid(ply) then

			// Send the servers plant config
			zclib.Data.Send("zgo2_plant_config", ply)

			// Send the servers bong config
			zclib.Data.Send("zgo2_bong_config", ply)

			// Send the servers pot config
			zclib.Data.Send("zgo2_pot_config", ply)

			// Updates the specified player which Marketplace got which buyrate
			zgo2.Marketplace.UpdatePlayer(ply)

			// Loads the saved marketplace cargo for the specified player
			zgo2.Marketplace.LoadCargo(ply)

			// Load the players seedlibary
			zgo2.SeedLibary.Load(ply)

			// Load the players backpack data
			zgo2.Backpack.Load(ply)

			// Update the player about all the currently active contracts
			zgo2.Contracts.Update(ply)
		end
	end)
end)
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher