-- "addons\\cosmic\\lua\\dash\\libraries\\keybind.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
keybind = keybind or setmetatable({
    GetTable = setmetatable({}, {
        __call = function(self) return self end
    })
}, {
    __call = function(self, a, b) return self.Add(a, b) end
})

local BINDER = {
    __tostring = function(self) return self.Name end,
    __eq = function(a, b) return getmetatable(a) == BINDER and getmetatable(b) == BINDER and a.Name == b.Name end
}

BINDER.__index = BINDER
BINDER.__concat = BINDER.__tostring
debug.getregistry().Keybind = BINDER

function BINDER:SetName(name)
    if self.Name then
        keybind.GetTable[self.Name] = nil
    end

    keybind.GetTable[name] = self
    self.Name = name

    return self
end

function BINDER:GetName()
    return self.Name
end

function BINDER:SetKey(key)
    self.Key = key

    return self
end

function BINDER:GetKey()
    return self.Key
end

function BINDER:SetCooldown(cd)
    self.Cooldown = cd

    return self
end

function BINDER:GetCooldown()
    return self.Cooldown
end

function BINDER:SetHelp(text)
    self.Help = text

    return self
end

function BINDER:GetHelp()
    return self.Help
end

function BINDER:SetClientCallback(func)
    self.ClientCallback = func

    return self
end

function BINDER:SetSharedCallback(func)
    self.SharedCallback = func

    return self
end

function BINDER:SetServerCallback(func)
    self.ServerCallback = func

    return self
end

function BINDER:SetCanRun(func)
    self.CanRunCallback = func

    return self
end

function BINDER:SetClientSide(bool)
    self.RunOnClient = bool
    self.RunOnServer = not bool

    return self
end

function BINDER:IsClientSide()
    return self.RunOnClient
end

function BINDER:SetShared(bool)
    self.RunOnClient = bool
    self.RunOnServer = bool

    return self
end

function BINDER:SetServer(bool)
    self.RunOnClient = not bool
    self.RunOnServer = bool

    return self
end

function BINDER:IsServerSide()
    return self.RunOnServer
end

function BINDER:Remove()
    keybind.GetTable[self:GetName()] = nil
end

function keybind.Add(name, key, func)
    func = func or function(self, pl)
        print(pl:Name() .. ' pressed ' .. key)
    end

    local bind = setmetatable({
        Key = key,
        Cooldown = 0.25,
        RunOnClient = false,
        RunOnServer = true,
        CanRunCallback = function(self, pl) return true end,
        ClientCallback = func,
        ServerCallback = func
    }, BINDER)

    bind:SetName(name)

    return bind
end

function keybind.Get(name)
    return keybind.GetTable[name]
end

function keybind.Exists(name)
    return keybind.GetTable[name] ~= nil
end

function keybind.Remove(name)
    keybind.GetTable[name] = nil
end

function PLAYER:SetKeybindCooldown(bind, cd)
    if not self.KeybindCooldowns then
        self.KeybindCooldowns = {}
    end

    self.KeybindCooldowns[bind:GetName()] = CurTime() + cd
end

function PLAYER:GetKeybindCooldown(bind)
    return self.KeybindCooldowns and self.KeybindCooldowns[bind:GetName()] or 0
end

if SERVER then
    util.AddNetworkString('keybind.Run')

    net.Receive('keybind.Run', function(_, pl)
        local bindName = net.ReadString()

        local bind = keybind.Get(bindName)
        if not bind then return end

        bind:ServerCallback(pl)
    end)
elseif CLIENT then
    hook('PlayerButtonDown', 'keybind.PlayerButtonDown', function(pl, key)
        if not IsFirstTimePredicted() then return end

        for k, bind in pairs(keybind.GetTable()) do
            if bind:GetKey() == key and pl:GetKeybindCooldown(bind) < CurTime() and bind:CanRunCallback(pl) then
                pl:SetKeybindCooldown(bind, bind:GetCooldown())

                if bind:IsServerSide() then
                    net.Start 'keybind.Run'
                        net.WriteString(bind:GetName())
                    net.SendToServer()
                end

                if bind:IsClientSide() then
                    bind:ClientCallback(k)
                end
            end
        end
    end)
end