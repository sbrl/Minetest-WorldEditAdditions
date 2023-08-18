local weaschem = require("worldeditadditions_core.utils.parse.file.weaschem")

local inspect = require("worldeditadditions_core.utils.inspect")


local function make_filename(test_id)
	return ".tests/parse/file/testfiles/parse_"..test_id..".weaschem"
end

local function make_handle(test_id)
	return io.open(make_filename(test_id), "r")
end

describe("parse.file.weaschem.parse", function()
	it("should parse a valid file", function()
		local handle = make_handle("valid")
		
		local success, code, result = weaschem.parse(handle)
		
		-- print("DEBUG:parse", inspect(result))
		
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		assert.are.same({
			id_map = {
				[0] = "default:air",
				[14] = "default:dirt",
				[5] = "default:stone"
			},
			header = {
				offset = {
					y = 0,
					x = 1,
					z = 2
				},
				type = "full",
				description = "Some description",
				generator = "WorldEditAdditions v1.14",
				name = "Test schematic",
				size = {
					y = 3,
					x = 5,
					z = 4
				}
			},
			data_tables = {
				data = {
					[1] = 5, [2] = 5, [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5, [10] = 14, [11] = 14, [12] = 14, [13] = 14, [14] = 14, [15] = 14, [16] = 14, [17] = 14, [18] = 14, [19] = 14, [20] = 14, [21] = 14, [22] = 14, [23] = 14, [24] = 14, [25] = 14, [26] = 14, [27] = 14, [28] = 14, [29] = 14, [30] = 14, [31] = 14, [32] = 14, [33] = 14, [34] = 14, [35] = 14, [36] = 14, [37] = 14, [38] = 14, [39] = 14, [40] = 14, [41] = 14, [42] = 14, [43] = 14, [44] = 14, [45] = 14, [46] = 14, [47] = 14, [48] = 14, [49] = 14, [50] = 0, [51] = 5, [52] = 14, [53] = 5, [54] = 14, [55] = 0, [56] = 0, [57] = 0, [58] = 0, [59] = 0, [0] = 5
				},
				param2 = {
					[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 1, [11] = 0, [12] = 1, [13] = 1, [14] = 0, [15] = 1, [16] = 0, [17] = 0, [18] = 0, [19] = 0, [20] = 0, [0] = 0,
				}
			}
		}, result)
	end)
	it("should not parse an invalid file magic bytes", function()
		local handle = make_handle("invalid_magicbytes")

		local success, code, result = weaschem.parse(handle)

		assert.are.same(false, success)
		assert.are.same("INVALID_MAGIC_BYTES", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse an invalid file magic bytes space", function()
		local handle = make_handle("invalid_magicbytes_space")

		local success, code, result = weaschem.parse(handle)

		assert.are.same(false, success)
		assert.are.same("INVALID_MAGIC_SPACE", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse when delta_which is not a valid value", function()
		local handle = make_handle("valid")

		local success, code, result = weaschem.parse(handle, "cheeeeese :D")

		assert.are.same(false, success)
		assert.are.same("INVALID_DELTA_WHICH", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse a file with an invalid version", function()
		local handle = make_handle("invalid_version")

		local success, code, result = weaschem.parse(handle)

		assert.are.same(false, success)
		assert.are.same("INVALID_VERSION", code)
		assert.are.same("string", type(result))
	end)
	it("should not parse a file with an invalid version token", function()
		local handle = make_handle("invalid_version_token")

		local success, code, result = weaschem.parse(handle)

		assert.are.same(false, success)
		assert.are.same("UNEXPECTED_TOKEN", code)
		assert.are.same("string", type(result))
	end)
end)
