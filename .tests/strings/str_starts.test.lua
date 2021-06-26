local polyfill = require("worldeditadditions.utils.strings.polyfill")

describe("str_starts", function()
	it("should return true for a single character", function()
		assert.are.equal(
			polyfill.str_starts("test", "t"),
			true
		)
	end)
	it("should return true for a multiple characters", function()
		assert.are.equal(
			polyfill.str_starts("test", "te"),
			true
		)
	end)
	it("should return true for identical strings", function()
		assert.are.equal(
			polyfill.str_starts("test", "test"),
			true
		)
	end)
	it("should return false for a single character ", function()
		assert.are.equal(
			polyfill.str_starts("test", "y"),
			false
		)
	end)
	it("should return false for a character present elsewherer", function()
		assert.are.equal(
			polyfill.str_starts("test", "e"),
			false
		)
	end)
	it("should return false for another substring", function()
		assert.are.equal(
			polyfill.str_starts("test", "est"),
			false
		)
	end)
end)
