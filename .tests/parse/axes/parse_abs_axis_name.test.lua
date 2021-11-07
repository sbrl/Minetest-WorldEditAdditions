local Vector3 = require("worldeditadditions.utils.vector3")

local axes = require("worldeditadditions.utils.parse.axes")
local parse_abs_axis_name = axes.parse_abs_axis_name


describe("parse_abs_axis_name", function()
	it("should work with positive x", function()
		local success, result = parse_abs_axis_name("x")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	it("should work with negative x", function()
		local success, result = parse_abs_axis_name("-x")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	it("should work with positive y", function()
		local success, result = parse_abs_axis_name("y")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 1, 0),
			result
		)
	end)
	it("should work with negative y", function()
		local success, result = parse_abs_axis_name("-y")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, -1, 0),
			result
		)
	end)
	it("should work with positive z", function()
		local success, result = parse_abs_axis_name("z")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	it("should work with negative z", function()
		local success, result = parse_abs_axis_name("-z")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	it("should work with multiple axes -x y", function()
		local success, result = parse_abs_axis_name("-xy")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 1, 0),
			result
		)
	end)
	it("should work with multiple axes z-y", function()
		local success, result = parse_abs_axis_name("z-y")
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, -1, 1),
			result
		)
	end)
	it("returns an error with invalid input", function()
		local success, result = parse_abs_axis_name("cheese")
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with no input", function()
		local success, result = parse_abs_axis_name()
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with input of the wrong type", function()
		local success, result = parse_abs_axis_name(5)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with input of the wrong type again", function()
		local success, result = parse_abs_axis_name({ "yay", "tests are very useful" })
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
end)
