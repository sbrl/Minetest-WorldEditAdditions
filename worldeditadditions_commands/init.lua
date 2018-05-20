--- WorldEditAdditions-ChatCommands
-- @module worldeditadditions_commands
-- @release 0.1
-- @copyright 2018 Starbeamrainbowlabs
-- @license Mozilla Public License, 2.0
-- @author Starbeamrainbowlabs

local safe_region, check_region, reset_pending = dofile(minetest.get_modpath("worldedit_commands") .. "/safe.lua")

local function parse_params_floodfill(params_text)
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
	
	return replace_node, radius
end

minetest.register_chatcommand("/floodfill", {
	params = "<replace_node> [<radius>]",
	description = "Floods all connected nodes of the same type starting at pos1 with <replace_node>, in a box-shape with a radius of <radius>, which defaults to 50.",
	privs = { worldedit = true },
	-- TODO: Integrate will the safe_region feature of regular worldedit
	func = safe_region(function(name, params_text)
		local replace_node, radius = parse_params_floodfill(params_text)
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		
		local start_time = os.clock()
		local nodes_replaced = worldedit.floodfill(worldedit.pos1[name], radius, replace_node)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, nodes_replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used floodfill at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. nodes_replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local replace_node, radius = parse_params_floodfill(params_text)
		
		return math.ceil(((4 * math.pi * (tonumber(radius) ^ 3)) / 3) / 2) -- Volume of a hemisphere
	end)
})
