dash.IncludeSH'shared.lua'

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PressE = true

local a = Material'sup/printer/ink-cartridge-refill.png'
local b = Material'sup/printer/health-care.png'
local c = Material'sup/printer/printer.png'
local d = Material'sup/gui/generic/money.png'
local e = ui.col.White:Copy()
local f = ui.col.FlatBlack:Copy()
local g = Color(0, 0, 0, 255)

function rp.DrawPrinterBar(h, i, j, k, l, m, n)
    g:LerpFromTo(l, ui.col.Red, ui.col.Green)
    draw.RoundedBoxEx(25, h, i, k, k, ui.col.Black, true, false, true, false)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(m)
    local o = k - 50
    surface.DrawTexturedRect(h + 25, i + 25, o, o)
    h = h + k
    j = j - k
    draw.RoundedBoxEx(25, h, i, math.Clamp(j * l, 3, j), k, g, false, true, false, true)
    draw.RoundedBoxEx(25, h, i, j, k, ui.col.Background, false, true, false, true)
    draw.SimpleText(n or math.floor(l * 100) .. '%', '3d2d', h + j * 0.5, i + k * 0.5, e, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

ENT.Draw = ENTITY.DrawModel
local h, i, j, k = -475, 634, 2081, 458
function ENT:DrawTranslucent()
    local t = self:GetPos()
    local u = self:GetAngles()
    local v, w = self:InDistance(125000)
    if not v then return end
    e.a = 255 - w / 500
    u:RotateAroundAxis(u:Up(), 90)
    u:RotateAroundAxis(u:Forward(), 39.6)
    cam.Start3D2D(t + u:Up() * 24.99, u, 0.01)
    draw.Box(h, i, j, k, f)
    if self:GetIsDestructing() then
        draw.Box(h, i, j, k, CurTime() % 2 < 1 and ui.col.DarkRed or f)
        draw.SimpleText('Самоуничтожение: ' .. string.FormattedTime(self:GetDestructionTime() - CurTime(), '%02i:%02i'), '3d2d', h + j * 0.5, i + k * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    elseif self:GetDestructionTime() > CurTime() then
        draw.SimpleText('Отмена самоуничтожения: ' .. string.FormattedTime(self:GetDestructionTime() - CurTime(), '%02i:%02i'), '3d2d', h + j * 0.5, i + k * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        local x = 25
        local y, z = h + x, i + k * 0.3
        local A, B = (j - x * 4) / 3, k * 0.3
        local C, D = h + j * 0.5, i + k * 0.15 - x * 0.5
        local E = self:Getowning_ent()
        if self:IsInPD() then
            draw.SimpleText('Confiscated Printer', '3d2d', C, D, e, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif IsValid(E) then
            local F, G = draw.SimpleText(E:Name(), '3d2d', C, D, e, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if E:GetOrg() ~= nil then
                local m = rp.orgs.GetBanner(E:GetOrg())
                if m ~= nil then
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(m)
                    local o = k * 0.3 - x * 2
                    surface.DrawTexturedRect(C - 20 - o - F / 2, D - o * .5, o, o)
                end
            end
        else
            draw.SimpleText('Unknown', '3d2d', C, D, e, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        rp.DrawPrinterBar(y, z, A, B, self:GetInk() / self:GetMaxInk(), a, self:GetInk() .. '/' .. self:GetMaxInk())
        y = y + A + x
        rp.DrawPrinterBar(y, z, A, B, self:Health() / 100, b)
        y = y + A + x
        rp.DrawPrinterBar(y, z, A, B, (CurTime() - self:GetLastPrint()) / rp.cfg.PrintDelay, c)
        rp.DrawPrinterBar(h + x, i + k * 0.6 + x, j - x * 2, B, self:GetBoostPercentage(), d, string.FormatUSD(self:GetPrintAmount()))
    end

    cam.End3D2D()
end

local function H(I)
    return not I:GetIsDestructing() or not I:IsCancelingDestruction()
end

local J = {
    Buttons = {
        {
            GetText = function(I) return 'Починить: ' .. string.FormatUSD(I:GetRepairPrice()) end,
            DoClick = function(I) net.Ping'rp.moneyprinter.Repair' end,
            CanUse = function(I) return H(I) and I:GetRepairPrice() > 0 end
        },
        {
            GetText = function(I) return 'Перезарядить: ' .. string.FormatUSD(I:GetInkPrice()) end,
            DoClick = function(I) net.Ping'rp.moneyprinter.Refill' end,
            CanUse = function(I) return H(I) and I:GetInkPrice() > 0 end
        },
        {
            Name = 'Начать самоуничтожение',
            DoClick = function(I) net.Ping'rp.moneyprinter.Destruct' end,
            CanUse = function(I) return not I:GetIsDestructing() and not I:IsCancelingDestruction() end
        },
        {
            Name = 'Остановить самоуничтожение',
            DoClick = function(I) net.Ping'rp.moneyprinter.Destruct' end,
            CanUse = function(I) return I:GetIsDestructing() and not I:IsCancelingDestruction() end
        }
    }
}

function ENT:PlayerUse()
    if IsValid(self.Menu) then
        self.Menu:Remove()
        return
    end

    self.Menu = ui.Create'rp_interactions_menu'
    self.Menu.OnUpdateTransform = function(o, t, u)
        if not o.IsThirdPerson then t.z = t.z + 25 end
        return t, u
    end

    self.Menu:SetOptions(J)
    self.Menu:SetEntity(self)
end

net.Receive('rp::use::printer', function()
    local ent = net.ReadEntity()

    ent:PlayerUse()
end)