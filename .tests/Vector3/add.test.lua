local Vector3 = require("worldeditadditions.utils.vector3")

local function format_map(map)
	local result = {}
	for key, value in pairs(map) do
		table.insert(result, key.."\t"..tostring(value))
	end
	return table.concat(result, "\n")
end


describe("Vector3.add", function()
	it("should add 2 positive vectors", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			a:add(b),
			Vector3.new(4, 5, 6)
		)
	end)
	it("should support the add operator", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			a + b,
			Vector3.new(4, 5, 6)
		)
	end)
	it("should work with floats", function()
		local a = Vector3.new(3.5, 4.5, 5.5)
		local b = Vector3.new(1.1, 1.1, 1.1)
		assert.are.same(
			a + b,
			Vector3.new(4.6, 5.6, 6.6)
		)
	end)
	it("should work with scalar a", function()
		local a = 2
		local b = Vector3.new(6, 7, 8)
		assert.are.same(
			a + b,
			Vector3.new(8, 9, 10)
		)
	end)
	it("should work with scalar b", function()
		local a = Vector3.new(6, 7, 8)
		local b = 2
		assert.are.same(
			a + b,
			Vector3.new(8, 9, 10)
		)
	end)
	it("should handle negative b", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(-1, -1, -1)
		assert.are.same(
			a + b,
			Vector3.new(2, 3, 4)
		)
	end)
	it("should handle negative a", function()
		local a = Vector3.new(-3, -4, -5)
		local b = Vector3.new(1, 1, 1)
		assert.are.same(
			a + b,
			Vector3.new(-2, -3, -4)
		)
	end)
	it("should handle negative a and b", function()
		local a = Vector3.new(-3, -4, -5)
		local b = Vector3.new(-1, -1, -1)
		assert.are.same(
			a + b,
			Vector3.new(-4, -5, -6)
		)
	end)
	it("should throw an error on invalid x", function()
		assert.has.errors(function()
			Vector3.new("cheese", 4, 5)
		end)
	end)
	it("should throw an error on invalid y", function()
		assert.has.errors(function()
			Vector3.new(4, "cheese", 5)
		end)
	end)
	it("should throw an error on invalid z", function()
		assert.has.errors(function()
			Vector3.new(66, 2, "cheese")
		end)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(1, 1, 1)
		
		local result = a + b
		assert.are.same(
			result,
			Vector3.new(4, 5, 6)
		)
		assert.are_not.equal(result, a)
		assert.are_not.equal(result, b)
	end)
end)
