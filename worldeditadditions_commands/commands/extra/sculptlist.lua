local wea = worldeditadditions

-- ███████  ██████ ██    ██ ██      ██████  ████████ ██      ██ ███████ ████████
-- ██      ██      ██    ██ ██      ██   ██    ██    ██      ██ ██         ██
-- ███████ ██      ██    ██ ██      ██████     ██    ██      ██ ███████    ██
--      ██ ██      ██    ██ ██      ██         ██    ██      ██      ██    ██
-- ███████  ██████  ██████  ███████ ██         ██    ███████ ██ ███████    ██
minetest.register_chatcommand("/sculptlist", {
	params = "[preview]",
	description = "Lists all the currently registered sculpting brushes and their associated metadata. If the keyword preview is specified as an argument, a preview of each brush is also printed.",
	privs = { worldedit = true },
	func = function(name, params_text)
		if name == nil then return end
		if not params_text then params_text = "" end
		params_text = wea.trim(params_text)
		
		local msg = {}
		
		table.insert(msg, "Currently registered sculpting brushes:\n")
		
		if params_text == "preview" then
			for brush_name, brush_def in pairs(wea.sculpt.brushes) do
				local success, preview = wea.sculpt.preview_brush(brush_name)
				
				local brush_size = "dynamic"
				if type(brush_def) ~= "function" then
					brush_size = brush_def.size.x.."x"..brush_def.size.y
				end
				
				print("//sculptlist: preview for "..brush_name..":")
				print(preview)
				
				table.insert(msg, brush_name.." ["..brush_size.."]:\n")
				table.insert(msg, preview.."\n\n")
			end
		else
			local display = { { "Name", "Native Size" } }
			for brush_name, brush_def in pairs(wea.sculpt.brushes) do
				local brush_size = "dynamic"
				if type(brush_def) ~= "function" then
					brush_size = brush_def.size
				end
				
				table.insert(display, {
					brush_name,
					brush_size
				})
			end
			-- Sort by brush name
			table.sort(display, function(a, b) return a[1] < b[1] end)
			
			table.insert(msg, worldeditadditions.format.make_ascii_table(display))
		end
		
		worldedit.player_notify(name, table.concat(msg))
	end
})
