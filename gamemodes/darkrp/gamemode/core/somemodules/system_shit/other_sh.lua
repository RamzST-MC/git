local reload_cd = 0
function GM:OnReloaded()
    if CLIENT and reload_cd < CurTime() then 
        notification.AddLegacy("Обновляем код на сервере, может подлагать...", 0, 10) 
        reload_cd = CurTime() + 3 
    end
end
