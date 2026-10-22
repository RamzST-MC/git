dash.IncludeSH 'shared.lua'

local mat_faceID = Material('divergent/entities/keypads/bioscanner_faceid.png', 'smooth')
local mat_locked = Material('sup/gui/generic/locked.png', 'smooth')
local mat_unlocked = Material('sup/gui/generic/unlocked.png', 'smooth')

local lookEnt, fr, ent
function ENT:Draw()
	self.BaseClass.Draw(self)

	local distance = LocalPlayer():EyePos():DistToSqr(self:GetPos())
	if (distance > 562500) then return end

	local pos = self:GetPos() + (self:GetUp() * .85) + (self:GetRight() * 4)
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)

	cam.Start3D2D(pos, ang, 0.05)
		local x, y, w, h = 0, -100, 160, 210

		local oX = 10
		if IsValid(self.Owner) and self.Owner:IsPlayer() and (self:GetOrg() ~= nil) and (self:GetOrg() ~= '') then
			local banner = rp.orgs.GetBanner(self.Owner:GetOrg())
			if banner then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(banner)
				surface.DrawTexturedRect(x + oX - 2.5, y + 0, 32, 32)
				oX = oX + 37
			end
		end

		local status = self:GetStatus()

		if (status == 1) then -- unlocked
			surface.SetDrawColor(25, 225, 25, 255)
			surface.SetMaterial(mat_unlocked)
			surface.DrawTexturedRect(x + (w * 0.5) - 96 / 2, y + (h * 0.5) - 96 / 2, 96, 96)
		elseif (status == 2) then -- locked & denied
			surface.SetDrawColor(225, 25, 25, 255)
			surface.SetMaterial(mat_locked)
			surface.DrawTexturedRect(x + (w * 0.5) - 96 / 2, y + (h * 0.5) - 96 / 2, 96, 96)
		else -- locked
			if lookEnt and (lookEnt == self) then
				surface.SetMaterial(mat_faceID)
				surface.SetDrawColor(255, 255, 255, (SysTime() % .5) >= .25 and 255 or 0)
				surface.DrawTexturedRect(x + (w * 0.5) - 96 / 2, y + (h * 0.5) - 96 / 2, 96, 96)
			else
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(mat_locked)
				surface.DrawTexturedRect(x + (w * 0.5) - 96 / 2, y + (h * 0.5) - 96 / 2, 96, 96)
			end
		end

	cam.End3D2D()
end

function ENT:Initialize()
	self.LookTime = 0
end

function ENT:Think()
	self:UpdateLever()

	self.LookTime = self.LookTime or 0

	local wep = LocalPlayer():GetActiveWeapon()
	if lookEnt and (lookEnt == self) and (not self:IsBusy()) and (not IsValid(fr)) and ((not IsValid(wep)) or (wep:GetClass() ~= 'keypad_cracker') or (not wep.IsCracking)) then
		self.LookTime = self.LookTime + FrameTime()

		if (self.LookTime >= 1) then
			net.Start('rp.biometric.Unlock')
				net.WriteEntity(self)
			net.SendToServer()

			self.LookTime = -5
		end
	elseif (self.LookTime ~= 0) then
		self.LookTime = math.Approach(self.LookTime, 0, FrameTime())
	end
end

function ENT:UpdateLever()
	self.PosePosition = self.PosePosition or 0

	self.PosePosition = math.Approach(self.PosePosition, self:IsBusy() and 1 or 0, 0.1)

	self:SetPoseParameter('switch', self.PosePosition)
	self:InvalidateBoneCache()
end

function ENT:ReadPlayerUse()
	
end

local padOptions = {
	{
		Name 	= 'Добавить Игрока',
		Check 	= function()
			return (player.GetCount() > 1)
		end,
		DoClick = function()
			fr:Close()
			local no = table.Filter(player.GetAll(), function(v) return !table.HasValue(ent.AllowedPlayers, v) end)
			ui.PlayerRequest(no, function(pl)
				net.Start 'rp.biometric.Player'
					net.WriteEntity(ent)
					net.WriteBit(true)
					net.WritePlayer(pl)
				net.SendToServer()
			end)
		end
	},
		{
		Name 	= 'Удалить Игрока',
		Check 	= function()
			return (#ent.AllowedPlayers > 0)
		end,
		DoClick = function()
			fr:Close()
			-- print(ent.AllowedPlayers)
			ui.PlayerRequest(ent.AllowedPlayers, function(pl)
				net.Start 'rp.biometric.Player'
					net.WriteEntity(ent)
					net.WriteBit(false)
					net.WritePlayer(pl)
				net.SendToServer()
			end)
		end,
	},
	{
		Name 	= 'Добавить/Удалить Организацию',
		Check 	= function()
			return (LocalPlayer():GetOrg() != nil)
		end,
		DoClick = function()
			fr:Close()
			net.Start 'rp.biometric.ToggleOrg'
				net.WriteEntity(ent)
				net.WriteBool(LocalPlayer():GetOrg() != nil)
			net.SendToServer()
		end,
	},
	{
		Name 	= 'Добавить/Удалить пати',
		Check 	= function()
			return (LocalPlayer():InParty())
		end,
		DoClick = function()
			fr:Close()

			net.Start 'rp.biometric.ToggleParty'
			net.WriteEntity(ent)
			net.WriteBool(LocalPlayer():GetParty() != nil)
			net.SendToServer()
		end,
	},
	{
		Name 	= 'Общий доступ к сканеру',
		Check 	= function()
			return false
		end,
		DoClick = function()
			fr:Close()

			net.Start 'rp.biometric.ToggleAccess'
			net.WriteEntity(ent)
			net.SendToServer()
		end,
	},
	{
		Name 	= 'Скопировать для всех сканеров',
		DoClick = function()
			fr:Close()

			net.Start 'rp.biometric.ApplyAll'
				net.WriteEntity(ent)
			net.SendToServer()
		end,
	},
}

local font17 = 'ui.17'

function ENT:PlayerUse()
	if IsValid(fr) then fr:Close() end

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('')
		self:SetSize(ScrW() * 0.125, 100)
		self:Center()
		self:MakePopup()
		self.Think = function(self)
			if (not IsValid(ent)) then
				fr:Close()
			end
		end
	end)

	fr.PaintOver = function(self, w, h)
		draw.SimpleText("Настройки Сканера", font17, 5, 5, color_white)
	end

	ent = self

	local count = -1
    local x, y = 5, 35
    local spasing = 5

	for k, v in ipairs(padOptions) do
        if (v.Check == nil) or (v.Check(ent) == true) then
            count = count + 1
            fr:SetSize(ScrW() * 0.155, ((count + 1) * (30 + spasing)) + (y + 7))
            fr:Center()

            local btn = vgui.Create('ui_button', fr)
            btn:SetPos(x, (count * (30 + spasing)) + y)
            btn:SetSize(ScrW() * 0.155 - 10, 30)
            btn:SetText(v.Name)

            btn.DoClick = function()
                v.DoClick(v)
                fr:Close()
            end
        end
    end

	return fr
end

net.Receive('rp.menu.pad', function()
	local ent = net.ReadEntity()
	
	ent.AllowedPlayers 	= net.ReadTable()

	ent:PlayerUse()
end)

local traceBase = {}
hook.Add('Think', 'rp.biometric.Think', function()
	local LP = LocalPlayer()
	if IsValid(LP) then
		traceBase.start = LP:GetShootPos()
		traceBase.endpos = LP:GetAimVector() * 32 + traceBase.start
		traceBase.filter = LP
		local tr = util.TraceLine(traceBase)

		lookEnt = tr.Entity
	end
end)