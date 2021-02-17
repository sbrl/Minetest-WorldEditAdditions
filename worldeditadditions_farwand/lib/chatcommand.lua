local farwand = worldeditadditions.farwand -- Convenience shurtcut

local function parse_params_farwand(params_text)
	if params_text == nil then
		return false, "Can't parse nil value"
	end
	local parts = worldeditadditions.split(params_text, "%s+", false)
	
	local key = nil
	local value = nil
	
	if #parts >= 1 then
		key = parts[1]
	end
	if #parts >= 2 then
		value = parts[2]
	end
	
	return true, key, value
end

minetest.register_chatcommand("/farwand", {
	params = "skip_liquid (true|false) | maxdist <number>",
	description = "Configures your worldeditadditions farwand tool on a per-player basis. skip_liquid configures whether liquids will be skipped when raycasting. maxdist configures the maximum distance to raycast looking for a suitable node (default: 1000, but while higher values mean that it will search further, it's not an exact number of nodes that will be searched)",
	privs = { worldedit = true },
	func = function(name, params_text)
		if name == nil then return end
		local success, key, value = parse_params_farwand(params_text)
		if success == false then
			worldedit.player_notify(name, key)
			return
		end
		
		if key == "" then
			worldedit.player_notify(name, "Current settings:\n"
				.."\tskip_liquid\t"..tostring(farwand.setting_get(name, "skip_liquid")).."\n"
				.."\tmaxdist\t"..tostring(farwand.setting_get(name, "maxdist")).."\n"
			)
			return 
		end
		
		if key == "skip_liquid" then
			local skip_liquid = false
			if value == "true" then skip_liquid = true end
			farwand.setting_set(name, "skip_liquid", skip_liquid)
			worldedit.player_notify(name, "Set skip_liquid to "..tostring(skip_liquid)..".")
		elseif key == "maxdist" then
			local maxdist = tonumber(value)
			if maxdist == nil then
				worldedit.player_notify(name, "Invalid maxdist '"..value.."' (expected number).")
				return
			end
			farwand.setting_set(name, "maxdist", maxdist)
			worldedit.player_notify(name, "Set maxdist to "..tostring(maxdist)..".")
		else
			worldedit.player_notify(name, "Unknown key '"..key.."' (valid values: skip_liquid, maxdist).")
			return
		end
	end
})
