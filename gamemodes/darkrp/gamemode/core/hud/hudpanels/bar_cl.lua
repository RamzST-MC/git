local PANEL = {}



function PANEL:IconBox(dock)

	local pnl = self:Add 'rp_hud_iconbox'

	pnl:DockMargin(5, 0, 0, 0)

	pnl:Dock(dock or LEFT)



	return pnl

end



function PANEL:Init()
	self:SetPos(0, ScrH()-34-5)
	self:SetSize(ScrW() - 5, 34)
end



function PANEL:Paint(w, h)
--	draw.Box(0, 0, w, h, ui.col.Background)

end



function PANEL:PerformLayout(w, h)



end



vgui.Register('rp_hud_bar', PANEL, 'Panel')

local PANEL = {}


function PANEL:IconBox(dock)

	local pnl = self:Add 'rp_hud_iconbox'

	pnl:DockMargin(5, 0, 0, 0)

	pnl:Dock(dock or LEFT)



	return pnl

end

function PANEL:Init()

	self:SetPos(0, 5)

	self:SetSize(ScrW() - 5, 34)

	local function makeTimer(name, timerEnd)

		local timerBox = self:IconBox(RIGHT)

		timerBox:SetColor(Color(150, 72, 0))

		timerBox:SetMaterial('sup/gui/hud/timer.png')

		function timerBox:ShouldDraw()

			local shouldDraw = timerEnd > CurTime()



			if (not shouldDraw) then

				rp.hud.Timers[name] = nil

				self:Remove()

			end



			return shouldDraw

		end

		function timerBox:GetString()

			return name .. ': ' .. string.FormattedTime(math.ceil(timerEnd - CurTime()), '%02i:%02i')

		end



		rp.hud.Timers[name] = {

			End = timerEnd,

			Box = timerBox

		}

	end



	net('rp.timer.Modify', function()

		local name = net.ReadString()



		local tab = rp.hud.Timers[name]



		if tab and IsValid(tab.Box) then

			tab.Box:Remove()

			rp.hud.Timers[name] = nil

		end



		if net.ReadBool() then

			makeTimer(name, CurTime() + net.ReadUInt(32))

		end

	end)





	for k, v in pairs(rp.hud.Timers) do

		makeTimer(k, v.End)

	end





	self.RadioChannel = self:IconBox(RIGHT)

	self.RadioChannel:SetColor(Color(15, 15, 15))

	self.RadioChannel:SetMaterial('sup/gui/hud/radio.png')

	function self.RadioChannel:ShouldDraw()

		return LocalPlayer():GetNetVar('RadioChannel') ~= nil

	end

	function self.RadioChannel:GetString()

		return LocalPlayer():GetNetVar('RadioChannel')

	end



	self.Employer = self:IconBox(RIGHT)

	self.Employer:SetColor(Color(42, 22, 116))

	self.Employer:SetMaterial('sup/gui/hud/employer.png')

	function self.Employer:ShouldDraw()

		return IsValid(LocalPlayer():GetNetVar('Employer'))

	end



	self.Employee = self:IconBox(RIGHT)

	self.Employee:SetColor(Color(42, 22, 116))

	self.Employee:SetMaterial('sup/gui/hud/employee.png')

	function self.Employee:ShouldDraw()

		return LocalPlayer():GetNetVar('Employees') ~= nil

	end




	local txt = ''

	local drawAcievement = false

	self.Achievement = self:IconBox(RIGHT)

	self.Achievement:SetColor(ui.col.SUP)

	self.Achievement:SetMaterial('sup/gui/hud/achievement.png')

	function self.Achievement:GetString()

		return txt // todo: make settext work

	end

	function self.Achievement:ShouldDraw()

		if drawAcievement then

			self.ColorPrimary.g = 200 * math.sin(RealTime() * 3)

			self.ColorSecondary.r = self.ColorPrimary.r

		end



		return drawAcievement

	end
end

vgui.Register('rp_hud_bar_right', PANEL, 'Panel')