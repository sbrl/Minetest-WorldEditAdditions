local Vector3 = require("worldeditadditions.utils.vector3")

-- To find these numbers, in Javascript:
-- function t(x) { return Math.sqrt((x*x)*3); }
-- for(let i = 0; i < 1000000000; i++) { let r = t(i); if(Math.floor(r) === r) console.log(`i ${i}, r ${r}`); }


describe("Vector3.unit", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(57735, 57735, 57735),
			a:unit():multiply(100000):floor()
		)
	end)
	it("should work with a the normalise alias", function()
		local a = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(57735, 57735, 57735),
			a:normalise():multiply(100000):floor()
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(57735, 57735, 57735),
			a:unit():multiply(100000):floor()
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-371635731, 371635731, -371635731)
		assert.are.same(
			Vector3.new(-57736, 57735, -57736),
			a:unit():multiply(100000):floor()
		)
	end)
end)
