local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.dot", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(3, 3, 3)
		local b = Vector3.new(4, 5, 6)
		assert.are.equal(
			45,
			a:dot(b)
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(-4, -4, -4)
		local b = Vector3.new(4, 5, 6)
		assert.are.equal(
			-60,
			a:dot(b)
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-3, 3, -3)
		local b = Vector3.new(7, 8, 9)
		assert.are.equal(
			-24,
			a:dot(b)
		)
	end)
	it("should work with the dot_product alias", function()
		local a = Vector3.new(-3, 3, -3)
		local b = Vector3.new(7, 8, 9)
		assert.are.equal(
			-24,
			a:dot_product(b)
		)
	end)
end)
