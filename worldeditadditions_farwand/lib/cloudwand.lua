local function add_point(name, pos)
	if pos ~= nil then
		-- print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		if not worldedit.pos1[name] then worldedit.pos1[name] = vector.new(pos) end
		if not worldedit.pos2[name] then worldedit.pos2[name] = vector.new(pos) end
		
		worldedit.marker_update(name)
		
		local volume_before = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		worldedit.pos1[name], worldedit.pos2[name] = worldeditadditions.vector.expand_region(worldedit.pos1[name], worldedit.pos2[name], pos)
		
		local volume_after = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		local volume_difference = volume_after - volume_before
		
		worldedit.marker_update(name)
		worldedit.player_notify(name, "Expanded region by "..volume_difference.." nodes")
	else
		worldedit.player_notify(name, "Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos1]", name, "nil")
	end
end
local function clear_points(name, pos)
	worldedit.pos1[name] = nil
	worldedit.pos2[name] = nil
	worldedit.marker_update(name)
	worldedit.set_pos[name] = nil
end

minetest.register_tool(":worldeditadditions:cloudwand", {
	description = "WorldEditAdditions far-reaching point cloud wand",
	inventory_image = "worldeditadditions_cloudwand.png",
	
	on_place = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_place", name)
		-- Right click when pointing at something
		-- Pointed thing: https://rubenwardy.com/minetest_modding_book/lua_api.html#pointed_thing
		clear_points(name)
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_use", name)
		local looking_pos, node_id = worldeditadditions.farwand.do_raycast(player)
		add_point(name, looking_pos)
		-- Left click when pointing at something or nothing
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- Right click when pointing at nothing
		-- print("[farwand] on_secondary_use", name)
		
		clear_points(name)
	end
})
