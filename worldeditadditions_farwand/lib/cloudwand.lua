local wea = worldeditadditions

minetest.register_tool(":worldeditadditions:cloudwand", {
	description = "WorldEditAdditions far-reaching additive selectior wand",
	inventory_image = "worldeditadditions_cloudwand.png",
	
	on_place = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_place", name)
		-- Right click when pointing at something
		-- Pointed thing: https://rubenwardy.com/minetest_modding_book/lua_api.html#pointed_thing
		wea.selection.clear_points(name)
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_use", name)
		local looking_pos, node_id = worldeditadditions.farwand.do_raycast(player)
		wea.selection.add_point(name, looking_pos)
		-- Left click when pointing at something or nothing
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- Right click when pointing at nothing
		-- print("[farwand] on_secondary_use", name)
		
		wea.selection.clear_points(name)
	end
})
