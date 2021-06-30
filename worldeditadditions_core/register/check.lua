function worldeditadditions_core.register_command(def)
	local def = table.copy(def)
	assert(name and #name > 0)
	assert(def.privs)
	def.require_pos = def.require_pos or 0
	assert(def.require_pos >= 0 and def.require_pos < 3)
	if def.params == "" and not def.parse then
		def.parse = function(param) return true end
	else
		assert(def.parse)
	end
	assert(def.nodes_needed == nil or type(def.nodes_needed) == "function")
	assert(def.func)
end
