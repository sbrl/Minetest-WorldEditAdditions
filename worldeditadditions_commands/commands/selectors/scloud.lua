--  ██████  ██████ ██       ██████  ██    ██ ██████
-- ██      ██      ██      ██    ██ ██    ██ ██   ██
-- ███████ ██      ██      ██    ██ ██    ██ ██   ██
--      ██ ██      ██      ██    ██ ██    ██ ██   ██
-- ██████   ██████ ███████  ██████   ██████  ██████
local wea = worldeditadditions
minetest.register_on_punchnode(function(pos, node, puncher)
	local name = puncher:get_player_name()
	if name ~= "" and wea.add_pos[name] ~= nil then
		if wea.add_pos[name] > 0 then
			wea.selection.add_point(name,pos)
			wea.add_pos[name] = wea.add_pos[name] - 1
			worldedit.player_notify(name, "You have "..wea.add_pos[name].." nodes left to punch")
		else wea.add_pos[name] = nil end
	end
end)
worldedit.register_command("scloud", {
	params = "<0-6|stop|reset>",
	description = "Set and add to WorldEdit region by punching up to six nodes that define the maximums of your target",
	privs = {worldedit=true},
	parse = function(param)
		return true, param
	end,
	func = function(name, param)
		local que = tonumber(param)
		if que then
			if que > 0 then
				wea.add_pos[name] = que < 7 and que or 6
				return true, "create or add to selection by punching "..wea.add_pos[name].." nodes"
			else
				wea.add_pos[name] = nil
				return true, "0 nodes to punch: operation canceled"
			end
		elseif param == "stop" then
			wea.add_pos[name] = nil
			return true, "selection operation stopped"
		elseif param == "reset" then
			wea.add_pos[name] = nil
			wea.selection.clear_points(name)
			return true, "selection cleared"
		else
			return false, (param == "" and "no input" or "invalid input: '"..param.."'").."! Allowed params are: 0-6, stop, or reset"
		end
	end,
})
