-- leak by lordee-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Condenser_Initialize(condenser)
	condenser.IsBusy = false

	condenser.Distillery = nil
	condenser.Cooler = nil

	condenser.LastThink = 1

	condenser.LastWear = -1

	// The Jar we are filling right now
	condenser.Jar = nil
	condenser.JarQueue = {
		[1] = {
			ent = nil,
			forward = -10,
			right = -25
		},
		[2] = {
			ent = nil,
			forward = -10,
			right = -40
		},
		[3] = {
			ent = nil,
			forward = 10,
			right = -25
		},
		[4] = {
			ent = nil,
			forward = 10,
			right = -40
		},
	}
	condenser.JarInQueueCount = 0

	// UpgradeStuff
	condenser.InstalledUpgrades = {}

	zyb.f.Condenser_SetupUpgrades(condenser)

	zyb.f.EntList_Add(condenser)
end

function zyb.f.Condenser_OnTouch(condenser,other)
	if not IsValid(other) then return end
	if zyb.f.CollisionCooldown(other) then return end

	if other:GetClass() == "zyb_jarpack" and condenser.JarInQueueCount < 4 then

		zyb.f.Condenser_AddJarToQueue(condenser,other)
	end
end

function zyb.f.Condenser_OnUse(condenser,ply)
	if (zyb.config.EquipmentSharing == true or zyb.f.IsOwner(ply, condenser)) and condenser:OnUpgradeMenu(ply) then
		// Open upgrade interface
		zyb.f.Condenser_OpenUpgradeMenu(ply, condenser)
	end
end

function zyb.f.Condenser_SetupUpgrades(condenser)
	condenser.UpgradeEnts = {}

	for i = 1, 3 do
		local ent = ents.Create("zyb_upgrade")
		local attach = condenser:GetAttachment(i)
		local angle = attach.Ang

		angle:RotateAroundAxis(condenser:GetUp(), 90)

		ent:SetAngles(angle)
		ent:SetPos(attach.Pos)
		ent:Spawn()
		ent:Activate()
		ent:SetModel("models/zerochain/props_yeastbeast/yb_distillery_filter.mdl")
		ent:SetParent(condenser)
		ent:SetNoDraw(true)

		condenser.UpgradeEnts[i] = ent
		ent.Condenser = condenser
	end

	zyb.f.UpdateCondenserEntity(condenser)
end



function zyb.f.Condenser_CondensingProcess(condenser)

	if condenser:GetWeakMoonShine() > 0 and condenser:GetMoonShine() < zyb.config.Condenser.MoonshineStorage then

		// The work amount of weakmoonshine we use
		local workAmount = zyb.config.Condenser.ProcessAmount

		// Here we remove the weakmoonshine
		condenser:SetWeakMoonShine(math.Clamp(condenser:GetWeakMoonShine() - workAmount,0,zyb.config.Condenser.WeakMoonshineStorage))

		workAmount = workAmount *  (1 + condenser:GetProductionBoost())

		local moonshine = workAmount * zyb.config.Condenser.CondenseAmount
		condenser:SetMoonShine(math.Clamp(condenser:GetMoonShine() + moonshine,0,zyb.config.Condenser.MoonshineStorage))

		zyb.f.CreateNetEffect("sfx_condensing",condenser)

		if CurTime() > condenser.LastWear and zyb.config.Upgrade.Cleaning then

			zyb.f.Condenser_UpgradeWearing(condenser)
			condenser.LastWear = CurTime() + zyb.config.Upgrade.Dirty_Interval
		end
	end
end

function zyb.f.Condenser_FillProcess(condenser)
	if IsValid(condenser.Jar) then

		local moveAmount = zyb.config.Jar.MoonshineAmount / 5
		local moonshine = condenser:GetMoonShine()

		if moonshine >= moveAmount then

			condenser:SetFillingJar(true)

			condenser.Jar:SetMoonShine(math.Clamp(condenser.Jar:GetMoonShine() + moveAmount,0,zyb.config.Jar.MoonshineAmount))
			condenser:SetMoonShine(math.Clamp(condenser:GetMoonShine() - moveAmount,0,zyb.config.Condenser.MoonshineStorage))

			condenser.Jar:UpdateVisuals()

			local jarMoonshine = condenser.Jar:GetMoonShine()
			local jarMax = zyb.config.Jar.MoonshineAmount

			if jarMoonshine >= jarMax then
				zyb.f.Condenser_RemoveJar(condenser)
			end
		else
			condenser:SetFillingJar(false)
		end
	else
		if condenser.JarInQueueCount > 0 then
			// We have a empty jar in the queue so lets take that
			zyb.f.Condenser_TakeEmptyJarFromQueue(condenser)
		end
	end
end



function zyb.f.Condenser_TakeEmptyJarFromQueue(condenser)
	for k, v in pairs( condenser.JarQueue ) do
		if IsValid(v.ent) then
			zyb.f.Condenser_AddEmptyJar(condenser,v.ent)
			v.ent = nil
			condenser.JarInQueueCount = condenser.JarInQueueCount - 1
			break
		end
	end
end

function zyb.f.Condenser_UpgradeWearing(condenser)
	if zyb.f.RandomChance(zyb.config.Upgrade.Dirty_Chance) then
		zyb.f.Debug("Module Wearing!")
		for k, v in pairs( condenser.UpgradeEnts ) do
			if IsValid(v) and v:GetNoDraw() == false and v:GetIsDirty() == false then
				v:SetSkin(1)
				v:SetIsDirty(true)
				zyb.f.UpdateBoostValues(condenser)
				break
			end
		end
	end
end



function zyb.f.Condenser_AddEmptyJar(condenser,jar)
	jar:SetParent(nil)
	condenser.Jar = jar
	condenser.Jar.Condenser = condenser

	DropEntityIfHeld(jar)
	local ang = condenser:GetAngles()
	ang:RotateAroundAxis(condenser:GetUp(), -90)

	condenser.Jar:SetAngles(ang)

	condenser.Jar:SetPos(condenser:GetPos() + condenser:GetUp() * 26 + condenser:GetRight() * -31)
	condenser.Jar:SetParent(condenser)
end



function zyb.f.Condenser_AddJarToQueue(condenser,jarpack)
	local freeSpot
	for k, v in pairs( condenser.JarQueue ) do
		if not IsValid(v.ent) then
			freeSpot = k
			break
		end
	end

	if freeSpot then
		jarpack:SetJarCount(jarpack:GetJarCount() - 1)

		if jarpack:GetJarCount() <= 0 then
			jarpack:Remove()
		end

		local ent = ents.Create("zyb_jar")
		ent:SetAngles(condenser:GetAngles())
		ent:SetPos(condenser:GetPos())
		ent:Spawn()
		ent:Activate()

		condenser.JarQueue[freeSpot].ent = ent
		local ang = condenser:GetAngles()
		ang:RotateAroundAxis(condenser:GetUp(), -90)
		ent:SetAngles(ang)

		ent:SetPos(condenser:GetPos() + condenser:GetUp() * 26 + condenser:GetRight() * condenser.JarQueue[freeSpot].right + condenser:GetForward() * condenser.JarQueue[freeSpot].forward)
		ent:SetParent(condenser)

		zyb.f.CreateNetEffect("sfx_jar",condenser)

		condenser.JarInQueueCount = condenser.JarInQueueCount + 1
	end
end

// If the Jar is full then we remove it from the Condenser
function zyb.f.Condenser_RemoveJar(condenser)
	if not IsValid(condenser.Jar) then return end
	condenser.Jar:SetParent(nil)
	condenser.Jar:SetPos(condenser:GetPos() + condenser:GetUp() * 26 + condenser:GetRight() * -65)
	condenser.Jar.Condenser = nil
	condenser.Jar = nil
	condenser:SetFillingJar(false)

	// Custom Hook
	hook.Run("zyb_OnMoonshineProduced" ,condenser)
end











util.AddNetworkString("zyb_UpgradeMenu_Open_net")
util.AddNetworkString("zyb_UpgradeMenu_ForceClose_net")

util.AddNetworkString("zyb_UpgradeMenu_Buy_net")
util.AddNetworkString("zyb_UpgradeMenu_Sell_net")

function zyb.f.Condenser_OpenUpgradeMenu(ply, condenser)
	local boardString = util.TableToJSON(condenser.InstalledUpgrades)
	local boardCompressed = util.Compress(boardString)

	net.Start("zyb_UpgradeMenu_Open_net")
	net.WriteEntity(condenser)
	net.WriteUInt(#boardCompressed, 16)
	net.WriteData(boardCompressed, #boardCompressed)
	net.Send(ply)
	zyb.f.Debug("zyb.f.OpenUpgradeMenu")
end

function zyb.f.ForceClose_UpgradeMenu(ply)
    net.Start("zyb_UpgradeMenu_ForceClose_net")
    net.Send(ply)
end

net.Receive("zyb_UpgradeMenu_Buy_net", function(len, ply)
    if zyb.f.Player_Timeout(ply) then return end
    local ent = net.ReadEntity()
    local u_id = net.ReadInt(16)

    if IsValid(ent) and ent:GetClass() == "zyb_distillery_condenser" and IsValid(ply) and zyb.f.InDistance(ply:GetPos(), ent:GetPos(), 200) then
        zyb.f.UpgradeMenu_Buy(ply, ent, u_id)
    end
end)

function zyb.f.UpgradeMenu_Buy(ply, condenser,uID)

    if table.Count(condenser.InstalledUpgrades) >= 3 then
        return
    end

    if zyb.config.Upgrade.Stacking == false and zyb.f.HasModuleType(condenser.InstalledUpgrades,uID) then
        return
    end


    local UpgradeData = zyb.config.Upgrades[uID]

    if UpgradeData == nil then return end

    // Check the rank
    if zyb.f.RankCheck(ply,UpgradeData.u_ranks) == false then
        zyb.f.Notify(ply, zyb.language.General["WrongUserGroup"], 1)
        return
    end

    if not zyb.f.HasMoney(ply, UpgradeData.u_price) then
        zyb.f.Notify(ply, zyb.language.General["NoMoney"], 1)
        return
    end

    zyb.f.TakeMoney(ply, UpgradeData.u_price)

    local buyInfo = zyb.language.General["BuyInfo"]
    buyInfo = string.Replace(buyInfo, "$ItemName", UpgradeData.u_name)
    buyInfo = string.Replace(buyInfo, "$Currency", zyb.config.Currency)
    buyInfo = string.Replace(buyInfo, "$ItemPrice", UpgradeData.u_price)
    zyb.f.Notify(ply, buyInfo, 0)

    table.insert(condenser.InstalledUpgrades, uID)

    condenser:EmitSound("zyb_cash")

    zyb.f.UpdateCondenserEntity(condenser)
end




net.Receive("zyb_UpgradeMenu_Sell_net", function(len, ply)
    if zyb.f.Player_Timeout(ply) then return end
    local ent = net.ReadEntity()
    local u_idPos = net.ReadInt(16)
    if IsValid(ent) and ent:GetClass() == "zyb_distillery_condenser" and IsValid(ply) and zyb.f.InDistance(ply:GetPos(), ent:GetPos(), 200) then
        zyb.f.UpgradeMenu_Sell(ply, ent,u_idPos)
    end
end)

function zyb.f.UpgradeMenu_Sell(ply, condenser,u_idPos)

    local UpgradeData = zyb.config.Upgrades[condenser.InstalledUpgrades[u_idPos]]

    if UpgradeData == nil then return end

    zyb.f.GiveMoney(ply, UpgradeData.u_price)

    local sellInfo = zyb.language.General["SellInfo"]
    sellInfo = string.Replace(sellInfo, "$ItemName", UpgradeData.u_name)
    sellInfo = string.Replace(sellInfo, "$Currency", zyb.config.Currency)
    sellInfo = string.Replace(sellInfo, "$ItemPrice", UpgradeData.u_price)
    zyb.f.Notify(ply, sellInfo, 0)

    table.remove(condenser.InstalledUpgrades, u_idPos )

    condenser:EmitSound("zyb_cash")

    zyb.f.UpdateCondenserEntity(condenser)
end


function zyb.f.UpdateCondenserEntity(condenser)
    for i = 1, 3 do
		if not IsValid(condenser.UpgradeEnts[i]) then continue end
        condenser.UpgradeEnts[i]:SetNoDraw(true)
        condenser.UpgradeEnts[i]:SetUpgradeID(-1)
        condenser.UpgradeEnts[i]:SetIsDirty(false)
        condenser.UpgradeEnts[i]:SetSkin(0)
    end

    for i = 1, table.Count(condenser.InstalledUpgrades) do
		if not IsValid(condenser.UpgradeEnts[i]) then continue end

        local u_data = zyb.config.Upgrades[condenser.InstalledUpgrades[i]]
        condenser.UpgradeEnts[i]:SetUpgradeID(condenser.InstalledUpgrades[i])
        condenser.UpgradeEnts[i]:SetNoDraw(false)
        condenser.UpgradeEnts[i]:SetColor(u_data.u_color)
    end

    // This recalculates the speedboost/ProductionBoost value once we updated it
    zyb.f.UpdateBoostValues(condenser)
end

function zyb.f.UpdateBoostValues(condenser)
    local speedBoost = 0
    local productionBoost = 0

    for k, v in pairs(condenser.UpgradeEnts) do
        if IsValid(v) and v:GetNoDraw() == false then
            local val = v:GetUpgradeID()
            local boostAmount = zyb.config.Upgrades[val].u_amount
            // 416932157

            if v:GetIsDirty() then
                boostAmount = boostAmount / 2
            end

            zyb.f.Debug(zyb.config.Upgrades[val].u_name .. " | BoostAmount: " .. boostAmount .. " | IsDirty: " .. tostring(v:GetIsDirty()) .. " | FinalBoostAmount: " .. boostAmount)


            if zyb.config.Upgrades[val].u_type == 1 then
                speedBoost = speedBoost + boostAmount
            elseif zyb.config.Upgrades[val].u_type == 2 then
                productionBoost = productionBoost + boostAmount
            end
        end
    end

    condenser:SetSpeedBoost(speedBoost)
    condenser:SetProductionBoost(productionBoost)
end
-- leak by lordee