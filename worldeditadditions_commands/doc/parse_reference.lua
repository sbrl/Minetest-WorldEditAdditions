

local function get_reference()
	local lines = {}
	for line in io.lines(worldeditadditions_commands.modpath.."/Chat-Command-Reference.md") do
		table.insert(lines, line)
	end
	return lines
end

local function group_by_heading(lines, max_level)
	local groups = {}
	local acc = {}
	
	for i,line in ipairs(lines) do
		if worldeditadditions.str_starts(line, "#") then
			local _, _, heading, headingtext = line:find("(#+)%s*(.*)")
			if #heading <= max_level then
				table.insert(groups, {
					level = #heading,
					heading = headingtext,
					text = table.concat(acc, "\n")
				})
				acc = {}
			end
		else
			table.insert(acc, line)
		end
	end
	return groups
end

function worldeditadditions.doc.parse_reference()
	local lines = get_reference()
	local headings = worldeditadditions.table.filter(
		group_by_heading(lines, 2),
		function(item, i) return item.level ~= 2 end
	)
	for i,value in ipairs(headings) do
		print(i, "level", value.level, "heading", value.heading, "text", value.text)
	end
end


worldeditadditions.doc.parse_reference()
