nw.Register('IsBanned', {
    Read     = net.ReadBool,
    Write    = net.WriteBool,
    LocalVar = true
})

nw.Register('ReasonBan', {
    Read = net.ReadString,
    Write = net.WriteString,
    LocalVar = true
})

nw.Register('AdminBan', {
    Read = net.ReadString,
    Write = net.WriteString,
    LocalVar = true
})

nw.Register('AdminSteamID', {
    Read = net.ReadString,
    Write = net.WriteString,
    LocalVar = true
})

nw.Register('TimeBanned', {
    Read = net.ReadUInt,
    Write = net.WriteUInt,
    LocalVar = true
})

function PLAYER:IsBanned()
	return (self:GetNetVar('IsBanned') == true)
end

function PLAYER:GetBanTime()
    if self:IsBanned() then
        if self:GetNetVar('TimeBanned') == "0" then
            return 'Никогда'
        else
            return os.date('%m/%d/%y - %H:%M', self:GetNetVar("TimeBanned"))
        end
    end
end

function PLAYER:GetBanReason()
    if self:IsBanned() then
        if self:GetNetVar("ReasonBan") != nil then
            return self:GetNetVar("ReasonBan")
        else
            return 'Не Указана!'
        end
    end
end

function PLAYER:GetBanAdmin()
    if self:IsBanned() then
        if self:GetNetVar("AdminSteamID") != nil then
            return self:GetNetVar("AdminBan") .. ' ('.. util.SteamIDFrom64(self:GetNetVar("AdminSteamID")) ..')'
        else
            return self:GetNetVar("AdminBan")
        end
    end
end