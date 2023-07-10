local wea_c = worldeditadditions_core
--[[
This file contains sapling alias definitions for a number of different mods.
If your mod is not listed here, please open a pull request to add it :-)

This mod's repository can be found here: https://github.com/sbrl/Minetest-WorldEditAdditions

Adding support for your mod is a 2 step process:

1. Update this file with your definitions
2. Update depends.txt to add a soft dependency on your mod. Find that file here: https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/worldeditadditions/depends.txt - for example, add something line "my_awesome_mod?" (note the question mark at the end) on a new line(without quotes).

Alternatively, you can register support in your mod directly. Do that by adding a soft dependency on worldeditadditions_core, and then calling worldeditadditions_core.normalise_saplingname if worldeditadditions is loaded.
]]--

-- TODO: MOVE register_sapling_alias & register_sapling_alias_many back to worldeditadditions from worldeditadditions_core!!!!
-- wea_c.register_sapling_alias("")

if minetest.get_modpath("default") then
	wea_c.register_sapling_alias_many({
		{ "default:sapling", "apple" },
		{ "default:bush_sapling", "bush" },
		{ "default:pine_sapling", "pine" },
		{ "default:pine_bush_sapling", "pine_bush" },
		{ "default:aspen_sapling", "aspen" },
		{ "default:junglesapling", "jungle" },
		{ "default:emergent_jungle_sapling", "jungle_emergent" },
		{ "default:acacia_sapling", "acacia" },
		{ "default:acacia_bush_sapling", "acacia_bush" },
		{ "default:blueberry_bush_sapling", "blueberry_bush" },
		-- { "default:large_cactus_seedling", "cactus" } -- Can't be bonemealed yet, but I'd guess it will be implemented eventually. It's not in the sapling category, so we won't detect it for bonemealing anyway
	})
end

if minetest.get_modpath("moretrees") then
	wea_c.register_sapling_alias_many({
		{ "moretrees:spruce_sapling", "spruce" },
		{ "moretrees:rubber_tree_sapling", "rubber" },
		{ "moretrees:beech_sapling", "beech" },
		{ "moretrees:jungletree_sapling", "jungle_moretrees" },
		{ "moretrees:fir_sapling", "fir" },
		{ "moretrees:willow_sapling", "willow_moretrees" },
		{ "moretrees:poplar_sapling", "poplar" },
		{ "moretrees:poplar_small_sapling", "poplar_small" },
		{ "moretrees:apple_tree_sapling", "apple_moretrees" },
		{ "moretrees:birch_sapling", "birch_moretrees" },
		{ "moretrees:palm_sapling", "palm_moretrees" },
		{ "moretrees:date_palm_sapling", "palm_date" },
		{ "moretrees:sequoia_sapling", "sequoia" },
		{ "moretrees:oak_sapling", "oak_moretrees" },
		{ "moretrees:cedar_sapling", "cedar" }
	})
end

if minetest.get_modpath("ethereal") then
	wea_c.register_sapling_alias_many({
		{ "ethereal:mushroom_sapling", "mushroom" },
		{ "ethereal:sakura_sapling", "sakura" },
		{ "ethereal:birch_sapling", "birch" },
		{ "ethereal:yellow_tree_sapling", "yellow_tree" },
		{ "ethereal:willow_sapling", "willow_ethereal" },
		{ "ethereal:redwood_sapling", "redwood" },
		{ "ethereal:palm_sapling", "palm_ethereal" },
		{ "ethereal:frost_tree_sapling", "frost" },
		{ "ethereal:banana_tree_sapling", "banana" },
		{ "ethereal:orange_tree_sapling", "orange" },
		{ "ethereal:bamboo_sprout", "bamboo_ethereal" },
		{ "ethereal:big_tree_sapling", "big" }
	})
end


--  ██████  ██████   ██████  ██           ████████ ██████  ███████ ███████ ███████
-- ██      ██    ██ ██    ██ ██              ██    ██   ██ ██      ██      ██
-- ██      ██    ██ ██    ██ ██              ██    ██████  █████   █████   ███████
-- ██      ██    ██ ██    ██ ██              ██    ██   ██ ██      ██           ██
--  ██████  ██████   ██████  ███████ ███████ ██    ██   ██ ███████ ███████ ███████

if minetest.get_modpath("lemontree") then
	wea_c.register_sapling_alias("lemontree:sapling", "lemon")
end
if minetest.get_modpath("pineapple") then
	wea_c.register_sapling_alias("pineapple:sapling", "pineapple")
end
if minetest.get_modpath("baldcypress") then
	wea_c.register_sapling_alias("baldcypress:sapling", "baldcypress")
end
if minetest.get_modpath("bamboo") then
	wea_c.register_sapling_alias("bamboo:sprout", "bamboo")
end
if minetest.get_modpath("birch") then
	wea_c.register_sapling_alias("birch:sapling", "birch")
end
if minetest.get_modpath("cherrytree") then
	wea_c.register_sapling_alias("cherrytree:sapling", "cherry")
end
if minetest.get_modpath("clementinetree") then
	wea_c.register_sapling_alias("clementinetree:sapling", "clementine")
end
if minetest.get_modpath("ebony") then
	wea_c.register_sapling_alias("ebony:sapling", "ebony")
end
if minetest.get_modpath("jacaranda") then
	wea_c.register_sapling_alias("jacaranda:sapling", "jacaranda")
end
if minetest.get_modpath("larch") then
	wea_c.register_sapling_alias("larch:sapling", "larch")
end
if minetest.get_modpath("maple") then
	wea_c.register_sapling_alias("maple:sapling", "maple")
end
if minetest.get_modpath("palm") then
	wea_c.register_sapling_alias("palm:sapling", "palm")
end
if minetest.get_modpath("plumtree") then
	wea_c.register_sapling_alias("plumtree:sapling", "plum")
end
if minetest.get_modpath("hollytree") then
	wea_c.register_sapling_alias("hollytree:sapling", "holly")
end
if minetest.get_modpath("pomegranate") then
	wea_c.register_sapling_alias("pomegranate:sapling", "pomegranate")
end
if minetest.get_modpath("willow") then
	wea_c.register_sapling_alias("willow:sapling", "willow")
end
if minetest.get_modpath("mahogany") then
	wea_c.register_sapling_alias("mahogany:sapling", "mahogany")
end
if minetest.get_modpath("chestnuttree") then
	wea_c.register_sapling_alias("chestnuttree:sapling", "chestnut")
end
