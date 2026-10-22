-- leak by lordee-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.NPC_OnUse(npc,ply)
    zyb.f.SellMoonshine(npc,ply)
end


hook.Add( "EntityTakeDamage", "zyb_EntityTakeDamage_NPCFix", function( target, dmginfo )
	if IsValid(target) and target:GetClass() == "zyb_buyer_npc" then
		return true
	end
end )

function zyb.f.IsMoonshineProducer(ply)
    if BaseWars then
        return true
    else
        if table.Count(zyb.config.MoonShine_Customer) > 0 then
            if zyb.config.MoonShine_Customer[zyb.f.GetPlayerJob(ply)] then
                return true
            else
                return false
            end
        else
            return true
        end
    end
end

function zyb.f.SellMoonshine(npc,ply)
    if ply:Team() == TEAM_DISTILLER then

        local jarCount = 0

        if zyb.config.NPC.SellMode == 1 then
            // Get all the moonshine near the npc

            for k,v in pairs(zyb.EntList) do
                if IsValid(v) and zyb.f.InDistance(npc:GetPos(), v:GetPos(), 300) then

                    if v:GetClass() == "zyb_jarcrate" and v:GetJarCount() > 0 then

                        jarCount = jarCount + v:GetJarCount()
                        zyb.f.CreateNetEffect("vfx_sell",v:GetPos())
                        SafeRemoveEntity(v)

                    elseif v:GetClass() == "zyb_palette" and v:GetCrateCount() > 0 then

                        jarCount = jarCount + (v:GetCrateCount() * 6)
                        zyb.f.CreateNetEffect("vfx_sell",v:GetPos())
                        SafeRemoveEntity(v)
                    end
                end
            end

        elseif zyb.config.NPC.SellMode == 2 then
            jarCount = ply:zyb_GetMoonshineJars()
        end

        if jarCount > 0 then

            local earning = jarCount * npc:GetPrice()

            earning = hook.Run("zyb_PreMoonshineSell",ply,earning)

            zyb.f.GiveMoney(ply, earning)

            // Custom Hook
            hook.Run("zyb_OnMoonshineSold" ,ply, npc, earning, jarCount)

            local sellInfo = zyb.language.NPC["SellInfo"]
            sellInfo = string.Replace(sellInfo, "$Amount", jarCount)
            sellInfo = string.Replace(sellInfo, "$Currency", zyb.config.Currency)
            sellInfo = string.Replace(sellInfo, "$MoneyAmount", earning)
            zyb.f.Notify(ply, sellInfo, 0)

            npc:EmitSound("zyb_npc_sell")

            ply:zyb_AddMoonshineJarSold(jarCount)
            ply:zyb_Reset_MoonshineJar()
        else
            zyb.f.Notify(ply, zyb.language.NPC["NoMoonshine"], 1)
            npc:EmitSound("zyb_npc_wrongjob")
        end

    else
        zyb.f.Notify(ply,zyb.language.NPC["WrongJob"], 1)
        npc:EmitSound("zyb_npc_wrongjob")
    end
end
-- leak by lordee