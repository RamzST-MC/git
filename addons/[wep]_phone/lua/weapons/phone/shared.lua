if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    SWEP.PrintName = "Телефон"
    SWEP.Slot = 2
    SWEP.SlotPos = 3
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false

    SWEP.Tooltips = {
		LeftClick = 'Меню телефона'
	}
end

SWEP.Author = ""
SWEP.Instructions = "ЛКМ чтобы откыть меню"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModel = "models/akulla/aphone/c_aphone.mdl"
SWEP.WorldModel = "models/akulla/aphone/w_aphone.mdl"
SWEP.ViewModelFOV = 98
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "RP"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.UseHands = true

function SWEP:Initialize()
    self:SetWeaponHoldType("slam")
end

function SWEP:Deploy()
    if SERVER then
        self.Owner:DrawWorldModel(true)
    end
end

function SWEP:Menu()
    --[[local m, t = DermaMenu(), player.GetAll()
    table.RemoveByValue(t, LocalPlayer())
    local lel = m:AddSubMenu('Позвонить')
    table.sort(t, function(f, l) return f:Team() > l:Team() end)

    for k, v in pairs(t) do
        local s = lel:AddOption(v:GetName(), function()
            if IsValid(v) then
                Phone.StartCall(v)
            end
        end)

        s:SetColor(Color(0, 0, 0, 255))
    end
	
	m:AddOption('Режим "Не беспокоить"', function()
		Phone.MuteForever()
	end)

    m:Open()
    m:SetPos(ScrW() / 2 - m:GetWide() / 2, ScrH() / 2)]]
	
	if IsValid(frphone) then return end
	
	frphone = ui.Create('ui_frame', function(self)
		self:SetTitle('Телефон')
		self:SetSize(300, 400)
		self:Center()
		self:MakePopup()
	end)
	
	ui.Create('ui_button', function(self, p)
		self:SetPos(5, 369)
		self:SetSize(290, 30)
		self:SetText('Режим "Не беспокоить"')
		self.DoClick = function(self)
			Phone.MuteForever()
		end
	end, frphone)

	ui.Create('ui_playerrequest', function(self, p) 
		local p = self:GetParent()
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5) - 25)
		self:SetPlayers(player.GetAll())
		self.OnSelection = function(self, row, pl)
			frphone:Close()
			if IsValid(pl) then
				Phone.StartCall(pl)
			end
		end
	end, frphone)
end

function SWEP:PrimaryAttack()
    if CLIENT then
        self:Menu()
    end
end