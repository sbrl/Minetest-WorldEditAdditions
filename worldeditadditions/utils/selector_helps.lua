function worldeditadditions.player_axis2d(name)
  -- minetest.get_player_by_name("singleplayer"):
	local dir = math.floor(minetest.get_player_by_name(name):get_look_horizontal() / math.pi * 2 + 0.5) % 4
	local crdnl = { {1,"z"},{-1,"x"},{-1,"z"},{1,"x"} }
  return crdnl[dir+1]
end

-- Tests
-- /lua print(unpack(worldeditadditions.player_axis2d(myname)))
