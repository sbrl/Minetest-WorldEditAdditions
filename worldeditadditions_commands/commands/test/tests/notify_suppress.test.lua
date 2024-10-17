local Notify = worldeditadditions_core.notify
worldeditadditions.normalize_test("suppress", {
	params = "N/A",
	description = "Tests notification suppression system.",
	func = function(name, params_table)
		Notify.suppress_for_player(name, 5)
		Notify.warn(name, "This message should not be shown.")
		Notify.suppress_for_player(name, -1)
		Notify.ok(name, "This message should be shown.")
		local result = Notify.suppress_for_function(name, function()
				Notify.error(name, "This message should not be shown.")
				return true
			end)
		if not result then
			Notify.error(name, "Error: suppress_for_function did not call function.")
		else
			Notify.ok(name, "suppress_for_function called function.")
		end
	end
})