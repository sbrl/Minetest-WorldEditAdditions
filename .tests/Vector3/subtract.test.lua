local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.subtract", function()
	it("should subtract 2 positive vectors", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			Vector3.new(2, 3,  4),
			a:subtract(b)
		)
	end)
	it("should work with the sub alias", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			Vector3.new(2, 3,  4),
			a:sub(b)
		)
	end)
	it("should work with scalar a", function()
		local a = 2
		local b = Vector3.new(6, 7, 8)
		assert.are.same(
			Vector3.new(4, 5, 6),
			a - b
		)
	end)
	it("should work with scalar b", function()
		local a = Vector3.new(6, 7, 8)
		local b = 2
		assert.are.same(
			Vector3.new(4, 5, 6),
			a - b
		)
	end)
	it("should support the subtract operator", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			Vector3.new(2, 3, 4),
			a - b
		)
	end)
	it("should handle negative b", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(-1, -1, -1)
		assert.are.same(
			Vector3.new(4, 5, 6),
			a - b
		)
	end)
	it("should handle negative a", function()
		local a = Vector3.new(-3, -4, -5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			Vector3.new(-4, -5, -6),
			a - b
		)
	end)
	it("should handle negative a and b", function()
		local a = Vector3.new(-3, -4, -5)
		local b = Vector3.new(-1, -1, -1)
		assert.are.same(
			Vector3.new(-2, -3, -4),
			a - b
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		
		local result = a - b
		assert.are.same(
			Vector3.new(2, 3, 4),
			result
		)
		assert.are_not.equal(result, a)
		assert.are_not.equal(result, b)
	end)
end)
