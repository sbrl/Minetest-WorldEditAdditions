local apply = require("worldeditadditions_core.utils.table.table_apply")

describe("table.makeset", function()
	it("should work", function()
		local source = { apples = 4 }
		local target = { oranges = 3 }
		
		apply(source, target)
		
		assert.are.same(
			{ apples = 4, oranges = 3 },
			target
		)
	end)
	it("should overwrite values in target", function()
		local source = { apples = 4 }
		local target = { apples = 3 }
		
		apply(source, target)
		
		assert.are.same(
			{ apples = 4 },
			target
		)
	end)
	it("should work with strings", function()
		local source = { apples = "4" }
		local target = { oranges = "3" }
		
		apply(source, target)
		
		assert.are.same(
			{ apples = "4", oranges = "3" },
			target
		)
	end)
	it("should overwrite values in target with strings", function()
		local source = { apples = "4" }
		local target = { apples = "3" }
		
		apply(source, target)
		
		assert.are.same(
			{ apples = "4" },
			target
		)
	end)
end)
