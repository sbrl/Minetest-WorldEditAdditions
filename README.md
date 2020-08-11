# Minetest-WorldEditAdditions
![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbrl/Minetest-WorldEditAdditions?color=green&label=latest%20release) [![View the changelog](https://img.shields.io/badge/%F0%9F%93%B0-Changelog-informational)](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/CHANGELOG.md)

> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

![Screenshot](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/screenshot.png)

## Quick Command Reference

### Geometry
 - [`//ellipsoid <rx> <ry> <rz> <node_name>`](#ellipsoid-rx-ry-rz-node_name)
 - [`//hollowellipsoid <rx> <ry> <rz> <node_name>`](#hollowellipsoid-rx-ry-rz-node_name)
 - [`//torus <major_radius> <minor_radius> <node_name>`](#torus-major_radius-minor_radius-node_name)
 - [`//hollowtorus <major_radius> <minor_radius> <node_name>`](#hollowtorus-major_radius-minor_radius-node_name)
 - [`//walls <replace_node>`](#walls-replace_node)
 - [`//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`](#maze-replace_node-seed)
 - [`//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`](#maze3d-replace_node-seed)

### Misc
 - [`//bonemeal [<strength> [<chance>]]`](#bonemeal-strength-chance)
 - [`//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ....`](#replacemix-target_node-chance-replace_node_a-chance_a-replace_node_b-chance_b-replace_node_n-chance_n-)
 - [`//floodfill [<replace_node> [<radius>]]`](#floodfill-replace_node-radius-floodfill)

### Terrain
 - [`//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`](#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-)
 - [`//layers [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`](#layers-node_name_1-layer_count_1-node_name_2-layer_count_2-)
 - [`//convolve <kernel> [<width>[,<height>]] [<sigma>]`](#convolve-kernel-widthheight-sigma)

### Statistics
 - [`//count`](#count)

### Extras
 - [`//multi <command_a> <command_b> ....`](#multi-command_a-command_b-command_c-)
 - [`//many <times> <command>`](#many-times-command) (coming soon in v1.9!)
 - [`//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`](#subdivide-size_x-size_y-size_z-cmd_name-args) **experimental**
 - [`//y`](#y)
 - [`//n`](#n)

### Tools
 - [WorldEditAdditions Far Wand](#far-wand)
 - [`//farwand skip_liquid (true|false) | maxdist <number>`](#farwand-skip_liquid-truefalse--maxdist-number)

## Detailed Explanations

### `//floodfill [<replace_node> [<radius>]]`
Floods all connected nodes of the same type starting at _pos1_ with <replace_node> (which defaults to `water_source`), in a sphere with a radius of <radius> (which defaults to 50).

```
//floodfill
//floodfill water_source 50
//floodfill glass 25
```

### `//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`
Places `<node_name_a>` in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with `<node_name_a>`. Optionally supports a mix of node names and chances, as `//mix` (WorldEdit) and `//replacemix` (WorldEditAdditions) does.

Will also work in caves, as it scans columns of nodes from top to bottom, skipping every non-air node until it finds one - and only then will it start searching for a node to place the target node on top of.

Note that all-air columns are skipped - so if you experience issues with it not overlaying correctly, try `//expand down 1` to add an extra node's space to your defined region.

Note also that columns without any air nodes in them at all are also skipped, so try `//expand y 1` to add an extra layer to your defined region.

```
//overlay grass
//overlay glass
//overlay grass_with_dirt
//overlay grass_with_dirt 10 dirt
//overlay grass_with_dirt 10 dirt 2 sand 1
//overlay sandstone dirt 2 sand 5
```

### `//layers [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`
Finds the first non-air node in each column and works downwards, replacing non-air nodes with a defined list of nodes in sequence. Like WorldEdit for Minecraft's `//naturalize` command, and also similar to [`we_env`'s `//populate`](https://github.com/sfan5/we_env). Speaking of, this command has `//naturalise` and `//naturalize` as aliases. Defaults to 1 layer of grass followed by 3 layers of dirt.

The list of nodes has a form similar to that of a chance list you might find in `//replacemix`, `//overlay`, or `//mix` - see the examples below. If the numberr of layers isn't specified, `1` is assumed (i.e. a single layer).

```
//layers dirt_with_grass dirt 3
//layers sand 5 sandstone 4 desert_stone 2
//layers brick stone 3
//layers cobble 2 dirt
```

### `//ellipsoid <rx> <ry> <rz> <node_name>`
Creates a solid ellipsoid at position 1 with the radius `(rx, ry, rz)`.

```
//ellipsoid 10 5 15 ice
//ellipsoid 3 5 10 dirt
//ellipsoid 20 10 40 air
```

### `//hollowellipsoid <rx> <ry> <rz> <node_name>`
Creates a hollow ellipsoid at position 1 with the radius `(rx, ry, rz)`. Works the same way as `//ellipsoid` does.

```
//hollowellipsoid 10 5 15 glass
//hollowellipsoid 21 11 41 stone
```

### `//torus <major_radius> <minor_radius> <node_name>`
Creates a solid torus at position 1 with the specified major and minor radii. The major radius is the distance from the centre of the torus to the centre of the circle bit, and the minor radius is the radius of the circle bit.

```
//torus 15 5 stone
//torus 5 3 meselamp
```

### `//hollowtorus <major_radius> <minor_radius> <node_name>`
Creates a hollow torus at position 1 with the radius major and minor radii. Works the same way as `//torus` does.

```
//hollowtorus 10 5 glass
//hollowtorus 21 11 stone
```

### `//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`
Generates a maze using replace_node as the walls and air as the paths. Uses [an algorithm of my own devising](https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html). It is guaranteed that you can get from every point to every other point in generated mazes, and there are no loops.

Requires the currently selected area to be at least 3x3x3.

The optional `path_length` and `path_width` arguments require additional explanation. When generating a maze, a multi-headed random walk is performed. When the generator decides to move forwards from a point, it does so `path_length` nodes at a time. `path_length` defaults to `2`.

`path_width` is easier to explain. It defaults to `1`, and is basically the number of nodes wide the path generated is.

Note that `path_width` must always be at least 1 less than the `path_length` in order to operate normally.

The last example below shows how to set the path length and width:

```
//maze ice
//maze stone 2 1 1234
//maze dirt 4 2 56789
```

### `//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`
Same as `//maze`, but adapted for 3d - has all the same properties. Note that currently there's no way to adjust the height of the passageways generated (you'll need to scale the generated maze afterwards).

Requires the currently selected area to be at least 3x3 on the x and z axes.

The optional `path_depth` parameter defaults to `1` and allows customisation of the height of the paths generated.

```
//maze3d glass
//maze3d bush_leaves 2 1 1 12345
//maze3d dirt 4 2 2
//maze3d stone 6 3 3 54321
```

### `//bonemeal [<strength> [<chance>]]`
Requires the [`bonemeal`](https://content.minetest.net/packages/TenPlus1/bonemeal/) ([repo](https://notabug.org/TenPlus1/bonemeal/)) mod (otherwise _WorldEditAdditions_ will not register this command and outut a message to the server log). Alias: `//flora`.

Bonemeals all eligible nodes in the current region. An eligible node is one that has an air node directly above it - note that just because a node is eligible doesn't mean to say that something will actually happen when the `bonemeal` mod bonemeals it.

Optionally takes a strength value (that's passed to `bonemeal:on_use()`, the method in the `bonemeal` mod that is called to actually do the bonemealing). The strength value is a positive integer from 1 to 4 (i.e. 1, 2, 3, or 4) - the default is 1 (the lowest strength).

I observe that a higher strength value gives a higher chance that something will actually grow. In the case of soil or sand nodes, I observe that it increases the area of effect of a single bonemeal action (thus at higher strengths generally you'll probably want a higher chance number - see below). See the [`bonemeal` mod README](https://notabug.org/TenPlus1/bonemeal) for more information.

Also optionally takes a chance number. This is the chance that an eligible node will actually get bonemealed, and is a positive integer that defaults to 1. The chance number represents a 1-in-{number} chance to bonemeal any given eligible node, where {number} is the chance number. In other words, the higher the chance number the lower the chance that a node will be bonemealed.

For example, a chance number of 2 would mean a 50% chance that any given eligible node will get bonemealed. A chance number of 16 would be a 6.25% chance, and a chance number of 25 would be 2%.

```
//bonemeal
//bonemeal 3 25
//bonemeal 4
//bonemeal 1 10
//bonemeal 2 15
```

### `//walls <replace_node>`
Creates vertical walls of `<replace_node>` around the inside edges of the defined region.

```
//walls dirt
//walls stone
//walls goldblock
```

### `//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ...`
Replaces a given node with a random mix of other nodes. Functions like `//mix`.

This command is best explained with examples:

```
//replacemix dirt stone
```

The above functions just like `//replace` - nothing special going on here. It replaces all `dirt` nodes with `stone`.

Let's make it more interesting:

```
//replacemix dirt 5 stone
```

The above replaces 1 in every 5 `dirt` nodes with `stone`. Let's get even fancier:

```
//replacemix stone stone_with_diamond stone_with_gold
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes. But wait - there's more!

```
//replacemix stone stone_with_diamond stone_with_gold 4
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes as before, but this time in the ratio 1:4 (i.e. for every `stone_with_diamond` node there will be 4 `stone_with_gold` nodes). Note that the `1` for `stone_with_diamond` is implicit there.

If we wanted to put all of the above features together into a single command, then we might do this:

```
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```

The above replaces 1 in 3 `dirt` nodes with a mix of `sandstone`, `dry_dirt`, and `cobble` nodes in the ratio 10:1:2. Awesome!

Here are all the above examples together:

```
//replacemix dirt stone
//replacemix dirt 5 stone
//replacemix stone stone_with_diamond stone_with_gold
//replacemix stone stone_with_diamond stone_with_gold 4
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```

### `//convolve <kernel> [<width>[,<height>]] [<sigma>]`
Advanced version of `//smooth` from we_env, and one of the few WorldEditAdditions commands to have any aliases (`//smoothadv` and `//conv`).

Extracts a heightmap from the defined region and then proceeds to [convolve](https://en.wikipedia.org/wiki/Kernel_(image_processing)) over it with the specified kernel. The kernel can be thought of as the filter that will be applied to the heightmap. Once done, the newly convolved heightmap is applied to the terrain. 

Possible kernels:

Kernel			| Description
----------------|------------------------------
[`box`](https://en.wikipedia.org/wiki/Box_blur)		| A simple uniform box blur.
`pascal`		| A kernel derived from the odd layers of [Pascal's Triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle). Slightly less smooth than a Gaussian blur.
[`gaussian`](https://en.wikipedia.org/wiki/Gaussian_blur)	| The default. A Gaussian blur - should give the smoothest result, and also the most customisable - see below.

If you can think of any other convolutional filters that would be useful, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new). The code backing this command is very powerful and flexible, so adding additional convolutional filters should be pretty trivial.

The width and height (if specified) refer to the dimensions of the kernel and must be odd integers and are separated by a single comma (and _no_ space). If the height is not specified, it defaults to the width. If using the `gaussian` kernel, the width and height must be identical. Larger kernels are slower, but produce a more smoothed effect and take more nearby nodes into account for every column. Defaults to a 5x5 kernel.

The sigma value is only applicable to the `gaussian` kernel, and can be thought of as the 'smoothness' to apply. Greater values result in more smoothing. Default: 2. See the [Gaussian blur](https://en.wikipedia.org/wiki/Gaussian_blur) page on Wikipedia for some pictures showing the effect of the sigma value.

```
//convolve
//convolve box 7
//convolve pascal 11,3
//convolve gaussian 7
//convolve gaussian 9 10
//convolve gaussian 5 0.2
```

### `//count`
Counts all the nodes in the defined region and returns the result along with calculated percentages (note that if the chat window used a monospace font, the returned result would be a perfect table. If someone has a ~~hack~~ solution to make the columns line up neatly, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) :D)

```
//count
```

### `//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`
Splits the current WorldEdit region into `(<size_x>, <size_y>, <size_z>)` sized chunks, and run `//<cmd_name> <args>` over each chunk. 

Sometimes, we want to run a single command on a truly vast area. Usually, this results in running out of memory. If this was you, then this command is just what you need! It should be able to handle any sized region - the only limit is your patience for command to complete.....

Note that this command only works with WorldEdit commands, and only those which require 2 points (e.g. `//torus` only requires a single point, so it wouldn't work very well - but `//set` or `//clearcut` would).

Note also that `<cmd_name>` should _not_ be prefixed with _any_ forward  slashes - see the examples below.

**Warning:** Once started, this command cannot be stopped without restarting your server! This is the case with all WorldEdit commands, but it's worth a special mention here.

```
//subdivide 10 10 10 set dirt
//subdivice 25 25 25 fixlight
```

### `//multi <command_a> <command_b> <command_c> .....`
Executes multi chat commands in sequence. Intended for _WorldEdit_ commands, but does work with others too. Don't forget a space between commands!

```
//multi //1 //2 //shift z -10 //sphere 5 sand //shift z 20 //ellipsoid 5 3 5 ice
//multi //1 //hollowtorus 30 5 stone //hollowtorus 20 3 dirt //torus 10 2 dirt_with_grass
//multi /time 7:00 //1 //outset h 20 //outset v 5 //overlay dirt_with_grass //1 //2 //sphere 8 air //shift down 1 //floodfill //reset
```

### `//many <times> <command>`
Executes a single chat command many times in a row. Uses `minetest.after()` to yield to the main server thread to allow other things to happen at the same time, so technically you could have multiple `//many` calls going at once (but multithreading support is out of reach, so only a single one will be executing at the same time).

Note that this isn't necessarily limited to executing WorldEdit / WorldEditAdditions commands. Combine with `//multi` (see above) execute multiple commands at once for even more power and flexibility!

```
//many 10 //bonemeal 3 100
//many 100 //multi //1 //2 //outset 20 //set dirt
```


### `//y`
Confirms the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```
//y
```

### `//n`
Prevents the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```
//n
```


### Far Wand
The far wand (`worldeditadditions:farwand`) is a variant on the traditional WorldEdit wand (`worldedit:wand`). It looks like this: ![A picture of the far wand](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/worldeditadditions_farwand/textures/worldeditadditions_farwand.png)

It functions very similarly to the regular WorldEdit wand, except that it has a _much_ longer range - which can be very useful for working on large-scale terrain for example. It also comes with an associated command to control it.

### `//farwand skip_liquid (true|false) | maxdist <number>`
This command helps control the behaviour of the [WorldEditAdditions far wand](#far-wand). Calling it without any arguments shows the current status:

```
//farwand
```

You can decide whether you can select liquids or not like so:

```
//farwand skip_liquid true
//farwand skip_liquid false
```

You can change the maximum range with the `maxdist` subcommand:

```
//farwand maxdist 1000
//farwand maxdist 200
//farwand maxdist 9999
```

Note that the number there isn't in blocks (because hard maths). It is however proportional to the distance the wand will raycast looks for nodes, so a higher value will result in it raycasting further.


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
