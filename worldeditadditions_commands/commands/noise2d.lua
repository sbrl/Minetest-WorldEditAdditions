
local wea = worldeditadditions

worldedit.register_command("noise2d", {
	params = "[<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]",
	description = "Applies 2d random noise to the terrain as a 2d heightmap in the defined region. Optionally takes an arbitrary set of key - value pairs representing parameters that control the properties of the noise and how it's applied. See the full documentation for details of these parameters and what they do.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text then return true, {} end
		params_text = wea.trim(params_text)
		if params_text == "" then return true, {} end
		
		
		local success, map = worldeditadditions.parse.map(params_text,
			wea.noise.engines.available) -- Keywords
		if not success then return success, map end
		
		if map.scale then
			map.scale = tonumber(map.scale)
			map.scale = wea.Vector3.new(map.scale, map.scale, map.scale)
		elseif map.scalex or map.scaley or map.scalez then
			map.scalex = tonumber(map.scalex) or 1
			map.scaley = tonumber(map.scaley) or 1
			map.scalez = tonumber(map.scalez) or 1
			map.scale = wea.Vector3.new(map.scalex, map.scaley, map.scalez)
		end
		if map.offsetx or map.offsety or map.offsetz then
			map.offsetx = tonumber(map.offsetx) or 0
			map.offsety = tonumber(map.offsety) or 0
			map.offsetz = tonumber(map.offsetz) or 0
			map.offset = wea.Vector3.new(map.offsetx, map.offsety, map.offsetz)
		end
		
		return true, map
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, params)
		local start_time = worldeditadditions.get_ms_time()
		local success, stats = worldeditadditions.noise.run2d(
			worldedit.pos1[name], worldedit.pos2[name],
			params
		)
		if not success then return success, stats end
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //noise2d at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", adding " .. stats.added .. " nodes and removing " .. stats.removed .. " nodes in " .. time_taken .. "s")
		return true, stats.added .. " nodes added and " .. stats.removed .. " nodes removed in " .. worldeditadditions.format.human_time(time_taken)
	end
})
