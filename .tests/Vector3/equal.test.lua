local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.equals", function()
	it("should return true when identical", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(3, 4, 5)
		
		assert.are.same(
			true,
			a:equals(b)
		)
	end)
	it("should return false when not identical", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(6, 7, 8)
		
		assert.are.same(
			false,
			a:equals(b)
		)
	end)
	it("should return false when not identical x", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(4, 4, 5)
		
		assert.are.same(
			false,
			a:equals(b)
		)
	end)
	it("should return false when not identical y", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(3, 5, 5)
		
		assert.are.same(
			false,
			a:equals(b)
		)
	end)
end)
