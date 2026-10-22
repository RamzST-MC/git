local n = {}
local t = {}
t["[C]"] = true
t["RunString"] = true
t["RunStringEx"] = true
t["CompileString"] = true
t["LuaCmd"] = true

local function r(e)
    local e = string.sub(jit.util.funcinfo(e).source, 2)
    if t[e] or n[e] then return end
    n[e] = true
    net.Start("__Detect")
    net.WriteString(e)
    net.SendToServer()
end

local ok, err = pcall(jit.attach, r, "bc")
if not ok then
    MsgC(Color(255,165,0), "[AntiGluaLoader] jit.attach unavailable: " .. tostring(err) .. "\n")
end