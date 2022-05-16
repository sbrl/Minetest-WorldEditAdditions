worldedit.alias_command("smoothadv", "convolve")
worldedit.alias_command("conv", "convolve")

worldedit.alias_command("naturalise", "layers")
worldedit.alias_command("naturalize", "layers")

worldedit.alias_command("flora", "bonemeal")

-- Measure Tools
worldedit.alias_command("mcount", "count")
worldedit.alias_command("mfacing", "mface")


--- Overrides to core WorldEdit commands
-- These are commented out for now, as they could be potentially dangerous to stability
-- Thorough testing is required of our replacement commands before these are uncommented
-- TODO: Depend on worldeditadditions_core before uncommenting this
-- BUG: //move+ seems to be leaving stuff behind for some strange reason --@sbrl 2021-12-26
-- worldeditadditions_core.alias_override("copy", "copy+")
-- worldeditadditions_core.alias_override("move", "move+") -- MAY have issues where it doesn't overwrite the old region properly, but haven't been able to reliably reproduce this
-- worldeditadditions_core.alias_override("replace", "replacemix")
