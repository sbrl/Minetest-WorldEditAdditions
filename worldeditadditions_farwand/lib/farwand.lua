local function set_pos1(name, pos)
	if pos ~= nil then
		print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		worldedit.pos1[name] = pos
		worldedit.mark_pos1(name)
	else
		print("[set_pos1]", name, "nil")
	end
end
local function set_pos2(name, pos)
	if pos ~= nil then
		print("[set_pos2]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		worldedit.pos2[name] = pos
		worldedit.mark_pos2(name)
	else
		print("[set_pos2]", name, "nil")
	end
end

local function do_raycast(player)
	if player == nil then return nil end
	local player_name = player:get_player_name()
	
	if worldeditadditions.farwand.player_data[player_name] == nil then
		worldeditadditions.farwand.player_data[player_name] = { maxdist = 1000, skip_liquid = true }
	end
	
	local looking_pos, node_id = worldeditadditions.raycast(
		player, 
		worldeditadditions.farwand.player_data[player_name].maxdist,
		worldeditadditions.farwand.player_data[player_name].skip_liquid
	)
	return looking_pos, node_id
end

minetest.register_tool(":worldeditadditions:farwand", {
	description = "WorldEditAdditions far-reaching wand",
	inventory_image = "worldeditadditions_farwand.png",
	
	on_place = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		print("[farwand] on_place", name)
		-- Right click when pointing at something
		-- Pointed thing: https://rubenwardy.com/minetest_modding_book/lua_api.html#pointed_thing
		local looking_pos, node_id = do_raycast(player)
		set_pos2(name, looking_pos)
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		print("[farwand] on_use", name)
		local looking_pos, node_id = do_raycast(player)
		set_pos1(name, looking_pos)
		-- Left click when pointing at something or nothing
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- Right click when pointing at nothing
		print("[farwand] on_secondary_use", name)
		
		local looking_pos, node_id = do_raycast(player)
		set_pos2(name, looking_pos)
	end
})
