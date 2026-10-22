include 'shared.lua'

cvar.Register 'enable_pictureframes'
	:SetDefault(true)
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Отображение Картин')

function ENT:RenderTexture()
	self.Rendering = true

	texture.Delete(self:EntIndex())

	local picture = texture.Create(self:EntIndex())
	picture:SetSize(500, 500)
	picture:SetFormat("png")
	picture:EnableProxy(false)
	picture:Download(self:GetURL(), function()
		if IsValid(self) then
			self.Rendering = false
			self.LastURL = self:GetURL()
		end
	end, function(e)
		if IsValid(self) then
			self.Rendering = false
		end
	end)
end



function ENT:GetTexture()
	return texture.Get(self:EntIndex())
end

function ENT:Draw()
	self:DrawModel()

	if (cvar.GetValue('enable_pictureframes') == false) or (not self:InSight()) then return end

	if (not self:GetTexture() and not self.Rendering) or (self:GetURL() ~= self.LastURL and not self.Rendering) then
		self:RenderTexture()
	elseif self:GetTexture() then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)

		cam.Start3D2D((self:GetPos() + (self:GetForward() * (-self:OBBMaxs().y + 0.5)) + (self:GetUp() * 1.65) + (self:GetRight() * (self:OBBMaxs().x - 0.5))), ang, 0.0462)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(self:GetTexture())
			surface.DrawTexturedRect(0, 0, 1014, 1014)
		cam.End3D2D()
	end
end




local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end

local fr
net.Receive('rp.OpenImageWindow', function()
	local set
	local text
	local ava

	if IsValid(fr) then fr:Close() end
	fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 120)
		self:SetTitle('Set Image')
		self:MakePopup()
		self:Center()
		function self:Think() 
			if IsValid(set) and IsValid(text) and IsValidURL(text:GetValue()) then
				set:SetDisabled(false)
			else
				set:SetDisabled(true)
			end
		end
	end)

	text = ui.Create('DTextEntry', function(self, p) 
		self:SetPos(5, 60)
		self:SetSize(p:GetWide() - 10, 25)
		self.OnEnter = function(s)
			set:DoClick()
		end
	end, fr)

	ui.Create('DLabel', function(self, p) 
		self:SetText('Картинки только .jpg и .png! За порно и символику бан')
		self:SetFont('ui.24')
		self:SetTextColor(rp.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 32)
	end, fr)

	set = ui.Create('ui_button', function(self, p)
		self:SetText('Загрузить Изображение')
		self:SetPos(5, 90)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			p:Close()
			rp.RunCommand('setimage', text:GetValue())
		end
	end, fr)

	ava = ui.Create('ui_button', function(self, p)
		self:SetText('Установить Аватарку')
		self:SetPos(p:GetWide()/2 + 2.5, 90)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			p:Close()
			rp.RunCommand('setimageavatar')
		end
	end, fr)
	
	if (LocalPlayer():GetOrg()) then
		ui.Create('ui_button', function(self, p)
			set:SetWide(fr:GetWide() / 3 - 6.666)
			ava:SetWide(fr:GetWide() / 3 - 6.666)
			ava:SetPos(set.x + set:GetWide() + 5, ava.y)
			
			self:SetText('Установить Баннер')
			self:SetPos(ava.x + ava:GetWide() + 5, 90)
			self:SetSize(fr:GetWide() - self.x - 5, 25)
			function self:DoClick()
				p:Close()
				rp.RunCommand('setimageorg')
			end
		end, fr)
	end
end)