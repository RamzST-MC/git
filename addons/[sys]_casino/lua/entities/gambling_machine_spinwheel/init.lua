dash.IncludeCL'cl_init.lua'
dash.IncludeSH'shared.lua'
function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SetSubMaterial(2, 'sup/entities/spinwheel/light')
	self:SetSubMaterial(6, 'sup/entities/spinwheel/ad_top')
	self:SetSubMaterial(7, 'sup/entities/spinwheel/background')
	self:SetSubMaterial(16, 'sup/entities/spinwheel/ad_bottom')
end

local tablerandom = {
	[1] = -2,
	[2] = 2,
	[3] = -3,
	[4] = 3,
	[5] = -4,
	[6] = 4,
	[7] = -5,
	[8] = 5,
}

function ENT:Use(activator, caller)
	if not IsValid(self.ItemOwner) then return end
	if CurTime() >= activator:GetNWInt("Oxladis", CurTime()) then
		if self.ItemOwner == activator then
			net.Start("rp.CasinoOwner")
			net.WriteEntity(self)
			net.Send(activator)
		else
			if not self:GetInService() or self:GetIsPayingOut() then return end
			if not activator:CanAfford(self:Getprice() * 5) then
				rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете позволить себе играть в этот автомат')
				return
			end

			if not self.ItemOwner:CanAfford(self:Getprice() * 5) then
				rp.Notify(activator, NOTIFY_ERROR, 'Владелец этой машины больше не может позволить себе ее эксплуатацию. Теперь она не работает.')
				rp.Notify(self.ItemOwner, NOTIFY_ERROR, 'Вы банкрот! Теперь она не работает')
				self:SetInService(false)
				return
			end

			local gp = self:Getprice()
			self:SetIsPayingOut(true)
			activator:SetNWInt("Oxladis", CurTime() + 1)
			local rand = math.random(1, 8)
			self:SetRoll(rand)
			--timer.Simple(.3, function()
			local roll = tablerandom[self:GetRoll()]
			local win2, win3, win4 = roll < 0 and NOTIFY_ERROR or NOTIFY_SUCCESS, roll < 0 and 'Profit' or 'Loss', roll < 0 and roll * -1 or roll
			if win2 == NOTIFY_ERROR then
				rp.Notify(activator, win2, "Вы проиграли " .. rp.FormatMoney((gp * roll) * -1) .. ", играя в Spin Wheel!")
				rp.Notify(self.ItemOwner, NOTIFY_SUCCESS, 'В вашем казино "Колесо удачи" проиграли и вы получили ' .. rp.FormatMoney((gp * roll) * -1))

				self.ItemOwner:AddMoney((gp * roll) * -1)
				activator:TakeMoney((gp * roll) * -1)
				self.ItemOwner:SetNetVar('GamblingZarobotok', self.ItemOwner:GetZarobotok() + ((gp * roll) * -1))
			else
				rp.Notify(activator, win2, "Вы выиграли " .. rp.FormatMoney(gp * win4) .. ", играя в Spin Wheel!")
				rp.Notify(self.ItemOwner, NOTIFY_ERROR, 'В вашем казино "Колесо удачи" выиграли и вы потеряли ' .. rp.FormatMoney(gp * win4))

				self.ItemOwner:TakeMoney(gp * win4)
				activator:AddMoney(gp * win4)
				self.ItemOwner:SetNetVar('GamblingUbitok', self.ItemOwner:GetUbitok() + gp * win4)
			end

			self:SetIsPayingOut(false)
			--end)
		end
	else
		-- activator:ChatPrint("У вас кулдаун "..math.Round(activator:GetNWInt("Oxladis",CurTime())-CurTime()).." сек.")
	end
end