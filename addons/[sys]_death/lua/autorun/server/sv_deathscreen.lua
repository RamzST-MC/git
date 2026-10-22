local util_AddNetworkString = util.AddNetworkString
local hook_Add = hook.Add
local RealTime = RealTime
local net_Start = net.Start
local net_WriteString = net.WriteString
local net_WriteEntity = net.WriteEntity
local net_Send = net.Send
local timer_Simple = timer.Simple
local IsValid = IsValid

util_AddNetworkString("RespawnTimer")
util_AddNetworkString("RespawnTimerHUD")
local GetTimeDeath = 5

hook_Add("PlayerDeath", "RespawnTimer", function(ply, weapon, attacker)
    ply.deadtime = RealTime()

    local wepname = weapon:GetClass()
    net_Start("RespawnTimer")
        net_WriteString(wepname)
        net_WriteEntity(attacker)
    net_Send(ply)
end)

hook_Add('playerCompletedHit', 'killerInfoComplete', function(p, k)
    k:SetNWBool('KilledByKiller', true)
    timer.Simple(15, function () if IsValid(k) then k:SetNWBool('KilledByKiller', false) end end)
end)

hook_Add("PlayerDeathThink", "RespawnTimer", function(ply)
    if ply.deadtime && RealTime() - ply.deadtime < GetTimeDeath then
        return false
    end
end)

hook_Add("PlayerSpawn", "RespawnTimer", function(ply)
    if not IsValid(ply) then 
        return 
    end

    net_Start("RespawnTimerHUD")
    net_Send(ply)
end)

hook.Add( 'PlayerSay', 'dsfsd32', function( ply, text )
    if not ply:Alive() then
        return ''
    end
end)