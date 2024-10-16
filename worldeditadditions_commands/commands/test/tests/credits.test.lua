-- Helper functions
local set_colour = function(colour, text)
	return minetest.colorize(colour, text)
end

local credits = {
	"=== WorldEditAdditions ===", "",
	"Made by",
	"  - "..set_colour("#ff00d7", "Starbeamrainbowlabs").." (https://github.com/sbrl)",
	"  - "..set_colour("#ffd700", "VorTechnix").." (https://github.com/VorTechnix)",
	"","With thanks to our discord members and everyone who has reported issues or contributed!",
}

local Notify = worldeditadditions_core.notify
worldeditadditions.normalize_test("credits", {
	params = "N\\A",
	description = "Sends WEA credits to player in info notification format.",
	func = function(name, params_table)
		local function send_credits(i)
			Notify.info(name, credits[i])
			if #credits > i then
				minetest.after(1, send_credits, i+1)
			end
		end
		send_credits(1)
	end
})