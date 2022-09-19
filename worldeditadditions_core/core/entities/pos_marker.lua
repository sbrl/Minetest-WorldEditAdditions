local wea_c = worldeditadditions_core
local EventEmitter = worldeditadditions_core.EventEmitter


local anchor

local WEAPositionMarker = {
	initial_properties = {
		visual = "cube",
		visual_size = { x = 1.15, y = 1.1 },
		collisionbox = { -0.55, -0.55, -0.55, 0.55, 0.55, 0.55 },
		physical = false,
		collide_with_objects = false,
		static_save = false,
		
		textures = {
			"worldeditadditions_bg.png",
			"worldeditadditions_bg.png",
			"worldeditadditions_bg.png",
			"worldeditadditions_bg.png",
			"worldeditadditions_bg.png",
			"worldeditadditions_bg.png",
		}
	},
	
	on_activate = function(self, staticdata)
		-- noop
	end,
	on_punch = function(self, _)
		anchor.delete(self)
	end,
	on_blast = function(self, damage)
		return false, false, {} -- Do not damage or knockback the player
	end
}

minetest.register_entity(":worldeditadditions:position", WEAPositionMarker)

local function create(player_name, pos, display_number)
	local entity = minetest.add_entity(pos, "worldeditadditions:position")
	
	entity:get_luaentity().player_name = player_name
	entity:get_luaentity().display_number = display_number
	
	anchor.set_number(entity, display_number)
	
	anchor:emit("create", {
		player_name = player_name,
		pos = pos,
		display_number = display_number,
	})
	return entity
end

local function delete(entity)
	local player_name = entity:get_luaentity().player_name
	local display_number = entity:get_luaentity().display_number
	
	entity:remove()
	
	anchor:emit("delete", {
		player_name = player_name,
		display_number = display_number
	})
end

local function set_number(entity, display_number)
	if type(display_number) ~= "number" then return false, "Error: The 'display_number' property must be of type number, but received value of unexpected type '"..type(display_number).."'." end
	
	-- marker:set_properties({  }) is our friend
	print("DEBUG:pos_marker_set_number display_number", display_number)
	print("DEBUG:pos_marker_set_number TODO_IMPLEMENT THIS. entity", wea_c.inspect(entity))
end

anchor = EventEmitter.new({
	create = create,
	delete = delete,
	set_number = set_number
})

return anchor