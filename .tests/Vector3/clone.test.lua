local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.clone", function()
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3, 4, 5)
		
		local result = a:clone()
		assert.are.same(
			Vector3.new(3, 4, 5),
			result
		)
		assert.are_not.equal(result, a)
	end)
	it("should return a new Vector3 instance for a different vector", function()
		local a = Vector3.new(-99, 66, 88)
		
		local result = a:clone()
		assert.are.same(
			Vector3.new(-99, 66, 88),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
