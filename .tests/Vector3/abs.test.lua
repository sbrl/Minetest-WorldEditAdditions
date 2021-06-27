local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.abs", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(16, 64, 16)
		assert.are.same(
			Vector3.new(16, 64, 16),
			a:abs()
		)
	end)
	it("should abs another positive vector", function()
		local a = Vector3.new(9, 16, 25)
		assert.are.same(
			Vector3.new(9, 16, 25),
			a:abs()
		)
	end)
	it("should abs a negative vector", function()
		local a = Vector3.new(-9, -16, -25)
		assert.are.same(
			Vector3.new(9, 16, 25),
			a:abs()
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(9, -16, 25)
		
		local result = a:abs()
		assert.are.same(
			Vector3.new(9, 16, 25),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
