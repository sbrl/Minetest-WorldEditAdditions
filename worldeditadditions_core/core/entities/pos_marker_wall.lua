local wea_c = worldeditadditions_core
local EventEmitter = worldeditadditions_core.EventEmitter
local Vector3 = wea_c.Vector3

local anchor

local entity_wall_size = 10
local collision_thickness = 0.2

local function make_id()
	return tostring(wea_c.get_ms_time()) .. "_" .. tostring(math.floor(math.random() * 1000000))
end

local last_reset = make_id()


local WEAPositionMarkerWall = {
	initial_properties = {
		visual = "cube",
		visual_size = { x = 1, y = 1, z = 1 },
		collisionbox = { -0.55, -0.55, -0.55, 0.55, 0.55, 0.55 },
		-- ^^ { xmin, ymin, zmin, xmax, ymax, zmax } relative to obj pos
		physical = false,
		collide_with_objects = false,
		hp_max = 1,
		
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
		local data = minetest.parse_json(staticdata)
		if type(data) ~= "table" or data.id ~= last_reset then
			self.object:remove()
			return
		end
		
		self.__id = data.id
		self._size = Vector3.clone(data.size)
		self._side = data.side
		self.player_name = data.player_name
		
		anchor.__single_setup(self.object, self._size, self._side)
		
		anchor:emit("update_entity", {
			entity = self.object,
			player_name = self.player_name
		})
	end,
	on_punch = function(self, _)
		print("DEBUG:pos_marker_wall on_punch")
		anchor.delete(self)
		-- Only unmark the rest of the walls
		-- Unmark for the player that created this wall.... NOT the player who punched it!
		wea_c.pos.unmark(self.player_name, false, true)
	end,
	on_blast = function(self, damage)
		return false, false, {} -- Do not damage or knockback the player
	end,
	get_staticdata = function(self)
		return minetest.write_json({
			id = self.__id,
			size = self._size,
			side = self._side,
			player_name = self.player_name
		})
	end
}

minetest.register_entity(
	":worldeditadditions:marker_wall",
	WEAPositionMarkerWall
)


--- Updates the properties of a single wall to match it's side and size
local function single_setup(entity, size, side)
	local new_props = {
		visual_size = Vector3.min(
			Vector3.new(10, 10, 10),
			size:abs()
		)
			-- x = math.min(10, math.abs(size.x)),
			-- y = math.min(10, math.abs(size.y)),
			-- z = math.min(10, math.abs(size.z))
	}

	local cthick = Vector3.new(
		collision_thickness,
		collision_thickness,
		collision_thickness
	)
	local cpos1 = Vector3.clone(new_props.visual_size):multiply(-1):divide(2):add(cthick)
	local cpos2 = Vector3.clone(new_props.visual_size):divide(2):subtract(cthick)

	if side == "x" or side == "-x" then
		new_props.visual_size = new_props.visual_size + Vector3.new(
			collision_thickness - 0.1
		)
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
	
	-- print("DEBUG:setup_single size", size, "side", side, "new_props", wea_c.inspect(new_props))
	
	entity:set_properties(new_props)
end

--- Creates a single marker wall entity.
-- @param	player_name	string	The name of the player it should belong to.
-- @param	pos1		Vector3	The pos1 corner of the area the SINGLE marker should cover.
-- @param	pos2		Vector3	The pos2 corner of the area the SINGLE marker should cover.
-- @param	side		string	The side that this wall is on. Valid values: x, -x, y, -y, z, -z.
-- @returns	Entity<WEAPositionMarkerWall>
local function create_single(player_name, pos1, pos2, side)
	
	
	local pos_centre = ((pos2 - pos1) / 2) + pos1
	local entity = minetest.add_entity(pos_centre, "worldeditadditions:marker_wall", minetest.write_json({
		id = last_reset,
		size = pos2 - pos1,
		side = side,
		player_name = player_name
	}))
	-- print("DEBUG:marker_wall create_single --> START player_name", player_name, "pos1", pos1, "pos2", pos2, "side", side, "SPAWN", pos_centre, "last_reset", last_reset)
	
	-- entity:get_luaentity().player_name = player_name
	
	-- single_setup(entity, pos2 - pos1, side)
	
	return entity
end


--- Creates a marker wall around the defined region.
-- @param	player_name			string	The name of the player that the wall belongs to.
-- @param	pos1				Vector3	pos1 of the defined region.
-- @param	pos2				Vector3	pos2 of the defined region.
-- @param	sides_to_display	string	The sides of the marker wall that should actually be displayed, squished together into a single string. Defaults to "+x-x+z-z". Use "+x-x+z-z+y-y" to display all sides; add and remove sides as desired.
-- @returns	table<entitylist>	A list of all created entities.
local function create_wall(player_name, pos1, pos2, sides_to_display)
	if not sides_to_display then
		sides_to_display = "+x-x+z-z" -- this matches WorldEdit
		-- To display all of them:
		-- sides_to_display = "+x-x+z-z+y-y"
	end
	-- print("DEBUG:marker_wall create_wall --> START player_name", player_name, "pos1", pos1, "pos2", pos2)
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
	if string.find(sides_to_display, "+x") then
		local posx_pos1 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)
		local posx_pos2 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)
		
		-- print("DEBUG ************ +X pos1", posx_pos1, "pos2", posx_pos2)

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

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"x"
				)
				table.insert(entities, entity)
			end
		end
		
	end
	
	
	--       ██   ██
	--        ██ ██
	-- ██████  ███
	--        ██ ██
	--       ██   ██
	-- Now, do negative x
	if string.find(sides_to_display, "-x") then
		local negx_pos1 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)
		local negx_pos2 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)
		-- print("DEBUG ************ -X pos1", negx_pos1, "pos2", negx_pos2)

		for z = negx_pos2.z, negx_pos1.z, -entity_wall_size do
			for y = negx_pos2.y, negx_pos1.y, -entity_wall_size do
				local single_pos1 = Vector3.new(
					negx_pos1.x,
					y,
					z
				)
				local single_pos2 = Vector3.new(
					negx_pos1.x,
					math.max(y - entity_wall_size, negx_pos1.y),
					math.max(z - entity_wall_size, negx_pos1.z)
				)

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"-x"
				)
				table.insert(entities, entity)
			end
		end
	
	end
	
	
	--       ██    ██
	--   ██   ██  ██ 
	-- ██████  ████  
	--   ██     ██   
	--          ██   
	-- Now, positive y
	if string.find(sides_to_display, "+y") then
		local posy_pos1 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)
		local posy_pos2 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)

		-- print("DEBUG ************ +Y pos1", posy_pos1, "pos2", posy_pos2)

		for z = posy_pos2.z, posy_pos1.z, -entity_wall_size do
			for x = posy_pos2.x, posy_pos1.x, -entity_wall_size do
				local single_pos1 = Vector3.new(
					x,
					posy_pos1.y,
					z
				)
				local single_pos2 = Vector3.new(
					math.max(x - entity_wall_size, posy_pos1.x),
					posy_pos1.y,
					math.max(z - entity_wall_size, posy_pos1.z)
				)

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"y"
				)
				table.insert(entities, entity)
			end
		end
		
	end
	
	--       ██    ██
	--        ██  ██
	-- ██████  ████
	--          ██
	--          ██
	-- Now, negative y
	if string.find(sides_to_display, "-y") then
		local negy_pos1 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)
		local negy_pos2 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)

		-- print("DEBUG ************ -Y pos1", negy_pos1, "pos2", negy_pos2)

		for z = negy_pos2.z, negy_pos1.z, -entity_wall_size do
			for x = negy_pos2.x, negy_pos1.x, -entity_wall_size do
				local single_pos1 = Vector3.new(
					x,
					negy_pos1.y,
					z
				)
				local single_pos2 = Vector3.new(
					math.max(x - entity_wall_size, negy_pos1.x),
					negy_pos1.y,
					math.max(z - entity_wall_size, negy_pos1.z)
				)

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"-y"
				)
				table.insert(entities, entity)
			end
		end
		
	end
	
	--       ███████
	--   ██     ███ 
	-- ██████  ███  
	--   ██   ███   
	--       ███████
	-- Now, positive z. Almost there!
	if string.find(sides_to_display, "+z") then
		local posz_pos1 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)
		local posz_pos2 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.max(pos1s.z, pos2s.z) + 0.5
		)

		-- print("DEBUG ************ +Z pos1", posz_pos1, "pos2", posz_pos2)

		for x = posz_pos2.x, posz_pos1.x, -entity_wall_size do
			for y = posz_pos2.y, posz_pos1.y, -entity_wall_size do
				local single_pos1 = Vector3.new(
					x,
					y,
					posz_pos1.z
				)
				local single_pos2 = Vector3.new(
					math.max(x - entity_wall_size, posz_pos1.x),
					math.max(y - entity_wall_size, posz_pos1.y),
					posz_pos1.z
				)

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"z"
				)
				table.insert(entities, entity)
			end
		end
		
	end
	
	
	--       ███████
	--          ███
	-- ██████  ███
	--        ███
	--       ███████
	-- Finally, negative z. Last one!
	if string.find(sides_to_display, "-z") then
		local negz_pos1 = Vector3.new(
			math.min(pos1s.x, pos2s.x) - 0.5,
			math.min(pos1s.y, pos2s.y) - 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)
		local negz_pos2 = Vector3.new(
			math.max(pos1s.x, pos2s.x) + 0.5,
			math.max(pos1s.y, pos2s.y) + 0.5,
			math.min(pos1s.z, pos2s.z) - 0.5
		)

		-- print("DEBUG ************ -Z pos1", negz_pos1, "pos2", negz_pos2)

		for x = negz_pos2.x, negz_pos1.x, -entity_wall_size do
			for y = negz_pos2.y, negz_pos1.y, -entity_wall_size do
				local single_pos1 = Vector3.new(
					x,
					y,
					negz_pos1.z
				)
				local single_pos2 = Vector3.new(
					math.max(x - entity_wall_size, negz_pos1.x),
					math.max(y - entity_wall_size, negz_pos1.y),
					negz_pos1.z
				)

				local entity = create_single(player_name,
					single_pos1, single_pos2,
					"-z"
				)
				table.insert(entities, entity)
			end
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
	-- print("DEBUG:marker_wall delete --> START with "..#entitylist.." entities")
	local player_name
	for _, entity in ipairs(entitylist) do
		if not entity.get_luaentity or not entity:get_luaentity() then return end -- Ensure the entity is still valid
		
		if not player_name then
			player_name = entity:get_luaentity().player_name
		end
		
		entity:remove()
	end
	
	last_reset = make_id()
	-- print("DEBUG:marker_wall delete --> LAST_RESET is now", last_reset, "type", type(last_reset))
	
	anchor:emit("delete", {
		player_name = player_name
	})
	
	
end

anchor = EventEmitter.new({
	create = create_wall,
	delete = delete,
	__single_setup = single_setup
})

return anchor