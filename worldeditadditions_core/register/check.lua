function worldeditadditions_core.register_command(name, def)
	-- TODO: Implement our own deep copy function here
	-- Depending on a Minetest-specific addition here makes be very uneasy
	-- ...especially since it's not obvious at first glance that this isn't a
	-- core feature provided by Lua itself
	local def = table.copy(def)
	
	assert(
		def.privs,
		"Error: No privileges specified in definition of command '"..name.."'."
	)
	
	def.require_pos = def.require_pos or 0
	
	assert(def.require_pos >= 0 and def.require_pos < 3)
	
	if def.params == "" and not def.parse then
		def.parse = function(params_text) return true end
	else
		assert(
			def.parse,
			"Error: No parameter parsing function specified, even though parameters were specified in definition of command '"..name.."'."
		)
	end
	
	assert(
		def.nodes_needed == nil or type(def.nodes_needed) == "function",
		"Error: nodes_needed must be either not specified or be a function that returns the number of nodes that could potentially be changed for a given set fo parsed parameters in definition of command '"..name.."'"
	)
	
	assert(
		def.func,
		"Error: 'func' is not defined. It must be defined to the function to call to run the command in definition of command '"..name.."'."
	)
	
	return def
end
