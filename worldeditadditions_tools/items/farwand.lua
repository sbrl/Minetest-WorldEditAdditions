local wea_t = worldeditadditions_tools

local function set_pos1(name, pos)
	if pos ~= nil then
		-- print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		worldedit.pos1[name] = pos
		worldedit.mark_pos1(name)
		worldedit.player_notify(name, "pos1 set to "..pos) -- pos is a Vector3
	else
		worldedit.player_notify(name, "Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos1]", name, "nil")
	end
end
local function set_pos2(name, pos)
	if pos ~= nil then
		-- print("[set_pos2]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		worldedit.pos2[name] = pos
		worldedit.mark_pos2(name)
		worldedit.player_notify(name, "pos2 set to "..pos)
	else
		worldedit.player_notify(name, "Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos2]", name, "nil")
	end
end

wea_t.register_tool("farwand", {
	description = "WorldEditAdditions far-reaching wand",
	inventory_image = "worldeditadditions_tools.png",
	
	on_place = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_place", name)
		-- Right click when pointing at something
		-- Pointed thing: https://rubenwardy.com/minetest_modding_book/lua_api.html#pointed_thing
		local looking_pos, node_id = worldeditadditions_tools.do_raycast(player)
		set_pos2(name, looking_pos)
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- print("[farwand] on_use", name)
		local looking_pos, node_id = worldeditadditions_tools.do_raycast(player)
		set_pos1(name, looking_pos)
		-- Left click when pointing at something or nothing
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		local name = player:get_player_name()
		-- Right click when pointing at nothing
		-- print("[farwand] on_secondary_use", name)
		
		local looking_pos, node_id = worldeditadditions_tools.do_raycast(player)
		set_pos2(name, looking_pos)
	end
})
