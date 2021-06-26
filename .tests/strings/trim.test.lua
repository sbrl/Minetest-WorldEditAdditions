local polyfill = require("worldeditadditions.utils.strings.polyfill")

describe("trim", function()
	it("work for a string that's already trimmed", function()
		assert.are.equal(
			polyfill.trim("test"),
			"test"
		)
	end)
	it("trim from the start", function()
		assert.are.equal(
			polyfill.trim("     test"),
			"test"
		)
	end)
	it("trim from the end", function()
		assert.are.equal(
			polyfill.trim("test     "),
			"test"
		)
	end)
	it("trim from both ends", function()
		assert.are.equal(
			polyfill.trim("   test     "),
			"test"
		)
	end)
	it("trim another string", function()
		assert.are.equal(
			polyfill.trim("yay    "),
			"yay"
		)
	end)
	it("trim tabs", function()
		assert.are.equal(
			polyfill.trim("//forest		"),
			"//forest"
		)
	end)
	it("avoid trimming spaces in the middle", function()
		assert.are.equal(
			polyfill.trim("te   st     "),
			"te   st"
		)
	end)
end)
