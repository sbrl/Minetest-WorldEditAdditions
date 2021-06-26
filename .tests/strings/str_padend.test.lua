local polyfill = require("worldeditadditions.utils.strings.polyfill")
	
describe("str_padend", function()
	it("should pad a string", function()
		assert.are.equal(
			polyfill.str_padend("test", 5, " "),
			"test "
		)
	end)
	it("should pad a different string", function()
		assert.are.equal(
			polyfill.str_padend("yay", 4, " "),
			"yay "
		)
	end)
	it("should pad a string with multiple characters", function()
		assert.are.equal(
			polyfill.str_padend("test", 10, " "),
			"test      "
		)
	end)
	it("should not pad a long string", function()
		assert.are.equal(
			polyfill.str_padend("testtest", 5, " "),
			"testtest"
		)
	end)
	it("should pad with other characters", function()
		assert.are.equal(
			polyfill.str_padend("1", 2, "0"),
			"10"
		)
	end)
	it("should pad with multiple other characters", function()
		assert.are.equal(
			polyfill.str_padend("1", 5, "0"),
			"10000"
		)
	end)
end)
