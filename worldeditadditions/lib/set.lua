local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions



-- ███████ ███████ ████████ 
-- ██      ██         ██    
-- ███████ █████      ██    
--      ██ ██         ██    
-- ███████ ███████    ██    

--- Sets the given parameter to the given value.
-- This function would pair well with worldeditadditions.nodeapply.
-- @param	pos1	Vector3		Position 1 of the define region to operate on.
-- @param	pos2	Vector3		Position 2 of the define region to operate on.
-- @param	param	string="param|param2"	The name of the parameter to set. Currently possible values:
-- - **`param`:** Param1, aka the node id.
-- - **`param2`:** The supplementary parameter that each node has. See also <https://api.minetest.net/nodes/#node-paramtypes>. The node type is set by the mod or game that provides each node in question.
-- - **`light`:** Sets the light value of all nodes in the defined region.
-- @param	value	string|number	The value to set the given parameter to. If `param` is set to "param" and `value` is a `string`, then `value` is converted into a number by calling `minetest.get_content_id()`.
-- @returns	bool,table|string	true,statistics_table OR false,error_message.
function worldeditadditions.set(pos1, pos2, mode, value)
	if mode ~= "param" and mode ~= "param2" and mode ~= "light" then
		return false, "Error: Unknown parameter type "..tostring(mode)..". Supported values: param, param2."
	end
	
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	print("SET mode", mode, "value", value)
	
	local setvalue = value
	if mode == "param" and type(setvalue) == "string" then
		setvalue = minetest.get_content_id(setvalue)
		print("SET TRANSFORM setvalue TO", setvalue)
	end
	
	print("SET setvalue", setvalue)
	
	-- Initialise statistics
	local stats = { changed = 0 }
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = nil
	if mode == "param" then
		data = manip:get_data()
	elseif mode == "param2" then
		data = manip:get_param2_data()
	elseif mode == "light" then
		-- Shortcut!
		manip:set_lighting({ day = setvalue, night = setvalue }, pos1, pos2)
		manip:write_to_map(false)
		manip:update_map()
		return true, stats
	end
	
	for i in area:iterp(pos1, pos2) do
		data[i] = setvalue
		stats.changed = stats.changed + 1
	end
	
	if mode == "param" then
		manip:set_data(data)
	else
		manip:set_param2_data(data)
	end
	
	
	-- Save the modified nodes back to disk & return
	-- Can't use worldedit.manip_helpers.finish 'cause of dynamic param/light setting
	manip:write_to_map()
	manip:update_map()

	return true, stats
end
