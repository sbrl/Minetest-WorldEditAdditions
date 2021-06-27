local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.__tostring", function()
	it("should stringify a Vector3", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			"(3, 4, 5)",
			a:__tostring()
		)
	end)
	it("should implicitly stringify a Vector3", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			"(3, 4, 5)",
			tostring(a)
		)
	end)
	it("should implicitly stringify another Vector3", function()
		local a = Vector3.new(55, 77, 22)
		assert.are.same(
			"(55, 77, 22)",
			tostring(a)
		)
	end)
	it("should handle negative numbers", function()
		local a = Vector3.new(-1, -2, -3)
		assert.are.same(
			"(-1, -2, -3)",
			tostring(a)
		)
	end)
	it("should handle a mix of positive and negative numbers", function()
		local a = Vector3.new(-7, 2, -99)
		assert.are.same(
			"(-7, 2, -99)",
			tostring(a)
		)
	end)
end)
