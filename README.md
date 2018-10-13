# Minetest-WorldEditAdditions
> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

## Current commands:
**Quick Reference:**

 - `//floodfill [<replace_node> [<radius>]]`
 - `//overlay <node_name>`
 - `//ellipsoid <rx> <ry> <rz> <node_name>`
 - `//hollowellipsoid <rx> <ry> <rz> <node_name>`
 - `//torus <major_radius> <minor_radius> <node_name>`
 - `//hollowtorus <major_radius> <minor_radius> <node_name>`
 - `//multi <command_a> <command_b> .....`

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
Creates a hollow torus at position 1 with the radius `(rx, ry, rz)`. Works the same way as `//torus` does.

```
//hollowtorus 10 5 15 glass
//hollowtorus 21 11 41 stone
```

## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc.

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.
