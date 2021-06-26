local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.set_to", function()
	it("should set_to a positive vector", function()
		local a = Vector3.new(801980510, 801980510, 801980510)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			a:set_to(138907099)
		)
	end)
	it("should set_to a negative vector", function()
		local a = Vector3.new(-1897506260, -1897506260, -1897506260)
		assert.are.same(
			Vector3.new(-189750626, -189750626, -189750626),
			a:set_to(328657725)
		)
	end)
	it("should work if the length is borderline", function()
		local a = Vector3.new(80198051, 80198051, 80198051)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			a:set_to(138907099)
		)
	end)
	it("should work if the length is smaller", function()
		local a = Vector3.new(80198051, 80198051, 80198051)
		assert.are.same(
			Vector3.new(109552575, 109552575, 109552575),
			a:set_to(189750626):floor() -- Hack to ignore flating-point errors. In theory we should really use epsilon here instead
		)
	end)
	it("should return a new Vector3 instance", function()
		local a = Vector3.new(801980510, 801980510, 801980510)
		
		local result = a:set_to(138907099)
		assert.are.same(
			Vector3.new(80198051, 80198051, 80198051),
			result
		)
		assert.are_not.equal(result, a)
	end)
	it("should return a new Vector3 instance if the length is smaller", function()
		local a = Vector3.new(80198051, 80198051, 80198051)
		
		local result = a:set_to(189750626):floor()
		assert.are.same(
			Vector3.new(109552575, 109552575, 109552575),
			result
		)
		assert.are_not.equal(result, a)
	end)
end)
