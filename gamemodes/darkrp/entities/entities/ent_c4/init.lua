AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/2_c4_planted.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self:PhysWake()

	local i = 0
	timer.Create(self:EntIndex() .. 'explode', 1, 5, function()
        if !IsValid(self) then return end
		i = i + 1
		self:EmitSound("C4.PlantSound")
		if (i == 5) then
			if IsValid(self) then
				self:Explosion()
			end
		end
	end)
end

local badprops = {
    ['models/props_interiors/vendingmachinesoda01a.mdl'] = true,
    ['models/props_interiors/vendingmachinesoda01a_door.mdl'] = true,
}

local targetDoors = {
    ['models/props_c17/door01_left.mdl'] = true,
    ['models/props_doors/door_rotate_112.mdl'] = true,
    ['models/props_wasteland/prison_celldoor001a_alt.mdl'] = true
}

local hiddenDoors = {}

local function findents(pos, radius)
    return table.Filter(ents.FindInSphere(pos, radius), function(v)
        return v:IsProp() or v:IsDoor()
    end)
end

function ENT:Explosion()
    local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetRadius(1000)
		effectdata:SetMagnitude(1000)
	util.Effect("HelicopterMegaBomb", effectdata)
	
	local exploeffect = EffectData()
		exploeffect:SetOrigin(self:GetPos())
		exploeffect:SetStart(self:GetPos())
	util.Effect("Explosion", exploeffect, true, true)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.ItemOwner)
		shake:SetPos(self:GetPos())
        shake:SetKeyValue("amplitude", "150")
        shake:SetKeyValue("radius", "250")
        shake:SetKeyValue("duration", "1.5")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
		
	local push = ents.Create("env_physexplosion")
		push:SetOwner(self.ItemOwner)
		push:SetPos(self:GetPos())
        push:SetKeyValue("magnitude", 50)
        push:SetKeyValue("radius", 300)     
		push:SetKeyValue("spawnflags", 2+16)
		push:Spawn()
		push:Activate()
		push:Fire("Explode", "", 0)
		push:Fire("Kill", "", .25)

	self:EmitSound(Sound("C4.Explode"))

	util.BlastDamage(self, self.ItemOwner, self:GetPos(), 150, 75)
    
	local props = findents(self:GetPos(), 150)

    for _, ent in ipairs(props) do
        if IsValid(ent) then
            local class = ent:GetClass()
            if class == 'prop_physics' then
                local rand = math.random(1, 7)
                if rand == 1 or badprops[ent:GetModel()] then
                    ent:Remove()
                elseif rand == 2 then
                    if not util.IsInWorld(ent:GetPos()) then
                        ent:Remove()
                    else
                        constraint.RemoveAll(ent)
                        local phys = ent:GetPhysicsObject()
                        if IsValid(phys) then
                            phys:EnableMotion(true)
                        end
                    end
                end
            elseif ent:IsDoor() and targetDoors[ent:GetModel()] and not hiddenDoors[ent] then
                ent:Fire("Unlock")
                ent:Fire("Open")
                
                local originalPos = ent:GetPos()
                local originalAng = ent:GetAngles()
                local originalModel = ent:GetModel()
                local originalSkin = ent:GetSkin()

                local oldDoor = ent
                ent:SetNoDraw(true)
                ent:SetNotSolid(true)
                ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                hiddenDoors[ent] = true
                
                local newDoor = ents.Create("prop_physics")
                newDoor:SetModel(originalModel)
                newDoor:SetPos(originalPos)
                newDoor:SetAngles(originalAng)
                newDoor:SetSkin(originalSkin or 0)
                newDoor:Spawn()
                
                local phys = newDoor:GetPhysicsObject()
                if IsValid(phys) then
                    phys:EnableMotion(true)
                    phys:ApplyForceCenter(Vector(math.random(-500, 500), math.random(-500, 500), math.random(200, 400)))
                end
                
                timer.Simple(180, function()
                    if IsValid(newDoor) then
                        newDoor:Remove()
                    end
                end)
                
                timer.Simple(185, function()
                    if IsValid(oldDoor) then
                        oldDoor:SetNoDraw(false)
                        oldDoor:SetNotSolid(false)
                        oldDoor:SetCollisionGroup(COLLISION_GROUP_NONE)
                        hiddenDoors[oldDoor] = nil
                    end
                end)
            end
        end
    end
    
    self:Remove()
end
