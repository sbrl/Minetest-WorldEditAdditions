-- ██████   █████  ███████ ███████ ███    ██  █████  ███    ███ ███████
-- ██   ██ ██   ██ ██      ██      ████   ██ ██   ██ ████  ████ ██
-- ██████  ███████ ███████ █████   ██ ██  ██ ███████ ██ ████ ██ █████
-- ██   ██ ██   ██      ██ ██      ██  ██ ██ ██   ██ ██  ██  ██ ██
-- ██████  ██   ██ ███████ ███████ ██   ████ ██   ██ ██      ██ ███████
worldedit.register_command("basename", {
	params = "<nodealias>",
	description = "Returns the base name of nodes that use a given alias.",
	privs = {worldedit = true},
	parse = function(params_text)
		if params_text == "" or not params_text then
			return false, "Node not specified."
		end
		return true, params_text
	end,
	func = function(name, params_text)
		if name == nil then return end
		return true, worldedit.normalize_nodename(params_text) or 'Error 404: "'..params_text..'" not found!'
	end
})
