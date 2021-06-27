local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.min_component", function()
	it("should work with a positive vector x", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.equal(
			3,
			a:min_component()
		)
	end)
	it("should work with a positive vector y", function()
		local a = Vector3.new(3, 1, 5)
		assert.are.equal(
			1,
			a:min_component()
		)
	end)
	it("should work with a positive vector z", function()
		local a = Vector3.new(3, 1, 0.5)
		assert.are.equal(
			0.5,
			a:min_component()
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(-4, -5, -46)
		assert.are.equal(
			-46,
			a:min_component()
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-30, 3, -3)
		assert.are.equal(
			-30,
			a:min_component()
		)
	end)
end)
