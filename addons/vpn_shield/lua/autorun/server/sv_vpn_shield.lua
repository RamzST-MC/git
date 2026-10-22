-- ItsNoctarius

if not SERVER then return end

AddCSLuaFile("autorun/client/cl_vpn_shield_probe.lua")
AddCSLuaFile("autorun/client/cl_vpn_shield_notify.lua")
AddCSLuaFile("vpn_shield/config.lua")

VPNShield = VPNShield or {}
VPNShield.Config = VPNShield.Config or {}
include("vpn_shield/config.lua")

util.AddNetworkString("vpnshield_probe_request")
util.AddNetworkString("vpnshield_probe_result")
util.AddNetworkString("vpnshield_notify")

local cvEnable = CreateConVar("sv_vpnshield_enable", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable VPN Shield checks.")
local cvKickProxy = CreateConVar("sv_vpnshield_kick_proxy", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Kick when IP is marked as proxy/VPN/Tor.")
local cvKickHosting = CreateConVar("sv_vpnshield_kick_hosting", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Kick when IP is datacenter/hosting.")
local cvKickCountryDenied = CreateConVar("sv_vpnshield_kick_country_denied", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Kick when country is in deny list.")
local cvDenyCountries = CreateConVar("sv_vpnshield_deny_countries", "", {FCVAR_ARCHIVE}, "Comma-separated denied country codes, e.g. RU,CN")
local cvAllowCountries = CreateConVar("sv_vpnshield_allow_countries", "", {FCVAR_ARCHIVE}, "Comma-separated allowed country codes. If set, others are denied.")
local cvRequireProbe = CreateConVar("sv_vpnshield_require_dhtml_probe", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Require client probe response.")
local cvKickProbeMismatch = CreateConVar("sv_vpnshield_kick_probe_mismatch", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Kick if client public IP differs from server-seen IP.")
local cvProbeGrace = CreateConVar("sv_vpnshield_probe_grace", "12", {FCVAR_ARCHIVE}, "Seconds to wait for client probe response.")
local cvCacheTTL = CreateConVar("sv_vpnshield_cache_ttl", "21600", {FCVAR_ARCHIVE}, "IP check cache TTL in seconds.")
local cvLog = CreateConVar("sv_vpnshield_log", "1", {FCVAR_ARCHIVE}, "Enable verbose VPN Shield logs.")

local ipCache = {}
local pendingLookups = {}
local pendingProbes = {}
local violations = {}

local function cfg()
	return VPNShield.Config or {}
end

local function log(msg)
	if not cvLog:GetBool() then return end
	MsgC(Color(90, 220, 255), "[VPNShield] ", color_white, msg .. "\n")
end

local function notifyPlayer(ply, title, text, variant, life)
	if not IsValid(ply) then return end
	net.Start("vpnshield_notify")
		net.WriteString(tostring(title or "VPNShield"))
		net.WriteString(tostring(text or ""))
		net.WriteString(tostring(variant or "info"))
		net.WriteFloat(tonumber(life) or 6)
	net.Send(ply)
end

local function loadViolations()
	local path = tostring(cfg().PersistenceFile or "vpn_shield/violations.json")
	if not file.Exists(path, "DATA") then
		violations = {}
		return
	end

	local raw = file.Read(path, "DATA")
	local parsed = util.JSONToTable(raw or "")
	if istable(parsed) then
		violations = parsed
	else
		violations = {}
	end
end

local function saveViolations()
	local path = tostring(cfg().PersistenceFile or "vpn_shield/violations.json")
	file.CreateDir("vpn_shield")
	file.Write(path, util.TableToJSON(violations, true) or "{}")
end

local function getViolationCount(ply)
	if not IsValid(ply) then return 0 end
	local sid64 = ply:SteamID64()
	if not sid64 or sid64 == "0" then return 0 end
	return tonumber(violations[sid64]) or 0
end

local function setViolationCount(ply, count)
	if not IsValid(ply) then return end
	local sid64 = ply:SteamID64()
	if not sid64 or sid64 == "0" then return end
	violations[sid64] = math.max(0, math.floor(tonumber(count) or 0))
	saveViolations()
end

local function handleViolation(ply, reason)
	local c = cfg()
	local msg = c.Messages or {}
	local warningLimit = math.max(0, tonumber(c.AllowedWarnings) or 0)
	local instant = tobool(c.KickInstantly)
	local warningShow = tonumber(c.WarningDisplayTime) or 7

	if instant then
		notifyPlayer(ply, msg.TitleBlocked or "VPN blocked", msg.BlockedText or "VPN/Proxy detected. Access denied.", "danger", 5.5)
		timer.Simple(0.3, function()
			if not IsValid(ply) then return end
			local kickFmt = msg.KickTemplate or "VPN/Proxy blocked: %s"
			ply:Kick(string.format(kickFmt, reason))
		end)
		return
	end

	local current = getViolationCount(ply) + 1
	setViolationCount(ply, current)

	if current <= warningLimit then
		local warningText = string.format(msg.WarningTemplate or "Detected VPN/Proxy. Warning %d/%d.", current, warningLimit)
		notifyPlayer(ply, msg.TitleWarning or "VPN warning", warningText, "info", warningShow)
		log(("Warning %d/%d for %s: %s"):format(current, warningLimit, ply:Nick(), reason))
		return
	end

	notifyPlayer(ply, msg.TitleBlocked or "VPN blocked", msg.BlockedText or "VPN/Proxy detected. Access denied.", "danger", 5.5)
	timer.Simple(0.35, function()
		if not IsValid(ply) then return end
		local kickFmt = msg.KickTemplate or "VPN/Proxy blocked: %s"
		ply:Kick(string.format(kickFmt, reason))
	end)
end

local function splitCsvUpper(value)
	local out = {}
	for token in string.gmatch(string.upper(value or ""), "([^,]+)") do
		token = string.Trim(token)
		if token ~= "" then
			out[token] = true
		end
	end
	return out
end

local function extractIP(raw)
	if not isstring(raw) then return nil end
	local bracketed = raw:match("^%[([%x:%.]+)%]")
	if bracketed then return bracketed end
	local ipv4 = raw:match("^(%d+%.%d+%.%d+%.%d+)")
	if ipv4 then return ipv4 end
	return raw
end

local function isPrivateIPv4(ip)
	if not ip then return true end
	if ip == "127.0.0.1" then return true end
	if string.StartWith(ip, "10.") then return true end
	if string.StartWith(ip, "192.168.") then return true end
	if ip:match("^172%.(%d+)%.") then
		local second = tonumber(ip:match("^172%.(%d+)%."))
		if second and second >= 16 and second <= 31 then
			return true
		end
	end
	return false
end

local function isRoutablePublicIP(ip)
	if not isstring(ip) then return false end
	ip = string.Trim(string.lower(ip))
	if ip == "" then return false end
	if ip == "loopback" or ip == "localhost" then return false end
	if string.find(ip, ":", 1, true) then
		if ip == "::1" or ip == "::" then return false end
		if string.StartWith(ip, "fc") or string.StartWith(ip, "fd") or string.StartWith(ip, "fe80") then
			return false
		end
		return true
	end

	if isPrivateIPv4(ip) then return false end
	return ip:match("^%d+%.%d+%.%d+%.%d+$") ~= nil
end

local function normalizeFromIPAPI(body)
	local data = util.JSONToTable(body or "")
	if not istable(data) then return nil, "ip-api bad json" end
	if data.status ~= "success" then
		return nil, "ip-api status: " .. tostring(data.message or "unknown")
	end

	return {
		ok = true,
		source = "ip-api",
		ip = tostring(data.query or ""),
		countryCode = string.upper(tostring(data.countryCode or "")),
		asn = tostring(data.as or ""),
		isp = tostring(data.isp or ""),
		isProxy = tobool(data.proxy) or tobool(data.mobile),
		isHosting = tobool(data.hosting),
		raw = data
	}
end

local function normalizeFromIPWho(body)
	local data = util.JSONToTable(body or "")
	if not istable(data) then return nil, "ipwho bad json" end
	if data.success == false then
		return nil, "ipwho failed"
	end

	local security = istable(data.security) and data.security or {}
	local connection = istable(data.connection) and data.connection or {}
	local isProxy = tobool(security.proxy) or tobool(security.vpn) or tobool(security.tor) or tobool(security.relay)
	local isHosting = tobool(connection.hosting)

	return {
		ok = true,
		source = "ipwho.is",
		ip = tostring(data.ip or ""),
		countryCode = string.upper(tostring(data.country_code or "")),
		asn = tostring(connection.asn or ""),
		isp = tostring(connection.isp or ""),
		isProxy = isProxy,
		isHosting = isHosting,
		raw = data
	}
end

local function requestIpIntel(ip, cb)
	local now = CurTime()
	local cached = ipCache[ip]
	if cached and cached.expiresAt > now then
		cb(cached.data, nil)
		return
	end

	if pendingLookups[ip] then
		table.insert(pendingLookups[ip], cb)
		return
	end
	pendingLookups[ip] = {cb}

	local function resolveAll(data, err)
		local queue = pendingLookups[ip] or {}
		pendingLookups[ip] = nil

		if data then
			ipCache[ip] = {
				data = data,
				expiresAt = now + math.max(30, cvCacheTTL:GetInt())
			}
		end

		for _, fn in ipairs(queue) do
			fn(data, err)
		end
	end

	local fields = "status,message,query,countryCode,proxy,hosting,mobile,as,isp"
	local primaryUrl = "http://ip-api.com/json/" .. ip .. "?fields=" .. fields
	http.Fetch(primaryUrl, function(body)
		local normalized, err = normalizeFromIPAPI(body)
		if normalized then
			resolveAll(normalized, nil)
			return
		end

		local fallbackUrl = "https://ipwho.is/" .. ip
		http.Fetch(fallbackUrl, function(fbBody)
			local fbNormalized, fbErr = normalizeFromIPWho(fbBody)
			if fbNormalized then
				resolveAll(fbNormalized, nil)
			else
				resolveAll(nil, "fallback failed: " .. tostring(fbErr or err))
			end
		end, function(fbErr)
			resolveAll(nil, "fallback http failed: " .. tostring(fbErr or err))
		end)
	end, function(httpErr)
		local fallbackUrl = "https://ipwho.is/" .. ip
		http.Fetch(fallbackUrl, function(fbBody)
			local fbNormalized, fbErr = normalizeFromIPWho(fbBody)
			if fbNormalized then
				resolveAll(fbNormalized, nil)
			else
				resolveAll(nil, "primary http failed: " .. tostring(httpErr) .. ", fallback: " .. tostring(fbErr))
			end
		end, function(fbErr)
			resolveAll(nil, "primary and fallback http failed: " .. tostring(httpErr) .. " / " .. tostring(fbErr))
		end)
	end)
end

local function countryAllowed(code)
	code = string.upper(tostring(code or ""))
	if code == "" then return true end

	local deny = splitCsvUpper(cvDenyCountries:GetString())
	if deny[code] then return false, "country denied: " .. code end

	local allowRaw = cvAllowCountries:GetString()
	if allowRaw ~= "" then
		local allow = splitCsvUpper(allowRaw)
		if not allow[code] then
			return false, "country not in allow list: " .. code
		end
	end

	return true
end

local function kickWithReason(ply, reason)
	if not IsValid(ply) then return end
	log(("Kicking %s (%s): %s"):format(ply:Nick(), ply:SteamID(), reason))
	ply:Kick("VPN/Proxy blocked: " .. reason)
end

local function startClientProbe(ply, serverSeenIP)
	if not IsValid(ply) then return end
	local token = util.CRC(serverSeenIP .. "|" .. ply:SteamID64() .. "|" .. SysTime() .. "|" .. math.random(1, 10 ^ 9))

	pendingProbes[ply] = {
		token = token,
		serverIP = serverSeenIP,
		deadline = CurTime() + math.max(3, cvProbeGrace:GetFloat())
	}

	net.Start("vpnshield_probe_request")
		net.WriteString(token)
	net.Send(ply)
end

local function evaluatePlayerIP(ply, ip)
	requestIpIntel(ip, function(intel, err)
		if not IsValid(ply) then return end

		if not intel then
			log(("Lookup failed for %s (%s): %s"):format(ply:Nick(), ip, tostring(err)))
			if cvRequireProbe:GetBool() then
				startClientProbe(ply, ip)
			end
			return
		end

		log(("Intel %s from %s -> proxy=%s hosting=%s country=%s asn=%s isp=%s"):format(
			ip, intel.source, tostring(intel.isProxy), tostring(intel.isHosting), tostring(intel.countryCode), tostring(intel.asn), tostring(intel.isp)
		))

		if cvKickProxy:GetBool() and intel.isProxy then
			handleViolation(ply, "proxy/vpn/tor detected")
			return
		end
		if cvKickHosting:GetBool() and intel.isHosting then
			handleViolation(ply, "hosting/datacenter connection")
			return
		end

		local allowed, reason = countryAllowed(intel.countryCode)
		if cvKickCountryDenied:GetBool() and not allowed then
			handleViolation(ply, reason)
			return
		end

		startClientProbe(ply, ip)
	end)
end

hook.Add("PlayerInitialSpawn", "VPNShield.PlayerInitialSpawn", function(ply)
	if not cvEnable:GetBool() then return end
	if not IsValid(ply) or ply:IsBot() then return end

	local ip = extractIP(ply:IPAddress())
	if not isRoutablePublicIP(ip) then
		local lowered = string.lower(tostring(ip or ""))
		-- Avoid noisy logs on local/listen-server loopback joins.
		if lowered ~= "loopback" and lowered ~= "localhost" then
			log(("Skipping non-public IP '%s' for %s"):format(tostring(ip), IsValid(ply) and ply:Nick() or "unknown"))
		end
		return
	end

	evaluatePlayerIP(ply, ip)
end)

net.Receive("vpnshield_probe_result", function(_, ply)
	if not cvEnable:GetBool() then return end
	if not IsValid(ply) then return end

	local data = pendingProbes[ply]
	if not data then return end

	local token = net.ReadString()
	local payload = net.ReadString()
	if token ~= data.token then
		kickWithReason(ply, "probe token mismatch")
		return
	end

	pendingProbes[ply] = nil

	local parsed = util.JSONToTable(payload or "")
	if not istable(parsed) then
		if cvRequireProbe:GetBool() then
			kickWithReason(ply, "invalid probe payload")
		end
		return
	end

	local ok = tobool(parsed.ok)
	local clientIP = extractIP(tostring(parsed.ip or ""))
	if not ok or not clientIP or clientIP == "" then
		log(("Probe failed for %s: %s"):format(ply:Nick(), tostring(parsed.error or "unknown")))
		if cvRequireProbe:GetBool() then
			kickWithReason(ply, "client probe failed")
		end
		return
	end

	if cvKickProbeMismatch:GetBool() and clientIP ~= data.serverIP then
		kickWithReason(ply, ("probe mismatch (%s ~= %s)"):format(clientIP, data.serverIP))
		return
	end

	log(("Probe passed for %s (%s)"):format(ply:Nick(), clientIP))
end)

hook.Add("Think", "VPNShield.ProbeTimeouts", function()
	if not cvEnable:GetBool() then return end

	local now = CurTime()
	for ply, probe in pairs(pendingProbes) do
		if not IsValid(ply) then
			pendingProbes[ply] = nil
		elseif now > probe.deadline then
			pendingProbes[ply] = nil
			if cvRequireProbe:GetBool() then
				kickWithReason(ply, "probe timeout")
			else
				log(("Probe timeout for %s, continuing (not required)"):format(ply:Nick()))
			end
		end
	end
end)

hook.Add("PlayerDisconnected", "VPNShield.PlayerDisconnected", function(ply)
	pendingProbes[ply] = nil
end)

hook.Add("Initialize", "VPNShield.LoadViolations", function()
	loadViolations()
end)

loadViolations()
