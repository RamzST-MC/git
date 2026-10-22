-- leak by lordee
zyb = zyb or {}
zyb.f = zyb.f or {}

if SERVER then
    util.AddNetworkString("zyb_baseanim_AnimEvent_net")

    function zyb.f.PlayAnimation(ent, anim, speed)
        //ent:ServerAnim(anim, speed)
        local animInfo = {}
        animInfo.anim = anim
        animInfo.speed = speed
        animInfo.ent = ent
        net.Start("zyb_baseanim_AnimEvent_net")
        net.WriteTable(animInfo)
        net.Broadcast()
    end
end

if CLIENT then
    net.Receive("zyb_baseanim_AnimEvent_net", function(len, ply)
        local animInfo = net.ReadTable()

        if animInfo and IsValid(animInfo.ent) and animInfo.anim and animInfo.speed then
            zyb.f.PlayClientAnimation(animInfo.ent,animInfo.anim, animInfo.speed)
        end
    end)

    function zyb.f.PlayClientAnimation(ent,anim, speed)
    	local sequence = ent:LookupSequence(anim)
    	ent:SetCycle(0)
    	ent:ResetSequence(sequence)
    	ent:SetPlaybackRate(speed)
    	ent:SetCycle(0)
    end
end
-- leak by lordee