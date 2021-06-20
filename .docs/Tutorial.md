---
layout: content-generic.njk
title: Tutorial
tags: navigable
date: 2004-01-01
---

# WorldEditAdditions Beginner's Tutorial
Welcome to the WorldEditAdditions beginners tutorial! There are a number of conventions used in the [chat command reference](/Reference) that may not be immediately obvious - this guide serves to explain in detail.

It is assumed that:

 - You are already familiar the basics of [Minetest](https://www.minetest.net/) (try the [tutorial game](https://content.minetest.net/packages/Wuzzy/tutorial/) if you're unsure)
 - You have both WorldEdit and WorldEditAdditions installed (see the [Download](/#download) section)

Minetest supports the execution of _Chat Commands_ to manipulate the Minetest world. While in a Minetest world, simply type `/help` (the first forward slash `/` will automatically cause the chat window to appear) and hit <kbd>enter</kbd> to display a list of chat commands that are currently registered grouped by mod for example.

WorldEdit commands are, by convention, prefixed with an additional forward slash `/`. Here are some examples of WorldEdit chat commands:

```
//1
//2
//set dirt
```

Explaining core WorldEdit commands is out of scope of this tutorial, but you can find a complete list of them here: <https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md>.

The purpose of _WorldEditAdditions_ is to extend _WorldEdit_ by adding additional commands. Example commands that have been implemented that are not present in core _WorldEdit_ include (but certainly aren't limited to):

 - [`//maze`](/Reference/#maze-replace_node-path_length-path_width-seed): Create instant mazes
 - [`//forest`](/Reference/#forest-density-sapling_a-chance_a-sapling_b-chance_b-sapling_n-chance_n-): Plant forests
 - [`//torus`](http://localhost:8080/Reference/#torus-major_radius-minor_radius-node_name-axesxy-hollow): Generate [torus](https://en.wikipedia.org/wiki/Torus) shapes
 - [`//scale`](/Reference/#scale-axis-scale_factor-factor_x-factor_y-factor_z-anchor_x-anchor_y-anchor_z): Scale things up and down - even both at the same time!

See a full list with complete explanations in the [chat command reference](/Reference).


## Regions
WorldEdit allows you to define a _region_ by specifying 2 points in the world - we number these points 1 and 2. By using the WorldEdit wand (or WorldEditAdditions Far Wand), one can left click to set the position of point 1, and right click to set point 2:

{% image "images/tutorial_pos1_2.jpeg" "A screenshot showing WorldEdit points 1 and 2 in a desert with a cactus" %}

Point 1 is on the cactus, and point 2 is on the ground in the bottom left.

Most WorldEdit and WorldEditAdditions commands require either 1 or 2 points to be set in order to work.

 - If 1 point is required, it's the origin point used by the command
 - If 2 points are required, the defined region specifies the area in which the command is operate


## Command syntax

 - Command syntax conventions:
	 - `<thing>`
	 - `a|b`
	 - `[optional_thing]`
	 - `<thing|other_thing>`


## Anything else?

 - Make sure we have covered everything


## Advanced Concepts

 - Memory usage
 - Meta commands
 - Other things?
