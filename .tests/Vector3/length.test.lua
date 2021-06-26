local Vector3 = require("worldeditadditions.utils.vector3")

-- To find these numbers, in Javascript:
-- function t(x) { return Math.sqrt((x*x)*3); }
-- for(let i = 0; i < 1000000000; i++) { let r = t(i); if(Math.floor(r) === r) console.log(`i ${i}, r ${r}`); }


describe("Vector3.length", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(80198051, 80198051, 80198051)
		assert.are.equal(
			138907099,
			a:length()
		)
	end)
	it("should work with a negative vector", function()
		local a = Vector3.new(-189750626, -189750626, -189750626)
		assert.are.equal(
			328657725,
			a:length()
		)
	end)
	it("should work with a mixed vector", function()
		local a = Vector3.new(-371635731, 371635731, -371635731)
		assert.are.equal(
			643691968,
			a:length()
		)
	end)
end)
