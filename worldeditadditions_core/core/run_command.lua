-- WARNING: safe_region MUST NOT be imported more than once, as it defines chat commands. If you want to import it again elsewhere, check first that multiple dofile() calls don't execute a file more than once.
local wea_c = worldeditadditions_core
local safe_region = dofile(wea_c.modpath.."/core/safe_region.lua")
local human_size = wea_c.format.human_size

-- TODO: Reimplement worldedit.player_notify(player_name, msg_text)

local function run_command_stage2(player_name, func, parse_result)
	local success, result_message = func(player_name, wea_c.table.unpack(parse_result))
	if result_message then
		-- TODO: If we were unsuccessfull, then colour the message red
		worldedit.player_notify(player_name, result_message)
	end
end

local function run_command(cmdname, options, player_name, paramtext)
	if options.require_pos > 0 and not worldedit.pos1[player_name] and not wea_c.pos.get1(player_name) then
		worldedit.player_notify(player_name, "Error: pos1 must be selected to use this command.")
		return false
	end
	if options.require_pos > 1 and not worldedit.pos2[player_name] and not wea_c.pos.get2(player_name) then
		worldedit.player_notify(player_name, "Error: Both pos1 and pos2 must be selected (together making a region) to use this command.")
		return false
	end
	local pos_count = wea_c.pos.count(player_name)
	if options.require_pos > 2 and pos_count < options.require_pos then
		worldedit.player_notify(player_name, "Error: At least "..options.require_pos.."positions must be defined to use this command, but you only have "..pos_count.." defined (try using the multiwand).")
		return false
	end
	
	local parse_result = { options.parse(paramtext) }
	local success = table.remove(parse_result, 1)
	if not success then
		worldedit.player_notify(player_name, parse_result[1] or "Invalid usage (no further error message was provided by the command. This is probably a bug.)")
		return false
	end
	
	if options.nodes_needed then
		local potential_changes = options.nodes_needed(player_name, wea_c.table.unpack(parse_result))
		if type(potential_changes) ~= "number" then
			worldedit.player_notify(player_name, "Error: The command '"..cmdname.."' returned a "..type(potential_changes).." instead of a number when asked how many nodes might be changed. Abort. This is a bug.")
			return
		end
		
		local limit = wea_c.safe_region_limit_default
		if wea_c.safe_region_limits[player_name] then
			limit = wea_c.safe_region_limits[player_name]
		end
		if type(potential_changes) == "string" then
			worldedit.player_notify(player_name, "/"..cmdname.." "..paramtext.." "..potential_changes..". Type //y to continue, or //n to cancel (in this specific situation, your configured limit via the //saferegion command does not apply).")
		elseif potential_changes > limit then
			worldedit.player_notify(player_name, "/"..cmdname.." "..paramtext.." may affect up to "..human_size(potential_changes).." nodes. Type //y to continue, or //n to cancel (see the //saferegion command to control when this message appears).")
			safe_region(player_name, cmdname, function()
				run_command_stage2(player_name, options.func, parse_result)
			end)
		else
			run_command_stage2(player_name, options.func, parse_result)	
		end
	else
		run_command_stage2(player_name, options.func, parse_result)
	end
	
end

return run_command
