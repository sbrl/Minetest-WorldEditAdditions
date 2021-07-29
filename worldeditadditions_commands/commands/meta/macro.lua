-- ███    ███  █████   ██████ ██████   ██████
-- ████  ████ ██   ██ ██      ██   ██ ██    ██
-- ██ ████ ██ ███████ ██      ██████  ██    ██
-- ██  ██  ██ ██   ██ ██      ██   ██ ██    ██
-- ██      ██ ██   ██  ██████ ██   ██  ██████
local wea = worldeditadditions
local v3 = worldeditadditions.Vector3
local function step(params)
	-- Initialize additional params on first call
	if not params.first then
		params.i = 1 -- Iteration number
		params.time = 0 -- Total execution time
		params.first = true
	end
	
	-- Load current command string to use
	local command, args = params.commands[params.i]:match("/([^%s]+)%s*(.*)$")
	if not args then args = ""
	else args = args:match("^%s*(.*)%s*$") end
	-- Get command and test privs
	local cmd = minetest.chatcommands[command]
	if not cmd then
		return false, "Error: "..command.." isn't a valid command."
	end
	if not minetest.check_player_privs(params.player_name, cmd.privs) then
		return false, "Your privileges are insufficient to run /\""..command.."\"."
	end
	
	-- Start a timer
	local start_time = wea.get_ms_time()
	-- Execute command
	cmd.func(params.player_name, args)
	-- Finish timer and add to total
	params.time = params.time + wea.get_ms_time() - start_time
	-- Increment iteration state
	params.i = params.i + 1
	
	if params.i <= #params.commands then
		-- If we haven't run out of values call function again
		minetest.after(params.delay, step, params) -- Time is in seconds
	else
		worldedit.player_notify(params.player_name, "The macro \""..
			params.file.."\" was completed in " ..
			wea.format.human_time(params.time))
	end
end

worldedit.register_command("macro", {
	params = "<file> [<delay=0>]",
	description = "Load commands from \"(world folder)/macros/<file>[.weamac | .wmac]\" with position 1 of the current WorldEdit region as the origin.",
	privs = {worldedit=true},
	require_pos = 0,
	parse = function(params_text)
		local parts = wea.split(params_text,"%s")
		local file_name, delay -- = params_text:match("^(.-)%s*(%d*%.?%d*)$")
		-- Check for params and delay
		if not parts[1] then
			return false, "Error: Insufficient arguments. Expected: \"<file> [<delay=0>]\""
		elseif not parts[#parts]:match("[^%d%.]") then
			delay = table.remove(parts,#parts)
			file_name = table.concat(parts," ")
		else
			delay = 0
			file_name = table.concat(parts," ")
		end
		-- Check file name
		if file_name:match("[!\"#%%&'%(%)%*%+,/:;<=>%?%[\\]%^`{|}]") then
			return false, "Disallowed file name: " .. params_text
		end
		
		return true, file_name, delay
	end,
	func = function(name, file_name, delay)
		if not worldedit.pos1[name] then
			worldedit.pos1[name] = v3.add(wea.player_vector(name), v3.new(0.5,-0.5,0.5)):floor()
			worldedit.mark_pos1(name)
		end
		worldedit.pos2[name] = worldedit.pos1[name]
		
		-- Find the file in the world path
		local testpaths = {
			minetest.get_worldpath() .. "/macros/" .. file_name,
			minetest.get_worldpath() .. "/macros/" .. file_name .. ".weamac",
			minetest.get_worldpath() .. "/macros/" .. file_name .. ".wmac",
		}
		local file, err
		for index, path in ipairs(testpaths) do
			file, err = io.open(path, "rb")
			if not err then break end
		end
		-- Check if file exists
		if err then
			return false, "Error: File \"" .. file_name .. "\" does not exist or is corrupt."
		end
		local value = file:read("*a")
		file:close()
		
		step({
			player_name = name,
			file = file_name:match("^[^%.]+"),
			delay = delay,
			commands = wea.split(value,"[\n\r]+")
		})
		
	end,
})

-- Make default macro
local function default_macro()
	local path = minetest.get_worldpath() .. "/macros"
	-- Create directory if it does not already exist
	minetest.mkdir(path)
	local writer, err = io.open(path.."/fixlight.weamac", "ab")
	if not writer then return false end
	writer:write("//multi //1 //2 //outset 50 //fixlight //y")
	writer:flush()
	writer:close()
	return true
end

-- Check for default macro
local function chk_default_macro()
	local path = minetest.get_worldpath() .. "/macros/fixlight.weamac"
	local file, err = io.open(path, "rb")
	if err then return false
	else
		file:close()
		return true
	end
end

if not chk_default_macro() then
	default_macro()
end
