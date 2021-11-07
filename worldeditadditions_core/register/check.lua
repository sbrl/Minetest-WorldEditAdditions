function worldeditadditions_core.check_command(name, def)
	if not (name and #name > 0) then
		return false, "Error: No command name."
	end
	if not def.privs then
		return false, "Error: privs is nill. Expected table."
	end
	def.require_pos = def.require_pos or 0
	if not (def.require_pos >= 0 and def.require_pos < 3) then
		return false, "Error: require_pos must be greater than -1 and less than 3."
	end
	if not def.parse then
		if def.params == "" then
			def.parse = function(params_text) return true end
		else
			return false, "Error: parse function is invalid."
		end
	end
	if not (def.nodes_needed == nil or type(def.nodes_needed) == "function") then
		return false, "Error: nodes_needed must be nil or function."
	end
	if not def.func then
		return false, "Error: main function is invalid."
	end
	return true
end
