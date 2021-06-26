local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.mean", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(2, 2, 2)
		local b = Vector3.new(4, 4, 4)
		assert.are.same(
			Vector3.new(3, 3, 3),
			a:mean(b)
		)
	end)
	it("should work with a positive vector the other way around", function()
		local a = Vector3.new(2, 2, 2)
		local b = Vector3.new(4, 4, 4)
		assert.are.same(
			Vector3.new(3, 3, 3),
			b:mean(a)
		)
	end)
	it("should mean another positive vector", function()
		local a = Vector3.new(6, 6, 6)
		local b = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(8, 8, 8),
			a:mean(b)
		)
	end)
	it("should mean a negative vector", function()
		local a = Vector3.new(-2, -2, -2)
		local b = Vector3.new(0, 0, 0)
		assert.are.same(
			Vector3.new(-1, -1, -1),
			a:mean(b)
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(6, 6, 6)
		local b = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(8, 8, 8),
			a:mean(b)
		)
		
		assert.are.same(Vector3.new(6, 6, 6), a)
		assert.are.same(Vector3.new(10, 10, 10), b)
	end)
end)
