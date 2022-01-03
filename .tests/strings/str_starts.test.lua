local polyfill = require("worldeditadditions.utils.strings.polyfill")

describe("str_starts", function()
	it("should return true for a single character", function()
		assert.are.equal(
			true,
			polyfill.str_starts("test", "t")
		)
	end)
	it("should return true for a multiple characters", function()
		assert.are.equal(
			true,
			polyfill.str_starts("test", "te")
		)
	end)
	it("should return true for identical strings", function()
		assert.are.equal(
			true,
			polyfill.str_starts("test", "test")
		)
	end)
	it("should return false for a single character ", function()
		assert.are.equal(
			false,
			polyfill.str_starts("test", "y")
		)
	end)
	it("should return false for a character present elsewherer", function()
		assert.are.equal(
			false,
			polyfill.str_starts("test", "e")
		)
	end)
	it("should return false for another substring", function()
		assert.are.equal(
			false,
			polyfill.str_starts("test", "est")
		)
	end)
end)
