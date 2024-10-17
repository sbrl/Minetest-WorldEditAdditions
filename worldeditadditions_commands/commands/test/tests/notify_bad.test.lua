local Notify = worldeditadditions_core.notify
worldeditadditions.normalize_test("notifybad", {
	params = "N/A",
	description = "Sends badly formed messages to player to test error handling.",
	func = function(name, params_table)
		local target = function(n)
			if not n then n = 16 end
			local ret = ""
			for _ = 1, n do ret = ret .. string.char(math.random(36, 126)) end
			return ret
		end
		local message = "This is a test..."
		
		Notify.warn(name, "Name is not string test:")
		Notify.info(target, message) -- Name not a string
		Notify.info(name, "Error should be logged to debug.text at " .. os.date('%Y-%m-%d %H:%M:%S'))
		
		Notify.warn(name, "Invalid name test:")
		Notify.info(target(), message) -- Bad name
		
		Notify.warn(name, "Message is not string test:")
		Notify.info(name, params_table) -- Message not a string
		
		Notify.warn(name, "Invalid color test:")
		Notify.custom(name, "bad", message, "#FF00") -- Bad colour
		return true, "Test complete."
	end
})