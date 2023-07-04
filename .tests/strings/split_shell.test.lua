local split_shell = require("worldeditadditions_core.utils.strings.split_shell")

describe("split_shell", function()
	it("should handle a single case x3", function()
		assert.are.same(
			{ "yay", "yay", "yay" },
			split_shell("yay yay yay")
		)
	end)
	
	it("should handle double quotes simple", function()
		assert.are.same(
			{ "dirt", "snow block" },
			split_shell("dirt \"snow block\"")
		)
	end)
	
	it("should handle an escaped double quote inside double quotes", function()
		assert.are.same(
			{ "yay", "yay\" yay", "yay" },
			split_shell("yay \"yay\\\" yay\" yay")
		)
	end)
	
	it("should handle single quotes", function()
		assert.are.same(
			{ "yay", "yay", "yay" },
			split_shell("yay 'yay' yay")
		)
	end)
	
	it("should handle single quotes again", function()
		assert.are.same(
			{ "yay", "inside quotes", "another" },
			split_shell("yay 'inside quotes' another")
		)
	end)
	
	it("should handle single quotes inside double quotes", function()
		assert.are.same(
			{ "yay", "yay 'inside quotes' yay", "yay" },
			split_shell("yay \"yay 'inside quotes' yay\" yay")
		)
	end)
	
	it("should handle single quotes and an escaped double quote inside double quotes", function()
		assert.are.same(
			{ "yay", "yay 'inside quotes' yay\"", "yay" },
			split_shell("yay \"yay 'inside quotes' yay\\\"\" yay")
		)
	end)
	
	it("should handle a complex case", function()
		assert.are.same(
			{ "y\"ay", "yay 'in\"side quotes' yay", "y\"ay" },
			split_shell("y\"ay \"yay 'in\\\"side quotes' yay\" y\\\"ay")
		)
	end)
	it("should handle a subtly different complex case", function()
		assert.are.same(
			{ "y\"ay", "yay", "in\"side quotes", "yay", "y\"ay" },
			split_shell("y\"ay yay 'in\\\"side quotes' yay y\\\"ay")
		)
	end)
	it("should handle redundant double quotes", function()
		assert.are.same(
			{ "cake" },
			split_shell("\"cake\"")
		)
	end)
	it("should handle redundant double quotes multi", function()
		assert.are.same(
			{ "cake", "cake", "cake" },
			split_shell("\"cake\" \"cake\" \"cake\"")
		)
	end)
	it("should handle redundant single quotes", function()
		assert.are.same(
			{ "cake" },
			split_shell("'cake'")
		)
	end)
	it("should handle redundant single quotes multi", function()
		assert.are.same(
			{ "cake", "cake", "cake" },
			split_shell("'cake' 'cake' 'cake'")
		)
	end)
	it("should handle redundant double and single quotes", function()
		assert.are.same(
			{ "cake", "cake", "cake" },
			split_shell("'cake' \"cake\" 'cake'")
		)
	end)
	
	it("should handle redundant double and single quotes opposite", function()
		assert.are.same(
			{ "cake", "cake", "cake" },
			split_shell("\"cake\" 'cake' \"cake\"")
		)
	end)
	it("should handle a random backslash single quotes", function()
		assert.are.same(
			{ "cake", "ca\\ke" },
			split_shell("\"cake\" 'ca\\ke'")
		)
	end)
	it("should handle a random backslash double quotes", function()
		assert.are.same(
			{ "cake", "ca\\ke" },
			split_shell("\"cake\" \"ca\\ke\"")
		)
	end)
	it("should handle a backslash after double quotes", function()
		assert.are.same(
			{ "\\cake", "cake" },
			split_shell("\"\\cake\" \"cake\"")
		)
	end)
	it("should handle a double backslash before double quotes", function()
		assert.are.same(
			{ "\\\"cake\"", "cake" },
			split_shell("\\\\\"cake\" \"cake\"")
		)
	end)
	it("should handle a single backslash before double quotes", function()
		assert.are.same(
			{ "\"cake\"", "cake" },
			split_shell("\\\"cake\" \"cake\"")
		)
	end)
	it("should handle a double backslash before single quotes", function()
		assert.are.same(
			{ "\\'cake'", "cake" },
			split_shell("\\\\'cake' 'cake'")
		)
	end)
	it("should handle a single backslash before single quotes", function()
		assert.are.same(
			{ "\"cake\"", "cake" },
			split_shell("\\\"cake\" \"cake\"")
		)
	end)
	it("should handle redundant double and single quotes again", function()
		assert.are.same(
			{ "cake", "cake", "cake", "is", "a", "li\\e" },
			split_shell("\"cake\" 'cake' \"cake\" is a \"li\\e\"")
		)
	end)
	
	-- Unclosed quotes are currently considered to last until the end of the string.
	
	it("should handle an unclosed double quote", function()
		assert.are.same(
			{ "the", "cake is a lie" },
			split_shell("the \"cake is a lie")
		)
	end)
	it("should handle an unclosed single quote", function()
		assert.are.same(
			{ "the", "cake is a lie" },
			split_shell("the 'cake is a lie")
		)
	end)
	it("should handle an unclosed single quote at the end", function()
		assert.are.same(
			{ "the", "cake is a lie'" },
			split_shell("the \"cake is a lie'")
		)
	end)
	it("should handle an unclosed single and double quote", function()
		assert.are.same(
			{ "the", "cake is \"a lie" },
			split_shell("the 'cake is \"a lie")
		)
	end)
	
end)