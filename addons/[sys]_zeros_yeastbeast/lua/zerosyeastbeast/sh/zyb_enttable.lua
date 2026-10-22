-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}


// List of all the zyb Entities on the server
if zyb.EntList == nil then
	zyb.EntList = {}
end

function zyb.f.EntList_Add(ent)
	table.insert(zyb.EntList, ent)
end
-- leak by lordee