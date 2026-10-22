AddCSLuaFile("cl_init.lua")
AddCSLuaFile("Shared.lua")
include("Shared.lua")
util.AddNetworkString("ActiveP")
util.AddNetworkString("withdrawp")
util.AddNetworkString("RechargeP")
util.AddNetworkString("UpgradeP")
util.AddNetworkString("Togglep")
util.AddNetworkString("ColorP")
util.AddNetworkString("CoolingP")
util.AddNetworkString('rp.Destruct')
include("autorun/server/Settings.lua")

ENT.SeizeReward = 5000
ENT.WantReason = 'Манипринтеры'
local config = DermaConfig
function ENT:Initialize()
	--activator check varaible--
	self:SetActivator(nil)
	
	--configuration area--
	self:Setlvl2price(config.Setlvl2price)--lvl2 price
	self:Setlvl3price(config.Setlvl3price)--lvl3 price
	self:Setlvl4price(config.Setlvl4price)--lvl4 price
	self:SetRechargeprice(config.Rechargeprice)--Recharge price
	self:SetCooling1price(config.Cooling1)--Cooling upgrade 1 price
	self:SetCooling2price(config.Cooling2)--Cooling upgrade 2 price
	self:SetCooling3price(config.Cooling3)--Cooling upgrade 3 price
	
	--Non Config Area--
	self:SetMainColorR(205)
	self:SetMainColorG(205)
	self:SetMainColorB(205)
	
	self:SetBgColorR(255)
	self:SetBgColorG(255)
	self:SetBgColorB(255)
	
	self:SetTempRate(config.TempRate)
	self:SetDestroyed(false)
	self:SetPTemp(config.InitTemp)
	self:SetUpgradelvl(1)
	self:Settoggle(true)
	self:SetCoolinglvl(1)
	self:SetCharge(config.InitCharge)
	
	self:SetUseType(SIMPLE_USE)
	self:SetModel("models/eclipse_custom/printer.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	
	self.PrinterHealth = config.PrinterHealth 
	self.timer = CurTime()
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end

	self:Settoggle(false)
end

function ENT:OnRemove()

end

function ENT:OnTakeDamage(dmg)
	if self:GetIsProtected() then return end

	self:TakePhysicsDamage(dmg)
	if(self.PrinterHealth <= 0) then return end
 
	self.PrinterHealth = self.PrinterHealth - dmg:GetDamage(); 
 
	if(self.PrinterHealth <= 0) then
		self:SetDestroyed(true)
		self:Destruct()
		self:Remove() 
	end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
    if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), 1, 4, "Ваш мани принтер взорвался!") end

	self:SetDestroyed(true)
	self:Remove()
end

function ENT:Think()
	if CurTime() > self.timer + 2 then
		self.timer = CurTime()
		if self:Gettoggle() == true then
			if  self:GetCharge() > 0 then
				
				--changing values such as money and temperature--
				self:SetPTemp(self:GetPTemp() + self:GetTempRate())
				self:SetMoney(self:GetMoney() + config.MoneyBaseVal * self:GetUpgradelvl())
				self:SetCharge(self:GetCharge() - 0.72/2)
				
				--temperature limit check--
				if self:GetPTemp() > config.FireTemp then
					self:SetDestroyed(true)
					self:Ignite( 30 )

					timer.Simple(5, function()
						if IsValid(self) then
							self:SetDestroyed(true)
							self:Destruct()
							self:Remove()
						end
					end)
				end
				
				if self:GetPTemp() > config.DestructTemp then
					self:Destruct()	
					self:Remove()
				end
				
			else
				
				--turns off if charge is 0 or less--
				self:Settoggle(false)
				
			end
		else
			
			--caculation issue correction lol--
			if self:GetPTemp() > 25 then
				self:SetPTemp(self:GetPTemp() - 1)
			end
			
		end
	end
	
	
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		net.Start("ActiveP")
		net.WriteEntity(self)
		net.Send(activator)
		
		self:SetActivator(activator)
	end
end

net.Receive("withdrawp", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			local amount = pri:GetMoney()
			if amount <= 0 then return end
			ply:addMoney(amount)
			DarkRP.notify(ply, 0, 4, "Ты получил $"..amount.." из принтера!")
			pri:SetMoney(0)
		end
	end
end)

--Recharge button pressed--
net.Receive("RechargeP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			if ply:canAfford(pri:GetRechargeprice()) == true then
				ply:addMoney(-pri:GetRechargeprice())
				pri:SetCharge(180)
				DarkRP.notify(ply, 0, 4, "Ваш принтер перезаряжен!")
			else
				DarkRP.notify(ply, 0, 4, "Вы не можете себе этого позволить!")
			end
		end
	end
end)

--upgrade button pressed--
net.Receive("UpgradeP", function(len, ply)

	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			if	pri:GetUpgradelvl() == 3 then
				if ply:canAfford(pri:Getlvl4price()) == true then
					ply:addMoney(-pri:Getlvl4price())
					pri:SetUpgradelvl(4)
					DarkRP.notify(ply, 0, 4, "Printer upgraded to lvl4!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
			if	pri:GetUpgradelvl() == 2 then
				if ply:canAfford(pri:Getlvl3price()) == true then
					ply:addMoney(-pri:Getlvl3price())
					pri:SetUpgradelvl(3)
					DarkRP.notify(ply, 0, 4, "Printer upgraded to lvl3!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
			if  pri:GetUpgradelvl() == 1 then
				if ply:canAfford(pri:Getlvl2price()) == true then
					ply:addMoney(-pri:Getlvl2price())
					pri:SetUpgradelvl(2)
					DarkRP.notify(ply, 0, 4, "Printer upgraded to lvl2!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
		end
	end
end)

--on/off button pressed--
net.Receive("Togglep", function(len, ply)
	pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			if pri:Gettoggle() == true then
				pri:Settoggle(false)
			else
				pri:Settoggle(true)
			end
		end
	end
end)

--printer color button pressed--
net.Receive("ColorP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			local color = net.ReadColor()
			pri:SetColor(color)
			DarkRP.notify(ply, 0, 4, "Color Successfully Changed!")
		end
	end
end)

--cooling upgrade button pressed--
net.Receive("CoolingP", function(len, ply)
local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if(ply:GetPos():Distance(pri:GetPos()) < 100) then
			if	pri:GetCoolinglvl() == 3 then
				if ply:canAfford(pri:GetCooling3price()) == true then
					ply:addMoney(-pri:GetCooling3price())
					pri:SetCoolinglvl(4)
					pri:SetTempRate(0)
					pri:SetPTemp(24)
					DarkRP.notify(ply, 0, 4, "Cooling upgraded to lvl4!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
			if	pri:GetCoolinglvl() == 2 then
				if ply:canAfford(pri:GetCooling2price()) == true then
					ply:addMoney(-pri:GetCooling2price())
					pri:SetCoolinglvl(3)
					pri:SetTempRate(0.24)
					DarkRP.notify(ply, 0, 4, "Cooling upgraded to lvl3!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
			if  pri:GetCoolinglvl() == 1 then
				if ply:canAfford(pri:GetCooling1price()) == true then
					ply:addMoney(-pri:GetCooling1price())
					pri:SetCoolinglvl(2)
					pri:SetTempRate(0.32)
					DarkRP.notify(ply, 0, 4, "Cooling upgraded to lvl2!")
				else
					DarkRP.notify(ply, 0, 4, "You cannot afford that!")
				end
			end
		end
	end
end)

net.Receive('rp.Destruct', function(len, pl)
    local ent = net.ReadEntity()
    if not IsValid(ent) or not ent:IsPrinter() or pl:GetPos():Distance(ent:GetPos()) > 200 then return end

    if ent:GetIsProtected() then
        ent:SetIsProtected(false)
		pl:Notify(NOTIFY_SUCCESS, 'Вы выключили защиту принтера!')
    else
        ent:SetIsProtected(true)
		pl:Notify(NOTIFY_SUCCESS, 'Вы включили защиту принтера!')
    end
end)

function ENT:IsPrinter()
    return true
end