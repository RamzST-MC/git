-- dbdriver: единое подключение к БД
-- dbdriver.Connect{
--     mode    = 'mysql' | 'sqlite' | 'failover' | 'auto',
--     library = 'auto' | 'tmysql4' | 'mysqloo',
--     name    = 'rp' | 'ba' ...
--     host, user, pass, db, port,
--     syncInterval = 300   -- как часто тянуть данные из MySQL в локальную SQLite-копию (сек)
-- }
dbdriver = dbdriver or {}
dbdriver._n = dbdriver._n or 0

local color_prefix = Color(0, 200, 255)
local color_text   = Color(250, 250, 250)
local color_ok     = Color(80, 255, 120)
local color_warn   = Color(255, 200, 40)
local color_err    = Color(255, 70, 70)

local function log(msg, col)
	MsgC(color_prefix, '[DB] ', col or color_text, tostring(msg) .. '\n')
end

local limited = {}
local function logLimited(key, msg, interval, col)
	local now, e = SysTime(), limited[key]
	if e and ((now - e.t) < (interval or 60)) then
		e.n = e.n + 1
		return
	end
	if e and (e.n > 0) then msg = msg .. ' (повторялось ещё ' .. e.n .. ' раз)' end
	limited[key] = {t = now, n = 0}
	log(msg, col or color_warn)
end

local CONN_ERRORS = {
	'lost connection', 'gone away', "can't connect", 'cant connect', 'connection refused', 'timed out',
	'(10060)', '(10061)', '(2002)', '(2003)', '(2006)', '(2013)', 'unknown mysql server host',
	'not connected', 'broken pipe', 'connection reset', 'no connection',
}
local function isConnErr(err)
	err = tostring(err or ''):lower()
	for _, s in ipairs(CONN_ERRORS) do
		if err:find(s, 1, true) then return true end
	end
	return false
end

local function verbOf(q)
	return (q:match('^%s*(%a+)') or ''):upper()
end

local WRITE = {INSERT = true, REPLACE = true, UPDATE = true, DELETE = true}

local MYSQL_ESC = {
	['\0']  = '\\0',
	['\n']  = '\\n',
	['\r']  = '\\r',
	['\\']  = '\\\\',
	["'"]   = "\\'",
	['"']   = '\\"',
	['\26'] = '\\Z',
}
local function mysqlEscape(s)
	return (tostring(s):gsub('[%z\n\r\'"\26]', MYSQL_ESC))
end
local function sqliteEscape(s)
	return sql.SQLStr(tostring(s), true)
end

local function translate(query)
	query = query:gsub('DELETE%s*%*%s+FROM', 'DELETE FROM')
	query = query:gsub('%)%s*ENGINE%s*=[^;]*', ')')
	query = query:gsub('%f[%w]UNSIGNED%f[%W]', '')
	query = query:gsub('"?%?"', '\1Q\1')
	query = query:gsub('"([^"\']*)"', "'%1'")
	query = query:gsub('\1Q\1', '"?"')
	return query
end

local function fillQuoted(query, args, escape, quote)
	local i = 0
	return (query:gsub('%?', function()
		i = i + 1
		local v = args[i]
		if (v == nil) then return 'NULL' end
		return quote .. escape(v) .. quote
	end))
end

local function fillRaw(query, args, escape, forceQuote)
	local i = 0
	return (query:gsub([[(["']?)%?(["']?)]], function(q1, q2)
		i = i + 1
		local v = args[i]
		if (v == nil) then return 'NULL' end
		if (q1 ~= '') and (q1 == q2) then
			local qq = forceQuote or q1
			return qq .. escape(v) .. qq
		end
		local s = tostring(v)
		if s:find('^%-?%d+%.?%d*$') then
			return q1 .. s .. q2
		end
		local qq = forceQuote or '"'
		return q1 .. qq .. escape(v) .. qq .. q2
	end))
end

local function splitArgs(...)
	local n = select('#', ...)
	local args = {...}
	local cback
	if isfunction(args[n]) then
		cback = args[n]
		args[n] = nil
	end
	return args, cback
end

local function convertValue(v)
	if (v == nil) or (v == 'NULL') then return nil end
	if isstring(v) then
		if v:find('^%-?%d+$') then
			if (#v <= 15) then return tonumber(v) end
		elseif v:find('^%-?%d+%.%d+$') and (#v <= 22) then
			return tonumber(v)
		end
	end
	return v
end

local function convertRows(res)
	if not istable(res) then return {} end
	for i = 1, #res do
		local row = res[i]
		for k, v in pairs(row) do
			row[k] = convertValue(v)
		end
	end
	return res
end

-- ========================= API =========================
local API = {}
API.__index = API
function API:IsConnected() return true end
function API:IsOffline() return false end
function API:Poll() end
function API:Disconnect() end
function API:Log(msg) log(self.Library .. ' => ' .. tostring(msg)) end
function API:Escape(v) return self._escape(v) end

function API:_final(spec)
	local query = spec.q
	if self._translate then query = translate(query) end
	if (spec.a == nil) then return query end
	if spec.raw then
		return fillRaw(query, spec.a, self._escape, self._forceQuote)
	end
	return fillQuoted(query, spec.a, self._escape, self._quote)
end

function API:_async(spec, cback)
	self:_run(self:_final(spec), cback)
end
function API:_sync(spec)
	local data, lastid, affected, time = self:_runSync(self:_final(spec))
	return data, lastid, affected, time
end

function API:Query(query, ...)
	local args, cback = splitArgs(...)
	self:_async({q = query, a = args}, cback)
end
function API:QuerySync(query, ...)
	local args = splitArgs(...)
	local data, lastid, affected, time = self:_sync({q = query, a = args})
	return (data or {}), lastid, affected, time
end
function API:Prepare(query)
	local db = self
	return setmetatable({Query = query}, {
		__call = function(s, ...) return db:Query(query, ...) end,
		__index = {
			Run      = function(s, ...) return db:Query(query, ...) end,
			RunSync  = function(s, ...) return db:QuerySync(query, ...) end,
			GetQuery = function() return query end,
		}
	})
end

function API:escape(v) return self._escape(v) end
function API:poll() end
function API:disconnect() end
function API:query(query, cback)
	self:_async({q = query}, cback)
end
function API:query_ex(query, options, cback)
	self:_async({q = query, a = options, raw = true}, cback)
end
function API:query_sync(query, options)
	return (self:_sync({q = query, a = options, raw = true}) or {})
end
function API:escape_dual(v)
	return mysqlEscape(v), sqliteEscape(v)
end
function API:query_dual(mysqlq, sqliteq, cback)
	self:query((self.Driver == 'sqlite') and sqliteq or mysqlq, cback)
end

-- ========================= SQLITE =========================
local SQLITE = setmetatable({}, API)
SQLITE.__index      = SQLITE
SQLITE.Driver       = 'sqlite'
SQLITE.Library      = 'sqlite'
SQLITE._quote       = "'"
SQLITE._forceQuote  = "'"
SQLITE._translate   = true
SQLITE._escape      = sqliteEscape

function SQLITE:Exec(query, silent)
	local start = SysTime()
	local res = sql.Query(query)
	if (res == false) then
		if not silent then
			local err = tostring(sql.LastError())
			logLimited('sqlite:' .. err:sub(1, 80), 'SQLite: ' .. err .. '  <=  ' .. query:sub(1, 200), 30)
		end
		return nil
	end
	local lastid, affected
	if WRITE[verbOf(query)] then
		lastid   = tonumber(sql.QueryValue('SELECT last_insert_rowid();'))
		affected = tonumber(sql.QueryValue('SELECT changes();'))
	end
	return convertRows(res), lastid, affected, SysTime() - start
end
function SQLITE:_runSync(query) return self:Exec(query) end
function SQLITE:_run(query, cback)
	local data, lastid, affected, time = self:Exec(query)
	if data and cback then
		timer.Simple(0, function() cback(data, lastid, affected, time) end)
	end
end

-- ========================= MYSQL BASE =========================
local MYSQLBASE = setmetatable({}, API)
MYSQLBASE.__index = MYSQLBASE
MYSQLBASE.Driver  = 'mysql'
MYSQLBASE._quote  = '"'
MYSQLBASE._escape = mysqlEscape

function MYSQLBASE:_connLost(err)
	self._dead = true
	if self._managed then return end
	logLimited('conn:' .. self._id, 'MySQL недоступен: ' .. tostring(err) .. ' (запросы пропускаются, переподключение каждые 15 сек)', 120, color_err)
	local tname = 'dbdriver.reconnect.' .. self._id
	if not timer.Exists(tname) then
		timer.Create(tname, 15, 0, function()
			self:Reconnect(function(ok)
				if ok then
					timer.Remove(tname)
					log('MySQL снова доступен.', color_ok)
				end
			end)
		end)
	end
end
function MYSQLBASE:_skip(cback, onfail)
	if onfail then return onfail('not connected') end
	logLimited('skip:' .. self._id, 'MySQL недоступен - запросы пропускаются.', 120)
	if cback then cback({}, nil, 0, 0) end
end

-- ========================= MYSQLOO =========================
local MYSQLOO = setmetatable({}, MYSQLBASE)
MYSQLOO.__index = MYSQLOO
MYSQLOO.Library = 'mysqloo'

function MYSQLOO:IsConnected()
	return (not self._dead) and (self._db:status() == mysqloo.DATABASE_CONNECTED)
end
function MYSQLOO:Reconnect(cb)
	if self._connecting then return end
	local st = self._db:status()
	if (st == mysqloo.DATABASE_CONNECTED) then
		self._dead = false
		self._connecting = true
		self:_run('SELECT 1', function()
			self._connecting = false
			if cb then cb(true) end
		end, function(err)
			self._connecting = false
			self._dead = true
			if cb then cb(false, err) end
		end, function()
			self._connecting = false
			if cb then cb(true) end
		end)
		return
	end
	if mysqloo.DATABASE_CONNECTING and (st == mysqloo.DATABASE_CONNECTING) then return end
	self._connecting = true
	self._db.onConnected = function()
		self._connecting = false
		self._dead = false
		if cb then cb(true) end
	end
	self._db.onConnectionFailed = function(_, err)
		self._connecting = false
		if cb then cb(false, err) end
	end
	local ok, err = pcall(function() self._db:connect() end)
	if not ok then
		self._connecting = false
		if cb then cb(false, err) end
	end
end
function MYSQLOO:_run(query, cback, onfail, onerror)
	if self._dead then return self:_skip(cback, onfail) end
	local q = self._db:query(query)
	q.onSuccess = function(_, data)
		if cback then cback(convertRows(data), q:lastInsert(), q:affectedRows(), 0) end
	end
	q.onError = function(_, err)
		if isConnErr(err) or (self._db:status() ~= mysqloo.DATABASE_CONNECTED) then
			self:_connLost(err)
			if onfail then onfail(err) end
			return
		end
		if onerror then return onerror(err) end
		logLimited('sql:' .. tostring(err):sub(1, 80), 'MySQL: ' .. tostring(err) .. '  <=  ' .. query:sub(1, 200), 30)
	end
	q:start()
end
function MYSQLOO:_runSync(query)
	if self._dead then return {}, nil, 0, 0, true end
	local data, lastid, affected, connfail
	local q = self._db:query(query)
	q.onSuccess = function(_, d)
		data, lastid, affected = convertRows(d), q:lastInsert(), q:affectedRows()
	end
	q.onError = function(_, err)
		if isConnErr(err) or (self._db:status() ~= mysqloo.DATABASE_CONNECTED) then
			connfail = true
			self:_connLost(err)
		else
			logLimited('sql:' .. tostring(err):sub(1, 80), 'MySQL: ' .. tostring(err) .. '  <=  ' .. query:sub(1, 200), 30)
		end
	end
	q:start()
	q:wait()
	return (data or {}), lastid, affected, 0, connfail
end
local function connectMySQLOO(cfg)
	local obj = setmetatable({}, MYSQLOO)
	dbdriver._n = dbdriver._n + 1
	obj._id = 'mysqloo' .. dbdriver._n
	obj._db = mysqloo.connect(cfg.host, cfg.user, cfg.pass, cfg.db, cfg.port or 3306)
	local connErr
	obj._db.onConnectionFailed = function(_, err) connErr = err end
	obj._db:connect()
	obj._db:wait()
	if (obj._db:status() == mysqloo.DATABASE_CONNECTED) then
		pcall(function() obj._db:setCharacterSet('utf8') end)
	else
		obj._dead = true
		obj._err = connErr
	end
	return obj
end

-- ========================= TMYSQL4 =========================
local TMYSQL = setmetatable({}, MYSQLBASE)
TMYSQL.__index = TMYSQL
TMYSQL.Library = 'tmysql4'

function TMYSQL:IsConnected()
	return (not self._dead) and (self._handle ~= nil)
end
function TMYSQL:Reconnect(cb)
	local handle, err = tmysql.initialize(self._cfg.host, self._cfg.user, self._cfg.pass, self._cfg.db, self._cfg.port or 3306)
	if handle and (not err) then
		self._handle = handle
		self._dead = false
		if cb then cb(true) end
	else
		if cb then cb(false, err) end
	end
end
function TMYSQL:_run(query, cback, onfail, onerror)
	if self._dead then return self:_skip(cback, onfail) end
	self._handle:Query(query, function(results)
		local r = (results and results[1]) or {}
		if r.error then
			if isConnErr(r.error) then
				self:_connLost(r.error)
				if onfail then onfail(r.error) end
			elseif onerror then
				onerror(r.error)
			else
				logLimited('sql:' .. tostring(r.error):sub(1, 80), 'MySQL: ' .. tostring(r.error) .. '  <=  ' .. query:sub(1, 200), 30)
			end
		elseif cback then
			cback(convertRows(r.data), r.lastid, r.affected, r.time)
		end
	end, rawget(_G, 'QUERY_FLAG_ASSOC'))
end
function TMYSQL:_runSync(query)
	if self._dead then return {}, nil, 0, 0, true end
	local data, lastid, affected, time, done, connfail
	self:_run(query, function(d, l, a, t)
		data, lastid, affected, time, done = d, l, a, t, true
	end, function() done, connfail = true, true end, function() done = true end)
	local deadline = SysTime() + 1
	while (not done) and (SysTime() < deadline) do
		self._handle:Poll()
	end
	return (data or {}), lastid, affected, time, connfail
end
local function connectTMySQL(cfg)
	local obj = setmetatable({}, TMYSQL)
	dbdriver._n = dbdriver._n + 1
	obj._id  = 'tmysql' .. dbdriver._n
	obj._cfg = cfg
	local handle, err = tmysql.initialize(cfg.host, cfg.user, cfg.pass, cfg.db, cfg.port or 3306)
	if handle and (not err) then
		obj._handle = handle
	else
		obj._dead = true
		obj._err = err
	end
	return obj
end

-- ========================= FAILOVER =========================
local FAILOVER = setmetatable({}, API)
FAILOVER.__index   = FAILOVER
FAILOVER.Driver    = 'mysql'
FAILOVER.Library   = 'failover'
FAILOVER._quote    = '"'
FAILOVER._escape   = mysqlEscape

local PAGE = 1000

function FAILOVER:IsConnected() return true end
function FAILOVER:IsOffline() return not self.Online end
function FAILOVER:Log(msg, col)
	MsgC(color_prefix, '[DB:' .. self.name .. '] ', col or color_text, tostring(msg) .. '\n')
end

function FAILOVER:_queueSize()
	local r = self.loc:Exec('SELECT COUNT(*) AS c FROM ' .. self._qt, true)
	return (r and r[1] and tonumber(r[1].c)) or 0
end
function FAILOVER:_enqueue(myq)
	self.loc:Exec("INSERT INTO " .. self._qt .. "(query, ts) VALUES('" .. sqliteEscape(myq) .. "', " .. os.time() .. ")", true)
end
function FAILOVER:_meta(key, value)
	if (value ~= nil) then
		self.loc:Exec("REPLACE INTO dbsync_meta(name, k, v) VALUES('" .. self.name .. "', '" .. key .. "', '" .. sqliteEscape(value) .. "')", true)
		return
	end
	local r = self.loc:Exec("SELECT v FROM dbsync_meta WHERE name='" .. self.name .. "' AND k='" .. key .. "'", true)
	return r and r[1] and r[1].v
end

function FAILOVER:_goOffline(err)
	self.Online = false
	self.Replaying = false
	self:StopSyncLoop()

	if (not self._announcedOffline) then
		self._announcedOffline = true
		local last = tonumber(self:_meta('last_snapshot'))
		self:Log('========================================================', color_err)
		self:Log('MySQL НЕДОСТУПЕН: ' .. tostring(err), color_err)
		self:Log('СЕРВЕР ПЕРЕШЁЛ НА SQLite (локальная база garrysmod/sv.db).', color_err)
		self:Log('Изменения сохраняются локально и будут автоматически перенесены в MySQL, когда он вернётся.', color_warn)
		self:Log('Локальная копия данных MySQL: ' .. (last and os.date('%d.%m.%Y %H:%M:%S', last) or 'ЕЩЁ НЕ СОЗДАВАЛАСЬ'), color_warn)
		self:Log('========================================================', color_err)
		hook.Run('dbdriver.Offline', self.name)
	end

	local tname = 'dbdriver.probe.' .. self._tid
	if not timer.Exists(tname) then
		timer.Create(tname, self.ProbeInterval, 0, function() self:_probe() end)
	end
end

function FAILOVER:_probe()
	if self.Online or self.Replaying then return end
	if self._probing and ((SysTime() - (self._probeStart or 0)) < 60) then return end
	self._probing    = true
	self._probeStart = SysTime()
	local ok, err = pcall(function()
		self.primary:Reconnect(function(connected, why)
			self._probing = false
			if connected then
				self:_recovered()
			else
				logLimited('probe:' .. self._tid, 'MySQL всё ещё недоступен (' .. tostring(why) .. '). Работаем на SQLite, проверка каждые ' .. self.ProbeInterval .. ' сек.', 600)
			end
		end)
	end)
	if not ok then
		self._probing = false
		logLimited('probeerr:' .. self._tid, 'Ошибка проверки MySQL: ' .. tostring(err), 600)
	end
end

function FAILOVER:_recovered()
	self:Log('MySQL снова доступен. Переношу накопленные изменения (' .. self:_queueSize() .. ' шт.)...', color_ok)
	self:_replay()
end

function FAILOVER:_replay()
	if self.Replaying then return end
	self.Replaying = true
	local function step()
		if not self.Replaying then return end
		local rows = self.loc:Exec('SELECT id, query FROM ' .. self._qt .. ' ORDER BY id LIMIT 1', true)
		local row = rows and rows[1]
		if not row then
			self.Replaying = false
			return self:_finishRecovery()
		end
		local function done()
			self.loc:Exec('DELETE FROM ' .. self._qt .. ' WHERE id=' .. row.id, true)
			step()
		end
		self.primary:_run(tostring(row.query), done, function(err)
			self:_goOffline(err)
		end, function(err)
			logLimited('replay:' .. tostring(err):sub(1, 60), 'Не удалось перенести запрос в MySQL (пропущен): ' .. tostring(err) .. '  <=  ' .. tostring(row.query):sub(1, 160), 30)
			done()
		end)
	end
	step()
end

function FAILOVER:_finishRecovery()
	self.Online = true
	timer.Remove('dbdriver.probe.' .. self._tid)

	if self._announcedOffline then
		self._announcedOffline = false
		self:Log('========================================================', color_ok)
		self:Log('MySQL ВОССТАНОВЛЕН. Все изменения перенесены, сервер снова работает на MySQL.', color_ok)
		self:Log('========================================================', color_ok)
		hook.Run('dbdriver.Online', self.name)
	else
		self:Log('Подключено к MySQL (режим failover: при сбое сервер перейдёт на SQLite).', color_ok)
	end

	self:ScheduleSync()
	self:StartSyncLoop()
end

-- ---- MySQL -> SQLite -------------------------------------------------
function FAILOVER:ScheduleSync()
	timer.Create('dbdriver.sync.' .. self._tid, 3, 1, function()
		if self.Online and (not self.Replaying) then self:SyncDown() end
	end)
end

function FAILOVER:StartSyncLoop()
	if (self.SyncInterval or 0) <= 0 then return end
	local tname = 'dbdriver.periodicsync.' .. self._tid
	if timer.Exists(tname) then return end
	timer.Create(tname, self.SyncInterval, 0, function()
		if self.Online and (not self.Replaying) and (not self.Syncing) then
			self:SyncDown()
		end
	end)
end
function FAILOVER:StopSyncLoop()
	timer.Remove('dbdriver.periodicsync.' .. self._tid)
	timer.Remove('dbdriver.sync.' .. self._tid)
end
function FAILOVER:SyncNow(cb)
	if not self.Online then if cb then cb(false) end return end
	self:SyncDown(cb)
end

function FAILOVER:Disconnect()
	self:StopSyncLoop()
	timer.Remove('dbdriver.probe.' .. self._tid)
	self.Replaying = false
	if self.primary and self.primary.Disconnect then self.primary:Disconnect() end
end

function FAILOVER:_storeRows(name, rows, fresh)
	local cols, seen = {}, {}
	for _, r in ipairs(rows) do
		for k in pairs(r) do
			if not seen[k] then seen[k] = true; cols[#cols + 1] = k end
		end
	end

	if (#cols == 0) then
		self.loc:Exec('DELETE FROM `' .. name .. '`', true)
		return
	end

	local head = 'REPLACE INTO `' .. name .. '`(`' .. table.concat(cols, '`,`') .. '`) VALUES '
	sql.Begin()
	if fresh and self.mirror[name] and (not self.mirror[name].pk) then
		self.loc:Exec('DELETE FROM `' .. name .. '`', true)
	end
	for i = 1, #rows, 100 do
		local vals = {}
		for j = i, math.min(i + 99, #rows) do
			local r, parts = rows[j], {}
			for c = 1, #cols do
				local v = r[cols[c]]
				if (v == nil) then
					parts[c] = 'NULL'
				elseif isnumber(v) then
					parts[c] = (v % 1 == 0) and string.format('%d', v) or string.format('%.17g', v)
				else
					parts[c] = "'" .. sqliteEscape(v) .. "'"
				end
			end
			vals[#vals + 1] = '(' .. table.concat(parts, ',') .. ')'
		end
		self.loc:Exec(head .. table.concat(vals, ','), true)
	end
	sql.Commit()
end

function FAILOVER:SyncDown(cb)
	if self.Syncing or (not self.Online) then if cb then cb(false) end return end

	local names = {}
	for name in pairs(self.mirror) do names[#names + 1] = name end
	table.sort(names)
	if (#names == 0) then if cb then cb(true) end return end

	self.Syncing = true
	local ti = 0

	local function finish(ok)
		self.Syncing = false
		if ok then
			self:_meta('last_snapshot', os.time())
			self:Log('Локальная копия MySQL обновлена (таблиц: ' .. #names .. ').', color_ok)
			hook.Run('dbdriver.Synced', self.name, #names)
		end
		if cb then cb(ok) end
	end

	local function nextTable()
		ti = ti + 1
		local name = names[ti]
		if not name then return finish(true) end

		local offset = 0
		local function page()
			if not self.Online then return finish(false) end
			self.primary:_run('SELECT * FROM `' .. name .. '` ORDER BY 1 LIMIT ' .. offset .. ',' .. PAGE, function(data)
				self:_storeRows(name, data, offset == 0)
				if (#data < PAGE) then return nextTable() end
				offset = offset + PAGE
				page()
			end, function(err)
				self:_goOffline(err)
				finish(false)
			end, function(err)
				logLimited('sync:' .. name, 'Не удалось скопировать таблицу ' .. name .. ': ' .. tostring(err), 300)
				nextTable()
			end)
		end
		page()
	end
	nextTable()
end

-- ---- выполнение запросов ---------------------------------------------
function FAILOVER:_mirror(spec)
	self.loc:Exec(self.loc:_final(spec), true)
end

function FAILOVER:_local(spec, myq, verb, cback)
	if (verb == 'CREATE') or (verb == 'ALTER') or (verb == 'DROP') then
		if (verb == 'CREATE') then self.loc:Exec(self.loc:_final(spec), true) end
		if cback then timer.Simple(0, function() cback({}, nil, 0, 0) end) end
		return
	end
	local data, lastid, affected, time = self.loc:Exec(self.loc:_final(spec))
	if data then
		if WRITE[verb] then self:_enqueue(myq) end
		if cback then timer.Simple(0, function() cback(data, lastid, affected, time) end) end
	end
end

function FAILOVER:_async(spec, cback)
	local myq  = self:_final(spec)
	local verb = verbOf(myq)
	if self.Online then
		self.primary:_run(myq, function(data, lastid, affected, time)
			if WRITE[verb] then self:_mirror(spec) end
			if cback then cback(data, lastid, affected, time) end
		end, function(err)
			self:_goOffline(err)
			self:_local(spec, myq, verb, cback)
		end)
	else
		self:_local(spec, myq, verb, cback)
	end
end

function FAILOVER:_sync(spec)
	local myq  = self:_final(spec)
	local verb = verbOf(myq)
	if self.Online then
		local data, lastid, affected, time, connfail = self.primary:_runSync(myq)
		if not connfail then
			if WRITE[verb] then self:_mirror(spec) end
			return data, lastid, affected, time
		end
		self:_goOffline('соединение потеряно во время запроса')
	end
	if (verb == 'CREATE') or (verb == 'ALTER') or (verb == 'DROP') then
		if (verb == 'CREATE') then self.loc:Exec(self.loc:_final(spec), true) end
		return {}, nil, 0, 0
	end
	local data, lastid, affected, time = self.loc:Exec(self.loc:_final(spec))
	if data and WRITE[verb] then self:_enqueue(myq) end
	return (data or {}), lastid, affected, time
end

function FAILOVER:query_dual(mysqlq, sqliteq, cback)
	local function localRun()
		local data, lastid, affected, time = self.loc:Exec(sqliteq)
		if data ~= nil then
			self:_enqueue(mysqlq)
			if cback then timer.Simple(0, function() cback(data, lastid, affected, time) end) end
		end
	end
	if self.Online then
		self.primary:_run(mysqlq, function(data, lastid, affected, time)
			self.loc:Exec(sqliteq, true)
			if cback then cback(data, lastid, affected, time) end
		end, function(err)
			self:_goOffline(err)
			localRun()
		end)
	else
		localRun()
	end
end

local function newFailover(cfg, primary)
	dbdriver._n = dbdriver._n + 1
	local o = setmetatable({}, FAILOVER)
	o.primary  = primary
	o.loc      = setmetatable({}, SQLITE)
	o.name     = cfg.name or cfg.style or 'db'
	o.mirror   = {}
	o._tid     = o.name .. dbdriver._n
	o._qt      = 'dbsync_queue_' .. tostring(o.name):gsub('[^%w_]', '_')
	o.ProbeInterval = (primary.Library == 'tmysql4') and 60 or 15
	o.SyncInterval  = tonumber(cfg.syncInterval) or 300
	o.Online   = false
	primary._managed = true

	o.loc:Exec('CREATE TABLE IF NOT EXISTS ' .. o._qt .. ' (id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT, ts INTEGER)', true)
	o.loc:Exec('CREATE TABLE IF NOT EXISTS dbsync_meta (name TEXT, k TEXT, v TEXT, PRIMARY KEY (name, k))', true)

	if primary:IsConnected() then
		o._announcedOffline = (o:_queueSize() > 0)
		o:_replay()
		o:ScheduleSync()
		o:StartSyncLoop()
	else
		o:_goOffline(primary._err or 'не удалось подключиться при старте')
	end
	return o
end

-- ========================= Подключение =========================
local function hasTMySQL()
	if (rawget(_G, 'tmysql') == nil) then pcall(require, 'tmysql4') end
	return (rawget(_G, 'tmysql') ~= nil)
end
local function hasMySQLOO()
	if (rawget(_G, 'mysqloo') == nil) then pcall(require, 'mysqloo') end
	return (rawget(_G, 'mysqloo') ~= nil)
end
local function newSQLite()
	return setmetatable({}, SQLITE)
end

function dbdriver.Connect(cfg)
	local mode = cfg.mode or 'mysql'
	local lib  = cfg.library or 'auto'

	if (mode == 'sqlite') then
		log('Режим sqlite: используется локальная база garrysmod/sv.db.')
		return newSQLite()
	end

	local order = (mode == 'failover') and {'mysqloo', 'tmysql4'} or {'tmysql4', 'mysqloo'}
	local primary
	for _, name in ipairs(order) do
		if ((lib == 'auto') or (lib == name)) and (not (primary and primary:IsConnected())) then
			local obj
			if (name == 'mysqloo') and hasMySQLOO() then obj = connectMySQLOO(cfg) end
			if (name == 'tmysql4') and hasTMySQL()    then obj = connectTMySQL(cfg)  end
			if obj and ((not primary) or obj:IsConnected()) then primary = obj end
		end
	end

	if (not primary) then
		log('Не найден модуль MySQL (' .. ((lib == 'auto') and 'mysqloo / tmysql4' or lib) .. ') в garrysmod/lua/bin. Используется SQLite.', color_err)
		return newSQLite()
	end

	if (mode == 'failover') then
		return newFailover(cfg, primary)
	end

	if primary:IsConnected() then
		log('MySQL подключён (' .. primary.Library .. '): ' .. tostring(cfg.db) .. '@' .. tostring(cfg.host) .. ':' .. tostring(cfg.port or 3306), color_ok)
		return primary
	end

	if (mode == 'auto') then
		log('MySQL недоступен (' .. tostring(primary._err) .. ') - используется SQLite.', color_err)
		return newSQLite()
	end

	primary:_connLost(primary._err or 'не удалось подключиться')
	return primary
end

function dbdriver.EnsureSchema(db, statements)
	if not db then return end
	local target = (db.Driver == 'sqlite') and db or db.loc
	if not target then return end
	for _, q in ipairs(statements) do
		target:Exec(q)
		if db.mirror then
			local name = q:match('CREATE TABLE IF NOT EXISTS%s+`?([%w_]+)`?')
			if name then
				db.mirror[name] = {pk = (q:find('PRIMARY KEY', 1, true) ~= nil)}
			end
		end
	end
	if db.mirror and db.Online then
		db:ScheduleSync()
		db:StartSyncLoop()
	end
end