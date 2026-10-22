function PermaProps.HasPermission( ply, name )

	return ply:IsRoot()

end

local function PermaPropsPhys( ply, ent, phys )

	if ent.PermaProps then

		return PermaProps.HasPermission( ply, "Physgun")

	end
	
end
hook.Add("PhysgunPickup", "PermaPropsPhys", PermaPropsPhys)
hook.Add( "CanPlayerUnfreeze", "PermaPropsUnfreeze", PermaPropsPhys) -- Prevents people from pressing RELOAD on the physgun

local function PermaPropsTool( ply, tr, tool )

	if IsValid(tr.Entity) and tr.Entity.PermaProps then

		if tool == "permaprops" then

			return true

		end

		return PermaProps.HasPermission( ply, "Tool")

	end

end
hook.Add( "CanTool", "PermaPropsTool", PermaPropsTool)

local function PermaPropsProperty( ply, property, ent )

	if IsValid(ent) and ent.PermaProps and tool ~= "permaprops" then

		return PermaProps.HasPermission( ply, "Property")

	end

end
hook.Add( "CanProperty", "PermaPropsProperty", PermaPropsProperty)

timer.Simple(5, function() hook.Remove("CanTool", "textScreensPreventTools") end) -- Fuck OFF
timer.Simple(5, function() hook.Remove("CanTool", "textscreenpreventtools") end)