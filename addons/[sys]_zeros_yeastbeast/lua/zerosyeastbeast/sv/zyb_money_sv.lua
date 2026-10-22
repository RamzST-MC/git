-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.GiveMoney(ply, money)
	-- Give the player the Cash
	if (DarkRP) then
		ply:addMoney(money)
	elseif (nut) then
		ply:getChar():giveMoney(money)
	elseif (BaseWars) then
		ply:GiveMoney(money)
	end
end

function zyb.f.TakeMoney(ply, money)
	-- Give the player the Cash
	if (DarkRP) then
		ply:addMoney(-money)
	elseif (nut) then
		ply:getChar():takeMoney(money)
	elseif (BaseWars) then
		ply:GiveMoney(-money)
	end
end

function zyb.f.HasMoney(ply, money)

	if (DarkRP) then
		if ((ply:getDarkRPVar("money") or 0) >= money) then
			return true
		else
			return false
		end
	elseif (nut) then
		if (ply:getChar():hasMoney(money)) then
			return true
		else
			return false
		end
	elseif (BaseWars) then
		if ((ply:GetMoney() or 0) >= money) then
			return true
		else
			return false
		end
	elseif ( engine.ActiveGamemode() == "sandbox") then
		return true
	end
end

// Returns the formated money as string
function zyb.f.Money_Format(money)
	if not money then return "0" end
	money = tostring(math.abs(money))
	local sep = ","
	local dp = string.find(money, "%.") or #money + 1

	for i = dp - 4, 1, -3 do
		money = money:sub(1, i) .. sep .. money:sub(i + 1)
	end

	return money
end

function zyb.f.Money_Display(money)
	return zyb.f.Money_Format(money) .. zyb.config.Currency
end
-- leak by lordee