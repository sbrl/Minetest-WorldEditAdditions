local wea_c = worldeditadditions_core
local EventEmitter = worldeditadditions_core.EventEmitter
local Vector3 = wea_c.Vector3

local anchor

local entity_wall_size = 10
local collision_thickness = 0.2

local WEAPositionMarkerWall = {
	initial_properties = {
		visual = "cube",
		visual_size = { x = 1, y = 1, z = 1 },
		collisionbox = { -0.55, -0.55, -0.55, 0.55, 0.55, 0.55 },
		-- ^^ { xmin, ymin, zmin, xmax, ymax, zmax } relative to obj pos
		physical = false,
		collide_with_objects = false,
		static_save = false,

		textures = {
			"worldeditadditions_core_marker_wall.png",
			"worldeditadditions_core_marker_wall.png",
			"worldeditadditions_core_marker_wall.png",
			"worldeditadditions_core_marker_wall.png",
			"worldeditadditions_core_marker_wall.png",
			"worldeditadditions_core_marker_wall.png",
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

minetest.register_entity(":worldeditadditions:marker_wall", WEAPositionMarker)


--- Updates the properties of a single wall to match it's side and size
local function single_setup(entity, size, side)
	local new_props = {
		visual_size = {
			x = math.min(10, size.x),
			y = math.min(10, size.y),
			z = math.min(10, size.z)
		}
	}

	local cthick = Vector3.new(
		collision_thickness,
		collision_thickness,
		collision_thickness
	)
	local cpos1 = Vector3.clone(new_props.visual_size):multiply(-1):divide(2):add(cthick)
	local cpos2 = Vector3.clone(new_props.visual_size):divide(2):subtract(cthick)

	if side == "x" or side == "-x" then
		new_props.visual_size.x = collision_thickness - 0.1
		cpos1.x = -collision_thickness
		cpos2.x = collision_thickness
	end
	if side == "y" or side == "-y" then
		new_props.visual_size.y = collision_thickness - 0.1
		cpos1.y = -collision_thickness
		cpos2.y = collision_thickness
	end
	if side == "z" or side == "-z" then
		new_props.visual_size.z = collision_thickness - 0.1
		cpos1.z = -collision_thickness
		cpos2.z = collision_thickness
	end

	new_props.collisionbox = {
		cpos1.x, cpos1.y, cpos1.z,
		cpos2.x, cpos2.y, cpos2.z
	}

	entity:set_properties(new_props)
end

--- Creates a single marker wall entity.
-- @param	player_name	string	The name of the player it should belong to.
-- @param	pos1		Vector3	The pos1 corner of the area the SINGLE marker should cover.
-- @param	pos2		Vector3	The pos2 corner of the area the SINGLE marker should cover.
-- @param	side		string	The side that this wall is on. Valid values: x, -x, y, -y, z, -z.
-- @returns	Entity<WEAPositionMarkerWall>
local function create_single(player_name, pos1, pos2, side)
	local pos_centre = pos2 - pos1
	local entity = minetest.add_entity(pos_centre, name)
	
	entity:get_luaentity().player_name = player_name
	
	single_setup(entity, pos2 - pos1, side)
	
	return entity
end


--- Creates a marker wall around the defined region.
-- @param	player_name			string	The name of the player that the wall belongs to.
-- @param	pos1				Vector3	pos1 of the defined region.
-- @param	pos2				Vector3	pos2 of the defined region.
-- @returns	table<entitylist>	A list of all created entities.
local function create_wall(player_name, pos1, pos2)
	local pos1s, pos2s = Vector3.sort(pos1, pos2)
	
	local entities = {}
	-- local dim1, dim2
	-- if side == "x" or side == "-x" then dim1, dim2 = size.z, size.y
	-- elseif side == "z" or size == "-z" then dim1, dim2 = size.x, size.y
	-- elseif side == "y" or size == "-y" then dim1, dim2 = size.x, size.z
	-- end
	
	-- x → z, y
	-- z → x, y
	-- y → x, z
	
	--       ██   ██
	--   ██   ██ ██
	-- ██████  ███
	--   ██   ██ ██
	--       ██   ██
	
	-- First, do positive x
	local posx_pos1 = Vector3.new(
		math.max(pos1s.x, pos2s.x),
		math.min(pos1s.y, pos2s.y),
		math.min(pos1s.z, pos2s.z)
	)
	local posx_pos2 = Vector3.new(
		math.max(pos1s.x, pos2s.x),
		math.max(pos1s.y, pos2s.y),
		math.max(pos1s.z, pos2s.z)
	)
	
	for z = posx_pos2.z, posx_pos1.z, -entity_wall_size do
		for y = posx_pos2.y, posx_pos1.y, -entity_wall_size do
			local single_pos1 = Vector3.new(
				posx_pos1.x,
				y,
				z
			)
			local single_pos2 = Vector3.new(
				posx_pos1.x,
				math.max(y - entity_wall_size, posx_pos1.y),
				math.max(z - entity_wall_size, posx_pos1.z)
			)
			
			local entity = create_single(player_name, single_pos1, single_pos2, "x")
			table.insert(entities, entity)
		end
	end
	
	
	-- TODO: All the other sides. For testing we're doing 1 side for now, so we can vaoid having to do everything all over again if we make a mistake.
	
	
	
	-- for z = pos2.z, pos1.z, -entity_wall_size do
	-- 	for y = pos2.y, pos1.y, -entity_wall_size do
	-- 		for x = pos2.x, pos1.x, -entity_wall_size do
				
	-- 		end
	-- 	end
	-- end
	
	return entities
end


--- Deletes all entities in the given entity list
-- @param	entitylist	table<entity>	A list of wall entities that make up the wall to delete.
local function delete(entitylist)
	local player_name
	for _, entity in ipairs(entitylist) do
		if not entity.get_luaentity or not entity:get_luaentity() then return end -- Ensure the entity is still valid
		
		if not player_name then
			player_name = entity:get_luaentity().player_name
		end
	end
	
	anchor:emit("delete", {
		player_name = player_name
	})
end

anchor = EventEmitter.new({
	create = create_wall,
	delete = delete
})
