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
    params_text = params_text or "air"
    return true, params_text
	end,
	func = function(name, params_text)
    if name == nil then return end
    worldedit.player_notify(name, worldedit.normalize_nodename(params_text) or 'Error 404: "'..params_text..'" not found!')
	end
})
