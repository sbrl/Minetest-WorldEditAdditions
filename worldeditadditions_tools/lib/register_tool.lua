-- ██████   ███████   ██████   ██  ███████  ████████  ███████  ██████  
-- ██   ██  ██       ██        ██  ██          ██     ██       ██   ██ 
-- ██████   █████    ██   ███  ██  ███████     ██     █████    ██████  
-- ██   ██  ██       ██    ██  ██       ██     ██     ██       ██   ██ 
-- ██   ██  ███████   ██████   ██  ███████     ██     ███████  ██   ██ 
--
-- ████████   ██████    ██████   ██      
--    ██     ██    ██  ██    ██  ██      
--    ██     ██    ██  ██    ██  ██      
--    ██     ██    ██  ██    ██  ██      
--    ██      ██████    ██████   ███████ 

--- WorldEditAdditions tool registration
-- A wrapper for registering tools for WorldEditAdditions.
-- @module worldeditadditions_core

local wea_t = worldeditadditions_tools

-- Helper functions --
local function log_error(toolname, error_message)
	minetest.log("error", "register_tool("..toolname..") error: "..error_message)
end

local function log_warn(toolname, error_message)
	minetest.log("warning", "register_tool("..toolname..") warning: "..error_message)
end


--- Registers a new WorldEditAdditions tool.
-- @param	tool		string	The name of the tool to register (sans the ":worldeditadditions:" prefix).
--[[
	=== WARNING ===
	":worldeditadditions:" will be prepended to the `tool` param so
	calling `register_tool(":worldeditadditions:<toolname>", def_table)`
	may cause errors.
--]]
-- @param	options		table	A table of options for the tool:
-- - `description` (string) A description of the tool.
-- - `inventory_image` (string) The path to the image for the tool.
-- - `on_use` (function) A function that is called when right click while pointing at something.
-- - `on_place` (function) A function that is called when left click while pointing at something.
-- - `on_secondary_use` (function) A function that is called when left click while pointing at nothing.
-- - `stack_max` (number) The maximum number of the items that can be put in an ItemStack.
-- - `groups` (table) A table of groups that the tool belongs to.
local function register_tool(tool, options)
	
	---
	-- 1: Validation
	---
	if type(options.description) ~= "string" then
		log_error(tool, "The description option is not a string.")
		return false
	end
	if type(options.inventory_image) ~= "string" then
		log_error(tool, "The inventory_image option is not a string.")
		return false
	end
	if not options.inventory_image:match("^.+%.png$") then
		log_error(tool, "The inventory_image option is not a valid image path.")
		return false
	end
	if type(options.on_use) ~= "function" then
		if options.on_use == nil then
			log_warn(tool, "The on_use option is nil.")
		else
			log_error(tool, "The on_use option is not a function.")
			return false
		end
	end
	if type(options.on_place) ~= "function" then
		if options.on_place == nil then
			log_warn(tool, "The on_place option is nil.")
		else
			log_error(tool, "The on_place option is not a function.")
			return false
		end
	end
	if type(options.on_secondary_use) ~= "function" then
		if options.on_secondary_use == nil then
			log_warn(tool, "The on_secondary_use option is nil.")
		else
			log_error(tool, "The on_secondary_use option is not a function.")
			return false
		end
	end
	
	---
	-- 2: Normalisation
	---
	if not options.stack_max then options.stack_max = 1 end
	if not options.groups then options.groups = {wea = 1, wand = 1} end
	
	---
	-- 3: Registration
	---
	minetest.register_tool(":worldeditadditions:" .. tool, options)
	wea_t.registered_tools[tool] = options
end

return register_tool