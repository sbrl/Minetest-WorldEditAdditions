local Vector3 = require("worldeditadditions.utils.vector3")

local facing_dirs = dofile("./.tests/parse/axes/include_facing_dirs.lua")

local axes = require("worldeditadditions.utils.parse.axes")
local parse_relative_axis_name = axes.parse_relative_axis_name



describe("parse_relative_axis_name", function()
	it("should work with up", function()
		local success, result = parse_relative_axis_name(
			"up",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 1, 0),
			result
		)
	end)
	it("should work with down", function()
		local success, result = parse_relative_axis_name(
			"down",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, -1, 0),
			result
		)
	end)
	
	-- ██   ██         ██████   ██████  ███████
	--  ██ ██          ██   ██ ██    ██ ██
	--   ███           ██████  ██    ██ ███████
	--  ██ ██          ██      ██    ██      ██
	-- ██   ██ ███████ ██       ██████  ███████
	it("should work with positive x → front", function()
		local success, result = parse_relative_axis_name(
			"front",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	it("should work with positive x → ?", function()
		local success, result = parse_relative_axis_name(
			"?",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	it("should work with positive x → back", function()
		local success, result = parse_relative_axis_name(
			"back",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	it("should work with positive x → left", function()
		local success, result = parse_relative_axis_name(
			"left",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	it("should work with positive x → right", function()
		local success, result = parse_relative_axis_name(
			"right",
			facing_dirs.x_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	
	
	-- ██   ██         ███    ██ ███████  ██████
	--  ██ ██          ████   ██ ██      ██
	--   ███           ██ ██  ██ █████   ██   ███
	--  ██ ██          ██  ██ ██ ██      ██    ██
	-- ██   ██ ███████ ██   ████ ███████  ██████
	it("should work with negative x → front", function()
		local success, result = parse_relative_axis_name(
			"front",
			facing_dirs.x_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	it("should work with negative x → ?", function()
		local success, result = parse_relative_axis_name(
			"?",
			facing_dirs.x_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	it("should work with negative x → back", function()
		local success, result = parse_relative_axis_name(
			"back",
			facing_dirs.x_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	it("should work with negative x → left", function()
		local success, result = parse_relative_axis_name(
			"left",
			facing_dirs.x_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	it("should work with negative x → right", function()
		local success, result = parse_relative_axis_name(
			"right",
			facing_dirs.x_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	
	
	-- ███████         ██████   ██████  ███████
	--    ███          ██   ██ ██    ██ ██
	--   ███           ██████  ██    ██ ███████
	--  ███            ██      ██    ██      ██
	-- ███████ ███████ ██       ██████  ███████
	it("should work with positive z → front", function()
		local success, result = parse_relative_axis_name(
			"front",
			facing_dirs.z_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	it("should work with positive z → ?", function()
		local success, result = parse_relative_axis_name(
			"?",
			facing_dirs.z_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	it("should work with positive z → back", function()
		local success, result = parse_relative_axis_name(
			"back",
			facing_dirs.z_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	it("should work with positive z → left", function()
		local success, result = parse_relative_axis_name(
			"left",
			facing_dirs.z_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	it("should work with positive z → right", function()
		local success, result = parse_relative_axis_name(
			"right",
			facing_dirs.z_pos
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	
	
	-- ███████         ███    ██ ███████  ██████
	--    ███          ████   ██ ██      ██
	--   ███           ██ ██  ██ █████   ██   ███
	--  ███            ██  ██ ██ ██      ██    ██
	-- ███████ ███████ ██   ████ ███████  ██████
	it("should work with negative z → front", function()
		local success, result = parse_relative_axis_name(
			"front",
			facing_dirs.z_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	it("should work with negative z → ?", function()
		local success, result = parse_relative_axis_name(
			"?",
			facing_dirs.z_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, -1),
			result
		)
	end)
	it("should work with negative z → back", function()
		local success, result = parse_relative_axis_name(
			"back",
			facing_dirs.z_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(0, 0, 1),
			result
		)
	end)
	it("should work with negative z → left", function()
		local success, result = parse_relative_axis_name(
			"left",
			facing_dirs.z_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(1, 0, 0),
			result
		)
	end)
	it("should work with negative z → right", function()
		local success, result = parse_relative_axis_name(
			"right",
			facing_dirs.z_neg
		)
		assert.is_true(success)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			result
		)
	end)
	
	
	
	it("returns an error with invalid input", function()
		local success, result = parse_relative_axis_name("cheese")
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with no input", function()
		local success, result = parse_relative_axis_name()
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with input of the wrong type", function()
		local success, result = parse_relative_axis_name(5)
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
	it("returns an error with input of the wrong type again", function()
		local success, result = parse_relative_axis_name({ "yay", "tests are very useful" })
		assert.is_false(success)
		assert.are.same(
			"string",
			type(result)
		)
	end)
end)
