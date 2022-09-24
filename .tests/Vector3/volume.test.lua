local Vector3 = require("worldeditadditions_core.utils.vector3")

describe("Vector3.volume", function()
	it("should work", function()
		local a = Vector3.new(4, 4, 4)
		local b = Vector3.new(8, 8, 8)
		assert.are.equal(
			64,
			Vector3.volume(a, b)
		)
	end)
	it("should work the other way around", function()
		local a = Vector3.new(4, 4, 4)
		local b = Vector3.new(8, 8, 8)
		assert.are.equal(
			64,
			Vector3.volume(b, a)
		)
	end)
	it("should work with negative values", function()
		local a = Vector3.new(-4, -4, -4)
		local b = Vector3.new(-8, -8, -8)
		assert.are.equal(
			64,
			Vector3.volume(a, b)
		)
	end)
	it("should work with different values", function()
		local a = Vector3.new(5, 6, 7)
		local b = Vector3.new(10, 10, 10)
		assert.are.equal(
			60,
			Vector3.volume(a, b)
		)
	end)
	it("should work with mixed values", function()
		local a = Vector3.new(10, 5, 8)
		local b = Vector3.new(5, 10, 2)
		assert.are.equal(
			150,
			Vector3.volume(a, b)
		)
	end)
end)
