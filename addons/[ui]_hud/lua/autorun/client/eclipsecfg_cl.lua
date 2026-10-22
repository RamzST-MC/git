eclipse = eclipse or {}

eclipse.color = {
    Main = Color(80, 80, 80),

    hp_bg = Color(155, 0, 0),
    hp = Color(221, 0, 0),
    
    arm_bg = Color(123, 123, 123),
    arm = Color(164, 164, 164),

    food_bg = Color(255, 132, 0),
    food = Color(254, 192, 86),

    CloseButtonHover = Color(255, 45, 45),
    CloseButton = Color(255, 255, 255),

    Slate_Black = Color(43, 43, 43),
    Eclipse = Color(58, 58, 58),
    Eerie_Black = Color(30, 30, 30),

    Sachet_Pink = Color(241, 138, 171),
    Dark_Pink = Color(177, 45, 87),
    Darker_Pink = Color(122, 30, 60),
    Cerise = Color(215, 38, 96),
    White = Color(255, 255, 255),
    Text = Color(176, 176, 176),

    White_Darker = Color(217, 217, 217),
    Darkest_Gray = Color(77, 77, 77),
    Gray = Color(179, 179, 179),
    Dark_Gray = Color(102, 102, 102),
    Darker_Gray = Color(88, 88, 88),
}

eclipse.col = eclipse.color

local function mat(material)
    return Material(material, 'noclamp smooth')
end

eclipse.material = {
    Heart = mat'divergent/ui/hud/icons/heart-60.png',
    Shield = mat'divergent/ui/hud/generic/armor.png',
    Food = mat'divergent/ui/hud/icons/energy.png',
    License = mat'divergent/ui/hud/icons/gunlicense.png',
    Radio = mat'divergent/ui/hud/icons/radio.png',
    Logo = mat'divergent/ui/hud/eclipse.png',
    Money = mat'divergent/ui/hud/icons/money.png',
    Jump = mat'divergent/ui/jump_white.png',
    HandCuffs = mat'divergent/ui/hud/icons/handcuffs.png',
    Search = mat'divergent/ui/hud/icons/search.png',
    Ammo = mat'divergent/ui/hud/icons/ammo_box.png',
    Laws = mat'sup/gui/hud/zcourt.png',
    Gift = mat'divergent/ui/hud/icons/gift-64.png',
    
    Locked = mat'sup/gui/hud/locked.png',
    UnLocked = mat'sup/gui/hud/unlocked.png',

    NotifyError = mat'divergent/ui/notifications/error.png',
    NotifyGeneric = mat'divergent/ui/notifications/generic.png',
    NotifyHint = mat'divergent/ui/notifications/hint.png',
    NotifySuccess = mat'divergent/ui/notifications/success.png',
    
    jobs = mat'divergent/ui/hud/f4/jobs.png',
    actions = mat'divergent/ui/hud/f4/actions.png',
    achievement = mat'divergent/ui/hud/f4/achievement.png',
    cosmetic = mat'divergent/ui/hud/f4/cosmetics.png',
    settings = mat'divergent/ui/hud/f4/settings.png',
    shop = mat'divergent/ui/hud/f4/shop.png',
    weaponskins = mat'divergent/ui/hud/f4/weapon-skins.png',
    
    BlankButton = mat'divergent/ui/hud/icons/blank_button.png',
    ПКМ = mat'ui/mouse_right.png',
    ЛКМ = mat'ui/mouse_left.png',
    
    CopShop = mat'divergent/entities/genome.png',

    DS = mat'divergent/ui/scoreboard/discord.png',
    Steam = mat'divergent/ui/scoreboard/steam.png',
    Donate = mat'divergent/ui/hud/icons/coin.png',
    
    Star = mat'divergent/ui/hud/generic/star.png',
    StarHalf = mat'divergent/ui/hud/generic/starhalf.png',

    Upgrade = mat'money_printer/update.png',
    Freeze = mat'money_printer/freeze.png',
}

eclipse.mat = eclipse.material