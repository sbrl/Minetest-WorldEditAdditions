-- ████████  ███████  ███████  ████████ 
--    ██     ██       ██          ██    
--    ██     █████    ███████     ██    
--    ██     ██            ██     ██    
--    ██     ███████  ███████     ██    

local wea_c = worldeditadditions_core
local wea_cmd = worldeditadditions_commands

local test_dir = wea_cmd.modpath .. "/commands/test/tests/"

-- Load tests with init function
local tests = dofile(test_dir .. "init.lua")(test_dir)
-- Helper functions
local set_colour = function(colour, text)
	return minetest.colorize(colour, text)
end

wea_c.register_command("test", {
	params = "list || <testname> <args> || help <testname>",
	description = "Run a test or list all tests",
	privs = {worldedit = true},
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then
			return false, "Error: No params found!"
		elseif ret[1] ~= "list" and #ret < 2 then
			if ret[1] == "help" then
				return false, "Error: No test found!"
			else return false, "Error: No arguments found!" end
		end
		if not tests[ ret[1] == "help" and ret[2] or ret[1] ] then
			return false, "Error: Test '"..ret[1].."' not found!"
		end
		return true, table.remove(ret, 1), ret
	end,
	func = function(name, subcommand, params_text)
		if subcommand == "list" then
			local ret = ""
			-- List in rows of 7
			local count = 0
			for k, _ in pairs(tests) do
				ret = ret .. k
				count = count + 1
				if count % 7 == 0 then ret = ret .. "\n"
				else ret = ret  .. ", "end
			end
			return true, ret
		elseif subcommand == "help" then
			if not params_text[1] then
				return false, "Error: No test found!"
			elseif not tests[params_text[1]] then
				return false, "Error: Test '"..params_text[1].."' not found!"
			else
				return true, table.concat({
					set_colour("#55FF55", "//test"),
					set_colour("#55B9FF", params_text[1]),
					tests[params_text[1]]:help()}, " ")
			end
		end
		return tests[subcommand](name, params_text)
	end
})