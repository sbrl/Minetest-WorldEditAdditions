local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.clamp", function()
	it("should work by not changing values if it's already clamped", function()
		local a = Vector3.new(5, 6, 7)
		local pos1 = Vector3.new(0, 0, 0)
		local pos2 = Vector3.new(10, 10, 10)
		
		local result = Vector3.clamp(a, pos1, pos2)
		
		assert.are.same(
			Vector3.new(5, 6, 7),
			result
		)
		
		result.z = 999
		
		assert.are.same(Vector3.new(5, 6, 7), a)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(10, 10, 10), pos2)
	end)
	it("should work with positive vectors", function()
		local a = Vector3.new(30, 3, 3)
		local pos1 = Vector3.new(0, 0, 0)
		local pos2 = Vector3.new(10, 10, 10)
		
		assert.are.same(
			Vector3.new(10, 3, 3),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	it("should work with multiple positive vectors", function()
		local a = Vector3.new(30, 99, 88)
		local pos1 = Vector3.new(4, 4, 4)
		local pos2 = Vector3.new(13, 13, 13)
		
		assert.are.same(
			Vector3.new(13, 13, 13),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	it("should work with multiple positive vectors with an irregular defined region", function()
		local a = Vector3.new(30, 99, 88)
		local pos1 = Vector3.new(1, 5, 3)
		local pos2 = Vector3.new(10, 15, 8)
		
		assert.are.same(
			Vector3.new(10, 15, 8),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	it("should work with multiple negative vectors", function()
		local a = Vector3.new(-30, -99, -88)
		local pos1 = Vector3.new(4, 4, 4)
		local pos2 = Vector3.new(13, 13, 13)
		
		assert.are.same(
			Vector3.new(4, 4, 4),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	it("should work with multiple negative vectors with an irregular defined region", function()
		local a = Vector3.new(-30, -99, -88)
		local pos1 = Vector3.new(1, 5, 3)
		local pos2 = Vector3.new(10, 15, 8)
		
		assert.are.same(
			Vector3.new(1, 5, 3),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	it("should work with multiple negative vectors with an irregular defined region with mixed signs", function()
		local a = Vector3.new(-30, -99, -88)
		local pos1 = Vector3.new(-1, 5, 3)
		local pos2 = Vector3.new(10, 15, 8)
		
		assert.are.same(
			Vector3.new(-1, 5, 3),
			Vector3.clamp(a, pos1, pos2)
		)
	end)
	
	
	
	
	it("should return new Vector3 instances", function()
		local a = Vector3.new(30, 3, 3)
		local pos1 = Vector3.new(0, 0, 0)
		local pos2 = Vector3.new(10, 10, 10)
		
		local result = Vector3.clamp(a, pos1, pos2)
		assert.are.same(Vector3.new(10, 3, 3), result)
		
		result.y = 999
		
		assert.are.same(Vector3.new(30, 3, 3), a)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(10, 10, 10), pos2)
	end)
end)
