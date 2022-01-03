# Chat Command Reference

This is the full chat command reference for WorldEditAdditions. Having trouble finding the section you want? Try the **[quick reference](https://github.com/sbrl/Minetest-WorldEditAdditions#quick-command-reference)** instead, which has links to back to sections of this document!

**Check out the reference on the new website - it's even searchable: <https://worldeditadditions.mooncarrot.space/Reference/>**

Other useful links:

 - [WorldEditAdditions quick reference](https://github.com/sbrl/Minetest-WorldEditAdditions#quick-command-reference)
 - [WorldEditAdditions Chat Command Cookbook](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/Cookbook.md)
 - [WorldEdit Chat Command Reference](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md)
 - [`we_env`](https://github.com/sfan5/we_env#readme)

**Note:** If anything in this reference isn't clear, that's a bug. Please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) (or even better a PR improving it) to let me know precisely which bit you don't understand and why.

## Geometry
<!--
 ██████  ███████  ██████  ███    ███ ███████ ████████ ██████  ██    ██
██       ██      ██    ██ ████  ████ ██         ██    ██   ██  ██  ██
██   ███ █████   ██    ██ ██ ████ ██ █████      ██    ██████    ████
██    ██ ██      ██    ██ ██  ██  ██ ██         ██    ██   ██    ██
 ██████  ███████  ██████  ██      ██ ███████    ██    ██   ██    ██
-->


### `//ellipsoid <rx> <ry> <rz> <node_name> [h[ollow]]`
Creates a solid ellipsoid at position 1 with the radius `(rx, ry, rz)`.

```weacmd
//ellipsoid 10 5 15 ice
//ellipsoid 3 5 10 dirt
//ellipsoid 20 10 40 air
//ellipsoid 14 5 8 steelblock h
//ellipsoid 7 4 7 papyrus hollow
```

### `//hollowellipsoid <rx> <ry> <rz> <node_name>`
Creates a hollow ellipsoid at position 1 with the radius `(rx, ry, rz)`. Works the same way as `//ellipsoid` does.

```weacmd
//hollowellipsoid 10 5 15 glass
//hollowellipsoid 21 11 41 stone
```

### `//ellipsoid2 [<node_name:dirt> [h[ollow]]]`
Creates an (optionally hollow) solid ellipsoid that fills the defined region.

```weacmd
//ellipsoid2
//ellipsoid2 ice
//ellipsoid2 air
//ellipsoid2 steelblock h
//ellipsoid2 papyrus hollow
```


### `//torus <major_radius> <minor_radius> <node_name> [<axes=xy> [h[ollow]]]`
Creates a solid torus at position 1 with the specified major and minor radii. The major radius is the distance from the centre of the torus to the centre of the circle bit, and the minor radius is the radius of the circle bit.

The optional axes sets the axes upon which the torus will lay flat. Possible values: `xy` (the default), `xz`, `yz`. A single axis may also be specified (i.e. `x`, `y`, or `z`) - this will be interpreted as the axis that runs through the hole in the middle of the torus.

```weacmd
//torus 15 5 stone
//torus 5 3 meselamp
//torus 10 6 sandstone xz
//torus 10 6 wool:red y
//torus 25 10 dirt xz hollow
```

### `//hollowtorus <major_radius> <minor_radius> <node_name> [<axes=xy>]`
Creates a hollow torus at position 1 with the radius major and minor radii. Works the same way as `//torus` does.

```weacmd
//hollowtorus 10 5 glass
//hollowtorus 21 11 stone
//hollowtorus 18 6 dirt xz
```

### `//line [<replace_node> [<radius>]]`
Draw a line from position 1 to position 2, optionally with a given thickness.

The radius can be thought of as the thickness of the line, and is defined as the distance from a given node to an imaginary line from pos1 to pos2. Defaults to drawing with dirt and a radius of 1.

Floating-point values are fully supported for the radius.

```weacmd
//line
//line stone
//line sandstone 3
//line glass 0.5
```

### `//hollow [<wall_thickness>]`
Replaces nodes inside the defined region with air, but leaving a given number of nodes near the outermost edges alone. In other words, it makes the defined region hollow, while leaving walls around the edges of a given thickness (defaulting to a wall thickness of 1).

Note that all air-like nodes are also left alone.

```weacmd
//hollow
//hollow 2
```

### `//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`
Generates a maze using replace_node as the walls and air as the paths. Uses [an algorithm of my own devising](https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html) (see also [this post of mine that has lots of eye candy :D](https://starbeamrainbowlabs.com/blog/article.php?article=posts/429-lua-blender-mazes.html)). It is guaranteed that you can get from every point to every other point in generated mazes, and there are no loops.

Requires the currently selected area to be at least 3x3 on the x and z axes respectively.

The optional `path_length` and `path_width` arguments require additional explanation. When generating a maze, a multi-headed random walk is performed. When the generator decides to move forwards from a point, it does so `path_length` nodes at a time. `path_length` defaults to `2`.

`path_width` is easier to explain. It defaults to `1`, and is basically the number of nodes wide the path generated is.

Note that `path_width` must always be at least 1 less than the `path_length` in order to operate normally.

Note also that since WorldEditAdditions v1.10, the seed doesn't have to be a number (but it can't contain spaces due to the parsing algorithm used). Non-numbers are hashed to a number using a simple (non-crypto-safe) hashing algorithm.

The last example below shows how to set the path length and width:

```weacmd
//maze ice
//maze stone 2 1 1234
//maze dirt 4 2 56789
//maze glass 2 1 minetestiscool
```


### `//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`
Same as `//maze`, but instead generates mazes in 3 dimensions instead of 2. Requires the currently selected area to be at least 3x3x3.

The optional `path_depth` parameter defaults to `1` and allows customisation of the height of the paths generated.

To get a better look at the generated maze, try inverting it like so:

```weacmd
//maze3d stone
//replace air dirt
//replace stone air
```

Additional examples:

```weacmd
//maze3d glass
//maze3d bush_leaves 2 1 1 12345
//maze3d dirt 4 2 2
//maze3d stone 6 3 3 54321
```


### `//walls [<replace_node=dirt> [<thickness=1>]]`
Creates vertical walls of `<replace_node>` around the inside edges of the defined region, optionally specifying the thickness thereof. Defaults to a replace node of `dirt` and a wall thickness of 1.

```weacmd
//walls
//walls dirt
//walls stone
//walls goldblock
//walls sandstone 2
//walls glass 4
```


### `//spiral2 [<circle|square>] [<replace_node=dirt> [<interval=3> [<acceleration=0>] ] ]`
Generates both square and circular spiral shapes with the given `<replace_node>` - defaulting to square spirals. The interval defines the gap between the spiral in nodes, and the acceleration defines by how much the interval should be increased (a value of 1 means 1 node per revolution).

```
//spiral2
//spiral2 circle stone
//spiral2 square
//spiral2 circle
//spiral2 glass 5
//spiral2 square desert_sand 3 1
```



## Misc
<!--
███    ███ ██ ███████  ██████
████  ████ ██ ██      ██
██ ████ ██ ██ ███████ ██
██  ██  ██ ██      ██ ██
██      ██ ██ ███████  ██████
-->


### `//floodfill [<replace_node> [<radius>]]`
Floods all connected nodes of the same type starting at _pos1_ with `<replace_node>` (which defaults to `water_source`), in a sphere with a radius of `<radius>` (which defaults to 50).

```weacmd
//floodfill
//floodfill water_source 50
//floodfill glass 25
```


### `//wbox <replace_node>`
Sets the edges of the current selection to `<replace_node>`to create an outline of a rectangular prism. Useful for roughing in walls.

```weacmd
//wbox silver_sandstone
//wbox dirt
```

### `//wcompass <replace_node> [<bead_node>]`
Creates a compass around pos1 with a single node bead pointing north (+Z).

```weacmd
//wcompass meselamp
//wcompass desert_cobble torch
//wcompass gold diamond
```

### `//wcorner <replace_node>`
Set the corners of the current selection to `<replace_node>`. Useful for outlining building sites and setting boundaries.

```weacmd
//wcorner glass
//wcorner stone_with_iron
```

### `//scale <axis> <scale_factor> | <factor_x> [<factor_y> <factor_z> [<anchor_x> <anchor_y> <anchor_z>`
Advanced version of [`//stretch` from WorldEdit](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md#stretch-stretchx-stretchy-stretchz) that can scale both up and down at the same time by transparently splitting it into 2 different operations. Scaling up is *always* done before scaling down.

Although the syntax looks complicated, it's really quite simple. The key concept to understand is that of the scale factor. It refers to how much the defined region should be scaled up or down by, and can be specified in multiple different ways:

Scale Factor    | Meaning
----------------|---------------------
1               | Don't scale at all.
0.5             | Scale down by 50%
2               | Scale up by 2x, doubling the size
5               | Scale up by 5x, quintupling the size
20%             | Scale down to 30% of the original size
1/3             | Scale down to 1 third of original size

In short, you can specify the scale factor directly, as a percentage, or as 1 number divided by another number.

**Note:** `//scale` always scales in the _positive direction_ by default. This can be changed however - see below.

With this in mind, there are 3 forms that you can tell `//scale` how you want to scale the defined region:

#### Single Axis
If you just need to scale a single axis, you can tell `//scale` that like so:

```weacmd
//scale <axis> <scale_factor>
```

To give a concrete example:

```weacmd
//scale y 2
```

The above will scale the defined region in the positive y direction by 2 times, doubling the height. If you want to scale in the opposite direction, do this:

```weacmd
//scale -y 2
```

This will scale in the _negative_ y direction by 2 times (again, doubling the height). Some more examples:

```weacmd
//scale z 50%
//scale -x 1/3
```

#### All axes
To scale on all axes at once, `//scale` takes the shortcut syntax of specifying a single scale factor:

```weacmd
//scale 2
//scale 200%
```

Both of the above will scale the defined region up by 2 times in all directions.

#### Multiple scale factors
If you want to specify different scale factors for difference axes, then `//scale` also supports a third syntax. Here's an example:

```weacmd
//scale 2 3 4
```

This will scale the defined region by 2x in the positive x, 3x in the positive y, and 4x in the positive z. As these are all scale factors, we can also use the syntax described above to scale up and down in the same operation:

```weacmd
//scale 50% 2 1/4
```

This will first scale in the positive y by 2x. Once that operation is completed, it will scale down to 50% size in the positive x and down to 25% size in the positive z. Note that if you want to scale down first and then scale up, you'll need to execute 2 separate commands.

If you want to change the anchor point of the scaling operation too, `//scale` supports a final syntax like so:

```weacmd
//scale 50% 2 1/4 1 -1 1
```

By adding 3 extra numbers for the x, y, and z axes respectively, we can control the direction `//scale` performs the scaling operation. A value of 1 or greater indicates the positive direction of the axis, and a value of -1 or less indicates the negative direction of the axis. I recommend by [worldedit_hud_helper](https://content.minetest.net/packages/Starbeamrainbowlabs/worldedit_hud_helper/) mod for easily determining which direction is which.

So in the above example, we scale in the positive x and z directions, and the negative y direction.


### `//copy+ <axis:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> <count> [<axis> <count> [...]]`
Fully backwards-compatible with `//copy` from regular WorldEdit, but allows you to specify multiple axes at once in a single copy operation. Each successive axis in the list is specified in the form `<axis> <count>`, where:

 - `<axis>` is the name of the axis to move the defined region along
 - `<count>` is the number of nodes along the defined axis to move

All of the following values are valid axes:

 - `x`
 - `y`
 - `z`
 - `-x`
 - `-y`
 - `-z`
 - `?` / `front` / `f`
 - `back` / `b`
 - `left` / `l`
 - `right` / `r`
 - `up` / `u`
 - `down` / `d`

Additionally all the absolute axis names (`x`/`y`/`z`/`-x`/`-y`/`-z`) may also be specified multiple times under the same count - e.g. `xy-z 6`.

```
//copy+ x 6
//copy+ y 10 z 4
//copy+ front 6 left 5
//copy+ ? 10 r 25 y 50
//copy+ xz 50 front 22
//copy+ yx 25
//copy+ -xz-y 10
```


### `//move+ <axis:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> <count> [<axis> <count> [...]]`
Identical to [`//copy+`](#copy), but instead moves the defined region instead of copying it.

```
//move+ x 6
//move+ y 10 z 4
//move+ front 6 left 5
//move+ ? 10 r 25 y 50
//move+ xz 50 front 22
//move+ yx 25
//move+ -xz-y 10
```


### `//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ...`
Replaces a given node with a random mix of other nodes. Functions like `//mix`.

This command is best explained with examples:

```weacmd
//replacemix dirt stone
```

The above functions just like `//replace` - nothing special going on here. It replaces all `dirt` nodes with `stone`.

Let's make it more interesting:

```weacmd
//replacemix dirt 5 stone
```

The above replaces 1 in every 5 `dirt` nodes with `stone`. Let's get even fancier:

```weacmd
//replacemix stone stone_with_diamond stone_with_gold
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes. But wait - there's more!

```weacmd
//replacemix stone stone_with_diamond stone_with_gold 4
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes as before, but this time in the ratio 1:4 (i.e. for every `stone_with_diamond` node there will be 4 `stone_with_gold` nodes). Note that the `1` for `stone_with_diamond` is implicit there.

If we wanted to put all of the above features together into a single command, then we might do this:

```weacmd
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```

The above replaces 1 in 3 `dirt` nodes with a mix of `sandstone`, `dry_dirt`, and `cobble` nodes in the ratio 10:1:2. Awesome!

Since WorldEditAdditions v1.12, you can also use percentages:

```weacmd
//replacemix dirt 33% sandstone 75% dry_dirt 10% cobble 15%
```

Note though that the percentages are internally converted to a 1-in-N chance and rounded down.

Here are all the above examples together:

```weacmd
//replacemix dirt stone
//replacemix dirt 5 stone
//replacemix stone stone_with_diamond stone_with_gold
//replacemix stone stone_with_diamond stone_with_gold 4
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```



## Terrain
<!--
████████ ███████ ██████  ██████   █████  ██ ███    ██
   ██    ██      ██   ██ ██   ██ ██   ██ ██ ████   ██
   ██    █████   ██████  ██████  ███████ ██ ██ ██  ██
   ██    ██      ██   ██ ██   ██ ██   ██ ██ ██  ██ ██
   ██    ███████ ██   ██ ██   ██ ██   ██ ██ ██   ████
-->


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

```weacmd
//convolve
//convolve box 7
//convolve pascal 11,3
//convolve gaussian 7
//convolve gaussian 9 10
//convolve gaussian 5 0.2
```


### `//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`
Places `<node_name_a>` in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with `<node_name_a>`. Optionally supports a mix of node names and chances, as `//mix` (WorldEdit) and `//replacemix` (WorldEditAdditions) does.

Will also work in caves, as it scans columns of nodes from top to bottom, skipping every non-air node until it finds one - and only then will it start searching for a node to place the target node on top of.

Note that all-air columns are skipped - so if you experience issues with it not overlaying correctly, try `//expand down 1` to add an extra node's space to your defined region.

Note also that columns without any air nodes in them at all are also skipped, so try `//expand y 1` to add an extra layer to your defined region.

```weacmd
//overlay grass
//overlay glass
//overlay grass_with_dirt
//overlay grass_with_dirt 10 dirt
//overlay grass_with_dirt 10 dirt 2 sand 1
//overlay sandstone dirt 2 sand 5
//overlay dirt 90% stone 10%
```


### `//fillcaves [<node_name>]`
Fills in all airlike nodes beneath non airlike nodes, which gives the effect of filling in caves. Defaults to filling in with stone, but this can be customised.

Note that the *entire* cave you want filling must be selected, as `//fillcaves` only operates within the defined region (ref #50).

```weacmd
//fillcaves
//fillcaves dirt
//fillcaves brick
```



### `//layers [<max_slope|min_slope..max_slope>] [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`
Finds the first non-air node in each column and works downwards, replacing non-air nodes with a defined list of nodes in sequence. Like WorldEdit for Minecraft's `//naturalize` command, and also similar to [`we_env`'s `//populate`](https://github.com/sfan5/we_env). Speaking of, this command has `//naturalise` and `//naturalize` as aliases. Defaults to 1 layer of grass followed by 3 layers of dirt.

Since WorldEditAdditions v1.13, a maximum and minimum slope is optionally accepted, and constrains the columns in the defined region that `//layers` will operate on. For example, specifying a value of `20` would mean that only columns with a slop less than or equal to 20° (degrees, not radians) will be operated on. A value of `45..60` would mean that only columns with a slope between 45° and 60° will be operated on.

The list of nodes has a form similar to that of a chance list you might find in `//replacemix`, `//overlay`, or `//mix` - see the examples below. If the number of layers isn't specified, `1` is assumed (i.e. a single layer).


```weacmd
//layers dirt_with_grass dirt 3
//layers sand 5 sandstone 4 desert_stone 2
//layers brick stone 3
//layers cobble 2 dirt
//layers 45..60 dirt_with_snow dirt 2
//layers 30 snowblock dirt_with_snow dirt 2
```


### `//erode [<snowballs|river> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`
Runs an erosion algorithm over the defined region, optionally passing a number of key - value pairs representing parameters that are passed to the chosen algorithm. This command is **experimental**, as the author is currently on-the-fence about the effects it produces.

Works best if you run `//fillcaves` first, or otherwise have no air nodes below the top non-air node in each column.

Currently implemented algorithms:

Algorithm	| Mode	| Description
------------|-------|-------------------
`snowballs`	| 2D	| The default - based on [this blog post](https://jobtalle.com/simulating_hydraulic_erosion.html). Simulates snowballs rolling across the terrain, eroding & depositing material. Then runs a 3x3 gaussian kernel over the result (i.e. like the `//conv` / `//smoothadv` command).
`river`     | 2D    | Fills in potholes and lowers pillars using a cellular automata-like algorithm that analyses the height of neighouring columns.

Usage examples:

```weacmd
//erode
//erode snowballs
//erode snowballs count 25000
```

Each of the algorithms above have 1 or more parameters that they support. These are detailed below.

#### Algorithm: `snowballs`
Based on the algorithm detailed in [this blog post](https://jobtalle.com/simulating_hydraulic_erosion.html) ([direct link to the source code](https://github.com/jobtalle/HydraulicErosion/blob/master/js/archipelago/island/terrain/erosionHydraulic.js)), devised by [Job Talle](https://jobtalle.com/).

Parameter			| Type		| Default Value		| Description
--------------------|-----------|-------------------|--------------------------
rate_deposit		| `float`	| 0.03				| The rate at which snowballs will deposit material
rate_erosion		| `float`	| 0.04				| The rate at which snowballs will erode material
friction			| `float`	| 0.07				| More friction slows snowballs down more.
speed				| `float`	| 1					| Speed multiplier to apply to snowballs at each step.
max_steps			| `float`	| 80				| The maximum number of steps to simulate each snowball for.
velocity_hist_count	| `float`	| 3					| The number of previous history values to average when detecting whether a snowball has stopped or not
init_velocity		| `float`	| 0.25				| The maximum random initial velocity of a snowball for each component of the velocity vector.
scale_iterations	| `float`	| 0.04				| How much to scale erosion by as time goes on. Higher values mean that any given snowball will erode more later on as more steps pass.
maxdiff				| `float`	| 0.4				| The maximum difference in height (between 0 and 1) that is acceptable as a percentage of the defined region's height.
count				| `float`	| 25000				| The number of snowballs to simulate.
noconv				| any		| n/a				| When set to any value, disables to automatic 3x3 gaussian convolution.

Usage examples:

```weacmd
//erode
//erode snowballs
//erode snowballs count 50000
```

If you find any good combinations of these parameters, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) (or a PR!) and let me know! I'll include good combinations here, and possibly add a presets feature too.

#### Algorithm: `river`
Ever been annoyed by small 1 wide holes or thin pillars all over the place? This command is for you! Does not operate on the very edge of the defined region, because the algorithm can't see the neighbours of those columns.

Parameter			| Type		| Default Value		| Description
--------------------|-----------|-------------------|--------------------------
steps				| `integer`	| 1					| The number of rounds or passes of the algorithm to run. Useful if you have a 1x3 hole for instance, it will take at least 2 steps to fill it in - and more if it's deeper than 1 node.
lower_sides			| `string`	| 4,3				| Comma separated list of numbers. Columns with this many sides lower than it will be lowered in height by 1 node.
raise_sides			| `string`	| 4,3				| Comma separated list of numbers. Columns with this many sides higher than it will be raised in height by 1 node.
doraise				| `boolean`	| true				| Whether to raise columns in height. If false, then no columns will be raised in height even if they are eligible to be so according to `raise_sides`.
dolower				| `boolean`	| true				| Whether to lower columns in height. If false, then no columns will be lowered in height even if they are eligible to be so according to `lower_sides`.

Usage examples:

```weacmd
//erode river
//erode river steps 10
```


### `//noise2d [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`
Applies 2D noise to the terrain in the defined region. Like `//erode`, this command accepts a number of different key-value parameters and provides a number of different underlying algorithms.

Parameter	| Type		| Default Value	| Description
------------|-----------|---------------|-----------------------
algorithm	| `string`	| perlinmt		| The 2D noise algorithm to apply - see below.
apply		| `string|integer` | 5		| How to apply the noise to the terrain - see below.
scalex		| `float`	| 1				| The scale of the noise on the x axis.
scaley		| `float`	| 1				| The scale of the noise on the y axis.
scalez		| `float`	| 1				| The scale of the noise on the z axis.
offsetx		| `float`	| 1				| The offset to add to the x axis before calling the noise function.
offsety		| `float`	| 0				| The offset to add to the y axis before calling the noise function.
offsetz		| `float`	| 0				| The offset to add to the z axis before calling the noise function.
exponent	| `float`	| 0				| Raise the generated noise value (with a range of 0 to 1) to this power. Generally results in sharper peaks.
multiply	| `float`	| 1				| Multiply the generated noise value by this number
add			| `float`	| 0				| Add this number to the generated noise value.


Different values of the `apply` parameter result in the generated noise values being applied in different ways:

 - An integer indicates that the noise should be rescaled to a given amplitude (equal parts of the range above and below 0) before being added to the terrain heightmap.`
 - The exact string `add`: Noise values are added to each heightmap pixel.
 - The exact string `multiply`: Each heightmap pixel is multiplied by the corresponding noise value.

The following algorithms are currently available:

Algorithm	| Description
------------|--------------------------
`perlinmt`  | **Default**.Perlin noise, backed by Minetest's inbuilt `PerlinNoise` class.
`perlin`	| Perlin noise, backed by a pure Lua perlin noise implementation. Functional, but currently contains artefacts I'm having difficulty tracking down.
`sin`		| A sine wave created with `math.sin()`.
`white`		| Random white noise.
`red`		| Red noise - has a lower frequency than white noise. Ref [Noise Functions and Map Generation by Red Blob Games](https://www.redblobgames.com/articles/noise/introduction.html).
`infrared`	| Even smoother than red noise. Tends to also be quite flat unless you use a slightly higher `apply` value (e.g. `20`).

When specifying algorithm names, the `algorithm` parameter name is optional. For example, the following are both equivalent:

```weacmd
//noise2d offsetx 4 perlin scale 0.2
//noise2d offsetx 4 algorithm perlin scale 0.2
```

Example invocations:

```weacmd
//noise2d sin scale 0.5
//noise2d offsetx 20 perlin
//noise2d sin exponent 4
```


### `//sculptlist [preview]`
Lists all the available sculpting brushes for use with `//sculpt`. If the `preview` keyword is specified as an argument, then the brushes are also rendered in ASCII as a preview. See [`//sculpt`](#sculpt).

```
//sculptlist
//sculptlist preview
```


### `//sculpt [<brush_name=default> [<height=5> [<brush_size=10>]]]`
Applies a specified brush to the terrain at position 1 with a given height and a given size. Multiple brushes exist (see [`//sculptlist`](#sculptlist)) - and are represented as a 2D grid of values between 0 and 1, which are  then scaled to the specified height. The terrain around position 1 is first converted to a 2D heightmap (as in [`//convolve`](#convolve) before the brush "heightmap" is applied to it.

Similar to [`//sphere`](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md#sphere-radius-node), [`//cubeapply 10 set`](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md#cubeapply-sizesizex-sizey-sizez-command-parameters), or [`//cylinder y 5 10 10 dirt`](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md#cylinder-xyz-length-radius1-radius2-node) (all from [WorldEdit](https://content.minetest.net/packages/sfan5/worldedit/)), but has a number of added advantages:

 - No accidental overhangs
 - Multiple custom brushes (see below on how you can add your own!)

A negative height value causes the terrain to be lowered by the specified number of nodes instead of raised.

While sculpting brushes cannot yet be rotated, this is a known issue. Rotating sculpting brushes will be implemented in a future version of WorldEditAdditions.

The selection of available brushes is limited at the moment, but see below on how to easily create your own!

```
//sculpt
//sculpt default 10 25
//sculpt ellipse
//sculpt circle 5 50
```

#### Create your own brushes
2 types of brush exist:

1. Dynamic (lua-generated) brushes
2. Static brushes

All brushes are located in `worldeditadditions/lib/sculpt/brushes` (relative to the root of WorldEditAdditions' installation directory).

Lua-generated brushes are not the focus here, but are a file with the extension `.lua` and return a function that returns a brush - see other existing Lua-generated brushes for examples (and don't forget to update `worldeditadditions/lib/sculpt/.init.lua`).

Static brushes on the other hand are simply a list of tab-separated values arranged in a grid. For example, here is a simple brush:

```tsv
0   1   0
1   2   1
0   1   0
```

Values are automatically rescaled to be between 0 and 1 based on the minimum and maximum values, so don't worry about which numbers to use. Static brushes are saved with the file extension `.brush.tsv` in the aforementioned directory, and are automatically rescanned when your Minetest server starts. While they can't be rescaled automatically to fix a target size (without creating multiple variants of a brush manually of course, though this may be implemented in the future), static brushes are much easier to create than dynamic brushes.

To assist with the creation of static brushes, a tool exists to convert any image to a static brush:

<https://worldeditadditions.mooncarrot.space/img2brush/>

The tool operates on the **alpha channel only**, so it's recommended to use an image format that supports transparency. All colours in the R, G, and B channels are ignored.

If you've created a cool new brush (be it static or dynamic), **please contribute it to WorldEditAdditions**! That way, everyone can enjoy using your awesome brush. [WorldPainter](https://www.worldpainter.net/) has many brushes available in the community, but `//sculpt` for WorldEditAdditions is new so don't have the same sized collection yet :-)

To contribute your new brush back, you can either [open a pull request](https://github.com/sbrl/Minetest-WorldEditAdditions/pulls) if you're confident using GitHub, or [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues) with your brush attached if not.



## Flora
<!--
███████ ██       ██████  ██████   █████
██      ██      ██    ██ ██   ██ ██   ██
█████   ██      ██    ██ ██████  ███████
██      ██      ██    ██ ██   ██ ██   ██
██      ███████  ██████  ██   ██ ██   ██
-->


### `//forest [<density>] <sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...`
Plants and grows saplings to generate a forest. A density value is optionally taken, which controls the overall density of the forest that is generated. The `bonemeal` mod is required - just like for the [`//bonemeal`](#bonemeal-strength-chance) command.

The density defaults to 1, acts like a multiplier, and is not affected by the chances of all saplings listed (e.g. you can have a sapling with a chance of 1-in-50, and the overall density of the forest will be unaffected). For example, 2 results in a forest twice as dense as the default, and 0.5 a forest half as dense as the default density.

The tree types are provided as a list of names and 1-in-N chances, just like [`//overlay`](#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-), `//mix`, `//layers`, etc. Unlike the aforementioned commands however, `//forest` has an additional layer of alias resolution to ease the process of determining what the name of the sapling is you want to use to generate forests with. See [`//saplingaliases`](#saplingaliases-aliasesall_saplings) for more details.

Saplings are placed with [`//overlay`](#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-) and grown using the same method that's used by the `//bonemeal` command. Up to 100 attempts are made to grow placed saplings. If all of those attempts fail (success is determined by whether the sapling is still present or not), the sapling is removed and the failure counter is incremented.

Currently, the following mods are known to have aliases registered:

 - `default`
 - [`moretrees`](https://content.minetest.net/packages/VanessaE/moretrees/) (warning: these saplings don't appear to work very well this command - assistance in debugging this would be very helpful)
 - [`cool_trees`](https://content.minetest.net/packages/runs/cool_trees/)

If you like, you can also reference the full name of a sapling node instead. The only requirements for saplings to be supported by this mod are:

1. It can be bonemealed
2. It has the `sapling` group

For example, the first 2 examples below are functionally equivalent.

```weacmd
//forest aspen
//forest default:aspen_sapling
//forest 2 oak 3 aspen pine
//forest 0.5 acacia
```


### `//saplingaliases [aliases|all_saplings]`
Lists all the currently registered sapling aliases in alphabetical order. These aliases can be used in the `//forest` subcommand.

Optionally takes a single parameter, which is the operating mode. Current implemented operating modes:

Mode			| Description
----------------|----------------------
`aliases`		| The default. Lists all the currently registered sapling aliases in alphabetical order.
`all_saplings`	| Spins through all the nodes currently registered in Minetest, and lists all the nodes that have the `sapling` group.

```weacmd
//saplingaliases
//saplingaliases all_saplings
//saplingaliases aliases
```



### `//bonemeal [<strength> [<chance> [<node_name> [<node_name> ...]]]]`
Requires the [`bonemeal`](https://content.minetest.net/packages/TenPlus1/bonemeal/) ([repo](https://notabug.org/TenPlus1/bonemeal/)) mod (otherwise _WorldEditAdditions_ will not register this command and output a message to the server log). Alias: `//flora`.

Bonemeals all eligible nodes in the current region. An eligible node is one that has an air node directly above it - note that just because a node is eligible doesn't mean to say that something will actually happen when the `bonemeal` mod bonemeals it.

Optionally takes a strength value (that's passed to `bonemeal:on_use()`, the method in the `bonemeal` mod that is called to actually do the bonemealing). The strength value is a positive integer from 1 to 4 (i.e. 1, 2, 3, or 4) - the default is 1 (the lowest strength).

I observe that a higher strength value gives a higher chance that something will actually grow. In the case of soil or sand nodes, I observe that it increases the area of effect of a single bonemeal action (thus at higher strengths generally you'll probably want a higher chance number - see below). See the [`bonemeal` mod README](https://notabug.org/TenPlus1/bonemeal) for more information.

Also optionally takes a chance number. This is the chance that an eligible node will actually get bonemealed, and is a positive integer that defaults to 1. The chance number represents a 1-in-{number} chance to bonemeal any given eligible node, where {number} is the chance number. In other words, the higher the chance number the lower the chance that a node will be bonemealed.

For example, a chance number of 2 would mean a 50% chance that any given eligible node will get bonemealed. A chance number of 16 would be a 6.25% chance, and a chance number of 25 would be 2%.

Since WorldEditAdditions v1.12, a percentage chance is also supported. This is denoted by suffixing a number with a percent sign (e.g. `//bonemeal 1 25%`).

Since WorldEditAdditions v1.13, a list of node names is also optionally supported. This will constrain bonemeal operations to be performed only on the node names listed.


```weacmd
//bonemeal
//bonemeal 3 25
//bonemeal 4
//bonemeal 1 10
//bonemeal 2 15
//bonemeal 2 10%
//bonemeal 2 10% dirt
//bonemeal 4 50 ethereal:grove_dirt
```



## Statistics
<!--
███████ ████████  █████  ████████ ██ ███████ ████████ ██  ██████ ███████
██         ██    ██   ██    ██    ██ ██         ██    ██ ██      ██
███████    ██    ███████    ██    ██ ███████    ██    ██ ██      ███████
     ██    ██    ██   ██    ██    ██      ██    ██    ██ ██           ██
███████    ██    ██   ██    ██    ██ ███████    ██    ██  ██████ ███████
-->


### `//count`
Counts all the nodes in the defined region and returns the result along with calculated percentages (note that if the chat window used a monospace font, the returned result would be a perfect table. If someone has a ~~hack~~ solution to make the columns line up neatly, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) :D)

**Note:** The output of `//count` can be rather long sometimes, and Minetest by default only shows the last few lines of chat. Press <kbd>F10</kbd> to show the full chat window that you can then scroll through to inspect the full output.

```weacmd
//count
```


### `//basename <name>`
Returns the absolute canonical name of a node, given an alias or partial node name. For example:

```weacmd
//basename dirt
```

...will return `default:dirt`. Uses `worldedit.normalize_nodename(string)` under the hood.

```weacmd
//basename stonebrick
//basename glass
```



## Selection
<!--
███████ ███████ ██      ███████  ██████ ████████ ██  ██████  ███    ██
██      ██      ██      ██      ██         ██    ██ ██    ██ ████   ██
███████ █████   ██      █████   ██         ██    ██ ██    ██ ██ ██  ██
     ██ ██      ██      ██      ██         ██    ██ ██    ██ ██  ██ ██
███████ ███████ ███████ ███████  ██████    ██    ██  ██████  ██   ████
-->




### `//scol [<axis1> ] <length>`
Short for _select column_. Sets the pos2 at a set distance along 1 axis from pos1. If the axis isn't specified, defaults the direction you are facing. Implementation thanks to @VorTechnix.

```weacmd
//scol 10
//scol x 3
```


### `//srect [<axis1> [<axis2>]] <length>`
Short for _select rectangle_. Sets the pos2 at a set distance along 2 axes from pos1. If the axes aren't specified, defaults to positive y and the direction you are facing. Implementation thanks to @VorTechnix.

```weacmd
//srect x z 10
//srect 3
//srect -z y 25
```


### `//scube [<axis1> [<axis2> [<axis3>]]] <length>`
Short for _select cube_. Sets the pos2 at a set distance along 3 axes from pos1. If the axes aren't specified, defaults to positive y, the direction you are facing and the axis to the left of facing. Implementation thanks to @VorTechnix.

```weacmd
//scube 5
//scube z a y 12
//scube x z 3
//scube -z 12
```


### `//scloud <0-6|stop|reset>`
Short for _select point cloud_. Sets pos1 and pos2 to include the nodes you punch. Numbers 1-6 designate how many nodes you want to punch before the operation ends. 0 or stop terminate the operation so that any further nodes you punch won't be added to selection. Reset terminates operation if one is running and resets the selection area.

```weacmd
//scloud 6
//scloud 5
//scloud stop
```


### `//scentre`
Short for _select center_. Sets pos1 and pos2 to the centre point(s) of the current selection area. 1, 2, 4 or 8 nodes may be selected depending on what parts of the original selection are even in distance. Implementation thanks to @VorTechnix.

```weacmd
//scentre
```

### `//srel <axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]`
Short for _select relative_. Sets the pos2 at set distances along 3 axes relative to pos1. If pos1 is not set it will default to the node directly under the player. The axis arguments accept `x, y, z` as well as `up, down, left, right, front, back`. Left, right, front and back are relative to player facing direction. Negative (`-`) can be applied to the axis, the length or both. Implementation thanks to @VorTechnix.

```weacmd
//srel front 5
//srel  y 12 right -2
//srel left 3 up 5 -front 7
//srel -z 12 -y -2 x -2
```

### `//sshift <axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]`
Short for _selection shift_. Shifts the WorldEdit region along 3 axes. The axis arguments accept `x, y, z` as well as `up, down, left, right, front, back`. Left, right, front and back are relative to player facing direction. Negative (`-`) can be applied to the axis, the length or both. Implementation thanks to @VorTechnix.

```weacmd
//sshift back 4
//sshift right -2 up 2
//sshift -left 2 z -7 -y -4
//sshift -z 12 -y -2 x -2
```

### `//smake <operation:odd|even|equal> <mode:grow|shrink|average> [<target=xz> [<base>]]`
Short for _selection make_. Modifies existing selection by moving pos2. Allows you to make the selection an odd or even length on one or more axes or set two or more axes equal to each other or the longest, shortest or average of them. Implementation thanks to @VorTechnix.

Usage examples:

```weacmd
//smake odd shrink
//smake even avg xz
//smake equal grow xy
//smake equal average
//smake equal zy x
```

#### `<operation>`: odd|even|equal

Value   | Description
--------|---------------
`odd`	| Round up or down, based on mode, all axes specified in `<target>` to the nearest odd length relative to pos1
`even`	| Round up or down, based on mode, all axes specified in `<target>` to the nearest even length relative to pos1
`equal`	| Set `<target>` axes length equal to the length of `<base>` axis if specified or to the length of the largest, smallest or average of the `<target>` axes based on mode.

#### `<mode>`: grow|shrink|average

#### *If `<operation>` == odd or even:*

Value			| Description
----------------|--------------
`grow`			| Grow each axis specified in `<target>` to the nearest odd/even number to itself
`shrink`		| Shrink each axis specified in `<target>` to the nearest odd/even number to itself
`average`/`avg` | Takes the average of all axes specified in `<target>` and then for each specified axis grows or shrinks it, depending on whether it is less than or greater than the average, to the nearest odd/even number to itself

#### *If `<operation>` == equal:*
The `<mode>` argument can be omitted and will not be parsed if present if `<base>` is specified

Value			| Description
----------------|---------------
`grow`			| Grow each axis specified in `<target>` to the length of the longest specified axis
`shrink`		| Shrink each axis specified in `<target>` to the length of the shortest specified axis
`average`/`avg`	| Set each axis specified in `<target>` to the average length of all the specified axes
If `<base>` | `<mode>` becomes optional. If present it will be ignored.

#### Additional arguments:

Name		| Description
------------|------------------
`<target>`	| Specify axes to perform operation on (default= xz)|
`<base>`: If `<operation>` == odd or even	| Does nothing
`<base>`: If `<operation>` == equal			| Overrides `<mode>` and sets all `<target>` axes equal to itself

### `//sfactor <mode:grow|shrink|average> <factor> [<target=xz>]`
Short for _selection factor_; alias: `//sfac`. Built specifically for use with `//maze`, this command sets targeted axes equal to the nearest multiple of `<factor>` based on the `<mode>`.

Usage examples:

```weacmd
//sfac grow 5
//sfac avg 3 xy
```

#### `<mode>`: grow|shrink|average

Value	|	Description
--------|--------------
`grow` | Rounds the length of each target axis up to the nearest multiple of `<factor>`
`shrink` | Rounds the length of each target axis down to the nearest multiple of `<factor>`
`average`/`avg` | Takes the average of all axes specified in `<target>` and then for each specified axis grows or shrinks it, depending on whether it is less than or greater than the average, to the nearest multiple of `<factor>`

### `//sstack`
Displays the contents of your per-user selection stack. This stack can be pushed to and popped from rather like a stack of plates. See also `//spush` (for pushing to the selection stack) and `//spop` (for popping from the selection stack).

```weacmd
//sstack
```

### `//spush`
Pushes the currently defined region onto your per-user selection stack. Does not otherwise alter the defined region.

If the stack is full (currently the limit is set to 100 regions in the stack), then it will complain at you but otherwise will have no effect.

Note that pos2 does _not_ need to be defined in order to use this. if it isn't defined, then a pos2 of `nil` will be pushed onto the stack instead.

```weacmd
//spush
```

### `//spop`
Pops a selection off your per-user selection stack and applies it to the currently defined region. If pos2 from the item popped from the stack is nil, then pos2 is explicitly unset. If the stack is empty, this has no effect.

```weacmd
//spop
```



## Measurement
<!--
███    ███ ███████  █████  ███████ ██    ██ ██████  ███████
████  ████ ██      ██   ██ ██      ██    ██ ██   ██ ██
██ ████ ██ █████   ███████ ███████ ██    ██ ██████  █████
██  ██  ██ ██      ██   ██      ██ ██    ██ ██   ██ ██
██      ██ ███████ ██   ██ ███████  ██████  ██   ██ ███████
-->


### `//mcount`
Alias for [`//count`](#count).

```
//mcount
```


### `//mface`
Returns the horizontal (X/Z) axis or axes the player is looking along.
Aliases: `//mfacing`.

```
//mface
```


### `//midpos`
Returns the coordinates of the centre of the current selection.

```
//midpos
```


### `//msize`
Returns the lengths of the current selection on the X, Y and Z axes.

```
//msize
```


### `//mtrig`
Returns the length of the diagonal from pos1 to pos2 and its angle on the XZ (horizontal) and Y (vertical) axes.

```
//mtrig
```



## Meta
<!--
███    ███ ███████ ████████  █████
████  ████ ██         ██    ██   ██
██ ████ ██ █████      ██    ███████
██  ██  ██ ██         ██    ██   ██
██      ██ ███████    ██    ██   ██
-->


### `//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`
Splits the current WorldEdit region into `(<size_x>, <size_y>, <size_z>)` sized chunks, and run `//<cmd_name> <args>` over each chunk.

Sometimes, we want to run a single command on a truly vast area. Usually, this results in running out of memory. If this was you, then this command is just what you need! It should be able to handle any sized region - the only limit is your patience for command to complete.....

Note that this command only works with WorldEdit commands, and only those which require 2 points (e.g. `//torus` only requires a single point, so it wouldn't work very well - but `//set` or `//clearcut` would).

Note also that `<cmd_name>` should _not_ be prefixed with _any_ forward  slashes - see the examples below.

While other server commands can be executed while a `//subdivide` is running, `//subdivide` manipulates your player's defined region when running. This has the side-effect that you can check on where it has got up to with `//p get` for example - but means that attempting to change your pos1 & pos2 manually will have no effect until the `//subdivide` completes.

**Warning:** Once started, this command cannot be stopped without restarting your server! This is the case with all WorldEdit commands, but it's worth a special mention here.

```weacmd
//subdivide 10 10 10 set dirt
//subdivice 25 25 25 fixlight
```


### `//multi <command_a> <command_b> <command_c> .....`
Executes multi chat commands in sequence. Intended for _WorldEdit_ commands, but does work with others too. Don't forget a space between commands!

```weacmd
//multi //set dirt //shift x 10 //set glass
```

Since WorldEditAdditions v1.12, curly brace syntax has also been introduced to allow nesting of commands:

```weacmd
//multi //fixlight {//many 5 //bonemeal 3 100}
```

This syntax can also be nested arbitrarily in arbitrarily complex combinations, and can also be used multiple separate times in a single `//multi` invocation (if you find a bug, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new)), though do remember that only `//multi` supports parsing out this syntax (e.g. if you want to nest multiple commands in a `//many` that's inside a `//multi`, you'll need a sub `//multi` there).

In addition, this also allows for including a double forward slash in the argument list for a command, should you need to do so (e.g. `//multi //example {//bar //baz} //example` will be executed as 3 commands: `/example`, then `/bar` with an argument of `//baz`, then finally `/example`).

```weacmd
//multi //1 //2 //shift z -10 //sphere 5 sand //shift z 20 //ellipsoid 5 3 5 ice
//multi //1 //hollowtorus 30 5 stone //hollowtorus 20 3 dirt //torus 10 2 dirt_with_grass
//multi /time 7:00 //1 //outset h 20 //outset v 5 //overlay dirt_with_grass //1 //2 //sphere 8 air //shift down 1 //floodfill //reset
```


### `//many <times> <command>`
Executes a single chat command many times in a row. Uses `minetest.after()` to yield to the main server thread to allow other things to happen at the same time, so technically you could have multiple `//many` calls going at once (but multithreading support is out of reach, so only a single one will be executing at the same time).

Note that this isn't necessarily limited to executing WorldEdit / WorldEditAdditions commands. Combine with `//multi` (see above) execute multiple commands at once for even more power and flexibility!

```weacmd
//many 10 //bonemeal 3 100
//many 100 //multi //1 //2 //outset 20 //set dirt
```


### `//ellipsoidapply <command_name> <args>`
Executes the given command, and then clips the result to the largest ellipsoid that will fit inside the defined region. The specified command must obviously take 2 positions - so for example `//set`, `//replacemix`, and `//maze3d` will work, but `//sphere`, `//torus`, and `//floodfill` won't.

For advanced users, `//multi` is also supported - but make sure your modifications stay within the defined region - otherwise they will not be affected by the ellipsoidal clipping operation.

```weacmd
//ellipsoidapply set dirt
//ellipsoidapply maze3d dirt 4 2 2
//ellipsoidapply erode
//ellipsoidapply replacemix sand bakedclay:red bakedclay:orange
//ellipsoidapply layers desert_sand sand 2 desert_sandstone 4 sandstone 10
```


### `//airapply <command_name> <args>`
Like [`//ellipsoidapply`](#ellipsoidapply), but instead only keeps changes that replace airlike nodes, and discards any other changes made.

As with `//ellipsoidapply` for advanced users `//multi` is also supported - but make sure your modifications stay within the defined region - otherwise they be kept regardless, as `//airapply` only applies the masking to the nodes in the defined region.

```weacmd
//airapply set sandstone
//airapply maze3d dirt 4 2 2
```


### `//noiseapply2d <threshold> <scale> <command_name> <args>`
Like [`//ellipsoidapply`](#ellipsoidapply), but instead only keeps changes where a noise function (defaults to `perlinmt`, see [`//noise2d`](#noise2d)) returns a value greater than a given threshold value.

Also takes a scale value that controls the scale of the noise - -higher values result in smaller "blobs". If you're operating on small areas, then a value of at least 10 is advised as "blobs" are by default on the scale of ~50 nodes.

As with `//ellipsoidapply` for advanced users `//multi` is also supported - but make sure your modifications stay within the defined region - otherwise they be kept regardless, as `//noiseapply2d` only applies the masking to the nodes in the defined region.

Any suggestions on  how to provide more customisability without making this command more difficult to use or significantly more inconsistent with other `//*apply` functions are welcome - please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new).

```weacmd
//noiseapply2d 0.5 10 set dirt
//noiseapply2d 0.4 3 layers dirt_with_snow dirt 3 stone 10
```

### `//for <value1> <value2> <value3>... do //<command> <arg> %% <arg>`
For a given list of values, executes the specified command for each value, replacing `%%` with each value. Implementation thanks to @VorTechnix.

To better illustrate what happens, consider the following command:

```
//for dirt stone glass do //replacemix air 10 %%
```

This is equivalent to executing the following 3 commands in sequence:

```
//replacemix air 10 dirt
//replacemix air 10 stone
//replacemix air 10 glass
```

Here are some more examples:

```
//for meselamp brick snowblock bamboo:wood do { //multi //maze %% //sshift y 5 }
//for 5 10 15 do //torus %% 3 dirt xz
```



## Extras
<!--
███████ ██   ██ ████████ ██████   █████  ███████
██       ██ ██     ██    ██   ██ ██   ██ ██
█████     ███      ██    ██████  ███████ ███████
██       ██ ██     ██    ██   ██ ██   ██      ██
███████ ██   ██    ██    ██   ██ ██   ██ ███████
-->


### `//y`
Confirms the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```weacmd
//y
```


### `//n`
Prevents the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```weacmd
//n
```



## Tools
<!--
████████  ██████   ██████  ██      ███████
   ██    ██    ██ ██    ██ ██      ██
   ██    ██    ██ ██    ██ ██      ███████
   ██    ██    ██ ██    ██ ██           ██
   ██     ██████   ██████  ███████ ███████
-->

### Far Wand
The far wand (`worldeditadditions:farwand`) is a variant on the traditional WorldEdit wand (`worldedit:wand`). It looks like this: ![A picture of the far wand](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/worldeditadditions_farwand/textures/worldeditadditions_farwand.png)

It functions very similarly to the regular WorldEdit wand, except that it has a _much_ longer range - which can be very useful for working on large-scale terrain for example. It also comes with an associated command to control it.

### `//farwand skip_liquid (true|false) | maxdist <number>`
This command helps control the behaviour of the [WorldEditAdditions far wand](#far-wand) and [cloud wand](#cloud-wand). Calling it without any arguments shows the current status:

```weacmd
//farwand
```

You can decide whether you can select liquids or not like so:

```weacmd
//farwand skip_liquid true
//farwand skip_liquid false
```

You can change the maximum range with the `maxdist` subcommand:

```weacmd
//farwand maxdist 1000
//farwand maxdist 200
//farwand maxdist 9999
```

Note that the number there isn't in blocks (because hard maths). It is however proportional to the distance the wand will raycast looks for nodes, so a higher value will result in it raycasting further.

### Cloud Wand
The cloud wand (`worldeditadditions:cloudwand`) is a another variant the above _Far Wand_. It looks like this: ![A picture of the far wand](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/worldeditadditions_farwand/textures/worldeditadditions_cloudwand.png)

Unlike the other 2 wands, this wand functions in an additive manner. Left-click on a node to expand the currently defined region (creating a new one if one isn't defined already) to include that node. Right click to clear the currently defined region.

It has the range of the _Far Wand_ mentioned above too, so you can select nodes from a great distance. It also abides by preferences set via the `//farwand` chat command.
