local wea = worldeditadditions
local Vector3 = wea.Vector3

local make_brush = dofile(wea.modpath.."/lib/sculpt/make_brush.lua")

--- Generates a textual preview of a given brush.
-- @param	brush_name	string	The name of the brush to create a preview for.
-- @param	target_size	Vector3	The target size of the brush to create. Default: (10, 10, 0).
-- @returns	bool,string	If the operation was successful, true followed by a preview of the brush as a string. If the operation was not successful, false and an error message string is returned instead.
local function preview_brush(brush_name, target_size, framed)
	if framed == nil then framed = true end
	if not target_size then target_size = Vector3.new(10, 10, 0) end
	local success, brush, brush_size = make_brush(brush_name, target_size)
	
	-- Values to map brush pixel values to.
	-- Brush pixel values are first multiplied by 10 before comparing to these numbers
	local values = {}
	values["@"] = 9.5
	values["#"] = 8
	values["="] = 6
	values[":"] = 5
	values["-"] = 4
	values["."] = 1
	values[" "] = 0
	
	local frame_vertical = "+"..string.rep("-", math.max(0, brush_size.x)).."+"
	
	local result = {}
	if framed then table.insert(result, frame_vertical) end
	
	for y = brush_size.y-1, 0, -1 do
		local row = {}
		if framed then table.insert(row, "|") end
		for x = brush_size.x-1, 0, -1 do
			local i = y*brush_size.x + x
			local pixel = " "
			local threshold_cur = -1
			for value,threshold in pairs(values) do
				if brush[i] * 10 > threshold and threshold_cur < threshold then
					pixel = value
					threshold_cur = threshold
				end
			end
			table.insert(row, pixel)
		end
		if framed then table.insert(row, "|") end
		table.insert(result, table.concat(row))
	end
	
	if framed then table.insert(result, frame_vertical) end
	
	
	return true, table.concat(result, "\n")
end

return preview_brush
