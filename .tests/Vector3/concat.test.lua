local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.__concat", function()
	it("should work when concatenating a Vector3 + Vector3", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(6, 7, 8)
		
		assert.are.is_true(
			type(tostring(a .. b)) == "string"
		)
	end)
	it("should work when concatenating a string + Vector3", function()
		local a = "yay"
		local b = Vector3.new(6, 7, 8)
		
		assert.are.is_true(
			type(tostring(a .. b)) == "string"
		)
	end)
	it("should work when concatenating a Vector3 + string", function()
		local a = Vector3.new(3, 4, 5)
		local b = "yay"
		
		assert.are.is_true(
			type(tostring(a .. b)) == "string"
		)
	end)
end)
