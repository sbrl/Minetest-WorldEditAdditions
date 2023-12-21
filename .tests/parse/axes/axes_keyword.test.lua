local Vector3 = require("worldeditadditions_core.utils.vector3")

local facing_dirs = dofile("./.tests/parse/axes/include_facing_dirs.lua")

local parse = require("worldeditadditions_core.utils.parse.axes_parser")
local parse_keyword = parse.keyword


describe("parse_keyword", function()
	
	-- Basic tests
	it("should work on single axes", function()
		local ktype, axis, sign = parse_keyword("x")
		assert.are.equals(ktype, "axis")
		assert.are.same(axis, {"x"})
		assert.are.equals(sign, 1)
	end)
	
	it("should work with axis clumping", function()
		local ktype, axis, sign = parse_keyword("zx")
		assert.are.equals(ktype, "axis")
		assert.are.same(axis, {"x", "z"})
		assert.are.equals(sign, 1)
	end)
	
	it("should work with h and v", function()
		local ktype, axis, sign = parse_keyword("hv")
		assert.are.equals(ktype, "axis")
		assert.are.same(axis, {"h", "v"})
		assert.are.equals(sign, 1)
	end)
	
	it("should work with h and v in clumping", function()
		local ktype, axis, sign = parse_keyword("hyxz")
		assert.are.equals(ktype, "axis")
		assert.are.same(axis, {"h", "y"})
		assert.are.equals(sign, 1)
	end)
	
	it("should work with negatives", function()
		local ktype, axis, sign = parse_keyword("-xv")
		assert.are.equals(ktype, "axis")
		assert.are.same(axis, {"v", "x"})
		assert.are.equals(sign, -1)
	end)
	
	it("should work with dirs", function()
		local ktype, axis, sign = parse_keyword("left")
		assert.are.equals(ktype, "dir")
		assert.are.equals(axis, "left")
		assert.are.equals(sign, 1)
	end)
	
	it("should work with negative dirs", function()
		local ktype, axis, sign = parse_keyword("-right")
		assert.are.equals(ktype, "dir")
		assert.are.equals(axis, "right")
		assert.are.equals(sign, -1)
	end)
	
	it("should work with mirroring", function()
		local ktype, axis, sign = parse_keyword("m")
		assert.are.equals(ktype, "rev")
		assert.are.equals(axis, "mirroring")
		assert.are.equals(sign, nil)
	end)
	
	-- Error tests
	it("should return error for bad axis", function()
		local ktype, axis, sign = parse_keyword("-axv")
		assert.are.equals(ktype, "err")
	end)
	
end)
