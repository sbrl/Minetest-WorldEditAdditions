local Notify = worldeditadditions_core.notify
worldeditadditions.normalize_test("notify", {
	params = "<message>",
	description = "Sends message to player in all main notification formats (error, warn, ok, info).",
	func = function(name, params_table)
		local message = table.concat(params_table, " ")
		Notify.error(name, message)
		Notify.warn(name, message)
		Notify.ok(name, message)
		Notify.info(name, message)
		Notify.custom(name, "@" .. name, "Good Job", "#FF00D7")
		return true
	end
})