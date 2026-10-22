-- CH_Bitminers = {}
-- CH_Bitminers.Config = {}
-- CH_Bitminers.Design = {}
-- CH_Bitminers.Config.MineMoneyInterval = {}

-- SET LANGUAGE
-- Available languages: English: en - Danish: da - Russian: ru - Spanish: es - French: fr
CH_Bitminers.Config.Language = "ru" -- Set the language of the script.

-- Bitminer Values
CH_Bitminers.Config.BitcoinRate = 50000 -- 1 bitcoin equals how much cash? (1 bitcoin = 3500)
CH_Bitminers.Config.RateRandomizeInterval = 20 -- seconds between bitcoin rate is changed.
CH_Bitminers.Config.RateUpdateInterval = 200 -- Default 20. So it will randomize the change between -20 to +20. So it can either go down or up, but maximum 20 either way.
CH_Bitminers.Config.MinBitcoinRate = 35000 -- The lowest the bitcoin rate can hit.
CH_Bitminers.Config.MaxBitcoinRate = 65000 -- The maximum the bitcoin rate can go to.

-- CH_Bitminers.Config.MineMoneyInterval[[AMOUNT OF MINERS] = INTERVAL BETWEEN MINING MONEY
-- Here it illustrates that having 1 miner will take 15 seconds before it mines bitcoins. The more miners, the less interval.
-- YOU DON'T NECESSARILY NEED TO MODIFY THIS
CH_Bitminers.Config.MineMoneyInterval[1] = 15
CH_Bitminers.Config.MineMoneyInterval[2] = 14
CH_Bitminers.Config.MineMoneyInterval[3] = 13
CH_Bitminers.Config.MineMoneyInterval[4] = 12
CH_Bitminers.Config.MineMoneyInterval[5] = 11
CH_Bitminers.Config.MineMoneyInterval[6] = 10
CH_Bitminers.Config.MineMoneyInterval[7] = 10
CH_Bitminers.Config.MineMoneyInterval[8] = 10
CH_Bitminers.Config.MineMoneyInterval[9] = 10
CH_Bitminers.Config.MineMoneyInterval[10] = 10
CH_Bitminers.Config.MineMoneyInterval[11] = 10
CH_Bitminers.Config.MineMoneyInterval[12] = 9
CH_Bitminers.Config.MineMoneyInterval[13] = 8
CH_Bitminers.Config.MineMoneyInterval[14] = 7
CH_Bitminers.Config.MineMoneyInterval[15] = 6
CH_Bitminers.Config.MineMoneyInterval[16] = 5

-- Bitminer Shelf
CH_Bitminers.Config.MaxBitcoinsMined = 5 -- How many bitcoins can a bitminer maximum contain
CH_Bitminers.Config.BitcoinsMinedPer = 0.025 -- Amount of bitcoins mined on each interval
CH_Bitminers.Config.WattsRequiredPerMiner = 1525 -- Amount of watts required per miner in order to properly mine bitcoins most optimal

CH_Bitminers.Config.ShelfHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.ShelfStartTemperature = 0 -- Temperature the shelf spawns with.

CH_Bitminers.Config.ShelfExplosion = true -- Should the shelf cause an explosion if it takes too much damage or overheats?
CH_Bitminers.Config.NotifyOwnerOverheating = true -- Should the owner of the shelf be notified when the mining shelf overheats?

CH_Bitminers.Config.ShowScreenDistance = 50000 -- Distance between player and shelf for showing screen

CH_Bitminers.Config.ShelfMiningSoundLevel = 25 -- Sound level of the shelf mining sound. (0 = muted)

-- Fuel Generator
CH_Bitminers.Config.GeneratorWattsInterval = 2 -- Interval for the fuel generator to generate watts in seconds.
CH_Bitminers.Config.FuelGeneratorHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.FuelConsumptionRate = 7 -- Every x second the generator will consume a random amount of fuel
CH_Bitminers.Config.FuelGeneratorExplosion = true -- Should the fuel generator cause an explosion if it takes too much damage?

CH_Bitminers.Config.GeneratorSmokeEffect = true -- Display smoke effect coming out of generator when turned on.
CH_Bitminers.Config.FuelGeneratorSoundLevel = 25 -- Sound level of the fuel generator when powered on. (0 = muted)

CH_Bitminers.Config.GeneratorWattsMin = 90 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.GeneratorWattsMax = 150 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- Solar Panel
CH_Bitminers.Config.SolarPanelWattsInterval = 4 -- Interval for the solar panel to generate watts in seconds.
CH_Bitminers.Config.SolarPanelHealth = 100 -- Amount of health before it destroys.
CH_Bitminers.Config.SolarPanelExplosion = true -- Should the solar panel cause an explosion if it takes too much damage?

CH_Bitminers.Config.SolarPanelWattsMin = 120 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.SolarPanelWattsMax = 170 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- RTG Generator
CH_Bitminers.Config.RTGWattsInterval = 4 -- Interval for the RTG to generate watts in seconds.
CH_Bitminers.Config.RTGGeneratorHealth = 300 -- Amount of health before it destroys.
CH_Bitminers.Config.RTGGeneratorExplosion = true -- Should the RTG cause an explosion if it takes too much damage? (NOTE: large explosion)

CH_Bitminers.Config.RTGRadiationEnabled = true -- Enable/disable the damage dealt by radiation.
CH_Bitminers.Config.RTGRadiationDamageOwnerOnly = false -- If enabled, should the radiation only damage the owner of the RTG? false = damage everyone, true = owner only

CH_Bitminers.Config.RTGRadiationInterval = 4 -- Amount of seconds between giving damage to players nearby.
CH_Bitminers.Config.RTGRadiationDistance = 500 -- Distance from players to RGT before doing damage.

CH_Bitminers.Config.RTGWattsMin = 130 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.RTGWattsMax = 180 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- Watts Decrease System
CH_Bitminers.Config.WattsDecreaseInterval = 5 -- Every 5th second it will decrease the watts if not powered/plugged in with a cable.
CH_Bitminers.Config.DecreaseAmountMin = 20 -- Minimum amount decreased every 5th second.
CH_Bitminers.Config.DecreaseAmountMax = 40 -- Minimum amount decreased every 5th second.

-- Power Cable
CH_Bitminers.Config.CableRopeLenght = 100 -- Lenght of the rope between the two ends of the power cable.

-- Cooling System & Upgrades
CH_Bitminers.Config.TemperatureInterval = 4 -- Interval between updating temperature on miners in seconds
CH_Bitminers.Config.TempToAddPerMiner = 0.05 -- Temperature added per miner on the shelf.

CH_Bitminers.Config.TempToTakePerCooling = 0.35 -- Temperature removed from shelf per cooling upgrade installed.
CH_Bitminers.Config.TempToTakeWhenOff = 0.8 -- Temperature to remove every interval if the shelf is turned off.

-- 3RD PARTY SUPPORT
CH_Bitminers.Config.CreateFireOnExplode = false -- ONLY WORKS WITH MY FIRE SYSTEM https://www.gmodstore.com/market/view/302

CH_Bitminers.Config.DarkRPLevelSystemEnabled = false -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System

CH_Bitminers.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431

CH_Bitminers.Config.WithdrawXPAmount = 400 -- Amount of XP to receive when exchanging bitcoins.


CH_Bitminers.Config.ScreenPositions = {
	withdraw_one = Vector( 4.974997, 15.155769, 48.283577 ), 
	withdraw_two = Vector( 5.793915, 24.367191, 45.947006 ),
	
	rgb_btn_one = Vector( 4.971034, 25.934856, 48.294861 ),
	rgb_btn_two = Vector( 5.786088, 28.407360, 45.969444 ),
	
	power_btn_one = Vector( 2.770266, 21.995148, 54.574265 ),
	power_btn_two = Vector( 4.824709, 28.136887, 48.712364 ),
	
	power_btn_small_one = Vector( 4.982971, 32.667717, 48.260895 ),
	power_btn_small_two = Vector( 5.784596, 35.163403, 45.973717 )
}