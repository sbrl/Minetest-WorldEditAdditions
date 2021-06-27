local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.max_component", function()
	it("should work with a positive vector x", function()
		local a = Vector3.new(30, 4, 5)
		assert.are.equal(
			30,
			a:max_component()
		)
	end)
	it("should work with a positive vector y", function()
		local a = Vector3.new(3, 10, 5)
		assert.are.equal(
			10,
			a:max_component()
		)
	end)
	it("should work with a positive vector z", function()
		local a = Vector3.new(3, 1, 50.5)
		assert.are.equal(
			50.5,
			a:max_component()
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(-4, -5, -1)
		assert.are.equal(
			-1,
			a:max_component()
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-30, 3, -3)
		assert.are.equal(
			3,
			a:max_component()
		)
	end)
end)
