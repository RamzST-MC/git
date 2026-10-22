-- leak by lordee
if not SERVER then return end
zyb = zyb or {}
zyb.f = zyb.f or {}

function zyb.f.Grinder_Initzialize(grinder)
	grinder.PaperBag = nil
	grinder.LastInput = -1
	grinder.LastGrind = -1
	grinder.Grinding = false
	grinder.Motor = nil

	zyb.f.EntList_Add(grinder)
end

function zyb.f.Grinder_OnTouch(grinder, other)
	if not IsValid(other) then return end
	if zyb.f.CollisionCooldown(other) then return end

	if other:GetClass() == "zyb_paperbag" and other:GetYeastAmount() < zyb.config.PaperBag.Capacity and not IsValid(grinder.PaperBag) then
		zyb.f.Grinder_AddPaperBag(grinder,other)
	elseif other:GetClass() == "zyb_yeast" and grinder:GetYeastAmount() <= 0 then
		zyb.f.Grinder_AddYeastBlock(grinder,other)
	elseif other:GetClass() == "zyb_motor" and not IsValid(grinder.Motor) then
		zyb.f.Grinder_AddMotor(grinder,other)
	end
end

function zyb.f.Grinder_OnUse(grinder, ply)
	if IsValid(grinder.Motor) then return end
	if not IsValid(grinder.PaperBag) then return end
	if grinder:GetYeastAmount() <= 0 then return end

	grinder.LastInput = CurTime() + 0.15
	grinder:SetGrinding(true)
	grinder.Grinding = true
end

function zyb.f.Grinder_Think(grinder)
	if IsValid(grinder.Motor) then
		if IsValid(grinder.PaperBag) and grinder:GetYeastAmount() > 0 then
			grinder.LastInput = CurTime() + 0.15
			grinder:SetGrinding(true)
			grinder.Grinding = true
			grinder.Motor:SetRunning(true)
		else
			grinder.Motor:SetRunning(false)
		end
	end

	if grinder.Grinding == false then return end

	if CurTime() > grinder.LastInput then
		grinder:SetGrinding(false)
		grinder.Grinding = false
	else
		if CurTime() > grinder.LastGrind then
			zyb.f.Grinder_GrindYeast(grinder)
		end
	end
end

function zyb.f.Grinder_GrindYeast(grinder)
	if not IsValid(grinder.PaperBag) then return end
	if grinder:GetYeastAmount() <= 0 then return end

	// Transfer the yeast
	local t_amount = zyb.config.Grinder.GrindAmount
	grinder.PaperBag:SetYeastAmount(grinder.PaperBag:GetYeastAmount() + t_amount)

	grinder:SetYeastAmount(math.Clamp(grinder:GetYeastAmount() - t_amount,0,zyb.config.YeastBlock.Amount))

	// Update the bag visuals
	local y_amount = grinder.PaperBag:GetYeastAmount()
	if y_amount < zyb.config.PaperBag.Capacity / 3 then
		grinder.PaperBag:SetBodygroup(0, 2)
	elseif y_amount > zyb.config.PaperBag.Capacity / 1.05 then
		grinder.PaperBag:SetBodygroup(0, 4)
	elseif y_amount > zyb.config.PaperBag.Capacity / 2 then
		grinder.PaperBag:SetBodygroup(0, 3)
	end

	// Drop the bag if full
	if grinder.PaperBag:GetYeastAmount() >= zyb.config.PaperBag.Capacity then
		zyb.f.Grinder_DropPaperBag(grinder)
	end

	if IsValid(grinder.Motor) then
		grinder.LastGrind = CurTime() + zyb.config.GrinderMotor.Interval
	else
		grinder.LastGrind = CurTime() + zyb.config.Grinder.Interval
	end
end


function zyb.f.Grinder_AddMotor(grinder,motor)
	DropEntityIfHeld(motor)

	grinder.Motor = motor
	local attach = grinder:GetAttachment(3)
	local ang = attach.Ang
	ang:RotateAroundAxis(attach.Ang:Forward(), -90)
	ang:RotateAroundAxis(attach.Ang:Right(), 90)

	grinder.Motor:SetPos(attach.Pos)
	grinder.Motor:SetAngles(ang)
	grinder.Motor:SetParent(grinder)
	grinder.Motor.Grinder = grinder
	grinder:SetBodygroup(0,1)
end

function zyb.f.Grinder_AddPaperBag(grinder,bag)
	DropEntityIfHeld(bag)
	grinder.PaperBag = bag

	if bag:GetYeastAmount() <= 0 then
		grinder.PaperBag:SetBodygroup(0, 1)
	end

	local ang = grinder:GetAngles()
	ang:RotateAroundAxis(grinder:GetUp(), 90)
	grinder.PaperBag:SetAngles(ang)

	grinder.PaperBag:SetPos(grinder:GetPos() + grinder:GetUp() * 2)
	grinder.PaperBag:SetParent(grinder)

	grinder.PaperBag.Grinder = grinder
end

function zyb.f.Grinder_DropPaperBag(grinder)
	if not IsValid(grinder.PaperBag) then return end
	grinder.PaperBag:SetParent(nil)
	grinder.PaperBag:SetPos(grinder:GetPos() + grinder:GetUp() * 2 + grinder:GetRight() * 25)

	grinder.PaperBag:PhysicsInit(SOLID_VPHYSICS)
	grinder.PaperBag:SetMoveType(MOVETYPE_VPHYSICS)
	grinder.PaperBag:SetSolid(SOLID_VPHYSICS)

	local phys = grinder.PaperBag:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	grinder.PaperBag = nil
end

function zyb.f.Grinder_AddYeastBlock(grinder,yeastblock)

	DropEntityIfHeld(yeastblock)

	SafeRemoveEntity(yeastblock)

	grinder:SetYeastAmount(zyb.config.YeastBlock.Amount)
end
-- leak by lordee