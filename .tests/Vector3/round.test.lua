local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.round", function()
	it("should round a positive vector", function()
		local a = Vector3.new(3.1, 4.75, 5.9)
		assert.are.same(
			Vector3.new(3, 5, 6),
			a:round()
		)
	end)
	it("should round a negative vector", function()
		local a = Vector3.new(-3.1, -4.2, -5.3)
		assert.are.same(
			Vector3.new(-3, -4, -5),
			a:round()
		)
	end)
	it("should work with integers", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			Vector3.new(3, 4, 5),
			a:round()
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3.1, 4.7, 5.99999)
		
		local result = a:round()
		assert.are.same(
			Vector3.new(3, 5, 6),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
