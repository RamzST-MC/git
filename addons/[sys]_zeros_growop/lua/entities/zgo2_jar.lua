--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Jar"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_jar.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

rp.inv.Wl['zgo2_jar'] = 'Банка'

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "WeedID")
	self:NetworkVar("Int", 1, "WeedAmount")
	self:NetworkVar("Int", 2, "WeedTHC")

	if SERVER then
		self:SetWeedID(0)
		self:SetWeedAmount(0)
		self:SetWeedTHC(0)
	end
end

if SERVER then
	function ENT:PostInitialize()
		zgo2.Jar.Initialize(self)

		self.am = self.amount or 1
		self.model = self:GetModel()
		
		self.weedid = zgo2.Plant.GetID(self:GetWeedID())
		self.weedam = math.Round(self:GetWeedAmount())
		self.weedthc = math.Round(self:GetWeedTHC())

		self.Type = zgo2.Plant.GetName(zgo2.Plant.GetID(self:GetWeedID())) .. " [" .. math.Round(self:GetWeedAmount()) .. zgo2.config.UoM .. " - THC: ".. (math.Round(self:GetWeedTHC()) or 50) .. "%]"
	end

	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.Jar.OnUse(self, activator)
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		zgo2.Jar.OnTouch(self, data.HitEntity)
	end
end

if CLIENT then
	function ENT:Initialize()
		self:DestroyShadow()

		timer.Simple(0.5, function()
			if IsValid(self) then
				self.m_Initialized = true
			end
		end)
	end

	function ENT:Think()
		zgo2.Jar.Think(self)
	end

	function ENT:Draw()
		self:DrawModel()
		zgo2.Jar.Draw(self)
	end
end
--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher