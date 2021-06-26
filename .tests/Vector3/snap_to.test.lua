local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.snap_to", function()
	it("should snap_to a positive vector", function()
		local a = Vector3.new(3.1, 4.75, 5.9)
		assert.are.same(
			Vector3.new(0, 0, 10),
			a:snap_to(10)
		)
	end)
	it("should snap_to a negative vector", function()
		local a = Vector3.new(-2.5, -4.2, -5.3)
		assert.are.same(
			Vector3.new(0, -6, -6),
			a:snap_to(6)
		)
	end)
	it("should work with integers", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			Vector3.new(3, 3, 6),
			a:snap_to(3)
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3.1, 4.7, 5.99999)
		
		local result = a:snap_to(3)
		assert.are.same(
			Vector3.new(3, 6, 6),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
