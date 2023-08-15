local polyfill = require("worldeditadditions_core.utils.strings.polyfill")

describe("trim", function()
	it("should work for a string that's already trimmed", function()
		assert.are.equal(
			polyfill.trim("test"),
			"test"
		)
	end)
	it("should trim from the start", function()
		assert.are.equal(
			polyfill.trim("     test"),
			"test"
		)
	end)
	it("should trim from the end", function()
		assert.are.equal(
			polyfill.trim("test     "),
			"test"
		)
	end)
	it("should trim from both ends", function()
		assert.are.equal(
			polyfill.trim("   test     "),
			"test"
		)
	end)
	it("should trim another string", function()
		assert.are.equal(
			polyfill.trim("yay    "),
			"yay"
		)
	end)
	it("should trim tabs", function()
		assert.are.equal(
			polyfill.trim("//forest		"),
			"//forest"
		)
	end)
	it("should avoid trimming spaces in the middle", function()
		assert.are.equal(
			polyfill.trim("te   st     "),
			"te   st"
		)
	end)
end)
