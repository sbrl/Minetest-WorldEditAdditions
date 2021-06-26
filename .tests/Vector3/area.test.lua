local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.area", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(3, 3, 3)
		assert.are.equal(
			27,
			a:area()
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(-4, -4, -4)
		assert.are.equal(
			-64,
			a:area()
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-3, 3, -3)
		assert.are.equal(
			27,
			a:area()
		)
	end)
end)
