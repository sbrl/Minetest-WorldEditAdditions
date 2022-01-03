local wea = worldeditadditions
local Vector3 = wea.Vector3

--- Parses a static brush definition.
-- @param	source	string	The source string that contains the static brush, formatted as TSV.
-- @returns	true,table,Vector3|false,string		A success boolean, followed either by an error message as a string or the brush (as a table) and it's size (as an X/Y Vector3)
return function(source)
	local width = -1
	local height
	local maxvalue, minvalue, range
	
	-- Parse out the TSV into a table of tables, while also parsing values as numbers
	-- Also keeps track of the maximum/minimum values found for rescaling later.
	local values = wea.table.map(
		wea.split(source, "\n", false),
		function(line)
			local row = wea.split(line, "%s+", false)
			width = math.max(width, #row)
			return wea.table.map(
				row,
				function(pixel)
					local value = tonumber(pixel)
					if not value then value = 0 end
					if maxvalue == nil or value > maxvalue then
						maxvalue = value
					end
					if minvalue == nil or value < minvalue then
						minvalue = value
					end
					return value
				end
			)
		end
	)
	
	height = #values
	range = maxvalue - minvalue
	
	local brush = {}
	for y,row in ipairs(values) do
		for x,value in ipairs(row) do
			local i = (y-1)*width + (x-1)
			brush[i] = (value - minvalue) / range
		end
	end
	
	return true, brush, Vector3.new(width, height, 0)
end
