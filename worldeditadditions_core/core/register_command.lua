-- ██████  ███████  ██████  ██ ███████ ████████ ███████ ██████
-- ██   ██ ██      ██       ██ ██         ██    ██      ██   ██
-- ██████  █████   ██   ███ ██ ███████    ██    █████   ██████
-- ██   ██ ██      ██    ██ ██      ██    ██    ██      ██   ██
-- ██   ██ ███████  ██████  ██ ███████    ██    ███████ ██   ██

-- WorldEditAdditions chat command registration

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
	if type(options.parse) ~= "string" then
		log_error(cmdname, "The parse option is not a function.")
		return false
	end
	if type(options.nodes_needed) ~= "string" then
		log_error(cmdname, "The nodes_needed option is not a function.")
		return false
	end
	if type(options.func) ~= "string" then
		log_error(cmdname, "The func option is not a function.")
		return false
	end
	
	
	---
	-- 2: Normalisation
	---
	if not options.privs then options.privs = {} end
	if not options.require_pos then options.require_pos = 0 end
	
	
	---
	-- 3: Registration
	---
	minetest.register_chatcommand("/"..cmdname, {
		params = options.params,
		description = options.description,
		privs = options.privs,
		func = function(player_name, paramtext)
			-- TODO: Fill this in
		end
		
	})
end
