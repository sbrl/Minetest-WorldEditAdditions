_G.worldeditadditions_core = {
	split = require("worldeditadditions_core.utils.strings.split"),
	table = {
		contains = require("worldeditadditions_core.utils.table.table_contains")
	}
}
local parse_map = require("worldeditadditions_core.utils.parse.map")

describe("parse.map", function()
	it("should work with a single param", function()
		local success, result = parse_map("apples yay")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = "yay" },
			result
		)
	end)
	it("should work with 2 params", function()
		local success, result = parse_map("apples yay oranges yummy")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = "yay", oranges = "yummy" },
			result
		)
	end)
	it("should work with an int value", function()
		local success, result = parse_map("apples 2")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2 },
			result
		)
	end)
	it("should work with a float value", function()
		local success, result = parse_map("apples 2.71")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2.71 },
			result
		)
	end)
	it("should work with 2 int values", function()
		local success, result = parse_map("apples 2 banana 23")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = 23 },
			result
		)
	end)
	it("should work with mixed values", function()
		local success, result = parse_map("apples 2 banana yummy")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = "yummy" },
			result
		)
	end)
	it("should work with a value that starts as a number and ends as a string", function()
		local success, result = parse_map("apples 20t banana yummy")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = "20t", banana = "yummy" },
			result
		)
	end)
	it("should work with a value that starts as a string and ends as a number", function()
		local success, result = parse_map("apples t20 banana yummy")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = "t20", banana = "yummy" },
			result
		)
	end)
	it("should work with multiple spaces", function()
		local success, result = parse_map("apples      2    banana \t   yummy")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = "yummy" },
			result
		)
	end)
	it("should ignore a hanging item at the end", function()
		local success, result = parse_map("apples 2 banana")
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2 },
			result
		)
	end)
	it("should work with hanging items declared as keywords at the end", function()
		local success, result = parse_map("apples 2 banana", { "banana" })
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = true },
			result
		)
	end)
	it("should work with hanging items declared as keywords in the middle", function()
		local success, result = parse_map("apples 2 banana pear paris", { "banana" })
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = true, pear = "paris" },
			result
		)
	end)
	it("should work with some but not other hanging items declared as keywords", function()
		local success, result = parse_map("apples 2 banana pear paris arrange", { "banana" })
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = true, pear = "paris" },
			result
		)
	end)
	it("should work with hanging items declared as keywords at the beginning", function()
		local success, result = parse_map("banana apples 2 pear paris", { "banana" })
		assert.are.equal(true, success)
		assert.are.same(
			{ apples = 2, banana = true, pear = "paris" },
			result
		)
	end)
end)
