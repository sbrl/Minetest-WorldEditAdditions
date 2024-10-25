local Path = require("worldeditadditions_core.utils.path")

describe("Path.norm", function()
	it("should correct bad formatting", function()
		local result, err = Path.norm("C:\\Users\\me\\".."/Documents//code.lua")
		assert.is_nil(err)
		assert.are.same(
			table.concat({"C:","Users","me","Documents","code.lua"}, Path.sep),
			result
		)
	end)
	it("should return an error if not a string", function()
		local result, err = Path.norm(123)
		assert.is_false(result)
		assert.are.same("string", type(err))
	end)
end)