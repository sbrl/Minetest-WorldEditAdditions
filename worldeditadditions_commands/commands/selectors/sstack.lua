-- ███████ ███████ ████████  █████   ██████ ██   ██
-- ██      ██         ██    ██   ██ ██      ██  ██
-- ███████ ███████    ██    ███████ ██      █████
--      ██      ██    ██    ██   ██ ██      ██  ██
-- ███████ ███████    ██    ██   ██  ██████ ██   ██
worldedit.register_command("sstack", {
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
				table.insert(result, i)
				table.insert(result, ": ")
				table.insert(result, worldeditadditions.vector.tostring(item[1]))
				table.insert(result, " - ")
				table.insert(result, worldeditadditions.vector.tostring(item[2]))
				table.insert(result, "\n")
			end
			table.insert(result, "========================\nTotal ")
			table.insert(result, #worldeditadditions.sstack[name])
			table.insert(result, " items")
		end
		return true, table.concat(result, "")
	end
})
