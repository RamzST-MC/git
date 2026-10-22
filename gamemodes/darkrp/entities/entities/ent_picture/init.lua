AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('rp.OpenImageWindow')

function ENT:Initialize()
	self:SetModel('models/hunter/plates/plate1x1.mdl')
	self:SetMaterial('models/debug/debugwhite')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

	self:SetURL('https://i.imgur.com/TZcJ1CK.png')

--	timer.Simple(0, function() self:CPPISetOwner(self.ItemOwner) end)
end

function ENT:Use(pl)
	if (not IsValid(self.ItemOwner) or (self.ItemOwner == pl)) and ((not pl.LastImageUSe) or (pl.LastImageUSe <= CurTime())) and (self:GetPos():Distance(pl:GetPos()) < 110) then
		net.Start('rp.OpenImageWindow')
		net.Send(pl)
		pl.LastImageUSe = CurTime() + 2
	end
end

local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end

local bad_chars = {
	'"',
	"'",
	']',
	'[',
	'\\'
}

local function EscapeURL(url)
	for k, v in ipairs(bad_chars) do
		url = string.Replace(url, v, '')
	end
	return url
end

local function set_image(pl, args)
	local ent = pl:GetEyeTrace().Entity
	if (not args) or (not IsValidURL(args)) then
		pl:Notify(NOTIFY_ERROR, 'Неверная ссылка')
	elseif IsValid(ent) and (not IsValid(ent.ItemOwner) or ent.ItemOwner == pl) then
		ent:SetURL(EscapeURL(args))
	end
end

rp.AddCommand('setimage', set_image)
:AddParam(cmd.STRING)
:AddAlias 'image'

rp.AddCommand('setimageavatar', function(pl, text, args)
	for i = 1, 5 do pl:Notify(NOTIFY_ERROR, 'НЕДОДЕЛ') end
end)

rp.AddCommand('setimageorg', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and (not IsValid(ent.ItemOwner) or ent.ItemOwner == pl) then
		ent:SetURL('https://i.imgur.com/' .. pl:GetNetVar('OrgBanner'))
	end
end)
