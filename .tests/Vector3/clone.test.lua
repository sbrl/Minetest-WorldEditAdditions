local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.clone", function()
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3, 4, 5)
		
		local result = a:clone()
		result.x = 4
		assert.are.same(Vector3.new(3, 4, 5), a)
		assert.are.same(Vector3.new(4, 4, 5), result)
	end)
	it("should return a new Vector3 instance for a different vector", function()
		local a = Vector3.new(-99, 66, 88)
		
		local result = a:clone()
		result.y = -44
		assert.are.same(Vector3.new(-99, 66, 88), a)
		assert.are.same(Vector3.new(-99, -44, 88), result)
	end)
end)
