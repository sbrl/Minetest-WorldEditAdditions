local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3
-- ███████ ███████ ██      ███████  ██████ ████████ ██  ██████  ███    ██
-- ██      ██      ██      ██      ██         ██    ██ ██    ██ ████   ██
-- ███████ █████   ██      █████   ██         ██    ██ ██    ██ ██ ██  ██
--      ██ ██      ██      ██      ██         ██    ██ ██    ██ ██  ██ ██
-- ███████ ███████ ███████ ███████  ██████    ██    ██  ██████  ██   ████

---Selection helpers and modifiers
local selection = {}

--- Additively adds a point to the current selection defined by pos1..pos2 or
-- makes a selection from the provided point.
-- @param	name	string	Player name.
-- @param	pos	vector	The position to include.
function selection.add_point(name, newpos)
	if newpos ~= nil then
		-- print("DEBUG:selection.add_point newpos", newpos)
		local has_pos1 = not not wea_c.pos.get1(name)
		local has_pos2 = not not wea_c.pos.get2(name)
		local created_new = not has_pos1 or not has_pos2
		if not has_pos1 then wea_c.pos.set1(name, Vector3.clone(newpos)) end
		if not has_pos2 then wea_c.pos.set2(name, Vector3.clone(newpos)) end

		
		-- Now no longer needed, given that the new sysstem uses an event listener to push updates to the selected region automatically
		-- worldedit.marker_update(name)
		
		local pos1, pos2 = wea_c.pos.get1(name), wea_c.pos.get2(name)
		
		local volume_before = worldedit.volume(pos1, pos2)
		
		
		local new_pos1, new_pos2 = Vector3.expand_region(
			Vector3.clone(pos1),
			Vector3.clone(pos2),
			newpos
		)
		
		wea_c.pos.set1(name, new_pos1)
		wea_c.pos.set2(name, new_pos2)
		
		
		local volume_after = worldedit.volume(new_pos1, new_pos2)
		
		local volume_difference = volume_after - volume_before
		if volume_difference == 0 and created_new then
			volume_difference = 1
		end
		
		local msg = "Expanded region by "
		if created_new then msg = "Created new region with " end
		msg = msg..volume_difference.." node"
		if volume_difference ~= 1 then msg = msg.."s" end
		
		-- Done automatically
		-- worldedit.marker_update(name)
		worldedit.player_notify(name, msg)
	else
		worldedit.player_notify(name, "Error. Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos1]", name, "nil")
	end
end

--- Clears current selection, *but only pos1 and pos2!
-- @param	name	string	Player name.
function selection.clear_points(name)
	wea_c.pos.clear(name)
	-- worldedit.marker_update(name)
	
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
	return (str == "facing" or str == "front" or str == "back" or str == "left" or str == "right" or str == "up" or str == "down")
end

return selection
