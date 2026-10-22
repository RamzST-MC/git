dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSubMaterial(2, 'sup/entities/fiftyfifty/light')
	self:SetSubMaterial(6, 'sup/entities/fiftyfifty/ad_top')
	self:SetSubMaterial(7, 'sup/entities/fiftyfifty/background')
	self:SetSubMaterial(16, 'sup/entities/fiftyfifty/ad_bottom')
end

function ENT:Use(activator, caller)
	if not IsValid(self.ItemOwner) then
		return
	end
	if CurTime() >= activator:GetNWInt("Oxladis",CurTime()) then
	if self.ItemOwner == activator then
		net.Start("rp.CasinoOwner")
			net.WriteEntity(self)
		net.Send(activator)
	else
		if !self:GetInService() or self:GetIsPayingOut() then return end
		if !activator:CanAfford(self:Getprice()) then rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете позволить себе играть в этот автомат') return end
		if !self.ItemOwner:CanAfford(self:Getprice() * 2) then
			rp.Notify(activator, NOTIFY_ERROR, 'Владелец этой машины больше не может позволить себе ее эксплуатацию. Теперь она не работает.')
			rp.Notify(self.ItemOwner, NOTIFY_ERROR, 'Вы банкрот! Теперь она не работает')
			self:SetInService(false)
			return
		end
		activator:SetNWInt("Oxladis",CurTime()+1)
		self:SetIsPayingOut(true)
		activator:TakeMoney(self:Getprice())
		self.ItemOwner:AddMoney(self:Getprice())
		timer.Simple(.1,function()
			self:SetPlayerRoll(math.random(1,100))
			self:SetHouseRoll(math.random(1,100))
			if self:GetPlayerRoll() > self:GetHouseRoll() then
				self.ItemOwner:TakeMoney(self:Getprice() * 2)
				activator:AddMoney(self:Getprice() * 2)
				rp.Notify(activator, NOTIFY_SUCCESS, "Вы выиграли "..rp.FormatMoney(self:Getprice()*2)..", играя в Fifty Fifty!")
				rp.Notify(self.ItemOwner, NOTIFY_ERROR, 'В вашем казино 50/50 выиграли и вы потеряли '..rp.FormatMoney(self:Getprice()))
				self.ItemOwner:SetNetVar('GamblingUbitok', self.ItemOwner:GetUbitok() + self:Getprice())
			elseif self:GetPlayerRoll() < self:GetHouseRoll() then
				rp.Notify(activator, NOTIFY_ERROR, "Вы проиграли "..rp.FormatMoney(self:Getprice())..", играя в Fifty Fifty!")
				rp.Notify(self.ItemOwner, NOTIFY_SUCCESS, 'В вашем казино 50/50 проиграли и вы получили '..rp.FormatMoney(self:Getprice()))
				self.ItemOwner:SetNetVar('GamblingZarobotok', self.ItemOwner:GetZarobotok() + self:Getprice())
				hook.Run("CasinoOwnerWin", self.ItemOwner, self:Getprice())
			else
				rp.Notify(activator, NOTIFY_GENERIC, "Ничья!")
			end
			self:SetIsPayingOut(false)
		end)
	end
else
	-- activator:ChatPrint("У вас кулдаун "..math.Round(activator:GetNWInt("Oxladis",CurTime())-CurTime()).." сек.")
end
end