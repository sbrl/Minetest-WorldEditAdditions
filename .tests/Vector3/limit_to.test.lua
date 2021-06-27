local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.limit_to", function()
	it("should limit_to a positive vector", function()
		local a = Vector3.new(801980510, 801980510, 801980510)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			a:limit_to(138907099)
		)
	end)
	it("should limit_to a negative vector", function()
		local a = Vector3.new(-1897506260, -1897506260, -1897506260)
		assert.are.same(
			Vector3.new(-189750626, -189750626, -189750626),
			a:limit_to(328657725)
		)
	end)
	it("should work if the length is borderline", function()
		local a = Vector3.new(80198051, 80198051, 80198051)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			a:limit_to(138907099)
		)
	end)
	it("should not change anything if the length is smaller", function()
		local a = Vector3.new(3, 4, 5)
		assert.are.same(
			Vector3.new(3, 4, 5),
			a:limit_to(100)
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(801980510, 801980510, 801980510)
		
		local result = a:limit_to(138907099)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			result
		)
		a.x = 4
		assert.are.same(Vector3.new(4, 801980510, 801980510), a)
		assert.are.same(Vector3.new(80198051, 80198051, 80198051), result)
	end)
	it("should return a new Vector3 instance if the length is smaller", function()
		local a = Vector3.new(3, 4, 5)
		
		local result = a:limit_to(101)
		assert.are.same(
			Vector3.new(3, 4, 5),
			result
		)
		a.x = 40
		assert.are.same(Vector3.new(40, 4, 5), a)
		assert.are.same(Vector3.new(3, 4, 5), result)
	end)
end)
