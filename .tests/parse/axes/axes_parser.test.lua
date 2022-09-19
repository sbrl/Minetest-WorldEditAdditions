local Vector3 = require("worldeditadditions_core.utils.vector3")

local facing_dirs = dofile("./.tests/parse/axes/include_facing_dirs.lua")

local parse = require("worldeditadditions_core.utils.parse.axes_parser")
local parse_axes = parse.keytable


describe("parse_axes", function()
	
	-- Basic tests
	it("should work on single horizontal axes", function()
		local minv, maxv = parse_axes({
			"x", "3",
			"-z", "10",
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, -10), minv)
		assert.are.same(Vector3.new(3, 0, 0), maxv)
	end)
	
	it("should handle axis clumps and orphan (universal) values", function()
		local minv, maxv = parse_axes({
			"xz", "-3",
			"10",
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(-3, 0, -3), minv)
		assert.are.same(Vector3.new(10, 10, 10), maxv)
	end)
	
	it("should work on directions and their abriviations", function()
		local minv, maxv = parse_axes({
			"l", "3",	-- +z
			"-r", "-3",	-- +z
			"b", "-10",	-- -x
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, -3), minv)
		assert.are.same(Vector3.new(10, 0, 3), maxv)
	end)
	
	it("should work with compass directions and their abriviations", function()
		local minv, maxv = parse_axes({
			"n", "3",	-- +z
			"south", "3",	-- -z
			"-west", "10",	-- +x
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, -3), minv)
		assert.are.same(Vector3.new(10, 0, 3), maxv)
	end)
	
	it("should work with ?", function()
		local minv, maxv = parse_axes({
			"?", "3",	-- -z
		}, facing_dirs.z_neg)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, -3), minv)
		assert.are.same(Vector3.new(0, 0, 0), maxv)
	end)
	
	it("should work with complex relative / absolute combinations", function()
		local minv, maxv = parse_axes({
			"f", "3",	-- +x
			"left", "10",	-- +z
			"y", "77",
			"x", "30",
			"back", "99",
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(-99, 0, 0), minv)
		assert.are.same(Vector3.new(33, 77, 10), maxv)
	end)
	
	it("should work with complex relative / absolute combinations with negative facing_dirs", function()
		local minv, maxv = parse_axes({
			"f", "3",	-- -z
			"l", "10",	-- +x
			"y", "77",
			"x", "30",
			"b", "99",	-- +z
		}, facing_dirs.z_neg)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, -3), minv)
		assert.are.same(Vector3.new(40, 77, 99), maxv)
	end)
	
	it("should return 2 0,0,0 vectors if no input", function()
		local minv, maxv = parse_axes({
			-- No input
		}, facing_dirs.z_neg)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(0, 0, 0), minv)
		assert.are.same(Vector3.new(0, 0, 0), maxv)
	end)
	
	-- Options tests
	it("should mirror the max values of the two vectors if mirroring keyword is present", function()
		local minv, maxv = parse_axes({
			"x", "3",
			"f", "-5",	-- +x
			"z", "-10",
			"mir",
		}, facing_dirs.x_pos)
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(-5, 0, -10), minv)
		assert.are.same(Vector3.new(5, 0, 10), maxv)
	end)
	
	it("should return a single vector if 'sum' input is truthy", function()
		local minv, maxv = parse_axes({
			"x", "3",
			"z", "-10",
		}, facing_dirs.x_pos,"sum")
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(3, 0, -10), minv)
		assert.are.same(nil, maxv)
	end)
	
	it("should dissable mirroring if 'sum' input is truthy", function()
		local minv, maxv = parse_axes({
			"x", "3",
			"f", "-5",	-- +x
			"z", "-10",
			"sym",
		}, facing_dirs.x_pos,"sum")
		assert.is.truthy(minv)
		assert.are.same(Vector3.new(-2, 0, -10), minv)
		assert.are.same(nil, maxv)
	end)
	
	-- Error tests
	it("should return error if bad axis/dir", function()
		local minv, maxv = parse_axes({
			"f", "3",	-- +x
			"lift", "10",	-- Invalid axis
			"y", "77",
			"x", "30",
			"back", "99",	-- -x
		}, facing_dirs.x_pos)
		assert.are.same(false, minv)
		assert.are.same("string", type(maxv))
	end)
	
	it("should return error if bad value", function()
		local minv, maxv = parse_axes({
			"f", "3",	-- +x
			"left", "10",	-- +z
			"y", "!Q",	-- Invalid value
			"x", "30",
			"back", "99",
		}, facing_dirs.x_pos)
		assert.are.same(false, minv)
		assert.are.same("string", type(maxv))
	end)
	
end)
