local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.divide", function()
	it("should divide 2 positive vectors", function()
		local a = Vector3.new(30, 40, 50)
		local b = Vector3.new(2, 2, 2)
		assert.are.same(
			Vector3.new(15, 20, 25),
			a:divide(b)
		)
	end)
	it("should work with the div alias", function()
		local a = Vector3.new(30, 40, 50)
		local b = Vector3.new(2, 2, 2)
		assert.are.same(
			Vector3.new(15, 20, 25),
			a:div(b)
		)
	end)
	it("should work with scalar a", function()
		local a = 2
		local b = Vector3.new(12, 14, 16)
		assert.are.same(
			Vector3.new(6, 7, 8),
			a / b
		)
	end)
	it("should work with scalar b", function()
		local a = Vector3.new(6, 8, 10)
		local b = 2
		assert.are.same(
			Vector3.new(3, 4, 5),
			a / b
		)
	end)
	it("should support the divide operator", function()
		local a = Vector3.new(10, 12, 14)
		local b = Vector3.new(2, 3, 2)
		assert.are.same(
			Vector3.new(5, 4, 7),
			a / b
		)
	end)
	it("should handle negative b", function()
		local a = Vector3.new(30, 40, 50)
		local b = Vector3.new(-2, -2, -2)
		assert.are.same(
			Vector3.new(-15, -20, -25),
			a / b
		)
	end)
	it("should handle negative a", function()
		local a = Vector3.new(-30, -40, -50)
		local b = Vector3.new(2, 4, 2)
		assert.are.same(
			Vector3.new(-15, -10, -25),
			a / b
		)
	end)
	it("should handle negative a and b", function()
		local a = Vector3.new(-30, -40, -50)
		local b = Vector3.new(-2, -2, -2)
		assert.are.same(
			Vector3.new(15, 20, 25),
			a / b
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(9, 12, 15)
		local b = Vector3.new(3, 3, 3)
		
		local result = a / b
		assert.are.same(
			Vector3.new(3, 4, 5),
			result
		)
		assert.are_not.equal(result, a)
		assert.are_not.equal(result, b)
	end)
end)
