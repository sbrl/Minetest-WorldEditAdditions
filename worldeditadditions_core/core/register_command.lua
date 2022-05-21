-- ██████  ███████  ██████  ██ ███████ ████████ ███████ ██████
-- ██   ██ ██      ██       ██ ██         ██    ██      ██   ██
-- ██████  █████   ██   ███ ██ ███████    ██    █████   ██████
-- ██   ██ ██      ██    ██ ██      ██    ██    ██      ██   ██
-- ██   ██ ███████  ██████  ██ ███████    ██    ███████ ██   ██

-- WorldEditAdditions chat command registration
local wea_c = worldeditadditions_core
local run_command = dofile(wea_c.modpath.."/core/run_command.lua")

local function log_error(cmdname, error_message)
	minetest.log("error", "register_command("..cmdname..") error: "..error_message)
end

local function register_command(cmdname, options)
	
	---
	-- 1: Validation
	---
	if type(options.params) ~= "string" then
		log_error(cmdname, "The params option is not a string.")
		return false
	end
	if type(options.description) ~= "string" then
		log_error(cmdname, "The description option is not a string.")
		return false
	end
	if type(options.parse) ~= "function" then
		log_error(cmdname, "The parse option is not a function.")
		return false
	end
	if type(options.func) ~= "function" then
		log_error(cmdname, "The func option is not a function.")
		return false
	end
	if wea_c.registered_commands[cmdname] and options.override ~= true then
		log_error(cmdname, "A WorldEditAdditions command with that name is registered, but the option override is not set to true.")
		return false
	end
	
	
	---
	-- 2: Normalisation
	---
	if not options.privs then options.privs = {} end
	if not options.require_pos then options.require_pos = 0 end
	if not options.nodes_needed then options.nodes_needed = function() return 0 end end
	
	---
	-- 3: Registration
	---
	minetest.register_chatcommand("/"..cmdname, {
		params = options.params,
		description = options.description,
		privs = options.privs,
		func = function(player_name, paramtext)
			run_command(cmdname, options, player_name, paramtext)
		end
	})
	wea_c.registered_commands[cmdname] = options
	if minetest.global_exists("worldedit") then
		worldedit.registered_commands[cmdname] = options
	end
end

return register_command
