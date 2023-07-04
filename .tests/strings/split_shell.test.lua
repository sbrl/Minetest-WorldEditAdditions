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
			{ "y\"ay", "yay", "in\"side quotes", "yay", "y\"ay" },
			split_shell("y\"ay \"yay 'in\\\"side quotes' yay\" y\\\"ay")
		)
	end)
	
end)