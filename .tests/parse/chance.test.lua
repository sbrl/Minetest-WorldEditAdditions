local parse_chance = require("worldeditadditions_core.utils.parse.chance")

describe("parse.chance", function()
	it("should work in 1-in-n mode by default", function()
		local source = "50%"
		
		assert.are.equal(
			2,
			parse_chance(source)
		)
	end)
	it("should work with a different value in 1-in-n mode", function()
		local source = "25%"
		
		assert.are.equal(
			4,
			parse_chance(source)
		)
	end)
	it("should work in weight mode", function()
		local source = "50%"
		
		assert.are.equal(
			2,
			parse_chance(source, "weight")
		)
	end)
	it("should work in weight mode with different number", function()
		local source = "90%"
		
		assert.are.equal(
			10,
			parse_chance(source, "weight")
		)
	end)
end)
