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

 - [`//maze`](/Reference/#maze): Create instant mazes
 - [`//forest`](/Reference/#forest): Plant forests
 - [`//torus`](http://localhost:8080/Reference/#torus): Generate [torus](https://en.wikipedia.org/wiki/Torus) shapes
 - [`//scale`](/Reference/#scale): Scale things up and down - even both at the same time!

See a full list with complete explanations in the [chat command reference](/Reference).


## Regions
WorldEdit allows you to define a _region_ by specifying 2 points in the world - we number these points 1 and 2. By using the WorldEdit wand (or WorldEditAdditions Far Wand), one can left click to set the position of point 1, and right click to set point 2:

{% image "images/tutorial_pos1_2.jpeg" "A screenshot showing WorldEdit points 1 and 2 in a desert with a cactus" %}

Point 1 is on the cactus, and point 2 is on the ground in the bottom left.

Most WorldEdit and WorldEditAdditions commands require either 1 or 2 points to be set in order to work.

 - If 1 point is required, it's the origin point used by the command
 - If 2 points are required, the defined region specifies the area in which the command is operate


## Command syntax
When explaining the syntax (ref [a](https://en.wikipedia.org/wiki/Syntax_(programming_languages)), [b](https://www.bbc.co.uk/bitesize/guides/z22wwmn/revision/6)) of a command, a number of different conventions are used to concisely explain said syntax. Understanding enables you to quickly understand the output of `/help /maze` for example, or the list of commands in the [reference](/Reference).

 - `<thing>`: A placeholder for a value that you can change. Do *not* include the `<` angle brackets `>` when replacing it with your actual value.
 - `a | b`: 1 thing or another, but not both.
 - `[optional_thing]`: Something that's optional. Specifying it enables greater control over the behaviour of the command, but it can be left out for convenience.
 - `<thing|other_thing>`: Pick 1 item from the list and replace the entire group, removing the `<` angle brackets `>` as with `<thing>`. For example `<snowballs|river>` could become either `snowballs` or `river`, but not both at the same time.
 - `<thing=default_value>`: Most commonly seen in `[` square brackets `]` indicating an optional thing. Indicates the default value of something that you can replace (or omit).
 - `...`: Indicates that the previous items can be repeated.

Let's illustrate this with a practical example. Consider the following:

```
//example <height> <apple|orange> | <height> <width> <pear|maple> [<extra_value>]
```

The following different invocations of the above would be valid:

```
//example 10 apple
//example 45 30 maple
//example 30 12 pear something_else
```

Now let's apply this to a more practical example:

```
//erode [<snowballs|river> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]
```

The `<snowballs|river>` explains that either a value of `snowballs` or `river` is acceptable. Then, a key - value list of options can be specified - allowing an arbitrary number of options.

From this, we can infer the following usage:

```
//erode snowballs speed 1 count 50000
```


## Anything else?

 - Make sure we have covered everything


## Advanced Concepts
A number of additional concepts that are not required to use WorldEditAdditions are explained here, as they can be helpful for understanding some of the more advanced concepts and commands provided by WorldEditAdditions.

### Meta commands
WorldEditAdditions provides a number of *meta commands*. Such commands don't do anything on their own, but call other commands in various different ways. Examples of meta commands include:

 - [`//subdivide`](/Reference#subdivide): split a region into chunks, and execute the command once for each chunk
 - [`//many`](/Reference#many): Execute a command multiple times
 - [`//multi`](/Reference#multi): Execute multiple commands in sequence

Of course, this isn't an exhaustive list - check the [reference](/Reference) for a full list.

### Memory usage
Memory (or RAM - Random Access Memory) is used by all the processes running on a system to hold data that they are currently working with. This is especially important for WorldEdit and WorldEditAdditions, since the larger the region you define the more memory that will be required to run commands on it.

Depending on your system, Minetest and your system can slow to a crawl or even crash if you execute a command on a region that's too big.

To work around this, the [`//subdivide`](/Reference#subdivide) command was implemented. It splits the defined region into chunks, and calls the specified command over and over again for each chunk. 

It's not suitable for all commands (since it requires that said command takes 2 points) though, but because it splits the defined region into multiple chunks, it can be executed on *enormous* regions that can't fit into memory all at the same time.


## Conclusion
This short tutorial has explained a few key concepts that are useful for understanding WorldEditAdditions, from executing chat commands to the syntax used in the [reference](/Reference) to concisely describe commands.

If there's a concept that you don't understand after reading this and the [reference](/Reference), please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) with a detailed explanation of what it is that you're finding difficult to understand.
