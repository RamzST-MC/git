local cmdflags = {}

hook.Add("BadminPlguinsLoaded", "ba.LoadFlags", function()
    for k, v in pairs(ba.cmd.Stored) do
       if cmdflags[v.Name] then
            v:SetFlag(cmdflags[v.Name])
        end
    end
end)