ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.PrintName = 'Money Printer'
ENT.Category = 'RP Printing Devices'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.CanCarry = true
ENT.MaxHealth = 100
function ENT:SetupDataTables()
    self:NetworkVar('Entity', 1, 'owning_ent')
    self:NetworkVar('Int', 1, 'Ink')
    self:NetworkVar('Int', 2, 'MaxInk')
    self:NetworkVar('Int', 3, 'LastPrint')
    self:NetworkVar('Int', 4, 'DestructionTime')
    self:NetworkVar('Int', 5, 'SpawnTime')
    self:NetworkVar('Bool', 1, 'IsDestructing')
end

function ENT:GetRepairPrice()
    return (self.MaxHealth - self:Health()) * rp.cfg.PrinterHPCost
end

function ENT:GetInkPrice()
    return (self:GetMaxInk() - self:GetInk()) * rp.cfg.InkCost
end

function ENT:IsCancelingDestruction()
    return not self:GetIsDestructing() and self:GetDestructionTime() > CurTime()
end

local a = 60 * 60 * 12
function ENT:GetBoostPercentage()
    local b = CurTime() - self:GetSpawnTime()
    return math.min(b / a, 1)
end

function ENT:GetBoostPayout()
    return math.floor(rp.cfg.PrintAmount * self:GetBoostPercentage())
end

function ENT:GetPrintAmount()
    local c = {
        Amount = rp.cfg.PrintAmount + self:GetBoostPayout()
    }

    hook.Call('calcPrintAmount', GAMEMODE, self, c)
    return c.Amount
end

function ENT:IsInPD()
    local d = self:GetParent()
    return IsValid(d) and d:GetClass() == 'evidence_rack'
end

function ENT:InRack()
    return IsValid(self:GetParent()) and self:GetParent():GetClass() == 'money_printer_rack_base' or false
end