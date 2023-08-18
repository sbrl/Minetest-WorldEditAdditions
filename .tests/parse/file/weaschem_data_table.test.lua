
local weaschem = require("worldeditadditions_core.utils.parse.file.weaschem")

local parse_json = require("worldeditadditions_core.utils.parse.json")

local inspect = require("worldeditadditions_core.utils.inspect")

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
local function validate_data_table(datatable, is_delta)
	-- print("DEBUG:validate_data_table datatable", inspect(datatable))
	for i, value in pairs(datatable) do
		assert.are.same("number", type(i))
		assert.are.same("number", type(value))
		assert.is_true(value - math.floor(value) < epsilon)
		assert.is_true(i - math.floor(i) < epsilon)
		if is_delta then
			assert.is_true(value >= -2)
		else
			assert.is_true(value >= -1)
		end
	end
end

describe("parse.file.weaschem.parse_data_table type full", function()
	it("should parse a valid data table type full", function()
		local content = '1,2,3'
		local success, code, result = weaschem.parse_data_table(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_data_table(result, false)
		assert.are.same({
			[0] = 1,
			[1] = 2,
			[2] = 3
		}, result)
	end)
	it("should parse a valid data table type delta", function()
		local content = '4,2,5'
		local success, code, result = weaschem.parse_data_table(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_data_table(result, true)
		assert.are.same({
			[0] = 4,
			[1] = 2,
			[2] = 5
		}, result)
	end)
	it("should parse a valid data table with multiple values the same", function()
		local content = '4,2,5,5'
		local success, code, result = weaschem.parse_data_table(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_data_table(result, true)
		assert.are.same({
			[0] = 4,
			[1] = 2,
			[2] = 5,
			[3] = 5
		}, result)
	end)
	it("should parse a valid data table type full with special value -1", function()
		local content = '4,2,5,-1'
		local success, code, result = weaschem.parse_data_table(content)

		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_data_table(result, true)
		assert.are.same({
			[0] = 4,
			[1] = 2,
			[2] = 5,
			[3] = -1
		}, result)
	end)
	it("should parse a valid data table with run-length encoding", function()
		local content = '4,2,5x5'
		local success, code, result = weaschem.parse_data_table(content)
		
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same("table", type(result))
		validate_data_table(result, false)
		assert.are.same({
			[0] = 4,
			[1] = 2,
			[2] = 5,
			[3] = 5,
			[4] = 5,
			[5] = 5,
			[6] = 5
		}, result)
	end)
end)

