local makeset = require("worldeditadditions_core.utils.table.makeset")

describe("table.makeset", function()
	it("should work with a single item", function()
		local result = makeset({ "apples" })
		assert.are.same(
			{ apples = true },
			result
		)
	end)
	it("should work with 2 items", function()
		local result = makeset({ "apples", "orange" })
		assert.are.same(
			{ apples = true, orange = true },
			result
		)
	end)
	it("should work with duplicate items", function()
		local result = makeset({ "apples", "apples" })
		assert.are.same(
			{ apples = true },
			result
		)
	end)
	it("should work with duplicate items and non-duplicate items", function()
		local result = makeset({ "apples", "oranges", "apples" })
		assert.are.same(
			{ apples = true, oranges = true },
			result
		)
	end)
end)
