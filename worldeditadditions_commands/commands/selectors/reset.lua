-- ██████   ███████  ███████  ███████  ████████ 
-- ██   ██  ██       ██       ██          ██    
-- ██████   █████    ███████  █████       ██    
-- ██   ██  ██            ██  ██          ██    
-- ██   ██  ███████  ███████  ███████     ██    

local wea_c = worldeditadditions_core

worldeditadditions_core.register_command("reset", {
	params = "",
	description = "Clears all defined points and the currently defined region.",
	privs = {worldedit=true},
	override = true, -- Override the WorldEdit command
	parse = function(params_text)
		return true, params_text
	end,
	func = function(name)
		wea_c.pos.clear(name)
		return true, "Selection reset for "..name
	end
})