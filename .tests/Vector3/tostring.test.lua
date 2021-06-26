local Vector3 = require("worldeditadditions.utils.vector3")

local function format_map(map)
	local result = {}
	for key, value in pairs(map) do
		table.insert(result, key.."\t"..tostring(value))
	end
	return table.concat(result, "\n")
end


describe("Vector3.__tostring", function()
	it("should stringify a Vector3", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			a:__tostring(),
			"(3, 4, 5)"
		)
	end)
	it("should implicitly stringify a Vector3", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			tostring(a),
			"(3, 4, 5)"
		)
	end)
	it("should implicitly stringify another Vector3", function()
		local a = Vector3.new(55, 77, 22)
		assert.are.same(
			tostring(a),
			"(55, 77, 22)"
		)
	end)
	it("should handle negative numbers", function()
		local a = Vector3.new(-1, -2, -3)
		assert.are.same(
			tostring(a),
			"(-1, -2, -3)"
		)
	end)
	it("should handle a mix of positive and negative numbers", function()
		local a = Vector3.new(-7, 2, -99)
		assert.are.same(
			tostring(a),
			"(-7, 2, -99)"
		)
	end)
end)
