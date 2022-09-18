local wea_c = worldeditadditions_core

-- ███████ ███████ ████████  █████   ██████ ██   ██
-- ██      ██         ██    ██   ██ ██      ██  ██
-- ███████ ███████    ██    ███████ ██      █████
--      ██      ██    ██    ██   ██ ██      ██  ██
-- ███████ ███████    ██    ██   ██  ██████ ██   ██
worldeditadditions_core.register_command("sstack", {
	params = "",
	description = "Displays the contents of your (per-user) selection stack.",
	privs = { worldedit = true },
	parse = function(params_text)
		return true
	end,
	nodes_needed = function(name)
		return 0
	end,
	func = function(name)
		
		local result = {"Stack contents for user ", name, ":\n"}
		if not worldeditadditions.sstack[name] then
			table.insert(result, "(empty)")
		else
			for i,item in ipairs(worldeditadditions.sstack[name]) do
				-- TODO: Implement a volume command....
				local volume = worldedit.volume(item[1], item[2])
				local volume_text = wea_c.format.human_size(volume, 2)
				if volume > 1000 then volume_text = "~"..volume_text end
				
				table.insert(result, i)
				table.insert(result, ": ")
				
				table.insert(result, volume_text)
				table.insert(result, " nodes - ")
				table.insert(result, tostring(item[1])) -- Vector3 instance
				table.insert(result, " - ")
				table.insert(result, tostring(item[2])) -- Vector3 instance
				table.insert(result, "\n")
			end
			table.insert(result, "========================\nTotal ")
			table.insert(result, #worldeditadditions.sstack[name])
			table.insert(result, " items")
		end
		return true, table.concat(result, "")
	end
})
