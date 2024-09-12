local Vector3 = require("worldeditadditions_core.utils.vector3")

local facing_dirs = dofile("./.tests/parse/axes/include_facing_dirs.lua")

local parse = require("worldeditadditions_core.utils.parse.axes_parser")
local parse_keyword = parse.keyword


describe("parse_keyword", function()
	
	-- Basic tests
	it("should work on single axes", function()
		local ktype, axis, sign = parse_keyword("x")
		assert.are.equals("axis", ktype)
		assert.are.same({"x"}, axis)
		assert.are.equals(1, sign)
	end)
	
	it("should work with axis clumping", function()
		local ktype, axis, sign = parse_keyword("zx")
		assert.are.equals("axis", ktype)
		assert.are.same({"x", "z"}, axis)
		assert.are.equals(1, sign)
	end)
	
	it("should work with h and v", function()
		local ktype, axis, sign = parse_keyword("hv")
		assert.are.equals("axis", ktype)
		assert.are.same(
			{"x", "y", "z", rev={"x", "y", "z"}},
			axis)
		assert.are.equals(1, sign)
	end)
	
	it("should work with h and v in clumping", function()
		local ktype, axis, sign = parse_keyword("hyxz")
		assert.are.equals("axis", ktype)
		assert.are.same(
			{"x", "y", "z", rev={"x", "z"}},
			axis)
		assert.are.equals(1, sign)
	end)
	
	it("should work with negatives", function()
		local ktype, axis, sign = parse_keyword("-xv")
		assert.are.equals("axis", ktype)
		assert.are.same({"x", "y", rev={"y"}}, axis)
		assert.are.equals(-1, sign)
	end)
	
	it("should work with dirs", function()
		local ktype, axis, sign = parse_keyword("left")
		assert.are.equals("dir", ktype)
		assert.are.equals("left", axis)
		assert.are.equals(1, sign)
	end)
	
	it("should work with negative dirs", function()
		local ktype, axis, sign = parse_keyword("-right")
		assert.are.equals("dir", ktype)
		assert.are.equals("right", axis)
		assert.are.equals(-1, sign)
	end)
	
	it("should work with mirroring", function()
		local ktype, axis, sign = parse_keyword("m")
		assert.are.equals("rev", ktype)
		assert.are.equals("mirroring", axis)
		assert.are.equals(nil, sign)
	end)
	
	-- Error tests
	it("should return error for bad axis", function()
		local ktype, axis, sign = parse_keyword("-axv")
		assert.are.equals("err", ktype)
	end)
	
end)
