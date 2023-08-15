local weaschem = require("worldeditadditions_core.utils.parse.file.weaschem")

local parse_json = require("worldeditadditions_core.utils.parse.json")

local function get_json_string(test_name)
	if test_name:match("[^%w_]") then return nil end -- Just in case
	local filename = ".tests/parse/file/testfiles/header_"..test_name..".json"
	
	local handle = io.open(filename, "r")
	if handle == nil then return nil end
	local content = handle:read("*a")
	handle:close()
	
	return content
end

describe("parse.file.weaschem.parse_header", function()
	it("should parse a valid header", function()
		local content = get_json_string("valid")
		assert.are_not.same(nil, content)
		local success, code, result = weaschem.parse_header(content)
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same(parse_json(content), result)
	end)
	it("should parse a valid header with a description", function()
		local content = get_json_string("valid2")
		assert.are_not.same(nil, content)
		local success, code, result = weaschem.parse_header(content)
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same(parse_json(content), result)
	end)
	it("should parse a valid header type delta", function()
		local content = get_json_string("valid_delta")
		assert.are_not.same(nil, content)
		local success, code, result = weaschem.parse_header(content)
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same(parse_json(content), result)
	end)
	it("should parse a valid header with a description type delta", function()
		local content = get_json_string("valid2_delta")
		assert.are_not.same(nil, content)
		local success, code, result = weaschem.parse_header(content)
		assert.are.same(true, success)
		assert.are.same("SUCCESS", code)
		assert.are.same(parse_json(content), result)
	end)
end)
