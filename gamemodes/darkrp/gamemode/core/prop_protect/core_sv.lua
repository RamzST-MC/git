local string 	= string
local IsValid 	= IsValid
local util 		= util
util.AddNetworkString('rp.toolEditor')
rp.pp = rp.pp or {}
rp.pp.Whitelist = rp.pp.Whitelist or {} -- Исправление ошибки nil value
local toolFuncs = {
[0] = function(pl)
return true
end,
[1] = PLAYER.IsVIP,
[2] = PLAYER.IsAdmin,
[3] = PLAYER.IsSuperAdmin
}
rp.pp.BlockedTools = {
['button']		= 0,
['camera']		= 0,
['colour']		= 0,
['fading_door'] = 0,
['keypad']		= 0,
['lamp']		= 3,
['light']		= 0,
['material']	= 0,
['nocollide']	= 0,
['precision']	= 0,
['remover']		= 0,
['stacker']		= 1,
['textscreen']	= 0,
['weld']		= 0,
['advdupe2']	= 1,
}
local db = rp._Stats
function rp.pp.IsBlockedModel(mdl)
mdl = string.lower(mdl or "")
mdl = string.Replace(mdl, "\\", "/") -- Исправлена ошибка синтаксиса (экранирован слеш)
mdl = string.gsub(mdl, "[\\/]+", "/")
return not (rp.pp.Whitelist[mdl] == true)
end
function rp.pp.PlayerCanManipulate(pl, ent)
if pl:IsBanned() then
return false
end
if IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner().propBuddies and ent:CPPIGetOwner().propBuddies[pl] then
	return true
end

return (ent:CPPIGetOwner() == pl) or (pl:HasAccess('a') and ba.canAdmin(pl) and IsValid(ent:CPPIGetOwner()) )
end
local can_dupe = {
['prop_physics'] = true,
['keypad']		= true,
['pad_biometric'] = true
}
function rp.pp.PlayerCanTool(pl, ent, tool)
if pl:IsBanned() then
return false
end
local tool = tool:lower()

if ent.isthingRemoval and (pl:HasAccess('a') and ba.canAdmin(pl)) then
	return true
end

if rp.pp.BlockedTools[tool] then
	local canTool = toolFuncs[rp.pp.BlockedTools[tool]](pl)
	if not canTool then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotTool'), tool)
		return canTool
	end
end

local EntTable =
	(tool == "adv_duplicator" and pl:GetActiveWeapon():GetToolObject().Entities) or
	(tool == "advdupe2" and pl.AdvDupe2 and pl.AdvDupe2.Entities) or
	(tool == "duplicator" and pl.CurrentDupe and pl.CurrentDupe.Entities)

if EntTable then
for k, v in pairs(EntTable) do
	local class = string.lower(v.Class)

	if class == "pad_biometric" then
		EntTable[k] = nil
	elseif not can_dupe[class] then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('DupeRestrictedEnts'))
		return false
	end
end
end
if ent:IsWorld() then 
	return true
elseif not IsValid(ent) then
	return false
end

local cantool = rp.pp.PlayerCanManipulate(pl, ent)

if (cantool == true) then
	hook.Call('PlayerToolEntity', GAMEMODE, pl, ent, tool)
end

return cantool
end
--
-- Data
function rp.pp.WhitelistModel(mdl)
db:Query('REPLACE INTO pp_whitelist VALUES(?);', mdl, function()
rp.pp.Whitelist[mdl] = true
end)
end
function rp.pp.BlacklistModel(mdl)
db:Query('DELETE FROM pp_whitelist WHERE Model=?;', mdl, function()
rp.pp.Whitelist[mdl] = nil
end)
end
function rp.pp.AddBlockedTool(tool, rank)
db:Query('REPLACE INTO pp_blockedtools VALUES(?, ?);', tool, rank, function()
rp.pp.BlockedTools[tool] = rank
end)
end
--
-- Load data
hook('InitPostEntity', 'pp.InitPostEntity', function()
-- Load whitelist
db:Query('SELECT * FROM pp_whitelist;', function(data)
for k, v in ipairs(data) do
rp.pp.Whitelist[v.Model] = true
end
end)
-- Load blocked tools
db:Query('SELECT * FROM pp_blockedtools;', function(data)
for k, v in ipairs(data) do
rp.pp.BlockedTools[v.Tool] = v.Rank
end
end)
end)
--
-- Meta functions
function ENTITY:IsProp()
return (self:GetClass() == 'prop_physics')
end
function ENTITY:CPPISetOwner(pl)
self.pp_owner = pl
self:SetNetVar('PropIsOwned', true)
end
function ENTITY:CPPIGetOwner()
return self.pp_owner
end
--
-- Workarounds
PLAYER._AddCount = PLAYER._AddCount or PLAYER.AddCount
function PLAYER:AddCount(t, ent)
if IsValid(ent) then
ent:CPPISetOwner(self)
end
return self:_AddCount(t, ent)
end
ENTITY._SetAngles = ENTITY._SetAngles or ENTITY.SetAngles
function ENTITY:SetAngles(ang)
if not ang then return self:_SetAngles(ang) end
ang.p = ang.p % 360
ang.y = ang.y % 360
ang.r = ang.r % 360
return self:_SetAngles(ang)
end
if undo then
local AddEntity, SetPlayer, Finish =  undo.AddEntity, undo.SetPlayer, undo.Finish
local Undo = {}
local UndoPlayer
function undo.AddEntity(ent, ...)
if type(ent) ~= "boolean" and IsValid(ent) then table.insert(Undo, ent) end
AddEntity(ent, ...)
end
function undo.SetPlayer(ply, ...)
	UndoPlayer = ply
	SetPlayer(ply, ...)
end

function undo.Finish(...)
	if IsValid(UndoPlayer) then
		for k,v in pairs(Undo) do
			v:CPPISetOwner(UndoPlayer)
		end
	end
	Undo = {}
	UndoPlayer = nil

	Finish(...)
end
end
duplicator.BoneModifiers = {}
duplicator.EntityModifiers['VehicleMemDupe'] = nil
for k, v in pairs(duplicator.ConstraintType) do
if (k ~= 'Weld') and (k ~= 'NoCollide') then
duplicator.ConstraintType[k] = nil
end
end
--
-- Commands
rp.AddCommand('shareprops', function(pl, args, text)
pl.propBuddies = pl.propBuddies or {}
if pl.propBuddies[args] then
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('UnsharedPropsYou'), args)
	rp.Notify(args, NOTIFY_SUCCESS, term.Get('UnsharedProps'), pl)
	pl.propBuddies[args] = false
else
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('SharedPropsYou'), args)
	rp.Notify(args, NOTIFY_SUCCESS, term.Get('SharedProps'), pl)
	pl.propBuddies[args] = true
end

pl:SetNetVar('ShareProps', pl.propBuddies)
end)
:AddParam(cmd.PLAYER_ENTITY)
rp.AddCommand('tooleditor', function(pl, text, args)
if pl:IsSuperAdmin() then
net.Start('rp.toolEditor')
net.WriteTable(rp.pp.BlockedTools)
net.Send(pl)
end
end)
local ranks = {
[0] = 'user',
[1] = 'vip',
[2] = 'admin',
[3] = 'Globaladmin'
}
rp.AddCommand('settoolgroup', function(pl, text, args)
if pl:IsRoot() then
if not args[1] or not args[2] then return end
rp.NotifyAll(NOTIFY_GENERIC, term.Get('PPGroupSet'), args[1], ranks[tonumber(args[2])], pl)
rp.pp.AddBlockedTool(args[1], tonumber(args[2]))
end
end)
-- Overwrite
concommand.Add('gmod_admin_cleanup', function(pl, cmd, args)
if (not pl:IsRoot())  then
pl:Notify(NOTIFY_ERROR, term.Get('CantAdminCleanup'))
return
end
if args[1] then
for k, v in ipairs(ents.GetAll()) do
if (v:GetClass() == args[1]) then
v:Remove()
end
end
end
end)