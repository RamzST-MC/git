--NOTE: Don't use permaprop for the NPC's, use !savepillsellers instead.

BLUES_PHARMA = BLUES_PHARMA or {}

BLUES_PHARMA.CONFIG = {}



--This is how fast the "overdose" value goes down. This is per seconds (0 - 100)

--Default: 0.5 = Aprox 3 minutes from full overdose

BLUES_PHARMA.CONFIG.OverdoseCooldownRate = 2



--These are the ranks that have permission to do !savepillsellers

BLUES_PHARMA.CONFIG.AuthorisedRanks = {

	"root"

}



--These are the prices of each full pill bottle sold at the pill market.

BLUES_PHARMA.CONFIG.SellPrices = {

	[1] = 12000, -- Aspirin

	[2] = 15000, -- Ibuprofen

	[3] = 16000, -- Naproxen

	[4] = 14000, -- Steroid

	[5] = 8600, -- Vitamin

	[6] = 18000, -- Corticosteroid

	[7] = 16000, -- Dianabol

	[8] = 24000 -- Anadrol

}  



--Set this to false if you don't wnat them to be able to eat the pills and get buffs

BLUES_PHARMA.CONFIG.CanConsumePills = true



--INFO: If you want to change more specific things about the recipes and there buff, do so in autorun/sh_blues_pharmaceuticals



--This is the maximum distance to render Cam3D2D UI at. This is Squared (Don't change it if you don't know what this means).

BLUES_PHARMA.CONFIG.Cam3D2DRenderDist = 400000  



--Change these functions if you are using a custom gamemode that isn't darkrp

BLUES_PHARMA.CONFIG.AddMoney = function(user, amount)

	user:addMoney(amount)

end



--Add entities are below here. Remove this if you want to do it manually

