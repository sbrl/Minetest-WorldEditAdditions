local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.is_contained", function()
	it("should return true when inside", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(30, 40, 50)
		local target = Vector3.new(6, 6, 6)
		
		assert.are.same(
			true,
			target:is_contained(a, b)
		)
	end)
	it("should return false when outside x", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(30, 40, 50)
		local target = Vector3.new(60, 6, 6)
		
		assert.are.same(
			false,
			target:is_contained(a, b)
		)
	end)
	it("should return false when outside y", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(30, 40, 50)
		local target = Vector3.new(6, 60, 6)
		
		assert.are.same(
			false,
			target:is_contained(a, b)
		)
	end)
	it("should return false when outside z", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(30, 40, 50)
		local target = Vector3.new(6, 6, 60)
		
		assert.are.same(
			false,
			target:is_contained(a, b)
		)
	end)
end)
