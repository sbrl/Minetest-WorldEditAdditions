-- ██████  ███████  ██████  ██ ███████ ████████ ███████ ██████
-- ██   ██ ██      ██       ██ ██         ██    ██      ██   ██
-- ██████  █████   ██   ███ ██ ███████    ██    █████   ██████
-- ██   ██ ██      ██    ██ ██      ██    ██    ██      ██   ██
-- ██   ██ ███████  ██████  ██ ███████    ██    ███████ ██   ██

--- WorldEditAdditions chat command registration
-- @module worldeditadditions_core
local wea_c = worldeditadditions_core
local run_command = dofile(wea_c.modpath.."/core/run_command.lua")

local function log_error(cmdname, error_message)
	minetest.log("error", "register_command("..cmdname..") error: "..error_message)
end


--- Registers a new WorldEditAdditions chat command.
-- 
-- **Async commands:** Set `async = true` in the definition table you pass to this function. THEN, to indicate you are doing an async thing return NO VALUES AT ALL from your main `func` that is passed the parsed arguments. When `async = true`, your main `func` will be passed a callback function as the 1st argument BEFORE all other arguments.
--
-- Call this function when you are done with all async work with the same variables you would return: success: bool, result_message: string.
--
-- **IMPORTANT:** You MUST NOT return `success, result_message` from the main function AND call the callback function in a single call of a command!
-- An example of this in action can be seen in the implementation of `//for`.
-- @param	cmdname		string	The name of the command to register.
-- @param	options		table	A table of options for the command:
-- - `params` (string) A textual description of the parameters the command takes.
-- - `description` (string) A description of the command.
-- - `privs` (`{someprivilege=true, ....}`) The privileges required to use the command.
-- - `require_pos` (number) The number of positions required for the command.
-- - `async=false` (bool) Whether this function is async. See the note in the description of this function for more information. *(since v1.15)*
-- - `parse` (function) A function that parses the raw param_text into proper input arguments to be passed to `nodes_needed` and `func`.
-- - `nodes_needed` (function) A function that returns the number of nodes the command could potential change given the parsed input arguments.
-- - `func` (function) The function to execute when the command is run.
-- - `override=false` (boolean) Whether to override an existing command with the same name.
-- @return	boolean	True if the command was registered successfully, false otherwise.
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
	if minetest.registered_chatcommands["/"..cmdname] and options.override ~= true then
		log_error(cmdname, "A chat command with that name is registered, but the option override is not set to true.")
		return false
	end
	
	
	---
	-- 2: Normalisation
	---
	if options.async == nil then options.async = false end
	if not options.privs then options.privs = {} end
	if not options.require_pos then options.require_pos = 0 end
	if not options.nodes_needed then options.nodes_needed = function() return 0 end end
	
	---
	-- 3: Registration
	---
	local register_chatcommand = minetest.register_chatcommand
	if minetest.registered_chatcommands["/"..cmdname] and options.override == true then
		register_chatcommand = minetest.override_chatcommand
	end
	register_chatcommand("/"..cmdname, {
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
