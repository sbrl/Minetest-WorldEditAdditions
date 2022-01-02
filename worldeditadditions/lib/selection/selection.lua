-- ███████ ███████ ██      ███████  ██████ ████████ ██  ██████  ███    ██
-- ██      ██      ██      ██      ██         ██    ██ ██    ██ ████   ██
-- ███████ █████   ██      █████   ██         ██    ██ ██    ██ ██ ██  ██
--      ██ ██      ██      ██      ██         ██    ██ ██    ██ ██  ██ ██
-- ███████ ███████ ███████ ███████  ██████    ██    ██  ██████  ██   ████

---Selection helpers and modifiers
local selection = {}

--- Additively adds a point to the current selection or
-- makes a selection from the provided point.
-- @param	name	string	Player name.
-- @param	pos	vector	The position to include.
function selection.add_point(name, pos)
	if pos ~= nil then
		local created_new = not worldedit.pos1[name] or not worldedit.pos2[name]
		-- print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		if not worldedit.pos1[name] then worldedit.pos1[name] = vector.new(pos) end
		if not worldedit.pos2[name] then worldedit.pos2[name] = vector.new(pos) end
		
		worldedit.marker_update(name)
		
		local volume_before = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		worldedit.pos1[name], worldedit.pos2[name] = worldeditadditions.vector.expand_region(worldedit.pos1[name], worldedit.pos2[name], pos)
		
		local volume_after = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		local volume_difference = volume_after - volume_before
		if volume_difference == 0 and created_new then
			volume_difference = 1
		end
		
		local msg = "Expanded region by "
		if created_new then msg = "Created new region with " end
		msg = msg..volume_difference.." node"
		if volume_difference ~= 1 then msg = msg.."s" end
		
		worldedit.marker_update(name)
		worldedit.player_notify(name, msg)
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

return selection
