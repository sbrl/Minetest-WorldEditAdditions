# WorldEditAdditions Cookbook
This file contains a number of useful commands that WorldEditAdditions users have discovered and found useful. They do not necessarily have to contain _WorldEditAdditions_ commands - pure _WorldEdit_ commands are fine too.

See also:

- [Quick Command Reference](https://github.com/sbrl/Minetest-WorldEditAdditions/tree/master#quick-command-reference)
- [WorldEditAdditions Detailed Chat Command Explanations](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/Chat-Command-Reference.md)
- [WorldEdit Chat Command Reference](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md)


## Fix lighting

```
//multi //1 //2 //outset 50 //fixlight //y
```

As a brush:

```
//brush cubeapply 50 fixlight
```

## Terrain editing
The following brushes together can make large-scale terrain sculpting easy:

```
//brush cubeapply 25 set stone
//brush ellipsoid 11 9 11 stone
//brush sphere 5 stone
//brush cubeapply 50 fillcaves stone
//brush cubeapply 30 50 30 conv
//brush cubeapply 50 conv
//brush sphere 5 air
//brush cubeapply 50 fixlight
//brush cubeapply 50 layers dirt_with_grass dirt 3 stone 10
```

## Preserve Air During Schematic Load
`//load` only writes non-air blocks in a saved WorldEdit schematic. To get around this the `//allocate` command was created so that users could set the target area to air before the new nodes were written. The following command applies this work flow (replace `<file>` with the name of your schematic before using the command):

```
//multi //allocate <file> //set air //load <file>
```

## En-mass Foliage clearing
Clearing large amounts of foliage is easy with the new `//subdivide` function!

```
//subdivide 20 20 20 //clearcut
```

Another good way to clear large chunk of land is with `//many`:

```
//many 25 //multi //clearcut //y //shift x 10
```

Adjust the numbers (and direction in the `//shift` command) to match your scenario.


## Flower Field
Make a flower field with no grass.

```
//overlay air 20 flowers:geranium 1 
```

Adjust the air value to change flower density.

```
//overlay air 80 flowers:rose 1 flowers:tulip 1 flowers:dandelion_yellow 1 flowers:chrysanthemum_green 1 flowers:geranium 1 flowers:viola 1 flowers:dandelion_white 1 flowers:tulip_black 1
```

When working with many types of flowers the air values need to be higher to compensate. The best equation for the air value that I've found is `<desired spacing> * <sum of flower probabilities>`.


## Grass Field
Make a grass field

```
//overlay air 36 default:grass_2 2 default:grass_3 2 default:grass_4 1 default:grass_5 1
```

Adjust the air value to change grass density. As with flower field the best equation for the air value is `<desired spacing> * <sum of flower probabilities>`.
