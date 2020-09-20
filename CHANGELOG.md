# WorldEditAdditions Changelog
It's about time I started a changelog! This will serve from now on as the master changelog for WorldEditAdditions.


## v1.9 (unreleased)
 - Add `//many` for executing a command many times in a row
 - Add **experimental** `//erode` command
 - Add `//fillcaves` command - fills in all air nodes beneath non air-nodes
 - Add `//forest` command for quickly generating forests
 - Fix some minor bugs and edge cases
 - `//subdivide`: Print status update when completing the last chunk


## v1.8: The Quality of Life Update (17th July 2020)
 - Update `//multi` to display human readable times (e.g. `2.11mins` instead of `126600ms`)
 - Far wand: Notify player when setting pos1 and pos2
 - Make timings more accurate (use `minetest.get_us_time()` instead of `os.clock()`)
 - Add _experimental_ `//subdivide` command
 - Attempt to fix a crash on startup due to a dependency issue (#21)


## v1.7: The Terrain Update! (21st June 2020)
 - Added `//layers` (like WorldEdit for Minecraft's `//naturalize`)
 - Added `//convolve` (advanced terrain smoothing inspired by image editors)
 - Added far wand (like the regular WorldEdit wand, but with a configurable range that can extend to 100s of blocks)
[/list]


## Release text template
The text below is used as a template when making releases.

--------

INTRO

See below for instructions on how to update.

CHANGELOG HERE


## Updating
Updating depends on how you installed WorldEditAdditions.

 - UI in Minetest: There should be an update button for you to click in the mod menu
 - ContentDB: Download the latest update from [here](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/)
 - Git: `cd` to the WorldEditAdditions directory and run `git pull`

After installing the update, don't forget to restart your client and / or server.


--------
