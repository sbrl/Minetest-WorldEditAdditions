local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.ceil", function()
	it("should ceil a positive vector", function()
		local a = Vector3.new(3.1, 4.2, 5.8)
		assert.are.same(
			Vector3.new(4, 5, 6),
			a:ceil()
		)
	end)
	it("should ceil a negative vector", function()
		local a = Vector3.new(-3.1, -4.2, -5.3)
		assert.are.same(
			Vector3.new(-3, -4, -5),
			a:ceil()
		)
	end)
	it("should work with integers", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			a:ceil(),
			Vector3.new(3, 4, 5)
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3.1, 4.7, 5.99999)
		
		local result = a:ceil()
		assert.are.same(
			Vector3.new(4, 5, 6),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
