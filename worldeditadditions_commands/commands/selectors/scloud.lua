-- ███████  ██████ ██       ██████  ██    ██ ██████
-- ██      ██      ██      ██    ██ ██    ██ ██   ██
-- ███████ ██      ██      ██    ██ ██    ██ ██   ██
--      ██ ██      ██      ██    ██ ██    ██ ██   ██
-- ███████  ██████ ███████  ██████   ██████  ██████
local wea = worldeditadditions
worldedit.register_command("scloud", {
	params = "0-6/stop/reset",
	description = "Set and add to WorldEdit region by punching put to six nodes that define the maximums of your target",
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
			wea.clear_points(name)
			return true, "selection cleared"
		else
			return false, (param == "" and "no input" or "invalid input: '"..param).."'! Allowed params are: 0-6/stop/reset"
		end
	end,
})
