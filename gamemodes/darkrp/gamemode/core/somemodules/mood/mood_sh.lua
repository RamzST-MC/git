rp.Mood = rp.Mood or {};

nw.Register("rp.mood")
    :Write(net.WriteUInt,4)
    :Read(net.ReadUInt,4)
    :SetLocalPlayer();

PLAYER_MOOD_NORMAL  = 0;
PLAYER_MOOD_GLOOMY  = 1;
PLAYER_MOOD_PACE    = 2;
PLAYER_MOOD_HERO    = 3;
PLAYER_MOOD_FINGER = 4;

rp.Mood.HoldTypes = {
    [PLAYER_MOOD_NORMAL]  = { "mood-normal",  "Руки по швам" },
    [PLAYER_MOOD_GLOOMY]  = { "mood-gloomy",  "Серьёзная" },
    [PLAYER_MOOD_PACE]  = { "mood-pace",  "Гопник" },
    [PLAYER_MOOD_HERO]  = { "mood-hero",  "Герой" },
    [PLAYER_MOOD_FINGER] = {"mood-finger", 'Пальцы вверх'}
}

--[[------------------------------------------------
    Mood: Normal
------------------------------------------------]]--
local DATA = {
    Name         = "mood-normal",
    HoldType     = "mood-normal",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_JUMP] = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Gloomy
------------------------------------------------]]--
local DATA = {
    Name         = "mood-gloomy",
    HoldType     = "mood-gloomy",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "pose_standing_01",
        [ACT_MP_CROUCH_IDLE] = "pose_ducking_02",
        [ACT_MP_JUMP]        = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Pace
------------------------------------------------]]--
local DATA = {
    Name         = "mood-pace",
    HoldType     = "mood-pace",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "idle_all_angry",
        [ACT_MP_CROUCH_IDLE] = "plazaidle4",
        [ACT_MP_JUMP]       = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Pace
------------------------------------------------]]--
local DATA = {
    Name         = "mood-hero",
    HoldType     = "mood-hero",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "pose_standing_02",
        [ACT_MP_CROUCH_IDLE] = "pose_ducking_01",
        [ACT_MP_JUMP]       = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

local DATA = {
    Name         = "mood-finger",
    HoldType     = "mood-finger",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "pose_standing_04",
        [ACT_MP_CROUCH_IDLE] = "pose_ducking_01",
        [ACT_MP_JUMP]       = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

hook.Add( "PlayerSwitchWeapon", "hook.rp-mood.PlayerSwitchWeapon", function( ply, oldWep, newWep )
    if not (ply.IsProne and ply:IsProne()) and (newWep:GetClass() == "keys" or newWep:GetClass() == "weapon_hands" or ply:IsArrested()) then
        newWep:SetHoldType( rp.Mood.HoldTypes[ply:GetNetVar("rp.mood") or PLAYER_MOOD_NORMAL][1] );
    end
end );