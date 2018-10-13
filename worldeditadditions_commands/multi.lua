--- Executes multiple worldedit commands in sequence.
-- @module worldeditadditions.multi

-- explode(seperator, string)
-- From http://lua-users.org/wiki/SplitJoin
function explode(delim, str)
	local ll, is_done
	local delim_length = string.len(delim)
	ll = 0
	is_done = false
	
	return function()
		if is_done then return end
		
		local result = nil
		local loc = string.find(str, delim, ll, true) -- find the next d in the string
		if loc ~= nil then -- if "not not" found then..
			result = string.sub(str, ll, loc - 1) -- Save it in our array.
			ll = loc + delim_length -- save just after where we found it for searching next time.
		else
			result = string.sub(str, ll) -- Save what's left in our array.
			is_done = true
		end
		
		return result
	end
end

-- From http://lua-users.org/wiki/StringTrim
function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

minetest.register_chatcommand("/multi", {
	params = "//<command_a> <args> //<command_b> <args> .....",
	description = "Executes multiple chat commands in sequence.",
	privs = { worldedit = true },
	func = function(name, params_text)
		-- Things start at 1, not 0 in Lua :-(
		local i = 0
		for command in explode(" /", string.sub(params_text, 2)) do
			local found, _, command_name, args = command:find("^([^%s]+)%s(.+)$")
			if not found then command_name = command end
			command_name = trim(command_name)
			
			worldedit.player_notify(name, "Executing #"..i..": "..command.." ("..command_name..")")
			
			local cmd = minetest.chatcommands[command_name]
			if not cmd then
				return false, "Error: "..command_name.." isn't a valid command."
			end
			if not minetest.check_player_privs(name, cmd.privs) then
				return false, "Your privileges are insufficient."
			end
			
			minetest.log("action", name.." runs "..command)
			cmd.func(name, args)
			
			i = i + 1
		end
	end
})
