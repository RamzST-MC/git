-- leak by lordee
if (not CLIENT) then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

local zyb_LastHighlight = -1
local zyb_Halotable = {}
local trace
local traceEnt
function zyb.f.DrawHalo_Upgrades()
	if zyb.config.Upgrade.Cleaning then
		if CurTime() > zyb_LastHighlight then

			zyb_Halotable = {}

			trace = LocalPlayer():GetEyeTrace()
			traceEnt = trace.Entity

			if IsValid(traceEnt) and traceEnt:GetClass() == "zyb_upgrade" and traceEnt:GetNoDraw() == false and traceEnt:GetIsDirty() and zyb.f.InDistance(LocalPlayer():GetPos(), traceEnt:GetPos(), 200) then
				table.insert(zyb_Halotable, traceEnt)
			end

			zyb_LastHighlight = CurTime() + 0.1
		end


		halo.Add(zyb_Halotable, HSVToColor(math.abs(math.sin(CurTime()) * 180), 1, 1), 5, 5, 5, true, true)
	end
end

hook.Add("PreDrawHalos", "zyb_AddHalos", zyb.f.DrawHalo_Upgrades)
-- leak by lordee