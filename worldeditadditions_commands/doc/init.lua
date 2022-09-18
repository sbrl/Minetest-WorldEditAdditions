-- ██████   ██████   ██████ ███████
-- ██   ██ ██    ██ ██      ██
-- ██   ██ ██    ██ ██      ███████
-- ██   ██ ██    ██ ██           ██
-- ██████   ██████   ██████ ███████

-- This directory contains support for the doc mod:
-- https://content.minetest.net/packages/Wuzzy/doc/
-- API docs: https://repo.or.cz/minetest_doc.git/blob/HEAD:/API.md

-- The strategy here is not to have duplicate content, but to pull data from 
-- existing sources.
-- Long-form article descriptions: Chat-Command-Reference.md
-- Short descriptions: Undecided, but maybe from the registered command definition?

worldeditadditions.doc = {
	parse_reference = dofile(worldeditadditions_commands.modpath.."/doc/parse_reference.lua")
}

