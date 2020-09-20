# WorldEditAdditions Cookbook
This file contains a number of useful commands that WorldEditAdditions users have discovered and found useful. They do not necessarily have to contain _WorldEditAdditions_ commands - pure _WorldEdit_ commands are fine too.

See also:

- [WorldEditAdditions Chat Command Cookbook](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/Cookbook.md)
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
