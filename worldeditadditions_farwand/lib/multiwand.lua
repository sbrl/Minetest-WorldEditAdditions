local wea_c = worldeditadditions_core
local wea = worldeditadditions
local Vector3 = wea.Vector3

local function push_pos(player_name, pos)
	pos = Vector3.clone(pos)
	if player_name == nil then return end
	if pos == nil then
		worldedit.player_notify(player_name, "[multi wand] Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
	else
		wea_c.pos.push(player_name, pos)
		worldedit.player_notify(player_name, "[multi wand] Added "..pos..". "..wea_c.pos.count(player_name).." points now registered.")
	end
end
local function pop_pos(player_name)
	if player_name == nil then return end
	local count_before = wea_c.pos.count(player_name)
	wea_c.pos.pop(player_name)
	local count_after = wea_c.pos.count(player_name)
	if count_before > 0 then
		worldedit.player_notify(player_name, "[multi wand] "..count_before.." -> "..count_after.." points registered")
	else
		worldedit.player_notify(player_name, "[multi wand] No points registered")
	end
end


minetest.register_tool(":worldeditadditions:multiwand", {
	description = "WorldEditAdditions multi-point wand",
	inventory_image = "worldeditadditions_multiwand.png",
	
	on_place = function(itemstack, player, pointed_thing)
		-- Right click when pointing at something
		-- Pointed thing: https://rubenwardy.com/minetest_modding_book/lua_api.html#pointed_thing
		-- print("[farwand] on_place", name)
		local name = player:get_player_name()
		pop_pos(name)
	end,
	
	on_use = function(itemstack, player, pointed_thing)
		-- Left click when pointing at something or nothing
		local name = player:get_player_name()
		-- print("[farwand] on_use", name)
		local looking_pos, node_id = wea.farwand.do_raycast(player)
		push_pos(name, looking_pos)
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		-- Right click when pointing at nothing
		-- print("[farwand] on_secondary_use", name)
		local name = player:get_player_name()
		
		-- local looking_pos, node_id = do_raycast(player)
		pop_pos(name)
	end
})
