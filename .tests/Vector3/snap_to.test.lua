local Vector3 = require("worldeditadditions.utils.vector3")

local function format_map(map)
	local result = {}
	for key, value in pairs(map) do
		table.insert(result, key.."\t"..tostring(value))
	end
	return table.concat(result, "\n")
end


describe("Vector3.snap_to", function()
	it("should snap_to a positive vector", function()
		local a = Vector3.new(3.1, 4.75, 5.9)
		print("DEBUG "..tostring(a:snap_to(10)))
		assert.are.same(
			a:snap_to(10),
			Vector3.new(0, 0, 10)
		)
	end)
	it("should snap_to a negative vector", function()
		local a = Vector3.new(-2.5, -4.2, -5.3)
		assert.are.same(
			a:snap_to(6),
			Vector3.new(0, -6, -6)
		)
	end)
	it("should work with integers", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			a:snap_to(3),
			Vector3.new(3, 3, 6)
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(3.1, 4.7, 5.99999)
		
		local result = a:snap_to(3)
		assert.are.same(
			result,
			Vector3.new(3, 6, 6)
		)
		assert.are_not.equal(result, a)
	end)
end)
