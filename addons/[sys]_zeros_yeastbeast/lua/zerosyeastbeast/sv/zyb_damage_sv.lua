-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Entity_OnTakeDamage(ent,dmg)
	ent:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local class = ent:GetClass()
	local entHealth = zyb.config.Damageable[class]

	if entHealth and entHealth > 0 then
		ent.CurrentHealth = (ent.CurrentHealth or entHealth) - damage

		if (ent.CurrentHealth <= 0) then

			// Call a custom hook
			hook.Run("zyb_OnObjectDestroyed",ent,dmg)

			if class == "zyb_distillery" then
				local cooler = ent:GetCooler()
				local condenser = ent:GetCondenser()

				zyb.f.CreateNetEffect("boiler_destroyed",ent)

				if IsValid(cooler) then
					SafeRemoveEntity(cooler)
				end

				if IsValid(condenser) then
					SafeRemoveEntity(condenser)
				end
			end

			SafeRemoveEntity(ent)
		end
	end
end
-- leak by lordee