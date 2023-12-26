local function adjust_speed_relative(player, offset)
	local overrides = player:get_physics_override()
	
	local src_speed = overrides.speed or 1
	local src_climb_speed = overrides.climb_speed or 1
	
	player:set_physics_override({
		speed = math.max(src_speed + offset, 0.5),
		climb_speed = math.max(src_climb_speed + offset, 0.5)
	})
	
	-- Completely paranoid is me
	local overrides_after = player:get_physics_override()
	worldedit.player_notify(player:get_player_name(), "Movement speed is now x" .. tostring(overrides_after.speed))
end


local function use_primary(player)
	adjust_speed_relative(player, 0.5)
end

local function use_secondary(player)
	adjust_speed_relative(player, -0.5)
end


minetest.register_tool(":worldeditadditions:movetool", {
	description = "WorldEditAdditions movement speed adjustment tool",
	inventory_image = "worldeditadditions_movement.png",
	
	
	on_use = function(itemstack, player, pointed_thing)
		-- Left click
		use_primary(player)
	end,
	
	on_secondary_use = function(itemstack, player, pointed_thing)
		-- Right click when pointed at nothing
		use_secondary(player)
	end,
	
	on_place = function(itemstack, player, pointed_thing)
		-- Right click when pointed at something
		use_secondary(player)
	end
})