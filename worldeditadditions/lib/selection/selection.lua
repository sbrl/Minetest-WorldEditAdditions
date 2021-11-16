-- ███████ ███████ ██      ███████  ██████ ████████ ██  ██████  ███    ██
-- ██      ██      ██      ██      ██         ██    ██ ██    ██ ████   ██
-- ███████ █████   ██      █████   ██         ██    ██ ██    ██ ██ ██  ██
--      ██ ██      ██      ██      ██         ██    ██ ██    ██ ██  ██ ██
-- ███████ ███████ ███████ ███████  ██████    ██    ██  ██████  ██   ████
local v3 = worldeditadditions.Vector3
---Selection helpers and modifiers
local selection = {}

--- Additively adds a point to the current selection or
-- makes a selection from the provided point.
-- @param	name	string	Player name.
-- @param	pos	vector	The position to include.
function selection.add_point(name, pos)
	if pos ~= nil then
		local is_new = not worldedit.pos1[name] and not worldedit.pos2[name]
		-- print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		if not worldedit.pos1[name] then worldedit.pos1[name] = vector.new(pos) end
		if not worldedit.pos2[name] then worldedit.pos2[name] = vector.new(pos) end
		
		worldedit.marker_update(name)
		
		local volume_before = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		worldedit.pos1[name], worldedit.pos2[name] = worldeditadditions.vector.expand_region(worldedit.pos1[name], worldedit.pos2[name], pos)
		
		local volume_after = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		local volume_difference = volume_after - volume_before
		
		worldedit.marker_update(name)
		-- print("DEBUG volume_before", volume_before, "volume_after", volume_after)
		if is_new then
			local msg = "Created new region of "..volume_after.." node"
			if volume_after ~= 1 then msg = msg.."s" end
			worldedit.player_notify(name, msg)
		else
			local msg = "Expanded region by "..volume_difference.." node"
			if volume_difference ~= 1 then msg = msg.."s" end
			worldedit.player_notify(name, msg)
		end
	else
		worldedit.player_notify(name, "Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos1]", name, "nil")
	end
end

--- Clears current selection.
-- @param	name	string	Player name.
function selection.clear_points(name)
	worldedit.pos1[name] = nil
	worldedit.pos2[name] = nil
	worldedit.marker_update(name)
	worldedit.set_pos[name] = nil
	
	worldedit.player_notify(name, "Region cleared")
end

--- Checks if a string is a valid axis.
-- @param	str	string	String to check (be sure to remove any + or -).
-- @param	hv	bool	Include "h" (general horizontal) and "v" (general vertical).
-- @return	bool	If string is a valid axis then true.
function selection.check_axis(str,hv)
	if hv then
		return (str == "x" or str == "y" or str == "z" or str == "h" or str == "v")
	else
		return (str == "x" or str == "y" or str == "z")
	end
end

--- Checks if a string is a valid dir.
-- @param	str	string	String to check (be sure to remove any + or -).
-- @return	bool	If string is a valid dir then true.
function selection.check_dir(str)
	return (str == "front" or str == "back" or str == "left" or str == "right" or str == "up" or str == "down")
end

--- Makes two vectors from the given positions and expands or contracts them
-- (based on mode) by a third provided vector.
-- @param	mode	string	"grow" | "shrink".
-- @param	pos1	vector	worldedit pos1.
-- @param	pos2	vector	worldedit pos2.
-- @param	vec	vector	The modifying vector.
-- @return	Vector3,Vector3	New vectors for worldedit positions.
function selection.resize(mode, pos1, pos2, vec)
	local pos1, pos2 = v3.sort(pos1, pos2)
	local vmin = v3.min(vec,v3.new()):abs()
	local vmax = v3.max(vec,v3.new())
	if mode == "grow" then
		return pos1 - vmin, pos2 + vMax
	elseif mode == "shrink" then
		return pos1 + vmin, pos2 - vMax
	else
		error("Resize Error: invalid mode \""..tostring(mode).."\".")
	end
end

return selection
