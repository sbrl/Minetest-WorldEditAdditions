--- WorldEditAdditions-ChatCommands
-- @module worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

minetest.register_chatcommand("/floodfill", {
	params = "<replace_node> [<radius>]",
	description = "Floods all connected nodes of the same type starting at pos1 with <replace_node>, in a box-shape with a radius of <radius>, which defaults to 50.",
	privs = { worldedit = true },
	-- TODO: Integrate will the safe_region feature of regular worldedit
	func = function(name, params_text)
		local found, _, replace_node, radius = params_text:find("([a-z:_\\-]+)%s+([0-9]+)")
		
		if found == nil then
			found, _, replace_node = params_text:find("([a-z:_\\-]+)")
			radius = 25
		end
		if found == nil then
			replace_node = "default:water_source"
		end
		radius = tonumber(radius)
		
		replace_node = worldedit.normalize_nodename(replace_node)
		
		local start_time = os.clock()
		local nodes_replaced = worldedit.floodfill(worldedit.pos1[name], radius, replace_node)
		
		worldedit.player_notify(name, nodes_replaced .. " nodes replaced in " .. (os.clock() - start_time) .. "s")
		minetest.log("action", name .. " used floodfill at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. nodes_replaced .. " nodes in " .. (os.clock() - start_time) .. "s")
	end
})
