# Minetest-WorldEditAdditions
> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

![Screenshot](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/screenshot.png)

## Current commands:
**Quick Reference:**

 - [`//floodfill [<replace_node> [<radius>]]`](#floodfill-replace_node-radius-floodfill)
 - [`//overlay <node_name>`](#overlay-node_name)
 - [`//ellipsoid <rx> <ry> <rz> <node_name>`](#ellipsoid-rx-ry-rz-node_name)
 - [`//hollowellipsoid <rx> <ry> <rz> <node_name>`](#hollowellipsoid-rx-ry-rz-node_name)
 - [`//torus <major_radius> <minor_radius> <node_name>`](#torus-major_radius-minor_radius-node_name)
 - [`//hollowtorus <major_radius> <minor_radius> <node_name>`](#hollowtorus-major_radius-minor_radius-node_name)
 - [`//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`](#maze-replace_node-seed)
 - [`//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`](#maze3d-replace_node-seed)
 - [`//bonemeal [<strength> [<chance>]]`](#bonemeal-strength-chance)
 - [`//walls <replace_node>`](#walls-replace_node)
 - [`//count`](#count)
 - [`//multi <command_a> <command_b> .....`](#multi-command_a-command_b-command_c-)
 - [`//y`](#y)
 - [`//n`](#n)

### `//floodfill [<replace_node> [<radius>]]`
Floods all connected nodes of the same type starting at _pos1_ with <replace_node> (which defaults to `water_source`), in a sphere with a radius of <radius> (which defaults to 50).

```
//floodfill
//floodfill water_source 50
//floodfill glass 25
```

### `//overlay <node_name>`
Places <replace_node> in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with <replace_node>.

Will also work in caves, as it scans columns of nodes from top to bottom, skipping every non-air node until it finds one - and only then will it start searching for a node to place the target node on top of.

Note that all-air columns are skipped - so if you experience issues with it not overlaying correctly, try `//expand down 1` to add an extra node's space to your defined region.

```
//overlay grass
//overlay glass
//overlay grass_with_dirt
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
Requires the [`bonemeal`](https://content.minetest.net/packages/TenPlus1/bonemeal/) ([repo](https://notabug.org/TenPlus1/bonemeal/)) mod (otherwise _WorldEditAdditions_ will not register this command and outut a message to the server log).

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

### `//count`
Counts all the nodes in the defined region and returns the result along with calculated percentages (note that if the chat window used a monospace font, the returned result would be a perfect table. If someone has a ~~hack~~ solution to make the columns line up neatly, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) :D)

```
//count
```

### `//multi <command_a> <command_b> <command_c> .....`
Executes multi chat commands in sequence. Intended for _WorldEdit_ commands, but does work with others too. Don't forget a space between commands!

```
//multi //1 //2 //shift z -10 //sphere 5 sand //shift z 20 //ellipsoid 5 3 5 ice
//multi //1 //hollowtorus 30 5 stone //hollowtorus 20 3 dirt //torus 10 2 dirt_with_grass
//multi /time 7:00 //1 //outset h 20 //outset v 5 //overlay dirt_with_grass //1 //2 //sphere 8 air //shift down 1 //floodfill //reset
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

## Troubleshooting
If you're experiencing issues with this mod, try checking this FAQ before opening an issue.

### I get an error saying that worldedit isn't installed
WorldEditAdditions requires that the `worldedit` mod is installed as a dependency. Install it and then try launching Minetest (or the `minetest-server`) again.

### I get an error saying that `worldedit.register_command()` is not a function
This is probably because your version of `worldedit` is too old. Try updating it. Specifically the `worldedit.register_command()` function was only added to `worldedit` in December 2019.


## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc.

## WorldEditAdditions around the web
Are you using WorldEditAdditions for a project? Open an issue and I'll add your project to the below list!

 - _(None that I'm aware of yet!)_

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.

If WorldEditAdditions has helped you out in a project, please consider adding a little sign in a corner of your project saying so :-)
