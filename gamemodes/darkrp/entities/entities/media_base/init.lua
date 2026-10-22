AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)
	
	if IsValid(self.ItemOwner) then
		self:CPPISetOwner(self.ItemOwner)
	end
end

hook('OnPhysgunPickup', function(pl, ent)
	if ent.Base == "media_base" then
		ent:SetFrozen(0)
	end
end)

function ENT:PhysgunFreeze()
	self:SetFrozen(1)
end

rp.AddCommand('playsong', function(pl, url, entid)
	local ent = pl:GetEyeTrace().Entity
	local url = url

	if (not IsValid(ent)) or (not ent:CanUse(pl)) or (not url) or (pl:GetPos():Distance(ent:GetPos()) > 150) or (pl ~= ent:CPPIGetOwner()) then return end

	if (url == '') then
		ent:SetURL('')
	else
		local service = medialib.load('media').guessService(url)

		if (not service) then
			pl:Notify(NOTIFY_ERROR, term.Get('InvalidURL'))
		else
			service:query(url, function(err, data)
				if err then
					pl:Notify(NOTIFY_ERROR, term.Get('VideoFailed'), err)
				else
					ent:SetURL(url)
					ent:SetTitle(data.title)
					ent:SetTime(data.duration or 0)
					ent:SetStart(CurTime())
					ent:SetLooping(0)
				end
			end)
		end
	end
end)
:AddParam(cmd.STRING)

rp.AddCommand('pausesong', function(pl)
	local ent = pl:GetEyeTrace().Entity

	if (not IsValid(ent)) or (not ent:CanUse(pl)) or (pl:GetPos():Distance(ent:GetPos()) > 150) or (pl ~= ent:CPPIGetOwner()) then return end

	if not ent:IsPaused() then
		ent:SetPaused(1)
		ent.timepaused = (CurTime() - ent:GetStart())
	else
		ent:SetPaused(0)
		ent:SetStart(CurTime() - ent.timepaused)
	end
end)

rp.AddCommand('loopsong', function(pl, url, entid)
	local ent = pl:GetEyeTrace().Entity
	local url = url

	if (not IsValid(ent)) or (not ent:CanUse(pl)) or (not url) or (pl:GetPos():Distance(ent:GetPos()) > 150) or (pl ~= ent:CPPIGetOwner()) then return end

	if (url == '') then
		ent:SetURL('')
	else
		local service = medialib.load('media').guessService(url)

		if (not service) then
			pl:Notify(NOTIFY_ERROR, term.Get('InvalidURL'))
		else
			service:query(url, function(err, data)
				if err then
					pl:Notify(NOTIFY_ERROR, term.Get('VideoFailed'), err)
				else
					ent:SetURL(url)
					ent:SetTitle(data.title)
					ent:SetTime(data.duration or 0)
					ent:SetStart(CurTime())
					ent:SetLooping(1)
				end
			end)
		end
	end
end)
:AddParam(cmd.STRING)