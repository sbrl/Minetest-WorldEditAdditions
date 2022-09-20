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
	if not entity.get_luaentity then return end -- Ensure the entity is still valid
	
	local player_name = entity:get_luaentity().player_name
	local display_number = entity:get_luaentity().display_number
	
	entity:remove()
	
	anchor:emit("delete", {
		player_name = player_name,
		display_number = display_number
	})
end

local number_colours = {
	"#FF0000",
	"#FF8800",
	"#FFFF00",
	"#88FF00",
	"#00FF00",
	"#00FF88",
	"#00FFFF",
	"#0088FF",
	"#0000FF",
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
		texture_name = texture_name.."worldeditadditions_l"..number_left..".png"
		texture_name = texture_name.."^worldeditadditions_r"..number_right..".png"
		print("DEBUG:set_number number_left", number_left, "number_right", number_right)
		
		local colour_id = (display_number % 12) + 1 -- Lua starts from 1, not 0 :-/
		texture_name = "("..texture_name..")^[colorize:"..number_colours[colour_id]..":255"
	end
	if #texture_name > 0 then
		texture_name = "worldeditadditions_bg.png^("..texture_name..")"
	else
		texture_name = "worldeditadditions_bg.png"
	end
	
	print("DEBUG:set_number texture_name", texture_name)
	
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

return anchor