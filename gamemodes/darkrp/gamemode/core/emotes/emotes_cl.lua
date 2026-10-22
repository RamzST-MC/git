local a = {}
local function b()
    hook.Remove('PostDrawTranslucentRenderables', 'rp.emotes.Draw')
end

local function c()
    hook('PostDrawTranslucentRenderables', 'rp.emotes.Draw', function()
        local d = 1
        for e = 1, #a do
            local f = a[d]
            local g = f.Emote
            local h = f.Player
            local i = f.Data
            local j = not IsValid(h) or SysTime() >= i.StartTime + g.Lifetime or g.ShouldEnd ~= nil and g:ShouldEnd(h, i)
            if j then
                if g.OnEnd ~= nil then g:OnEnd(h, i) end
                table.remove(a, d)
                if #a == 0 then
                    b()
                    break
                end

                continue
            end

            d = d + 1
            g:Draw(h, i)
        end
    end)
end

net('rp.emote.Start', function(k)
    local h = net.ReadPlayer()
    local l = net.ReadUInt(8)
    if not IsValid(h) then return end
    local g = rp.emotes.GetByID(l)
    local i = {
        StartTime = SysTime()
    }

    if g.OnStart ~= nil then g:OnStart(h, i) end
    a[#a + 1] = {
        Emote = g,
        Player = h,
        Data = i
    }

    if #a == 1 then c() end
end)

hook('EntityEmitSound', 'rp.emotes.MuteEntitySound', function(i)
    if i.SoundName == 'common/null.wav' then return false end
    if i.Entity.EmoteMuteSound then return false end
end)