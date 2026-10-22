SWEP.PrintName = "Маскировка"
SWEP.Category = "RP"
SWEP.Base = 'weapon_rp_base'
SWEP.ViewModel = ''
SWEP.WorldModel = 'models/weapons/w_suitcase_passenger.mdl'
SWEP.Spawnable = true
SWEP.COOLDOWN = 0
SWEP.COOLDOWN2 = 0

local mat = Material("spawnicons/models/weapons/w_suitcase_passenger_128.png")
function SWEP:DrawWeaponSelection(x, y, w, h, a)
	if mat:IsError() then
		local pnl = vgui.Create("SpawnIcon")
		pnl:SetSize(128, 128)
		pnl:InvalidateLayout(true)
		pnl:SetModel("models/weapons/w_suitcase_passenger.mdl", 0, 0)
		timer.Simple(0, function()
			pnl:Remove()
			self.Generated = true
		end)
		return
	end

	local fsin = 0
	if self.BounceWeaponIcon == true then fsin = math.sin(CurTime() * 10) * 5 end
	surface.SetMaterial(mat)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	local iconW = 128
	surface.DrawTexturedRect(x + w * 0.5 - iconW * 0.5 + fsin, y + h * 0.5 - iconW * 0.5 - fsin - 20, iconW - fsin * 2, iconW + fsin)
	self:PrintWeaponInfo(x + w + 20, y + h * 0.95, a)
end

function SWEP:DrawWorldModel()
	local entOwner = self:GetOwner()
	if not entOwner:IsValid() then
		self:SetRenderOrigin()
		self:SetRenderAngles()
		self:DrawModel()
		return
	end

	self:RemoveEffects(EF_BONEMERGE_FASTCULL)
	self:RemoveEffects(EF_BONEMERGE)
	local iHandBone = entOwner:LookupBone("ValveBiped.Bip01_R_Hand")
	if not iHandBone then return end
	local vecBone, angBone = entOwner:GetBonePosition(iHandBone)
	if false then
		local forward = angBone:Forward()
		angBone:RotateAroundAxis(forward, 70)
		local right = angBone:Right()
		angBone:RotateAroundAxis(right, -160)
		local up = angBone:Up()
		angBone:RotateAroundAxis(up, 30)
		vecBone:Sub(angBone:Up() * 2.5)
		vecBone:Sub(angBone:Right() * 0)
	else
		local forward = angBone:Forward()
		angBone:RotateAroundAxis(forward, 90)
		local right = angBone:Right()
		angBone:RotateAroundAxis(right, 90)
		local up = angBone:Up()
		angBone:RotateAroundAxis(up, 90)
		vecBone:Sub(angBone:Up() * 5)
		vecBone:Sub(angBone:Right() * -.5)
	end

	self:SetRenderOrigin(vecBone)
	self:SetRenderAngles(angBone)
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:PrimaryAttack()
	if self.COOLDOWN > CurTime() then return end
	if CLIENT then rp.DisguiseMenu() end
	self.COOLDOWN = CurTime() + 5
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if SERVER then
		local pl = self.Owner
		if pl:GetNetVar('IsDisguise') == false or self.COOLDOWN2 > CurTime() then return end
		timer.Destroy(pl:SteamID64())

		if pl:GetNetVar('IsDisguise') == false then
			rp.Notify(pl,NOTIFY_ERROR,'У вас нет маскировки!')
			return false
		end

		pl:SetNetVar('IsDisguise',false)
		pl:SetModel(pl.MainModel)
		pl:SetNetVar('DisguiseJob', nil)
		rp.Notify(pl,NOTIFY_ERROR,'Вы сняли маскировку.')	
		self.COOLDOWN2 = CurTime() + 5
	end
end