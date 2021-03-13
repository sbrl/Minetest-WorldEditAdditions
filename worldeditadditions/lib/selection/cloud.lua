--  ██████ ██       ██████  ██    ██ ██████
-- ██      ██      ██    ██ ██    ██ ██   ██
-- ██      ██      ██    ██ ██    ██ ██   ██
-- ██      ██      ██    ██ ██    ██ ██   ██
--  ██████ ███████  ██████   ██████  ██████
worldeditadditions.add_pos = {}
worldeditadditions.selection = {}
function worldeditadditions.selection.add_point(name, pos)
	if pos ~= nil then
		-- print("[set_pos1]", name, "("..pos.x..", "..pos.y..", "..pos.z..")")
		if not worldedit.pos1[name] then worldedit.pos1[name] = vector.new(pos) end
		if not worldedit.pos2[name] then worldedit.pos2[name] = vector.new(pos) end
		
		worldedit.marker_update(name)
		
		local volume_before = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		worldedit.pos1[name], worldedit.pos2[name] = worldeditadditions.vector.expand_region(worldedit.pos1[name], worldedit.pos2[name], pos)
		
		local volume_after = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		
		local volume_difference = volume_after - volume_before
		
		worldedit.marker_update(name)
		worldedit.player_notify(name, "Expanded region by "..volume_difference.." nodes")
	else
		worldedit.player_notify(name, "Error: Too far away (try raising your maxdist with //farwand maxdist <number>)")
		-- print("[set_pos1]", name, "nil")
	end
end
function worldeditadditions.selection.clear_points(name)
	worldedit.pos1[name] = nil
	worldedit.pos2[name] = nil
	worldedit.marker_update(name)
	worldedit.set_pos[name] = nil
	
	worldedit.player_notify(name, "Region cleared")
end
