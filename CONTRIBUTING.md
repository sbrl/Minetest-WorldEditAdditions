# Contributing Guide

Hey there! So you like WorldEditAdditions enough to consider helping out? That's awesome! This guide should get you up and running in no time.

**Lua API documentation:** <https://worldeditadditions.mooncarrot.space/api/>
- Visit me to find handy functions for doing all kinds of things! It's like the batteries that weren't included with Lua and much much more :D

## Code structure
The WorldEditAdditions codebase is split into 3 main submods:

Name							| Description
--------------------------------|------------------------
`worldeditadditions`			| The main mod. Core world manipulation implementations (backed by the `*_core` mod ref core and utility functions) should go in here.
`worldeditadditions_commands`	| Chat commands. These interact with the core manipulators in `worldeditadditions` mod.
`worldeditadditions_farwand`	| Everything to do with the far wand tool, and now other tools like the cloud wand, multi-point wand, etc. It's different enough to everything else that it warrants it's own separate mod to avoid muddling things.
`worldeditadditions_core`		| Core components such as the positioning system (`worldeditadditions_core.pos`), the command registration function, and utility functions go in here.

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

## FDT: Frequently Done Tasks

### Implementing a new command
Many new contributors want to implement a new command. While there are a few steps to doing so, there's loads of resources to help ya out :D

Firstly, the structure for commands is thus:

1. The bit that does the thing your command should do goes in [`worldeditadditions/lib`](https://github.com/sbrl/Minetest-WorldEditAdditions/tree/main/worldeditadditions/lib)
2. The bit that registers the chat command goes in [`worldeditadditions_commands`](https://github.com/sbrl/Minetest-WorldEditAdditions/tree/main/worldeditadditions_commands/commands)

Please do see other commands and functions in the mod already for example help on doing this and to match style.

### Parsing command arguments
Parsing command-line arguments can be tricky, but WorldEditAdditions has a range of functions to help you out here.

The one you probably want is [`worldeditadditions_core.split_shell`]()


## Chat command template

```lua
-- ███    ██  █████  ███    ███ ███████
-- ████   ██ ██   ██ ████  ████ ██
-- ██ ██  ██ ███████ ██ ████ ██ █████
-- ██  ██ ██ ██   ██ ██  ██  ██ ██
-- ██   ████ ██   ██ ██      ██ ███████
local wea = worldeditadditions
local weac = worldeditadditions_core
local Vector3 = weac.Vector3
worldeditadditions_core.register_command("{name}", {
	params = "<argument> <argument=default> <option1|option2|...> [<optional_argument> <optional_argument2> ...] | [<optional_argument> [<optional_argument2>]]",
	description = "A **brief** description of what this command does",
	privs = { worldedit = true },
	require_pos = 0, -- Optional | (0|1|2)
	parse = function(params_text)
		-- Do stuff with params_text
		return true, param1, param2
	end,
	nodes_needed = function(name) --Optional
		return Vector3.volume(weac.pos.get1(name), weac.pos.get2(name))
	end,
	func = function(name, param1, param2)
		-- Start a timer
		local start_time = weac.get_ms_time()
		-- Do stuff
		
		-- Finish timer
		local time_taken = weac.get_ms_time() - start_time
		
		minetest.log("This is a logged message!")
		return true, "Completed command in " .. weac.format.human_time(time_taken)
	end
})
```
