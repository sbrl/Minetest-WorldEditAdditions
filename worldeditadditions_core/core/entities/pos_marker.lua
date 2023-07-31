local wea_c = worldeditadditions_core
local EventEmitter = worldeditadditions_core.EventEmitter


local anchor

local function make_id()
	return tostring(wea_c.get_ms_time()) .. "_" .. tostring(math.floor(math.random() * 1000000))
end

local last_reset = make_id()


local WEAPositionMarker = {
	initial_properties = {
		visual = "cube",
		visual_size = { x = 1.15, y = 1.1 },
		collisionbox = { -0.55, -0.55, -0.55, 0.55, 0.55, 0.55 },
		physical = false,
		collide_with_objects = false,
		hp_max = 1,
		
		textures = {
			"worldeditadditions_core_bg.png",
			"worldeditadditions_core_bg.png",
			"worldeditadditions_core_bg.png",
			"worldeditadditions_core_bg.png",
			"worldeditadditions_core_bg.png",
			"worldeditadditions_core_bg.png",
		}
	},
	
	on_activate = function(self, staticdata)
		local data = minetest.parse_json(staticdata)
		print("DEBUG:pos_marker ON_ACTIVATE data", data)
		if type(data) ~= "table" or data.id ~= last_reset then
			-- print("DEBUG:marker_wall/remove staticdata", staticdata, "last_reset", last_reset)
			self.object:remove()
			-- else
			-- print("DEBUG:marker_wall/ok staticdata", staticdata, "type", type(staticdata), "last_reset", last_reset, "type", type(last_reset))
			return
		end
		
		self.__id = data.id
		self.player_name = data.player_name
		self.display_number = data.display_number
		
		anchor:emit("update_entity", {
			entity = self.object,
			id = self.__id,
			player_name = self.player_name,
			i = self.display_number
		})
		anchor.set_number(self.object, self.display_number)
	end,
	on_punch = function(self, _)
		print("DEBUG:pos_marker on_punch")
		anchor.delete(self)
	end,
	on_blast = function(self, damage)
		return false, false, {} -- Do not damage or knockback the player
	end,
	get_staticdata = function(self)
		return minetest.write_json({
			id = self.__id,
			display_number = self.display_number,
			player_name = self.player_name
		})
	end
}

minetest.register_entity(":worldeditadditions:position", WEAPositionMarker)

local function create(player_name, pos, display_number)
	local entity = minetest.add_entity(pos, "worldeditadditions:position", minetest.write_json({
		id = last_reset,
		display_number = display_number,
		player_name = player_name
	}))
	
	-- entity:get_luaentity().player_name = player_name
	-- entity:get_luaentity().display_number = display_number
	
	-- anchor.set_number(entity, display_number)
	
	anchor:emit("create", {
		player_name = player_name,
		pos = pos,
		display_number = display_number,
	})
	return entity
end

local function delete(entity)
	if not entity or not entity.get_luaentity or not entity:get_luaentity() then return end -- Ensure the entity is still valid
	
	local player_name = entity:get_luaentity().player_name
	local display_number = entity:get_luaentity().display_number
	
	last_reset = make_id()
	
	entity:remove()
	
	anchor:emit("delete", {
		player_name = player_name,
		display_number = display_number
	})
end

local number_colours = {
	"#FF0000",
	"#ff6800",
	"#FFD700",
	"#CCFF00",
	"#00FF00",
	"#00FFAA",
	"#00FFFF",
	"#0088FF",
	"#5058FF",
	"#8800ff",
	"#FF00ff",
	"#FF0088"
}

local function set_number(entity, display_number)
	if type(display_number) ~= "number" then return false, "Error: The 'display_number' property must be of type number, but received value of unexpected type '"..type(display_number).."'." end
	
	local texture_name = ""
	
	if display_number < 100 then
		local number_right = display_number % 10
		local number_left = (display_number - number_right) / 10
		texture_name = texture_name .. "worldeditadditions_core_l" .. number_left .. ".png"
		texture_name = texture_name .. "^worldeditadditions_core_r" .. number_right .. ".png"
		-- print("DEBUG:set_number number_left", number_left, "number_right", number_right)
		
		local colour_id = ((display_number - 1) % 12) + 1 -- Lua starts from 1, not 0 :-/
		texture_name = "("..texture_name..")^[colorize:"..number_colours[colour_id]..":255"
	end
	if #texture_name > 0 then
		texture_name = "worldeditadditions_core_bg.png^(" .. texture_name .. ")"
	else
		texture_name = "worldeditadditions_core_bg.png"
	end
	
	-- print("DEBUG:set_number texture_name", texture_name)
	
	entity:set_properties({
		textures = {
			texture_name, texture_name, texture_name,
			texture_name, texture_name, texture_name,
		}
	})
end

anchor = EventEmitter.new({
	create = create,
	delete = delete,
	set_number = set_number
})
anchor.debug = true
return anchor
