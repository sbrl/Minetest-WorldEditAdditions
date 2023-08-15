local weac = worldeditadditions_core
local Vector3
local parse_json
if worldeditadditions_core then
	Vector3 = weac.Vector3
	parse_json = weac.parse.json
else
	Vector3 = require("worldeditadditions_core.utils.vector3")
	parse_json = require("worldeditadditions_core.utils.parse.json")
end


--- Library for parsing .weaschem WorldEditAdditions Schematic files.
-- 
-- Most of these functions return 3 values rather than the usual 2. This might seem overcomplicated, but it enables a higher level of validation in automated testing. These 3 return values take the following form:
-- 
-- 1. bool: A success/failure bool. `true` means success, and `false`, means failure.
-- 2. string: The error code. "SUCCESS" if #1 (the bool) is `true`. Otherwise set to a code to indicate exactly which error ocurred.
-- 3. any|string: EITHER the expected return value, OR a string with a human-readable error message if `bool=false`.
-- @namespace worldeditadditions_core.parse.file.weaschem
local weaschem = {}

--- Validates and converts a raw table into a Vector3 instance.
-- @param	source_obj	table	The table to convert.
-- @returns	bool,string,Vector3|string	A success bool, then an error code, then finally EITHER the resulting Vector3 instance (if bool=true) OR an error message as a string.
function weaschem.parse_vector3(source_obj)
	if type(source_obj) ~= "table" then return false, "VECTOR3_INVALID_TYPE", "Vector3: Expected a table, but got a value of type '"..type(source_obj).."'." end
	
	if source_obj.x == nil then return false, "VECTOR3_NO_X", "Vector3: No value for the x coordinate was found." end
	if source_obj.y == nil then return false, "VECTOR3_NO_Y", "Vector3: No value for the y coordinate was found." end
	if source_obj.z == nil then return false, "VECTOR3_NO_Z", "Vector3: No value for the z coordinate was found." end
	if type(source_obj.x) ~= "number" then return false, "VECTOR3_INVALID_X", "Vector3: The type of the x coordinate was expected to be number, but found '"..type(source_obj.x).."'." end
	if type(source_obj.y) ~= "number" then return false, "VECTOR3_INVALID_Y", "Vector3: The type of the y coordinate was expected to be number, but found '"..type(source_obj.y).."'." end
	if type(source_obj.z) ~= "number" then return false, "VECTOR3_INVALID_Z", "Vector3: The type of the z coordinate was expected to be number, but found '"..type(source_obj.z).."'." end
	
	local result = Vector3.clone(source_obj)
	
	local rounded = result:floor()
	if math.abs(result.x - rounded.x) > 0.0000001 then return false, "VECTOR3_X_FLOAT", "The x coordinate appears to be a floating-point number and not an integer. Only integer values in schematics are supported." end
	if math.abs(result.y - rounded.y) > 0.0000001 then return false, "VECTOR3_Y_FLOAT", "The y coordinate appears to be a floating-point number and not an integer. Only integer values in schematics are supported." end
	if math.abs(result.z - rounded.z) > 0.0000001 then return false, "VECTOR3_Z_FLOAT", "The z coordinate appears to be a floating-point number and not an integer. Only integer values in schematics are supported." end
	
	return true, "SUCCESS", result
end

function weaschem.parse_header(source)
	local raw_obj = parse_json(source)
	if raw_obj == nil then return false, "HEADER_INVALID", "The header is invalid JSON." end
	
	local header = {}
	
	
	if raw_obj["name"] == nil then return false, "HEADER_NO_NAME", "No name property found in header."
	else
		header["name"] = raw_obj["name"]
		if type(header["name"]) ~= "string" then
			return false, "HEADER_NAME_INVALID",
				"Invalid name in header: expected string, but found value of type '"..type(raw_obj["name"]).."'."
		end
	end
	if raw_obj["description"] ~= nil then
		header["description"] = raw_obj["description"]
		if type(header["description"]) ~= "string" then
			return false, "HEADER_DESCRIPTION_INVALID",
				"Invalid description in header: expected string, but found value of type '"..type(raw_obj["description"]).."'."
		end
	end
	
	
	if raw_obj["offset"] == nil then
		return false, "HEADER_NO_OFFSET", "No offset property found in header."
	else
		local success, code, result = weaschem.parse_vector3(raw_obj["offset"])
		if not success then return success, code, result end
		header["offset"] = result
	end
	if raw_obj["size"] == nil then return false, "HEADER_NO_SIZE", "No size property found in header."
	else
		local success, code, result = weaschem.parse_vector3(raw_obj["size"])
		if not success then return success, code, result end
		header["size"] = result
	end
	
	
	if raw_obj["type"] == nil then
		return false, "HEADER_NO_TYPE", "No type property found in header."
	else
		header["type"] = raw_obj["type"]
		if type(header["type"]) ~= "string" then
			return false, "HEADER_TYPE_INVALID",
				"Invalid type in header: expected string, but found value of type '" .. type(raw_obj["type"]) "'."
		end
		if header["type"] ~= "full" and header["type"] ~= "delta" then
			return false, "HEADER_TYPE_INVALID",
				"The value of the header field type was expected to be 'full' or 'delta', but was found to be '" ..
				tostring(header["type"]) .. "'."
		end
	end
	
	
	if raw_obj["generator"] == nil then
		return false, "HEADER_NO_GENERATOR", "No generator property found in header."
	else
		header["generator"] = raw_obj["generator"]
		if type(header["generator"]) ~= "string" then
			return false, "HEADER_GENERATOR_INVALID",
				"Invalid generator in header: expected string, but found value of generator '"..type(raw_obj["generator"]).."'."
		end
	end
	
	
	return true, "SUCCESS", header
end




function weaschem.parse_id_map(source)
	local raw_obj = parse_json(source)
	if raw_obj == nil then return false, "ID_MAP_INVALID", "The node id map is invalid JSON." end
	
	local result = {}
	for id_str, node_name in pairs(raw_obj) do
		local id = tonumber(id_str)
		if id == nil then return false, "ID_MAP_INVALID_ID", "A node id in the node id map is not parsable as a number." end
		if string.find(node_name, ":") == nil then return false, "ID_MAP_RELATIVE_NODE_NAME", "A node name does not contain a colon, suggesting it is a relative node id. Relative node ids are not supported." end
		
		if result[id] ~= nil then return false, "ID_MAP_DUPLICATE", "Multiple node ids in the node id map parse to the same number." end
		result[id] = node_name
	end
	
	return true, "SUCCESS", result
end


function weaschem.parse_data_table(source)
	local data_table = {}
	local values = weac.split(source, ",", true)
	local i = 0
	for _, next_val in pairs(values) do
		if next_val:find("x") ~= nil then
			local multi_count, multi_node_id = string.match(next_val, "(%d+)x(%d+)")
			multi_count = tonumber(multi_count)
			if type(multi_count) ~= "number" then
				return false, "DATA_TABLE_INVALID_COUNT", "Encountered count value in data table at position '"..tostring(i).."'."
			end
			multi_node_id = tonumber(multi_node_id)
			if type(multi_node_id) ~= "number" then
				return false, "DATA_TABLE_INVALID_NODE_ID", "Encountered node id value in data table at position '"..tostring(i).."'."
			end
			
			for _ = 1,multi_count do
				data_table[i] = multi_node_id
				i = i + 1
			end
		else
			local node_id = tonumber(next_val)
			if type(multi_count) ~= "number" then
				return false, "DATA_TABLE_INVALID_NODE_ID",
					"Encountered node id value in data table at position '" .. tostring(i) .. "'."
			end
			
			data_table[i] = node_id
			i = i + 1
		end
	end
	
	return true, "SUCCESS", data_table
end

--- Parses the WorldEditAdditions schematic file from the given handle.
-- This requires a file handle, as significant optimisations can be made in the case of invalid files.
-- @param	handle		File	A Lua file handle to read from.
-- @param	delta_which	string	If the schematic file is of type delta (i.e. as opposed to full), then this indicates which state is desired. Useful to significantly optimise both CPU and memory usage by avoiding parsing more than necessary if only one state is desired. Possible values: both (default; read both the previous and current states), prev (read only the previous state), current (read only the current state).
-- @returns TODO DOCUMENT THIS.
function weaschem.parse(handle, delta_which)
	if delta_which == nil then delta_which = "both" end
	if delta_which ~= "both" and delta_which ~= "prev" and delta_which ~= "current" then
		return false, "INVALID_DELTA_WHICH", "Invalid delta_which argument. Possible values: both [default], prev, current."
	end
	
	local temp, temp2 = handle:read(8, 1)
	if temp ~= "WEASCHEM" then
		return false, "INVALID_MAGIC_BYTES", "The magic bytes 'WEASCHEM' were not found, so the input is an invalid .weaschem schematic."
	end
	if temp2 ~= " " then
		return false, "INVALID_MAGIC_SPACE", "Invalid character after magic bytes (expected a single U+20 space)"
	end
	
	local version = handle:read("*n")
	if version ~= 1 then
		return false, "INVALID_VERSION", "Invalid schematic version. Expected 1, but found '"..tostring(version).."'."
	end
	
	temp = handle:read(1)
	if temp ~= "\n" then
		return false, "UNEXPECTED_TOKEN", "Invalid character present after schematic version number (expected a new line character U+0A)"
	end
	
	temp = handle:read("*l")
	
	local success, code, header = weaschem.parse_header(temp)
	if not success then return success, code, header end
	
	temp = handle:read("*l")
	if temp == nil then return false, "NO_ID_MAP", "Unable to read the id map from the file." end
	local id_map
	success, code, id_map = weaschem.parse_id_map(temp)
	if not success then return success, code, id_map end
	
	local data_tables = {}
	
	if header["type"] == "full" then
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table full:data from the file." end
		success, code, temp2 = weaschem.parse_data_table(temp)
		if not success then return success, code, temp2 end
		data_tables["data"] = temp2
		
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table full:param2 from the file." end
		success, code, temp2 = weaschem.parse_data_table(temp)
		if not success then return success, code, temp2 end
		data_tables["param2"] = temp2
	else
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table delta:data_previous from the file." end
		-- delta_which="current" is the only state in which we would NOT want to parse the previous state. Regardless, we still need to read the line in though even if we immediately discard it otherwise we'll be out of sync.
		if delta_which ~= "current" then
			success, code, temp2 = weaschem.parse_data_table(temp)
			if not success then return success, code, temp2 end
			data_tables["data_prev"] = temp2
		end
		
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table delta:param2_previous from the file." end
		if delta_which ~= "current" then
			success, code, temp2 = weaschem.parse_data_table(temp)
			if not success then return success, code, temp2 end
			data_tables["param2_prev"] = temp2
		end
		
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table delta:data_current from the file." end
		if delta_which ~= "prev" then
			success, code, temp2 = weaschem.parse_data_table(temp)
			if not success then return success, code, temp2 end
			data_tables["data_current"] = temp2
		end
		
		temp = handle:read("*l")
		if temp == nil then return false, "NO_DATA_TABLE", "Unable to read the data table delta:param2_current from the file." end
		if delta_which ~= "prev" then
			success, code, temp2 = weaschem.parse_data_table(temp)
			if not success then return success, code, temp2 end
			data_tables["param2_current"] = temp2
		end
	end
	
	
	local result = {
		header = header,
		id_map = id_map,
		data_tables = data_tables
	}
	
	return true, "SUCCESS", result
end


return weaschem