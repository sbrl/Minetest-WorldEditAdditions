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
 - [`//maze <replace_node> [<seed>]`](#maze-replace_node-seed)
 - [`//multi <command_a> <command_b> .....`](#multi-command_a-command_b-command_c-)
 - [`//yy`](#yy)
 - [`//nn`](#nn)

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

### `//maze <replace_node> [<seed>]`
Generates a maze using replace_node as the walls and air as the paths. Uses [an algorithm of my own devising](https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html). It is guaranteed that you can get from every point to every other point in generated mazes, and there are no loops.

A seed can optionally be provided, which will cause the same maze to be generated every time (otherwise `os.time()` is used to dynamically set the seed).

```
//maze ice
//maze stone 1234
```

### `//multi <command_a> <command_b> <command_c> .....`
Executes multi chat commands in sequence. Intended for _WorldEdit_ commands, but does work with others too. Don't forget a space between commands!

```
//multi //1 //2 //shift z -10 //sphere 5 sand //shift z 20 //ellipsoid 5 3 5 ice
//multi //1 //hollowtorus 30 5 stone //hollowtorus 20 3 dirt //torus 10 2 dirt_with_grass
//multi /time 7:00 //1 //outset h 20 //outset v 5 //overlay dirt_with_grass //1 //sphere 8 air //shift down 1 //floodfill //reset
```

### `//yy`
Confirms the execution of a command if it could potentially affect a large number of nodes and take a while. Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command.

```
//yy
```

### `//nn`
Prevents the execution of a command if it could potentially affect a large number of nodes and take a while. Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command.

```
//nn
```

## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc.

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.
