if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.NPC = zmlab2.NPC or {}

function zmlab2.NPC.Initialize(NPC)

end
local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)
local simple_off = Vector(0, 0, 75)

local ang = Angle(0, 90, 90)
function zmlab2.NPC.Draw(NPC)
    NPC:DrawModel()

    if zmlab2 and zmlab2.util and zmlab2.util.InDistance(NPC:GetPos(), LocalPlayer():GetPos(), 500) and zmlab2.Convar.Get("zmlab2_cl_drawui") == 1 then
        local bone = NPC:LookupBone('ValveBiped.Bip01_Head1')
        if bone then
            pos = NPC:GetBonePosition(bone) + complex_off
        else
            pos = NPC:GetPos() + simple_off
        end

        ang.y = (LocalPlayer():EyeAngles().y - 90)

        local inView, dist = NPC:InDistance(150000)

        if (not inView) then return end

        local alpha = 255 - (dist/590)
        color_white.a = alpha
        color_black.a = alpha

        local x = math.sin(CurTime() * math.pi) * 30

        cam.Start3D2D(pos, ang, 0.03)
            surface.SetDrawColor(255, 255, 255, alpha)
            surface.SetMaterial(Material('sup/entities/genome.png'))
            surface.DrawTexturedRect(-64, -246 + x, 128, 128)

            draw.SimpleTextOutlined('Скупщик мета', '3d2d', 0, x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
        cam.End3D2D()
    end
end
