local Vector3 = require("worldeditadditions.utils.vector3")

-- To find these numbers, in Javascript:
-- function t(x) { return Math.sqrt((x*x)*3); }
-- for(let i = 0; i < 1000000000; i++) { let r = t(i); if(Math.floor(r) === r) console.log(`i ${i}, r ${r}`); }


describe("Vector3.move_towards", function()
	it("should work with a positive vector", function()
		local a = Vector3.new(3, 4, 5)
		local b = Vector3.new(10, 10, 10)
		assert.are.same(
			Vector3.new(5.0022714374157439821, 5.7162326606420661435, 6.4301938838683883048),
			a:move_towards(b, 3)
		)
	end)
end)
