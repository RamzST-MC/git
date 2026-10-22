rp.RegisterEvent('Паркур', {
	NiceName = 'Parkour Event',
	Hooks = {
		['PlayerSpawn'] = function(pl)
			pl:Give('climb_swep')
		end,
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('climb_swep')
		end
	end,
})

rp.RegisterEvent('Vape', {
	NiceName = 'Vape Event',
	Hooks = {
		['PlayerSpawn'] = function(pl)
			pl:Give('weapon_vape')
		end,
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('weapon_vape')
		end
	end,
})

rp.RegisterEvent('Guns', {
	NiceName = 'Guns Event',
	Hooks = {
		['PlayerSpawn'] = function(pl)
			pl:Give('bb_xm1014_alt')
			pl:Give('weapon_shield')
			pl:Give('bb_m4a1_alt')
			pl:Give('weapon_taser')
		end,
	},
	OnStart = function()
		for k, pl in ipairs(player.GetAll()) do
			pl:Give('bb_xm1014_alt')
			pl:Give('weapon_shield')
			pl:Give('bb_m4a1_alt')
			pl:Give('weapon_taser')
		end
	end,
})

rp.RegisterEvent('VIP', {
	NiceName = 'VIP Event',
	Hooks = {
		['PlayerVIPCheck'] = function(pl)
			return true
		end,
	}
})

rp.RegisterEvent('Salary', {
	NiceName = 'Salary',
	Hooks = {
		['PlayerPayDay'] = function(pl, salary)
			return (salary * 2)
		end,
	}
})

rp.RegisterEvent('BURGATRON', {
	NiceName = 'BURGATRON',
	Hooks = {
		['PlayerHasHunger'] = function(pl)
			if (pl.HungerImmune) then return false end
		end,
		['PlayerSpawn'] = function(pl)
			pl:Give('weapon_burgatron')
		end,
		['PlayerDeath'] = function(pl)
			pl.HungerImmune = nil
		end,
		['KeyPress'] = function(pl, key)
			if (key == IN_USE) then
				local tr = pl:GetEyeTrace()

				if (tr.Entity and tr.Entity:IsPlayer() and tr.Entity.IsBurger) then
					tr.Entity:Kill();

					pl.HungerImmune = true;

					pl:EmitSound("vo/sandwicheat09.wav", 100, 100)
					
					pl:Notify(NOTIFY_GREEN, term.Get('BURGHungerImmune'))
					tr.Entity:Notify(NOTIFY_GREEN, term.Get('BURGNotPeople'))
				end
			end
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give("weapon_burgatron");
		end
	end,
	OnEnd = function()
		for k, v in ipairs(player.GetAll()) do
			if (v:GetActiveWeapon():IsValid() and v:GetActiveWeapon():GetClass() == "weapon_burgatron") then
				v:SelectWeapon("weapon_physgun")
			end

			v.HungerImmune = nil
			if (not v:IsRoot()) then
				v:StripWeapon("weapon_burgatron")
			end
		end
	end
})