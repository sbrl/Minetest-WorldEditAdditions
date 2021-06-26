# WorldEditAdditions Changelog
It's about time I started a changelog! This will serve from now on as the main changelog for WorldEditAdditions.

Note to self: See the bottom of this file for the release template text.

## v1.12: The selection tools update
 - Add `//spush`, `//spop`, and `//sstack`
 - Add `//srect` (_select rectangle_), `//scol` (_select column_), `//scube` (_select cube_) - thanks, @VorTechnix!
 - Add `//scloud` (_select point cloud_), `//scentre` (_select centre node(s)_), `//srel` (_select relative_)  - thanks, @VorTechnix!
 - Add `//smake` (_selection make_) - thanks, @VorTechnix!
 - Significantly refactored backend utility functions (more to come in future updates)
 - Add new universal chance parsing
     - Any `<chance>` can now either be a 1-in-N number (e.g. `4`, `10`), or a percentage chance (e.g. `50%`, `10%`).
     - Caveat: Percentages are converted to a 1-in-N chance, but additionally that number is rounded down in some places
 - `//torus`, `//hollowtorus`: Add optional new axes
 - `//torus`, `//ellipsoid`: Add optional hollow keyword - @VorTechnix
 - `//multi`: Add curly brace syntax for nesting command calls ([more information](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#multi-command_a-command_b-command_c-))
 - `//erode`: Add new `river` erosion algorithm for filling in potholes and removing pillars

### Bugfixes
 - `//bonemeal`: Try bonemealing everything that isn't an air block (#49)
 - `//overlay`: Don't place nodes above water
 - `//multi`: Improve resilience by handling some edge cases
 - `//layers`: Fix crash due to outdated debug code
 - `//erode`/snowballs: Fix assignment to undeclared variable
 - `//floodfill`: Fix error handling


## v1.11: The big data update (25th January 2021)
 - Add `//scale` (currently **experimental**)
     - Scale operations that scale up and down at the same time are split into 2 separate operations automatically (scaling up is always performed first)
 - `//count`: Make numbers human-readable
     - Tip: Use a monospace font for the chat window, and the columns will be aligned!
 - Add `//hollow` for hollowing out areas (a step towards parity with Minecraft WorldEdit)
 - `//subdivide`: Improve performance of initial chunk counting algorithm - it should get started on the job _much_ quicker now (especially on large regions)
 - `//subdivide`: Fix a bug where the entire defined region was emerged all at once instead of in chunks
 - `//subdivide`: Fix performance & memory usage issues
     - Fix passing arguments to the command being executed
     - If you encounter any other issues with it over large areas (particularly 2000x150x2000 and larger), please let me know
 - Bugfix: Fix obscure crash in calls to `human_size` ("unknown" will now be returned if passed junk)
 - `//many` can now be used with commands with no arguments.
 - `//conv`, `//erode`, `//fillcaves`: Treat liquids as air
 - Add new [cloud wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#cloud-wand)
 - `//conv`, `//erode`: Minor refactoring to improve code clarity


## v1.10: The tidyup update (16th January 2021)
 - `//maze`: Fix some parts of generated mazes staying solid
 - `//maze`, `//maze3d`: Allow non-number seeds (existing seeds aren't affected - they will still produce identical output)
 - `//many`: Improve format of progress messages, add ETA
 - `//subdivide`: Make asynchronous, and use `minetest.emerge_area()` to ensure areas are loaded before executing on a subdivision chunk
     - This will ensure that `//subdivide`ing enormous regions should now function as expected. Want to level an entire rainforest with `//subdivide` and `//clearcut`? Now you can! :D
 - Add `//line` for drawing simple lines


## v1.9: The Nature Update (20th September 2020)
 - Add `//many` for executing a command many times in a row
 - Add **experimental** `//erode` command
 - Add `//fillcaves` command - fills in all air nodes beneath non air-nodes
 - Add `//forest` command for quickly generating forests, and `//saplingaliases` to compliment it
 - Add `//ellipsoidapply`: Like `//cubeapply`, but clips the result to an ellipsoid that is the size of the defined region.
 - Fix some minor bugs and edge cases
 - `//subdivide`: Print status update when completing the last chunk
 - `//count`: Optimise by removing nested `for` loops


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
 - Git: `cd` to the WorldEditAdditions directory and run `git pull` (**Important:** Recently, WorldEditAdditions changed the default branch from `master` to `main`. If you're updating from before then, you'll need to re-clone the mod or else do some git-fu)

After installing the update, don't forget to restart your client and / or server.


--------
