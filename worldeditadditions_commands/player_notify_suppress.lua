-- Overrides worldedit.player_notify() to add the ability to
-- suppress messages (used in //subdivide)

local player_notify_suppressed = {}

local orig_player_notify = worldedit.player_notify
function worldedit.player_notify(name, message)
	if not player_notify_suppressed[name] then
		orig_player_notify(name, message)
	end
end

--- Disables sending worldedit messages to the player with the given name.
function worldedit.player_notify_suppress(name)
	player_notify_suppressed[name] = true
end
--- Enables sending worldedit messages to the player with the given name.
function worldedit.player_notify_unsuppress(name)
	player_notify_suppressed[name] = nil
end
