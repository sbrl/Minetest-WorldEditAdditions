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
