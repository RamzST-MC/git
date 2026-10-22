wd_Config = {}
if CLIENT then
	-- The time is a bit weird, here are some presets: 10 is 8 seconds, 20 is 4 seconds, 40 is 2 seconds, 80 is 1 second, 160 is 0.5 seconds (there is a pattern).
	wd_Config["Time"] = 120 -- 120 is 0.75 seconds
	wd_Config["InnerColor"] = Color(20, 20, 20, 255)
	wd_Config["OuterColor"] = Color(255, 255, 255, 25)
	wd_Config["HilightColor"] = Color(255, 255, 255, 255)
	wd_Config["DrawLines"] = true
	--
	-- Below you add the name of any entity which is hackable, the name that should appear next to it and the vector offset (only change the third value).
	wdEntInfo = {}
	wdEntInfo["keypad"] = {"Кейпад", Vector(0, 0, 20)}
	--wdEntInfo["gmod_wire_keypad"] = {"Wire Keypad", Vector(0, 0, 20)}
	wdEntInfo["gmod_button"] = {"Кнопка", Vector(0, 0, 20)}
	wdEntInfo["gmod_lamp"] = {"Фонарь", Vector(0, 0, 20)}
	wdEntInfo["gmod_light"] = {"Лампочка", Vector(0, 0, 20)}
	wdEntInfo["gmod_wire_button"] = {"Wire Button", Vector(0, 0, 20)}
	wdEntInfo["gmod_dynamite"] = {"Dynamite", Vector(0, 0, 20)}
	wdEntInfo["wd_explosive"] = {"Взломать", Vector(0, 0, 20)}
	wdEntInfo["player"] = {"Человек", Vector(0, 0, 100)}
	wdEntInfo["weed_plant"] = {"Терминал", Vector(0, 0, 20)}
	wdEntInfo["gmod_cameraprop"] = {"Камера", Vector(0, 0, 20)}
	wdEntList = {}
	for k, v in pairs(wdEntInfo) do
		table.insert(wdEntList, k)
	end

	-- Defining these after so they don't get classes as hackable ents.
	wdEntInfo["wd_signal_amplifier"] = {"Signal Amplifier", Vector(0, 0, 20)}
	wdEntInfo["wd_power_booster"] = {"Power Booster", Vector(0, 0, 20)}
end

wd_Config["HackRange"] = 400
if SERVER then
	wd_Config["Time"] = 0.75 -- Set according to the clientside time.
	wd_Config["HackCooldown"] = 35 -- The cooldown when hacking
	wd_Config["EmpCooldown"] = 100 -- The cooldown for the emp
	-- Below you add the name of any entity which is hackable and the code that it should run on the server if successful.
	wdEntInfo = {}
	local function ExplodeEnt(ent, ply, rds, dmg, remove)
		ent:EmitSound("weapons/c4/c4_beep1.wav", 100, 100)
		timer.Simple(2, function()
			if not ent:IsValid() then return end
			local effectdata = EffectData()
			effectdata:SetOrigin(ent:GetPos())
			util.Effect("HelicopterMegaBomb", effectdata)
			util.Effect("Explosion", effectdata)
			util.BlastDamage(ent, ply, ent:GetPos(), rds, dmg)
			if remove == true then ent:Remove() end
		end)
	end

	wdEntInfo["keypad"] = function(ent, ply)
		ent:Process(ent.KeypadData.Password)
		--print(ent.KeypadData.Password)
		--ply:ChatPrint('Вы взломали KeyPad! Пороль: ' .. ent.KeypadData.Password)
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["weed_plant"] = function(ent, pl)
		pl.Hack_Money = pl.Hack_Money or 0
		if CurTime() > pl.Hack_Money + 120 then
			if ent:GetNWBool('Guard') == true then
				rp.Notify(pl, NOTIFY_ERROR, 'Защита слишком сильная! Вы не сможете это взломать!')
				return false
			end

			pl.Hack_Money = CurTime()
		else
			rp.Notify(pl, NOTIFY_SUCCESS, "Подождите еще " .. string.FormattedTime(120 - math.abs(pl.Hack_Money - CurTime()), " %02iм:%02iс") .. " до следующего взлома.")
		end
	end

	wdEntInfo["keypad_wire"] = wdEntInfo["keypad"]
	wdEntInfo["gmod_wire_button"] = function(ent, ply)
		if ent.Value == ent.value_on then
			ent:Switch(false)
		else
			ent:Switch(true)
		end

		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["gmod_button"] = function(ent, ply)
		ent:Toggle(not ent:GetOn())
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["gmod_light"] = function(ent, ply)
		ent:Toggle(not ent:GetOn())
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["gmod_lamp"] = function(ent, ply)
		ent:Toggle(not ent:GetOn())
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["gmod_dynamite"] = function(ent, ply)
		ent:Explode()
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect("cball_explode", effectdata)
		ent:EmitSound("buttons/button19.wav", 100, 100)
	end

	wdEntInfo["wd_explosive"] = function(ent, ply)
		--ent:Explode()
		ply.PoliceCount = 0
		for k, v in pairs(player.GetAll()) do
			if v:IsCP() then ply.PoliceCount = ply.PoliceCount + 1 end
		end

		if ply.PoliceCount < 3 then
			rp.Notify(ply, NOTIFY_ERROR, 'Слишком мало полиции для ограбления')
			return false
		end

		if ent.HackOff == false then
			ply:ChatPrint('Сервер уже взломан, попробуйте позже!')
			return false
		else
			local Money = math.random(3000, 15000)
			for k, v in pairs(ents.GetAll()) do
				if tostring(v):find('br_money') then
					print(v)
					v:SetNWFloat("BANK_AMOUNT", v:GetNWFloat('BANK_AMOUNT') - Money)
				end
			end

			ent:SetSkin(1)
			ply:Wanted(nil, 'Взлом сервера')
			ply:AddMoney(Money)
			rp.Notify(ply, NOTIFY_ERROR, 'Ты получил за взлом # $', tostring(Money))
			ent.HackOff = false
			timer.Simple(600, function()
				ent.HackOff = true
				ent:SetSkin(0)
			end)
		end
	end

	wdEntInfo["player"] = function(ent, ply)
		if ent.HackOff == false then
			rp.Notify(ply, NOTIFY_ERROR, 'Ты уже украл у этого человека деньги, оставь его!')
			return false
		else
			local money = math.random(500, 1000)
			if ent:GetMoney() < 10000 then return false end
			ent:TakeMoney(money)
			ply:AddMoney(money)
			if ent:InSpawn() or ply:InSpawn() then
				ply:Notify(NOTIFY_ERROR, 'Нельзя красть на спавне')
				return
			end

			if ply:GetJob() ~= TEAM_KARMAN then
				ply:Notify(NOTIFY_ERROR, 'Нельзя красть за эту профессию!')
				return
			end

			rp.Notify(ply, NOTIFY_ERROR, 'Ты украл #$', tostring(money))
			rp.Notify(ent, NOTIFY_ERROR, 'У вас украли #$', tostring(money))
			ent.HackOff = false
			timer.Simple(180, function() ent.HackOff = true end)
		end
	end

	wdEntInfo["gmod_cameraprop"] = function(ent, ply)
		function ent:Explode()
			self:EmitSound("weapons/c4/c4_beep1.wav", 200, 200)
			if not self:IsValid() then return end
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(vPoint)
			effectdata:SetOrigin(vPoint)
			effectdata:SetScale(1)
			util.Effect("HelicopterMegaBomb", effectdata)
			self:EmitSound("weapon_AWP.Single", 400, 400)
			self:Remove()
		end

		ent:Explode()
	end

	wdEntInfo["wd_signal_amplifier"] = function(ent, ply) end
	wdEntInfo["wd_power_booster"] = function(ent, ply) end
	wdEntList = {}
	for k, v in pairs(wdEntInfo) do
		table.insert(wdEntList, k)
	end
end