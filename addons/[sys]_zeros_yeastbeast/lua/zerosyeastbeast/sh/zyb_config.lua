-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}
zyb.config = zyb.config or {}

/////////////////////////////////////////////////////////////////////////////

// Bought by 76561198451089181
// Version 1.1.5

/////////////////////////// Zeros YeastBeast  /////////////////////////////

/////////////////////////////////////////////////////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////

// This enables the Debug Mode
zyb.config.Debug = false

// This switches between fastdl and workshop download for the users
zyb.config.EnableResourceAddfile = false

// The Currency we want to display
zyb.config.Currency = "$"

// The unit to measure liquid
zyb.config.LiquidUnit = " l"

// The unit to measure heat
zyb.config.HeatUnit = " c"

// The language we want
zyb.config.SelectedLanguage = "ru" // en de fr hu pt pl es ru cn dk

// These Ranks are allowed to use the !savezyb chat command for saving buyer npcs
zyb.config.AdminRanks = {
    ["root"] = true
}

// These jobs are allowed to sell moonshine to the npc, Leave empty to allow everyone to sell moonshine
zyb.config.MoonShine_Customer = {
    [TEAM_DISTILLER] = true
}

// If set to true then there are no owner checks
zyb.config.EquipmentSharing = true

// The Damage the entitys have do take before they get destroyed.
// Setting it to -1 disables it
zyb.config.Damageable = {
    ["zyb_fermbarrel"] = 100,
    ["zyb_distillery"] = 300,
    ["zyb_fuel"] = 25,
    ["zyb_jarpack"] = 50,
    ["zyb_paperbag"] = 25,
    ["zyb_sugar"] = 25,
    ["zyb_water"] = 25,
    ["zyb_yeast"] = 25,
    ["zyb_yeastgrinder"] = 100,
    ["zyb_palette"] = 100,
}




//Should the player drop all of the moonshine jars he has in his inventory on death
zyb.config.DropMoonshineOnDeath = true


zyb.config.YeastBlock = {
    // The amount of Yeast
    Amount = 200,
}

zyb.config.Water = {
    // The amount of Water
    Amount = 250,
}

zyb.config.Sugar = {
    // The amount of Sugar
    Amount = 100,
}

zyb.config.Wood = {
    // The amount of Wood
    Amount = 100,
}

zyb.config.PaperBag = {
    // How much yeast can fit in to the bag
    Capacity = 200,
}

zyb.config.Grinder = {
     // The interval at which we grind yeast in seconds
    Interval = 1,

    // The amount of yeast that gets grinded
    GrindAmount = 15,
}

zyb.config.GrinderMotor = {
    // If the grinder has a motor installed then this grind interval gets used
    Interval = 0.5,
}

zyb.config.FermBarrel = {
    // How much yeast is needed
    YeastAmount = 400,

    // How much water is needed
    WaterAmount = 500,

    // How much sugar is needed
    SugarAmount = 200,

    // How often do we need to shake the barrel to mix it
    ShakeCount = 5,

    // How long does it take for the mixture to ferment?
    FermentingTime = 120,

    // How much femented YeastStew does it produce in the end
    YeastStew = 1500,

    // How much dirt need to be cleaned after the barrel got used, set it to -1 to disable the cleaning process
    DirtAmount = 100,

    // How much dirt get removed per click
    CleanPerClick = 25,
}

zyb.config.Distillery = {
    // How much yeastew can fit in the distillery
    YeastStewAmount = 3000,

    // How much wood can we put in the distillery
    FuelAmount = 200,

    // How much fuel get used every 3 seconds
    FuelUsage = 5,

    // How much yeaststew can be processed per second
    ProcessAmount = 15,

    // The yeaststew amount that gets destroyed when the distillery overheats
    BurnAmount = 3,

    // How much yeaststew will be distilled to steam, 0.7 = 70%
    DistillAmount = 0.7,

    // 1.25 = +25% How much extra yeastStew Steam are we producing if the Distillery has the perfect heat
    PerfectHeatBoni = 1.5
}

zyb.config.Cooler = {

    // The interval at which it cools the liquid. This value gonna change depending on the water temperatur
    CoolingSpeed = 2,

    // How much yeaststeam can be stored in the cooler tills its full
    YeastSteamAmount = 500,

    // How much water can fit in the cooler
    WaterAmount = 500,

    // How much yeaststewsteam can be processed per second
    ProcessAmount = 10,

    // How much moonshine will be produced from the yeaststewsteam // 0.5 = 50%
    CoolAmount = 0.5,

    // The amount of moonshine that can get stored in the cooler before it gets full
    WeakMoonshineStorage = 100,

    // If the water gets warmer then 40 degree then only this much moonshine will be produced 0.2 = 20%
    HeatPenalty = 0.2
}

zyb.config.Condenser = {

    // The Amount of time in seconds it takes to process weakmoonshine to moonshine
    ProcessSpeed = 2,

    // The amount of uncondensed moonshine that can get stored in the condenser before it gets full
    WeakMoonshineStorage = 300,

    // The amount of moonshine that can get stored in the condenser before it gets full
    MoonshineStorage = 300,

    // How much WeakMoonShine can be processed per second
    ProcessAmount = 10,

    // How much Moonshine are we getting from 1l of weakmoonshine, 0.2 = 20%
    CondenseAmount = 0.3
}

zyb.config.Upgrade = {

    // If true then the upgrades get dirty over time and need to be cleaned to stay at maximal efficiency
    Cleaning = true,

    // How high is the chance of a module getting dirty?
    Dirty_Chance = 25,

    // How often while condensing moonshine should we try to dirty the modules
    Dirty_Interval = 10,

    // Should allow we that player can add more then one upgrade module of the same type to the condenser
    Stacking = true,
}


zyb.config.Upgrades = {
    [1] = {
        u_name = "Basic Speed",
        u_desc = "Increases the speed a bit.",
        u_type = 1, // The type of the Upgrade, 1 = Speed, 2 = Production
        u_amount = 0.1, // 0.25 = +25%
        u_color = Color(242,108,79), // The color of the module
        u_ranks = {}, // What Ranks are allowed to buy this Upgrade, leave empty to allow it for everyone
        u_price = 1000, // The price of the upgrade
    },
    [2] = {
        u_name = "VIP Speed",
        u_desc = "Increases the speed a lot.",
        u_type = 1,
        u_amount = 0.5,
        u_color = Color(188,54,63),
        u_ranks = {},
        u_price = 5000,
    }
}

zyb.config.Jar = {

    // How much moonshine can fit in to the jar
    MoonshineAmount = 50,

    // How much should the players health change when he drinks the moonshine (This can also be a negative value)
    Health = 25,

    // How long should the drunk effect last, This value gets added to the allready existing effecttime.
    EffectDuration = 20,
}

zyb.config.ConstructionKit = {
    Data = {
        [1] = {
            class = "zyb_distillery_condenser",
            model = "models/zerochain/props_yeastbeast/yb_distillery_condenser.mdl",
        },
        [2] = {
            class = "zyb_distillery_cooler",
            model = "models/zerochain/props_yeastbeast/yb_distillery_cooler.mdl",
        }
    },
    AcceptKey = MOUSE_LEFT, // The Button which complets the action
    CancelKey = MOUSE_RIGHT, // The Button which cancels the action
    BuildDistance = 500,
}

zyb.config.NPC = {
    // The model of the npc
    Model = "models/humans/group01/male_04.mdl",

    // Setting this to false will improve network performance but disables the npc reactions for the player
    Capabilities = true,

    // The maximal money the player recieves per Moonshine Jar
    MaxBuyRate = 6000,

    // The minimal money the player can receive per Moonshine Jar
    MinBuyRate = 4000,

    // The interval at which the sell price changes in seconds
    RefreshRate = 300,

    // How should the player sell the moonshine?
    // 1 = Player needs to bring the physical moonshine to the npc
    // 2 = Player can absorb the moonshine and sell by the npc
    SellMode = 2,
}


zyb.config.Palette = {
    // How many crates can fit on the palette
    Limit = 36
}

// Do we have VrondakisLevelSystem installed?
zyb.config.VrondakisLevelSystem = false
zyb.config.Vrondakis = {}
zyb.config.Vrondakis["Producing"] = {XP = 25} // XP per produced Moonshine Jar
zyb.config.Vrondakis["Selling"] = {XP = 25}	// XP per Sold Moonshine Jar
-- leak by lordee