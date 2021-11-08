local Vector3 = require("worldeditadditions.utils.vector3")

local facing_dirs = dofile("./.tests/parse/axes/include_facing_dirs.lua")

local axes = require("worldeditadditions.utils.parse.axes")
local parse_axes = axes.parse_axes

--[[ Original idea for how this function was supposed to work from @VorTechnix
-- It's changed a bit to make it more testable
parse_axes("6",name) == return Vector3.new(6,6,6), Vector3.new(-6,-6,-6)
parse_axes("h 4",name) == return Vector3.new(4,0,4), Vector3.new(-4,0,-4)
parse_axes("v 4",name) == return Vector3.new(0,4,0), Vector3.new(0,-4,0)
parse_axes("-x 4 z 3 5",name) == return Vector3.new(0,0,3), Vector3.new(-4,0,-5)
parse_axes("x -10 y 14 true",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)
parse_axes("x -10 y 14 r",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)
parse_axes("x -10 y 14 rev",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)

-- Assuming player is facing +Z (north)
parse_axes("front 4 y 2 r",name) == return Vector3.new(0,2,4), Vector3.new(0,-2,0)
parse_axes("right 4 y 2 r",name) == return Vector3.new(0,2,0), Vector3.new(-4,-2,0)
]]--


describe("parse_axes", function()
	it("should work with complex relative / absolute combinations", function()
		local success, pos1, pos2 = parse_axes({
			"front", "3",	-- +x
			"left", "10",	-- +z
			"y", "77",
			"x", "30",
			"back", "99"
		}, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-99, 0, 0), pos1)
		assert.are.same(Vector3.new(33, 77, 10), pos2)
	end)
	it("should work with complex relative / absolute combinations with other facing_dirs", function()
		local success, pos1, pos2 = parse_axes({
			"front", "3",	-- +x
			"left", "10",	-- +z
			"y", "77",
			"x", "30",
			"back", "99"
		}, facing_dirs.z_neg)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, -3), pos1)
		assert.are.same(Vector3.new(40, 77, 99), pos2)
	end)
	
	it("should work with ?", function()
		local success, pos1, pos2 = parse_axes({
			"?", "3"
		}, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(3, 0, 0), pos2)
	end)
	
	
	it("should work with positive y / positive value", function()
		local success, pos1, pos2 = parse_axes({ "y", "17" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 17, 0), pos2)
	end)
	it("should work with positive y / negative value", function()
		local success, pos1, pos2 = parse_axes({ "y", "-6" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, -6, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with negative y / positive value", function()
		local success, pos1, pos2 = parse_axes({ "-y", "17" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, -17, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with negative y / negative value", function()
		local success, pos1, pos2 = parse_axes({ "-y", "-6" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 6, 0), pos2)
	end)
	
	
	it("should work with positive x / positive value", function()
		local success, pos1, pos2 = parse_axes({ "x", "1" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(1, 0, 0), pos2)
	end)
	it("should work with positive x / big positive value", function()
		local success, pos1, pos2 = parse_axes({ "x", "99" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(99, 0, 0), pos2)
	end)
	it("should work with positive x / negative value", function()
		local success, pos1, pos2 = parse_axes({ "x", "-1" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-1, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with positive z / positive value", function()
		local success, pos1, pos2 = parse_axes({ "z", "1" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 1), pos2)
	end)
	it("should work with positive z / negative value", function()
		local success, pos1, pos2 = parse_axes({ "z", "-1" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, -1), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with multiple positive axes / positive values", function()
		local success, pos1, pos2 = parse_axes({ "x", "14", "z", "3" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(14, 0, 3), pos2)
	end)
	it("should work with multiple positive axes / negative values", function()
		local success, pos1, pos2 = parse_axes({ "x", "-16", "z", "-9" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-16, 0, -9), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	
	it("should work with negative x / positive value", function()
		local success, pos1, pos2 = parse_axes({ "-x", "1" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-1, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with negative x / big positive value", function()
		local success, pos1, pos2 = parse_axes({ "-x", "99" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-99, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with negative x / negative value", function()
		local success, pos1, pos2 = parse_axes({ "-x", "-3" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(3, 0, 0), pos2)
	end)
	it("should work with negative z / positive value", function()
		local success, pos1, pos2 = parse_axes({ "-z", "6" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, -6), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with negative z / negative value", function()
		local success, pos1, pos2 = parse_axes({ "-z", "-4" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 0, 4), pos2)
	end)
	it("should work with multiple negative axes / positive values", function()
		local success, pos1, pos2 = parse_axes({ "-x", "14", "z", "-3" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-14, 0, -3), pos1)
		assert.are.same(Vector3.new(0, 0, 0), pos2)
	end)
	it("should work with multiple negative axes / negative values", function()
		local success, pos1, pos2 = parse_axes({ "-x", "-16", "-z", "-9" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(0, 0, 0), pos1)
		assert.are.same(Vector3.new(16, 0, 9), pos2)
	end)
	
	it("should work with complex multiple positive / negative combinations", function()
		local success, pos1, pos2 = parse_axes({ "x", "-16", "-x", "10", "-z", "-9", "y", "88" }, facing_dirs.x_pos)
		assert.is_true(success)
		assert.are.same(Vector3.new(-26, 0, 0), pos1)
		assert.are.same(Vector3.new(0, 88, 9), pos2)
	end)
	
	
	
	it("returns an error with invalid token list", function()
		local success, result = parse_axes("cheese", facing_dirs.z_neg)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with invalid facing_dir", function()
		local success, result = parse_axes({ "-x", "1" }, "rocket")
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with no input", function()
		local success, result = parse_axes()
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with token list of the wrong type", function()
		local success, result = parse_axes(5, facing_dirs.x_pos)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with token list of the wrong type again", function()
		local success, result = parse_axes(false, facing_dirs.x_pos)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with token of the wrong type in token list", function()
		local success, result = parse_axes({ "-x", "99", false }, facing_dirs.x_pos)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
end)
