function PLAYER:GetPlayTime()
	local base 		= tonumber(self:GetNetVar('PlayTime')) or 0
	local session 	= CurTime() - (tonumber(self:GetNetVar('FirstJoined')) or CurTime())

	-- защита от битого FirstJoined (отрицательная или нереальная сессия) - раньше давала "-497812:32:12"
	if (session < 0) or (session > 31536000) then session = 0 end

	return math.max(0, base + session)
end

function PLAYER:GetSessionTime()
    return (CurTime() - (self:GetNetVar('SessionStart') or 0))
end

nw.Register 'PlayTime'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'FirstJoined'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'SessionStart'
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register 'ActiveWarns'
    :Write(net.WriteUInt, 6)
    :Read(net.ReadUInt, 6)
    :SetPlayer()

nw.Register 'WarnTable'
    :Write(net.WriteTable)
    :Read(net.ReadTable)
    :SetPlayer()

if SERVER then
    hook.Add('PlayerAuthed', 'session::Create', function(pl)
        if IsValid(pl) then
            pl:SetNetVar('SessionStart', CurTime())
        end
    end)
end