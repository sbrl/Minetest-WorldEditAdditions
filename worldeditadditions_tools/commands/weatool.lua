-- ██     ██  ███████   █████   ████████   ██████    ██████   ██      
-- ██     ██  ██       ██   ██     ██     ██    ██  ██    ██  ██      
-- ██  █  ██  █████    ███████     ██     ██    ██  ██    ██  ██      
-- ██ ███ ██  ██       ██   ██     ██     ██    ██  ██    ██  ██      
--  ███ ███   ███████  ██   ██     ██      ██████    ██████   ███████ 

local wea_c = worldeditadditions_core
local wea_t = worldeditadditions_tools

worldeditadditions_core.register_command("tool", {
	params = "list || give|exists <tool name> ",
	description = "Give WEA tools by name to the calling player or list available tools.",
	privs = { worldedit = true, weatool = true },
	require_pos = 0,
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then return false, "Error: No params found!" end
		
		local commands = {list = true, give = true, exists = true}
		if not commands[ret[1]] then
			return false, "Invalid command: "..ret[1]
		end
		
		if wea_t.registered_tools[ret[2]] or ret[1] == "list" then
			return true, ret
		else return false, "No such WEA tool: "..ret[2] end
	end,
	func = function(name, params_text)
		if params_text[1] == "list" then
			-- Return a list of available tools in rows of 7
			local ret = "WEA Registered Tools:\n"
			local i = 0
			for k, _ in pairs(wea_t.registered_tools) do
				i = i + 1
				if i % 7 == 0 then ret = ret..k.."\n"
				else ret = ret..k.." " end
			end
			return true, ret
		elseif params_text[1] == "exists" then
			-- NOTE: If tool did not exist it would be flagged by parse function
			return true, "WEA tool \""..params_text[2].."\" exists"
		else
			-- Initiate player variable and check if it is a valid player
			local player = minetest.get_player_by_name(name)
			if not player or not player:is_player() then
				return false, "\""..name.."\" is not a valid player."
			end
			-- Create inventory and item instances
			local inv = player:get_inventory()
			local item = "worldeditadditions:"..params_text[2]
			-- Make sure the player doesn't already have the item and has room for it
			if inv:contains_item("main", item) then
				return false, name.." already has (a) \""..params_text[2].."\"."
			elseif not inv:room_for_item("main", item) then
				return false, name.." does not have room for (a) \""..params_text[2].."\"."
			else
				-- Give the player the item
				inv:add_item("main", item)
				return true, "Gave \""..params_text[2].."\" to "..name
			end
			
		end
	end,
})