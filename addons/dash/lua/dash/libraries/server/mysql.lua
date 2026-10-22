pcall(require, 'tmysql4') -- без модуля dash не падает, MySQL просто недоступен

mysql = setmetatable({
	GetTable = setmetatable({}, {
		__call = function(self)
			return self
		end
	})
}, {
	__call = function(self, ...)
		return self.Connect(...)
	end
})

local DATABASE = {
	__tostring = function(self)
		return self.Database .. '@' .. self.Hostname .. ':' ..  self.Port
	end
}
DATABASE.__concat 	= DATABASE.__tostring
DATABASE.__index 	= DATABASE

local STATEMENT = {
	__tostring = function(self)
		return self.Query
	end,
	__call = function(self, ...)
		return self:Run(...)
	end
}
STATEMENT.__concat 	= STATEMENT.__tostring
STATEMENT.__index 	= STATEMENT

_R.MySQLDatabase 	= DATABASE
_R.MySQLStatement 	= STATEMENT

local tostring 		= tostring
local SysTime 		= SysTime
local pairs 		= pairs
local select 		= select
local isfunction 	= isfunction
local string_format = string.format
local string_gsub 	= string.gsub

local color_prefix, color_text = Color(185,0,255), Color(250,250,250)

local query_queue	= {}

function mysql.Connect(hostname, username, password, database, port, optional_socketpath, optional_clientflags)
	local db_obj = setmetatable({
		Hostname = hostname,
		Username = username,
		Password = password,
		Database = database,
		Port 	 = port,
	}, DATABASE)

	if mysql.GetTable[tostring(db_obj)] then
		return mysql.GetTable[tostring(db_obj)]
	end

	db_obj.Handle, db_obj.Error = tmysql.initialize(hostname, username, password, database, port, optional_socketpath, optional_clientflags)

	if db_obj.Error then
		db_obj:Log(db_obj.Error)
	elseif (db_obj.Handle == false) then
		db_obj:Log('Connection failed!')
	else
		mysql.GetTable[tostring(db_obj)] = db_obj

		db_obj:Log('Connected successfully.')
	end

	--self:SetOption(MYSQL_SET_CLIENT_IP, GetConVarString('ip'))
	--self:Connect()

	return db_obj
end


function DATABASE:IsConnected()
	return self.Handle and self.Handle ~= false and self.Handle ~= nil
end

function DATABASE:Connect()
	if not self:IsConnected() then
		self:Log('Connect called but Handle is not valid (connection failed at init)')
		return false
	end
	return self.Handle:Connect()
end

function DATABASE:Disconnect()
	if not self:IsConnected() then return end
	return self.Handle:Disconnect()
end

function DATABASE:Poll()
	if not self:IsConnected() then return end
	self.Handle:Poll()
end

function DATABASE:Escape(value)
	if not self:IsConnected() then return 'NULL' end
	return (value ~= nil) and self.Handle:Escape(tostring(value))
end

function DATABASE:Log(message)
	MsgC(color_prefix, '[MySQL] ', color_text, tostring(self) .. ' => '.. tostring(message) .. '\n')
end

local quote = '"'
local retry_errors = {
	['Lost connection to MySQL server during query'] = true,
	[' MySQL server has gone away'] = true,
}

local function handlequery(db, query, results, cback)
	if (results[1].error ~= nil) then
		db:Log(results[1].error)
		if retry_errors[results[1].error] then
			if query_queue[query] then
				query_queue[query].Trys = query_queue[query].Trys + 1
			else
				query_queue[query] = {
					Db 		= db, 
					Query 	= query,
					Trys 	= 0,
					Cback 	= cback
				}
			end
		end
	elseif cback then
		cback(results[1].data, results[1].lastid, results[1].affected, results[1].time)
	end
end

function DATABASE:Query(query, ...)
	if not self:IsConnected() then
		self:Log('Query skipped — no valid DB connection: ' .. tostring(query))
		local nargs = select('#', ...)
		local cback = nargs > 0 and select(nargs, ...) or nil
		if isfunction(cback) then cback({}, nil, 0, 0) end
		return
	end

	local args = {...}
	local count = 0
	query = query:gsub('?', function()
		count = count + 1
		return (args[count] ~= nil) and (quote .. self:Escape(args[count]) .. quote) or 'NULL'
	end)

	self.Handle:Query(query, function(results)
		handlequery(self, query, results, args[count + 1])
	end)
end

function DATABASE:QuerySync(query, ...)
	local data, lastid, affected, time
	local start = SysTime() + 0.3
	if (... == nil) then
		self:Query(query, function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	else
		self:Query(query, ..., function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	end
	
	while (not data) and (start >= SysTime()) do
		self:Poll()
	end
	return data, lastid, affected, time
end

function DATABASE:Prepare(query)
	local _, varcount 	= string_gsub(query, '?', '?')
	local dbhandle 		= self.Handle
	local db 			= self
	local values		= {}

	query = string.Replace(query, '?', '%s')

	return setmetatable({
		Handle = self.Handle,
		Query = query,
		Count = varcount,
		Values = values,
		Run = function(self, ...)
			local cback = select(varcount + 1, ...)
			for i = 1, varcount do
				local value = select(i, ...)
				values[i] = (value ~= nil) and (quote .. db:Escape(value) .. quote) or 'NULL'
			end
			local query = string_format(query, unpack(values))
			dbhandle:Query(query, function(results)
				handlequery(db, query, results, cback)
			end)
		end,
	}, STATEMENT)
end


function DATABASE:SetCharacterSet(charset)
	if not self:IsConnected() then return end
	self.Handle:SetCharacterSet(charset)
end

function DATABASE:SetOption(opt, value)
	if not self:IsConnected() then return end
	self.Handle:SetOption(opt, value)
end


function DATABASE:GetServerInfo()
	if not self:IsConnected() then return nil end
	return self.Handle:GetServerInfo()
end

function DATABASE:GetHostInfo()
	if not self:IsConnected() then return nil end
	return self.Handle:GetHostInfo()
end

function DATABASE:GetServerVersion()
	if not self:IsConnected() then return nil end
	return self.Handle:GetServerVersion()
end

--[[function STATEMENT:Run(...)
	
end]]

function STATEMENT:RunSync(...)
	local data, lastid, affected, time
	local start = SysTime() + 0.3

	if (... == nil) then
		self:Run(..., function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	else
		self:Run(function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	end

	while (not data) and (start >= SysTime()) do
		self.Handle:Poll()
	end
	return data, lastid, affected, time
end

function STATEMENT:GetQuery()
	return self.Query
end

function STATEMENT:GetCount()
	return self.Count
end

function STATEMENT:GetDatabase()
	return self.Handle
end


timer.Create('mysql.QueryQueue', 0.5, 0, function()
	for k, v in pairs(query_queue) do
		if (v.Trys < 5) then
			v.Db:Query(v.Query, v.Cback)
			v.Trys = v.Trys + 1
		else
			query_queue[k] = nil
		end
	end
end)