# ![](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/main/worldeditadditions-64.png) WorldEditAdditions
![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbrl/Minetest-WorldEditAdditions?color=green&label=latest%20release) [![View the changelog](https://img.shields.io/badge/%F0%9F%93%B0-Changelog-informational)](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/CHANGELOG.md) [![ContentDB](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/shields/downloads/)](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/) [![Join the official discord server](https://worldeditadditions.mooncarrot.space/img/shield-discord.svg)](https://discord.gg/FzD73kuhsk)

> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

**Important News: The `master` branch has been renamed to `main`, to follow the new standard across the Git ecosystem. If you've installed _WorldEditAadditions_ through git, you will need to re-clone the repository.**

![Screenshot](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/main/screenshot.png)

_(Do you have a cool build that you used WorldEditAdditions to build? [Get in touch](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) and I'll feature your screenshot here!)_


## Table of Contents
 - [Quick Command Reference](#quick-command-reference) (including links to detailed explanations)
 - [Using the Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#far-wand)
 - [Using the Cloud Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#cloud-wand)
 - [Detailed Chat Command Explanations](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md)
 - [Chat Command Cookbook](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Cookbook.md)
 - [Troubleshooting](#troubleshooting)
 - [Contributing](#contributing)
 - [WorldEditAdditions around the web](#worldeditadditions-around-the-web)
 - [Licence](#license)


## Quick Command Reference
The detailed explanations have moved! Check them out [here](https://worldeditadditions.mooncarrot.space/Reference/) (or edit at [Chat-Command-Reference.md](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md)), or click the links below.

### Geometry
 - [`//spline <replace_node> <width_start> [<width_end=width_start> [<steps=3>]]`](https://worldeditadditions.mooncarrot.space/Reference/#spline)
 - [`//dome+ <radius> <replace_node> [<pointing_dir:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> ...] [h[ollow]]`](https://worldeditadditions.mooncarrot.space/Reference/#dome)
 - [`//metaball add <radius> | remove <index> | render <replace_node> [<threshold=1>] | list | clear | volume`](https://worldeditadditions.mooncarrot.space/Reference/#metaball)
 - [`//ellipsoid <rx> <ry> <rz> <node_name> [h[ollow]]`](https://worldeditadditions.mooncarrot.space/Reference/#ellipsoid)
 - [`//ellipsoid2 <node_name> [h[ollow]]`](https://worldeditadditions.mooncarrot.space/Reference/#ellipsoid2)
 - [`//hollowellipsoid <rx> <ry> <rz> <node_name>`](https://worldeditadditions.mooncarrot.space/Reference/#hollowellipsoid)
 - [`//torus <major_radius> <minor_radius> <node_name> [<axes=xy> [h[ollow]]]`](https://worldeditadditions.mooncarrot.space/Reference/#torus)
 - [`//hollowtorus <major_radius> <minor_radius> <node_name> [<axes=xy>]`](https://worldeditadditions.mooncarrot.space/Reference/#hollowtorus)
 - [`//walls <replace_node>`](https://worldeditadditions.mooncarrot.space/Reference/#walls)
 - [`//line [<replace_node> [<radius>]]`](https://worldeditadditions.mooncarrot.space/Reference/#line)
 - [`//hollow [<wall_thickness>]`](https://worldeditadditions.mooncarrot.space/Reference/#hollow)
 - [`//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`](https://worldeditadditions.mooncarrot.space/Reference/#maze)
 - [`//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`](https://worldeditadditions.mooncarrot.space/Reference/#maze3d)
 - [`//spiral2 [<circle|square>] [<replace_node=dirt> [<interval=3> [<acceleration=0>] ] ]`](https://worldeditadditions.mooncarrot.space/Reference/#spiral2)
 - [`//wbox <replace_node>`](https://worldeditadditions.mooncarrot.space/Reference/#wbox)
 - [`//wcompass <replace_node> [<bead_node>]`](https://worldeditadditions.mooncarrot.space/Reference/#wcompass)
 - [`//wcorner <replace_node>`](https://worldeditadditions.mooncarrot.space/Reference/#wcorner)

### Misc
 - [`//revolve <times> [<pivot_point_number=last_point>]`](https://worldeditadditions.mooncarrot.space/Reference/#revolve)
 - [`//copy+ <axis:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> <count> [<axis> <count> [...]]`](https://worldeditadditions.mooncarrot.space/Reference/#copy)
 - [`//move+ <axis:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> <count> [<axis> <count> [...]]`](https://worldeditadditions.mooncarrot.space/Reference/#move)
 - [`//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ....`](https://worldeditadditions.mooncarrot.space/Reference/#replacemix)
 - [`//floodfill [<replace_node> [<radius>]]`](https://worldeditadditions.mooncarrot.space/Reference/#floodfill)
 - [`//scale <axis> <scale_factor> | <factor_x> [<factor_y> <factor_z> [<anchor_x> <anchor_y> <anchor_z>]]`](https://worldeditadditions.mooncarrot.space/Reference/#scale) **experimental**

### Terrain
 - [`//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`](https://worldeditadditions.mooncarrot.space/Reference/#overlay)
 - [`//layers [<max_slope|min_slope..max_slope>] [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`](https://worldeditadditions.mooncarrot.space/Reference/#layers)
 - [`//fillcaves [<node_name>]`](https://worldeditadditions.mooncarrot.space/Reference/#fillcaves)
 - [`//convolve <kernel> [<width>[,<height>]] [<sigma>]`](https://worldeditadditions.mooncarrot.space/Reference/#convolve)
 - [`//erode [<snowballs|river> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`](https://worldeditadditions.mooncarrot.space/Reference/#erode) **experimental**
 - [`//noise2d [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`](https://worldeditadditions.mooncarrot.space/Reference/#noise2d)
 - [`//sculpt [[<brush_name=default> [<brush_size=8> [<height=1>]]]`](https://worldeditadditions.mooncarrot.space/Reference/#sculpt)
 - [`//sculptlist [preview]`](https://worldeditadditions.mooncarrot.space/Reference/#sculptlist)

### Flora
 - [`//bonemeal [<strength> [<chance> [<node_name> [<node_name> ...]]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#bonemeal-strength-chance)
 - [`//forest [<density>] <sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...`](https://worldeditadditions.mooncarrot.space/Reference/#forest) _(new in v1.9)_
 - [`//saplingaliases [aliases|all_saplings]`](https://worldeditadditions.mooncarrot.space/Reference/#saplingaliases) _(new in v1.9)_

### Statistics
 - [`//count`](https://worldeditadditions.mooncarrot.space/Reference/#count)
 - [`//basename <name>`](https://worldeditadditions.mooncarrot.space/Reference/#basename)

### Selection
 - [`//scol [<axis1> ] <length>`](https://worldeditadditions.mooncarrot.space/Reference/#scol)
 - [`//srect [<axis1> [<axis2>]] <length>`](https://worldeditadditions.mooncarrot.space/Reference/#srect)
 - [`//scube [<axis1> [<axis2> [<axis3>]]] <length>`](https://worldeditadditions.mooncarrot.space/Reference/#scube)
 - [`//scloud <0-6|stop|reset>`](https://worldeditadditions.mooncarrot.space/Reference/#scloud)
 - [`//scentre`](https://worldeditadditions.mooncarrot.space/Reference/#scentre)
 - [`//srel <axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]`](https://worldeditadditions.mooncarrot.space/Reference/#srel)
 - [`//smake <operation:odd|even|equal> <mode:grow|shrink|average> [<target=xz> [<base>]]`](https://worldeditadditions.mooncarrot.space/Reference/#smake)
 - [`//sstack`](https://worldeditadditions.mooncarrot.space/Reference/#sstack)
 - [`//spush`](https://worldeditadditions.mooncarrot.space/Reference/#spush)
 - [`//spop`](https://worldeditadditions.mooncarrot.space/Reference/#spop)
 - [`//sshift <axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]`](https://worldeditadditions.mooncarrot.space/Reference/#sshift)
 - [`//sfactor <mode:grow|shrink|average> <factor> [<target=xz>]`](https://worldeditadditions.mooncarrot.space/Reference/#sfactor)
 - [`//pos <index>`](https://worldeditadditions.mooncarrot.space/Reference/#pos)
 - [`//pos1`](https://worldeditadditions.mooncarrot.space/Reference/#pos1)
 - [`//pos2`](https://worldeditadditions.mooncarrot.space/Reference/#pos2)
 - [`//mark`](https://worldeditadditions.mooncarrot.space/Reference/#mark)
 - [`//unmark`](https://worldeditadditions.mooncarrot.space/Reference/#unmark)
 - [`//reset`](https://worldeditadditions.mooncarrot.space/Reference/#reset)
 
### Measure
 - [`//mface`](https://worldeditadditions.mooncarrot.space/Reference/#mface) _(new in v1.13)_
 - [`//midpos`](https://worldeditadditions.mooncarrot.space/Reference/#midpos) _(new in v1.13)_
 - [`//msize`](https://worldeditadditions.mooncarrot.space/Reference/#msize) _(new in v1.13)_
 - [`//mtrig`](https://worldeditadditions.mooncarrot.space/Reference/#mtrig) _(new in v1.13)_
 
### Meta
 - [`//multi <command_a> <command_b> ....`](https://worldeditadditions.mooncarrot.space/Reference/#multi)
 - [`//many <times> <command>`](https://worldeditadditions.mooncarrot.space/Reference/#many) _(new in v1.9)_
 - [`//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`](https://worldeditadditions.mooncarrot.space/Reference/#subdivide)
 - [`//ellipsoidapply <command_name> <args>`](https://worldeditadditions.mooncarrot.space/Reference/#ellipsoidapply) _(new in v1.9)_
 - [`//airapply <command_name> <args>`](https://worldeditadditions.mooncarrot.space/Reference/#airapply) _(new in v1.9)_
 - [`//noiseapply2d <threshold> <scale> <command_name> <args>`](https://worldeditadditions.mooncarrot.space/Reference/#noiseapply2d) _(new in v1.13)_
 - [`//for <value1> <value2> <value3>... do //<command> <arg> %% <arg>`](https://worldeditadditions.mooncarrot.space/Reference/#for) _(new in v1.13)_

### Extras
 - [`//y`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#y)
 - [`//n`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#n)

### Tools
 - [WorldEditAdditions Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#far-wand)
 - [WorldEditAdditions Cloud Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#cloud-wand)
 - [`//farwand skip_liquid (true|false) | maxdist <number>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#farwand-skip_liquid-truefalse--maxdist-number)


## Installation
You can install _WorldEditAadditions_ in multiple ways:

### Through ContentDB
WorldEditAdditions is on ContentDB here: <https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/>.

### Through the latest release
You can get a copy of WorldEditAdditions by downloading the source code for the [latest release](https://github.com/sbrl/Minetest-WorldEditAdditions/releases/latest), but this is not recommended because it takes additional effort to update to the latest version.

### Through Git
You can also clone this git repository. Note that the `main` branch is not considered to be stable at all times - though it shouldn't crash. It is recommended that you checkout a release to ensure stability. Do that like so:

```bash
# First, clone the repository
git clone https://github.com/sbrl/Minetest-WorldEditAdditions.git WorldEditAdditions
cd WorldEditAdditions
# Then, checkout the latest release on Linux:
git checkout "$(git describe --tags --abbrev=0)";
```

If you do not checkout the latest release, you will be using the development version of WorldEditAdditions. While every effort is made to ensure that the development version is stable at all times, this is not a guarantee.

Windows users, you'll need to check the [releases page](https://github.com/sbrl/Minetest-WorldEditAdditions/releases) and find the name of the latest release, then do this instead of the `git checkout` above:

```bash
git checkout TAG_NAME_HERE
```


## Troubleshooting
If you're experiencing issues with this mod, try checking this FAQ before opening an issue.

### I get an error saying that worldedit isn't installed
WorldEditAdditions requires that the `worldedit` mod is installed as a dependency. Install it and then try launching Minetest (or the `minetest-server`) again.

### I get an error saying that `worldedit.register_command()` is not a function
This is probably because your version of `worldedit` is too old. Try updating it. Specifically the `worldedit.register_command()` function was only added to `worldedit` in December 2019.

### I get a crash on startup saying `attempt to call field 'alias_command' (a nil value)`
Please update to v1.8+. There was a bug in earlier versions that caused a race condition that sometimes resulted in this crash.

### Why don't the [moretrees](https://content.minetest.net/packages/VanessaE/moretrees/) trees work with `//forest`?
As far as I can tell, the saplings provided by the [`moretrees` mod](https://content.minetest.net/packages/VanessaE/moretrees/) don't properly interact with bonemeal from the [bonemeal mod](https://content.minetest.net/packages/TenPlus1/bonemeal/), which WorldEditAdditions uses to grow trees. As far as I can tell WorldEditAdditions has everything in place needed to support them, but until applying bonemeal to `moretrees` saplings results in a tree rather than waiting for one to grow over time, WorldEditAdditions will always fail to place trees provided by the `moretrees` mod, unfortunately.

### The region markers look weird!
We've implemented a custom replacement for the WorldEdit region markers that supports selecting more than 2 points. This new WorldEditAdditions positioning system synchronises with WorldEdit's positioning system, so you can use both WorldEdit and WorldEditAdditions tools and commands interchangeably and they will seamlessly sync with each other.

The only side effect of this is that WorldEdit commands such as `//shift` are not aware of the new WorldEditAdditions positioning system, so you may encounter a situation where both WorldEdit and WorldEditAdditions region markers may display until you use another WorldEditAdditions command or tool to update them. This will be fixed in time as more commands and tools are implemented.

### The position markers disappear when far way
This is a limitation of Minetest. You can workaround it though by setting [`active_block_range`](https://github.com/minetest/minetest/blob/5.6.1/minetest.conf.example#L2868) to a higher value - though be aware this also affects ABMs and other entities as well, so it can cause server lag.

The new positioning system now partially rectifies this issue with the region marker walls by creating a grid of entities instead of a single entity, such that a portion of them are more likely to be in range.


## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc. More contributing help can be found in [the contributing guide](CONTRIBUTING.md).

### Inspiration
Want to contribute, but finding it tough to search for inspiration of what to implement? Here are some great places to look:

- [**Our issue tracker:**](https://github.com/sbrl/Minetest-WorldEditAdditions/issues) There are always a bunch of issues open with cool commands and features that have yet to be implemented.
- **Other software:** Software for Minecraft is often far more mature than that available for Minetest. As a result, it's full of cool ideas. A lot of the existing commands in WorldEditAdditions were sourced from here.
	- WorldEdit for Minecraft
	- VoxelSniper(-Reimagined) for Minecraft
	- WorldPainter for Minecraft
- **Do some building:** When you put WorldEditAdditions to use in building projects of your own, things will absolutely stand out to you what you want in the creative building process that WorldEditAdditions doesn't yet have.
- **Watch others build stuff:** Doesn't even have to be Minetest! There are lots of talented Minecraft builders with videos and series on e.g. YouTube. From their creative building processes, many ideas can be derived.

The ultimate goal is for WorldEditAdditions to support the creative building process in a way that enables builders of all backgrounds to create incredible things.


## WorldEditAdditions around the web
Are you using WorldEditAdditions for a project? Open an issue and I'll add your project to the below list!

 - _(None that I'm aware of yet! Open an issue or get in touch and I'll link to your project (-:)_

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

All textures however are licenced under [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) (Creative Commons Attribution Share-Alike International 4.0).

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.

If WorldEditAdditions has helped you out in a project, please consider adding a little sign in a corner of your project saying so :-)
