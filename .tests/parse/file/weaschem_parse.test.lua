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
	
	it("should parse a valid delta file", function()
		local handle = make_handle("valid_delta")
		
		local success, code, result = weaschem.parse(handle)
		
		-- print("DEBUG:parse", inspect(result))
		
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		assert.are.same({
			id_map = {
				[0] = "default:air", [14] = "default:dirt", [5] = "default:stone", },
			header = {
				offset = {
					y = 0, x = 1, z = 2, },
				type = "delta",
				description = "Some description",
				generator = "WorldEditAdditions v1.14",
				name = "Test schematic",
				size = {
					y = 3, x = 5, z = 4, }
			},
			data_tables = {
				data_prev = {
					[1] = 5, [2] = 5, [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5, [10] = 14,
					[11] = 14, [12] = 14, [13] = 14, [14] = 14, [15] = 14, [16] = 14, [17] = 14, [18] = 14, [19] = 14,
					[20] = 14, [21] = 14, [22] = 14, [23] = 14, [24] = 14, [25] = 14, [26] = 14, [27] = 14, [28] = 14,
					[29] = 14, [30] = 14, [31] = 14, [32] = 14, [33] = 14, [34] = 14, [35] = 14, [36] = 14, [37] = 14,
					[38] = 14, [39] = 14, [40] = 14, [41] = 14, [42] = 14, [43] = 14, [44] = 14, [45] = 14, [46] = 14,
					[47] = 14, [48] = 14, [49] = 14, [50] = 0, [51] = 5, [52] = 14, [53] = 5, [54] = -1, [55] = 0,
					[56] = 0, [57] = 0, [58] = 0, [59] = 0, [0] = 5
				},
				data_current = {
					[1] = 5, [2] = 5, [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5, [10] = -2,
					[11] = -2, [12] = -2, [13] = -2, [14] = -2, [15] = -2, [16] = -2, [17] = -2, [18] = -2, [19] = -2,
					[20] = -2, [21] = -2, [22] = -2, [23] = -2, [24] = -2, [25] = -2, [26] = -2, [27] = -2, [28] = -2,
					[29] = -2, [30] = -2, [31] = -2, [32] = -2, [33] = -2, [34] = -2, [35] = -2, [36] = -2, [37] = -2,
					[38] = -2, [39] = -2, [40] = -2, [41] = -2, [42] = -2, [43] = -2, [44] = -2, [45] = -2, [46] = -2,
					[47] = -2, [48] = -2, [49] = -2, [50] = 0, [51] = 5, [52] = 14, [53] = 5, [54] = 14, [55] = 0,
					[56] = 0, [57] = 0, [58] = 0, [59] = 0, [0] = 5
				},
				param2_prev = {
					[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 1, [11] = 0,
					[12] = 1, [13] = 1, [14] = 0, [15] = 0, [16] = 0, [17] = 0, [18] = 0, [19] = 0, [20] = 1, [21] = 1,
					[22] = 1, [23] = 1, [24] = 1, [25] = 1, [26] = 1, [27] = 1, [28] = 1, [29] = 1, [30] = 1, [31] = 1,
					[32] = 1, [33] = 1, [34] = 1, [35] = 1, [36] = 1, [37] = 1, [38] = 1, [39] = 1, [40] = 1, [41] = 1,
					[42] = 1, [43] = 1, [44] = 1, [45] = 1, [46] = 1, [47] = 1, [48] = 1, [49] = 1, [50] = 1, [51] = 1,
					[52] = 1, [53] = 1, [54] = 1, [55] = 1, [56] = 1, [57] = 1, [58] = 1, [59] = 1, [0] = 0
				},
				param2_current = {
					[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 1, [11] = 0,
					[12] = 1, [13] = 1, [14] = 0, [15] = 0, [16] = 0, [17] = 0, [18] = 0, [19] = 0, [20] = 1, [21] = 1,
					[22] = 1, [23] = 1, [24] = 1, [25] = 1, [26] = 1, [27] = 1, [28] = 1, [29] = 1, [30] = 1, [31] = 1,
					[32] = 1, [33] = 1, [34] = 1, [35] = 1, [36] = 1, [37] = 1, [38] = 1, [39] = 1, [40] = 1, [41] = 1,
					[42] = 1, [43] = 1, [44] = 1, [45] = 1, [46] = 1, [47] = 1, [48] = 1, [49] = 1, [50] = 1, [51] = 1,
					[52] = 1, [53] = 1, [54] = 1, [55] = 1, [56] = 1, [57] = 1, [58] = 1, [59] = 1, [0] = 0
				}
			}
		}, result)
		
		-- TODO: Test delta_which more thoroughly.
	end)
end)
