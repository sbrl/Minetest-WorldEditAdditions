minetest.register_tool(":worldeditadditions:farwand", {
	description = "WorldEditAdditions far-reaching wand",
	inventory_image = "worldeditadditions_farwand.png",
	
	on_place = function(itemstack, player, pointed_thing)
		print("[farwand] on_place", player:get_player_name())
		-- Right click when pointing at something
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		print("[farwand] on_use", player:get_player_name())
		-- Left click when pointing at something or nothing
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		-- Right click when pointing at nothing
		
		print("[farwand] on_secondary_use", player:get_player_name())
	end
})
