AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.SeizeReward = 450
ENT.WantReason = 'Денежный принтер'

util.AddNetworkString('rp.moneyprinter.Repair')
util.AddNetworkString('rp.moneyprinter.Refill')
util.AddNetworkString('rp.moneyprinter.Destruct')
util.AddNetworkString('rp::use::printer')

function ENT:Initialize()
	self:SetModel('models/sup/printer/printer.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

	self:SetMaxInk(5)
    self:SetInk(self:GetMaxInk())
    self:SetSpawnTime(CurTime())
    self:SetLastPrint(CurTime())
    self:SetHealth(self.MaxHealth)
	self:SetSequence("Print_One_Bill")
end

function ENT:Use(pl)
    net.Start('rp::use::printer')
    net.WriteEntity(self)
    net.Send(pl)
end

function ENT:Think()
    if self:GetIsDestructing() and self:GetDestructionTime() <= CurTime() and not self:IsCancelingDestruction() then
        self:Explode()
        return
    end

    -- if self:GetIsDestructing() or self:IsCancelingDestruction() then return end

    if self:GetInk() <= 0 or self:IsInPD() then
        self:SetLastPrint(CurTime())
        self:NextThink(CurTime() + 1)
        return true
    end

    if CurTime() - self:GetLastPrint() >= rp.cfg.PrintDelay and (!self:GetIsDestructing() and !self:IsCancelingDestruction()) then
        self:PrintMoney(false)
        self:SetLastPrint(CurTime())
    end

    self:NextThink(CurTime() + 1)
    return true
end

function ENT:PrintMoney(bool)
    if self:GetInk() <= 0 then return end

    local am = self:GetPrintAmount()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect('Sparks', effectdata)

	local amount = (hook.Call('calcPrintAmount', GAMEMODE, am) or am)
	local money = rp.SpawnMoney(self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 42)), amount)
	if IsValid(money) then
		money.PrinterMoney = true
	end
    if !bool then
        self:AddInk(-1)
    end
    self:SetLastPrint(CurTime())
end

function ENT:AddInk(amount)
    self:SetInk(math.Clamp(self:GetInk() + amount, 0, self:GetMaxInk()))
end

function ENT:Explode()
    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    util.Effect('Explosion', effectdata)

    self:Remove()
end

net.Receive('rp.moneyprinter.Repair', function(len, pl)
    local ent = pl:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPrinter() or pl:GetPos():Distance(ent:GetPos()) > 200 then return end

    local cost = ent:GetRepairPrice()
    if cost <= 0 then return end
    if not pl:CanAfford(cost) then return end

	pl:TakeMoney(cost)
    ent:SetHealth(ent.MaxHealth)
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('PrinterRepaired'), rp.FormatMoney(cost))
end)

net.Receive('rp.moneyprinter.Refill', function(len, pl)
    local ent = pl:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPrinter() or pl:GetPos():Distance(ent:GetPos()) > 200 then return end

    local cost = ent:GetInkPrice()
    if cost <= 0 then return end
    if not pl:CanAfford(cost) then return end

    pl:TakeMoney(cost)
	ent:SetInk(ent:GetMaxInk())
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('PrinterRefilled'), rp.FormatMoney(cost))
end)

net.Receive('rp.moneyprinter.Destruct', function(len, pl)
    local ent = pl:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPrinter() or pl:GetPos():Distance(ent:GetPos()) > 200 then return end

    -- ent:Explode()
    if ent:GetIsDestructing() then
        ent:SetIsDestructing(false)
        ent:SetDestructionTime(CurTime() + 60)
    elseif ent:IsCancelingDestruction() then
        ent:SetIsDestructing(false)
        ent:SetDestructionTime(0)
    else
        ent:SetIsDestructing(true)
        ent:SetDestructionTime(CurTime() + 180)
    end
end)

function ENT:IsPrinter()
    return true
end