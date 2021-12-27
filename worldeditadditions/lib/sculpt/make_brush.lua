local wea = worldeditadditions

--- Makes a sculpting brush that is as close to a target size as possible.
-- @param	brush_name	string	The name of the brush to create.
-- @param	target_size	Vector3	The target size of the brush to create.
-- @returns	true,table,Vector3|false,string	If the operation was successful, true followed by the brush in a 1D ZERO-indexed table followed by the actual size of the brush as a Vector3 (x & y components used only). If the operation was not successful, false and an error message string is returned instead.
local function make_brush(brush_name, target_size)
	if not wea.sculpt.brushes[brush_name] then return false, "Error: That brush does not exist. Try using //sculptbrushes to list all available sculpting brushes." end
	
	local brush_def = wea.sculpt.brushes[brush_name]
	
	local success, brush, size_actual
	if type(brush_def) == "function" then
		success, brush, size_actual = brush_def(target_size)
		if not success then return success, brush end
	else
		brush = brush_def.brush
		size_actual = brush_def.size
	end
	
	return true, brush, size_actual
end

return make_brush
