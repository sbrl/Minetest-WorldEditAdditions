local wea = worldeditadditions
local Vector3 = wea.Vector3

local make_brush = dofile(wea.modpath.."/lib/sculpt/make_brush.lua")

--- Generates a textual preview of a given brush.
-- @param	brush		table	The brush in question to preview.
-- @param	size		Vector3	The size of the brush.
-- @returns	string		A preview of the brush as a string.
local function make_preview(brush, size, framed)
	if framed == nil then framed = true end
	
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
	
	local frame_vertical = "+"..string.rep("-", math.max(0, size.x)).."+"
	
	local result = {}
	if framed then table.insert(result, frame_vertical) end
	
	for y = size.y-1, 0, -1 do
		local row = {}
		if framed then table.insert(row, "|") end
		for x = size.x-1, 0, -1 do
			local i = y*size.x + x
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
	
	
	return table.concat(result, "\n")
end

return make_preview
