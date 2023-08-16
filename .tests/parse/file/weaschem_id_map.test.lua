local weaschem = require("worldeditadditions_core.utils.parse.file.weaschem")

local parse_json = require("worldeditadditions_core.utils.parse.json")

local function get_string(test_name)
	if test_name:match("[^%w_]") then return nil end -- Just in case
	local filename = ".tests/parse/file/testfiles/idmap_"..test_name..".json"
	
	local handle = io.open(filename, "r")
	if handle == nil then return nil end
	local content = handle:read("*a")
	handle:close()
	
	return content
end

local epsilon = 0.000001
local function validate_id_map(idmap, is_delta)
	for node_id, node_name in pairs(idmap) do
		assert.are.same("number", type(node_id))
		assert.are.same("string", type(node_name))
		assert.is_true(node_id - math.floor(node_id) < epsilon)
		if is_delta then
			assert.is_true(node_id >= -2)
		else
			assert.is_true(node_id >= -1)
		end
	end
end

describe("parse.file.weaschem.parse_id_map", function()
	it("should parse a valid id map", function()
		local content = '{"0": "default:stone","15":"default:dirt_with_grass"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_id_map(result)
		assert.are.same({
			[0] = "default:stone",
			[15] = "default:dirt_with_grass"
		}, result)
	end)
	it("should parse a valid id map with multiple mods", function()
		local content = '{"0": "default:stone","15":"default:dirt_with_grass","99":"another:blah"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_id_map(result)
		assert.are.same({
			[0] = "default:stone",
			[15] = "default:dirt_with_grass",
			[99] = "another:blah"
		}, result)
	end)
	it("should not parse an invalid id map", function()
		local content = '{"0": "default:stone,"15":"default:dirt_with_grass"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_INVALID_JSON", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map with a relative node name", function()
		local content = '{"0": "stone","15":"default:dirt_with_grass"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_RELATIVE_NODE_NAME", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map with a floating-point node ids", function()
		local content = '{"0": "stone","15":"default:dirt_with_grass"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_RELATIVE_NODE_NAME", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map type full with invalid node id -1", function()
		local content = '{"0": "default:stone","15":"default:dirt_with_grass","-1": "somemod:blah"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_NEGATIVE_NODE_ID", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map type full with invalid node id -2", function()
		local content = '{"0": "default:stone","15":"default:dirt_with_grass","-2": "somemod:blah"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_NEGATIVE_NODE_ID", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map type full with invalid node id -99", function()
		local content = '{"0": "default:stone","15":"default:dirt_with_grass","-99": "somemod:blah"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_NEGATIVE_NODE_ID", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map with floating-point node names", function()
		local content = '{"0": "default:stone","15.1":"default:dirt_with_grass"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_FLOATING_POINT_NODE_NAME", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map with duplicate node names", function()
		local content = '{"15": "default:stone","15.0":"foo:dupliate"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_DUPLICATE", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an id map with a node id that is not a number", function()
		local content = '{"15": "default:stone","cheeese :D":"foo:dupliate"}'
		local success, code, result = weaschem.parse_id_map(content)

		assert.are.same(false, success)
		assert.are.same("ID_MAP_INVALID_ID", code)
		assert.are.same("string", type(result))
	end)
end)

