local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.sqrt", function()
	it("should sqrt a positive vector", function()
		local a = Vector3.new(16, 64, 16)
		assert.are.same(
			Vector3.new(4, 8, 4),
			a:sqrt()
		)
	end)
	it("should sqrt another positive vector", function()
		local a = Vector3.new(9, 16, 25)
		assert.are.same(
			Vector3.new(3, 4, 5),
			a:sqrt()
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(9, 16, 25)
		
		local result = a:sqrt()
		assert.are.same(
			Vector3.new(3, 4, 5),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
