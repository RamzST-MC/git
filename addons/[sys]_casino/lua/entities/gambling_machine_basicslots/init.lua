dash.IncludeCL 'cl_init.lua'
dash.IncludeSH 'shared.lua'

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSubMaterial(2, 'sup/entities/basicslots/light')
	self:SetSubMaterial(6, 'sup/entities/basicslots/ad_top')
	self:SetSubMaterial(7, 'sup/entities/basicslots/background')
	self:SetSubMaterial(16, 'sup/entities/basicslots/ad_bottom')
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
			if !self.ItemOwner:CanAfford(self:Getprice() * 10) then
				rp.Notify(activator, NOTIFY_ERROR, 'Владелец этой машины больше не может позволить себе ее эксплуатацию. Теперь она не работает.')
				rp.Notify(self.ItemOwner, NOTIFY_ERROR, 'Вы банкрот! Теперь она не работает')
				self:SetInService(false)
				return
			end
			self:SetIsPayingOut(true)
			timer.Simple(.1,function()
				self:SetRoll1(math.random(0,9))
				self:SetRoll2(math.random(0,9))
				self:SetRoll3(math.random(0,9))
				local roll1 = self:GetRoll1()
				local roll2 = self:GetRoll2()
				local roll3 = self:GetRoll3()
				if roll1 == roll2 and roll1 == roll3 then
					self.ItemOwner:TakeMoney(self:Getprice() * 10)
					activator:AddMoney(self:Getprice() * 10)
					rp.Notify(activator, NOTIFY_SUCCESS, 'Вы выиграли '..rp.FormatMoney(self:Getprice() * 10)..', играя в слоты!')
					rp.Notify(self.ItemOwner, NOTIFY_SUCCESS, 'В вашем казино "Слоты удачи" выиграли и вы отдали '..rp.FormatMoney(self:Getprice()*10))
					self.ItemOwner:SetNetVar('GamblingUbitok', self.ItemOwner:GetUbitok() + self:Getprice()*10)
					activator:SetNWInt("Oxladis",CurTime()+1)
				elseif roll1 == roll2 or roll2 == roll3 then
					self.ItemOwner:TakeMoney(self:Getprice() * 4)
					activator:AddMoney(self:Getprice() * 4)
					rp.Notify(activator, NOTIFY_SUCCESS, 'Вы выиграли '..rp.FormatMoney(self:Getprice() * 4)..', играя в слоты!')
					rp.Notify(self.ItemOwner, NOTIFY_SUCCESS, 'В вашем казино "Слоты удачи" выиграли и вы отдали '..rp.FormatMoney(self:Getprice()*4))
					self.ItemOwner:SetNetVar('GamblingUbitok', self.ItemOwner:GetUbitok() + self:Getprice()*4)
					activator:SetNWInt("Oxladis",CurTime()+1)
				else
					activator:TakeMoney(self:Getprice())
					self.ItemOwner:AddMoney(self:Getprice())
					rp.Notify(activator, NOTIFY_ERROR, 'Вы проиграли '..rp.FormatMoney(self:Getprice())..', играя в слоты!')
					rp.Notify(self.ItemOwner, NOTIFY_SUCCESS, 'В вашем казино "Слоты удачи" проиграли и вы получили '..rp.FormatMoney(self:Getprice()))
					self.ItemOwner:SetNetVar('GamblingZarobotok', self.ItemOwner:GetZarobotok() + self:Getprice())
					hook.Run("CasinoOwnerWin", self.ItemOwner, self:Getprice())
					activator:SetNWInt("Oxladis",CurTime()+1)
				end
			self:SetIsPayingOut(false)
		end)
	end
else
	-- activator:ChatPrint("У вас кулдаун "..math.Round(activator:GetNWInt("Oxladis",CurTime())-CurTime()).." сек.")
end
end