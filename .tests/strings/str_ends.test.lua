local polyfill = require("worldeditadditions.utils.strings.polyfill")

describe("str_ends", function()
	it("should return true for a single character", function()
		assert.are.equal(
			true,
			polyfill.str_ends("test", "t")
		)
	end)
	it("should return true for a multiple characters", function()
		assert.are.equal(
			true,
			polyfill.str_ends("test", "st")
		)
	end)
	it("should return true for identical strings", function()
		assert.are.equal(
			true,
			polyfill.str_ends("test", "test")
		)
	end)
	it("should return false for a single character ", function()
		assert.are.equal(
			false,
			polyfill.str_ends("test", "y")
		)
	end)
	it("should return false for a character present elsewherer", function()
		assert.are.equal(
			false,
			polyfill.str_ends("test", "e")
		)
	end)
	it("should return false for another substring", function()
		assert.are.equal(
			false,
			polyfill.str_ends("test", "tes")
		)
	end)
end)
