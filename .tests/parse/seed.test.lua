local parse_seed = require("worldeditadditions_core.utils.parse.seed")

describe("parse.seed", function()
	it("should work", function()
		local source = "a test string"
		
		local result = parse_seed(source)
		
		assert.are.equal(
			"number",
			type(result)
		)
	end)
	it("should work with a long string", function()
		local source = "If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction. If it looks like a duck and quacks like a duck but it needs batteries, you probably have the wrong abstraction."
		
		local result = parse_seed(source)
		
		assert.are.equal(
			"number",
			type(result)
		)
	end)
end)
