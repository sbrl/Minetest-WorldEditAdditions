local contains = require("worldeditadditions_core.utils.table.table_contains")

describe("table.makeset", function()
	it("should work with a string", function()
		assert.are.same(
			true,
			contains({ "apples" }, "apples")
		)
	end)
	it("should work with a number", function()
		assert.are.same(
			true,
			contains({ 4 }, 4)
		)
	end)
	it("should return false if a number doesn't exist", function()
		assert.are.same(
			false,
			contains({ 5 }, 4)
		)
	end)
	it("should work with a string and multiple items in the table", function()
		assert.are.same(
			true,
			contains({ "yay", "apples", "cat" }, "apples")
		)
	end)
	it("should return false if it doesn't exist", function()
		assert.are.same(
			false,
			contains({ "yay" }, "orange")
		)
	end)
	it("should return false if it doesn't exist wiith multiple items", function()
		assert.are.same(
			false,
			contains({ "yay", "apples", "cat" }, "orange")
		)
	end)
end)
