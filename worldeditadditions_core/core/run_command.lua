-- WARNING: safe_region MUST NOT be imported more than once, as it defines chat commands. If you want to import it again elsewhere, check first that multiple dofile() calls don't execute a file more than once.
local wea_c = worldeditadditions_core
local safe_region = dofile(wea_c.modpath.."/core/safe_region.lua")
local human_size = dofile(wea_c.modpath.."/core/lib/human_size.lua")

-- TODO: Reimplement worldedit.player_notify(player_name, msg_text)

local function run_command_stage2(player_name, func, parse_result)
	local success, result_message = func(player_name, unpack(parse_result))
	if result_message then
		-- TODO: If we were unsuccessfull, then colour the message red
		worldedit.player_notify(player_name, result_message)
	end
end

local function run_command(cmdname, options, player_name, paramtext)
	if options.require_pos > 0 and not worldedit.pos1[player_name] then
		worldedit.player_notify(player_name, "Error: pos1 must be selected to use this command.")
		return false
	end
	if options.require_pos > 1 and not worldedit.pos2[player_name] then
		worldedit.player_notify(player_name, "Error: Both pos1 and pos2 must be selected (together making a region) to use this command.")
		return false
	end
	
	local parse_result = { options.parse(paramtext) }
	local success = table.remove(parse_result, 1)
	if not success then
		worldedit.player_notify(player_name, parse_result[1] or "Invalid usage (no further error message was provided by the command. This is probably a bug.)")
		return false
	end
	
	if options.nodes_needed then
		local potential_changes = options.nodes_needed(player_name, unpack(parse_result))
		
		local limit = wea_c.safe_region_limit_default
		if wea_c.safe_region_limits[player_name] then
			limit = wea_c.safe_region_limits[player_name]
		end
		
		if potential_changes > limit then
			worldedit.player_notify(player_name, "/"..cmdname.." "..paramtext.."' may affect up to "..human_size(potential_changes).." nodes. Type //y to continue, or //n to cancel (see the //saferegion command to control when this message appears).")
			safe_region(player_name, cmdname, function()
				run_command_stage2(player_name, options.func, parse_result)
			end)
		end
	else
		run_command_stage2(player_name, options.func, parse_result)
	end
	
end

return run_command
