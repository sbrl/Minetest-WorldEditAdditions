# Contributing Guide

Hey there! So you like WorldEditAdditions enough to consider helping out? That's awesome! This guide should get you up and running in no time.


## Code structure
The WorldEditAdditions codebase is split into 3 main submods:

Name							| Description
--------------------------------|------------------------
`worldeditadditions`			| The main mod. Core world manipulation implementations should go in here.
`worldeditadditions_commands`	| Chat commands. These interact with the core manipulators in `worldeditadditions` mod.
`worldeditadditions_farwand`	| Everything to do with the far wand tool. It's different enough to everything else that it warrants it's own separate mod to avoid muddling things.

Additionally, every command should be implemented in its own file. This helps keep things organised and files short.

Don't forget to update `init.lua` to `dofile()` the new file(s) you create in each submod :-)


## Guidelines
When actually implementing stuff, here are a few guidelines that I recommend to summarise everything:

 - Keep each command implementation to its own file
 - Split up files with more than 500 lines into smaller chunks (such as what I've done with the `//convolve` implementation in the `worldeditadditions` submod)
 - Try to follow the existing programming style
 - If you think of something helpful to add to this guide, please open an issue / PR :D
 - Being excellent to everyone shouldn't have to be on this list, but it is
 - @sbrl has the final say


## Chat command template

```lua
-- ███    ██  █████  ███    ███ ███████
-- ████   ██ ██   ██ ████  ████ ██
-- ██ ██  ██ ███████ ██ ████ ██ █████
-- ██  ██ ██ ██   ██ ██  ██  ██ ██
-- ██   ████ ██   ██ ██      ██ ███████
local wea = worldeditadditions
worldedit.register_command("{name}", {
	params = "<argument> <argument=default> <option1|option2|...> [<optional_argument> <optional_argument2> ...] | [<optional_argument> [<optional_argument2>]]",
	description = "A **brief** description of what this command does",
	privs = { worldedit = true },
	require_pos = 0, -- Optional | (0|1|2)
	parse = function(params_text)
		-- Do stuff with params_text
		return true, param1, param2
	end,
	nodes_needed = function(name) --Optional
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, param1, param2)
		-- Start a timer
		local start_time = wea.get_ms_time()
		-- Do stuff
		
		-- Finish timer
		local time_taken = wea.get_ms_time() - start_time
		
		minetest.log("This is a logged message!")
		return true, "Completed command in " .. wea.format.human_time(time_taken)
	end
})
```
