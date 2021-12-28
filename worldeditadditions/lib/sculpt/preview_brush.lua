local wea = worldeditadditions
local Vector3 = wea.Vector3

local make_brush = dofile(wea.modpath.."/lib/sculpt/make_brush.lua")
local make_preview = dofile(wea.modpath.."/lib/sculpt/make_preview.lua")

--- Generates a textual preview of a given brush.
-- @param	brush_name	string	The name of the brush to create a preview for.
-- @param	target_size	Vector3	The target size of the brush to create. Default: (10, 10, 0).
-- @returns	bool,string	If the operation was successful, true followed by a preview of the brush as a string. If the operation was not successful, false and an error message string is returned instead.
local function preview_brush(brush_name, target_size, framed)
	if framed == nil then framed = true end
	if not target_size then target_size = Vector3.new(10, 10, 0) end
	
	local success, brush, brush_size = make_brush(brush_name, target_size)
	if not success then return success, brush end
	
	return true, make_preview(brush, brush_size, framed)
end

return preview_brush
