# Minetest-WorldEditAdditions
![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbrl/Minetest-WorldEditAdditions?color=green&label=latest%20release) [![View the changelog](https://img.shields.io/badge/%F0%9F%93%B0-Changelog-informational)](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/CHANGELOG.md) [![ContentDB](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/shields/downloads/)](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/)

> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

![Screenshot](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/screenshot.png)

_(Do you have a cool build that you used WorldEditAdditions to build? [Get in touch](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) and I'll feature you screenshot here!)_


## Table of Contents
 - [Quick Command Reference](#quick-command-reference) (including links to detailed explanations)
 - [Using the Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#far-wand)
 - [Detailed Chat Command Explanations](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md)
 - [Troubleshooting](#troubleshooting)
 - [Contributing](#contributing)
 - [WorldEditAdditions around the web](#worldeditadditions-around-the-web)
 - [Licence](#license)


## Quick Command Reference
The detailed explanations have moved! Check them out [here](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md), or click the links below.

### Geometry
 - [`//ellipsoid <rx> <ry> <rz> <node_name>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#ellipsoid-rx-ry-rz-node_name)
 - [`//hollowellipsoid <rx> <ry> <rz> <node_name>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#hollowellipsoid-rx-ry-rz-node_name)
 - [`//torus <major_radius> <minor_radius> <node_name>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#torus-major_radius-minor_radius-node_name)
 - [`//hollowtorus <major_radius> <minor_radius> <node_name>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#hollowtorus-major_radius-minor_radius-node_name)
 - [`//walls <replace_node>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#walls-replace_node)
 - [`//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#maze-replace_node-seed)
 - [`//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#maze3d-replace_node-seed)

### Misc
 - [`//bonemeal [<strength> [<chance>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#bonemeal-strength-chance)
 - [`//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ....`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#replacemix-target_node-chance-replace_node_a-chance_a-replace_node_b-chance_b-replace_node_n-chance_n-)
 - [`//floodfill [<replace_node> [<radius>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#floodfill-replace_node-radius-floodfill)

### Terrain
 - [`//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-)
 - [`//layers [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#layers-node_name_1-layer_count_1-node_name_2-layer_count_2-)
 - [`//fillcaves [<node_name>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#fillcaves-node_name)
 - [`//convolve <kernel> [<width>[,<height>]] [<sigma>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#convolve-kernel-widthheight-sigma)
 - [`//erode [<snowballs|...> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#erode-snowballs-key_1-value_1-key_2-value_2-) **experimental**

### Statistics
 - [`//count`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#count)

### Extras
 - [`//multi <command_a> <command_b> ....`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#multi-command_a-command_b-command_c-)
 - [`//many <times> <command>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#many-times-command) (coming soon in v1.9!)
 - [`//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#subdivide-size_x-size_y-size_z-cmd_name-args) **experimental**
 - [`//y`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#y)
 - [`//n`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#n)

### Tools
 - [WorldEditAdditions Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#far-wand)
 - [`//farwand skip_liquid (true|false) | maxdist <number>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/docs/Chat-Command-Reference.md#farwand-skip_liquid-truefalse--maxdist-number)


## Troubleshooting
If you're experiencing issues with this mod, try checking this FAQ before opening an issue.

### I get an error saying that worldedit isn't installed
WorldEditAdditions requires that the `worldedit` mod is installed as a dependency. Install it and then try launching Minetest (or the `minetest-server`) again.

### I get an error saying that `worldedit.register_command()` is not a function
This is probably because your version of `worldedit` is too old. Try updating it. Specifically the `worldedit.register_command()` function was only added to `worldedit` in December 2019.

### I get a crash on  startup saying `attempt to call field 'alias_command' (a nil value)`
Please update to v1.8+. There was a bug in earlier versions that caused a race condition that sometimes resulted in this crash.


## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc.


## WorldEditAdditions around the web
Are you using WorldEditAdditions for a project? Open an issue and I'll add your project to the below list!

 - _(None that I'm aware of yet!)_

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

All textures however are licenced under [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) (Creative Commons Attribution Share-Alike International 4.0).

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.

If WorldEditAdditions has helped you out in a project, please consider adding a little sign in a corner of your project saying so :-)
