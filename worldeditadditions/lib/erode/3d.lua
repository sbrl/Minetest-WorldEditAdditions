local wea = worldeditadditions
local weac = worldeditadditions_core
local Vector3 = weac.Vector3

---
-- @module worldeditadditions.erode



--- Parses a density value into a string.
-- @param	val		number|string	The value to parse. If it's a  string & ends in a percentage sign (%), then it's interpreted as a percentage instead of a multiplier.
-- @returns	bool,number|string		Success bool + result. If success=true, then type(result) is a number representing a multiplier, otherwise is an error message as a string.
local function parse_density(val)
	if type(val) == "string" then
		local result = tonumber(string.gsub(val, "[^0-9]", ""), 10)
		if weac.str_ends(val, "%") then
			result = result / 100
		end
		return true, result
	elseif type(val) == "number" then -- assume a multiplier
		return true, val
	else
		return false, "Error: value "..tostring(val).." provided wasn't a string or a number, but a "..type(val)..", which isn't a supported type"
	end
end

--- 3D random node erosion algorithm, inspired by VoxelSniper for Minecraft
-- @ref inspiration <https://intellectualsites.gitbook.io/fastasyncvoxelsniper/default-commands/commands#the-random-erode-brush>
-- @param	pos1	Vector3		pos1 of the defined region
-- @param	pos2	Vector3		pos2 of the defined region
-- @param	area	VoxelArea	The VoxelArea instance from the parent VoxelManipulator.
-- @param	data	number[]	The nodeid data table from the VoxelManipulator. It's just a list of nodeids, which are integers. MUTATED!
-- @param	params_custom	table	The table of parameters to pass to the function:
-- | Parameter		| Type			| Meaning |
-- |----------------|---------------|---------|
-- | max_steps		| int?			| Overrides `density` if set. The number of blocks to check & remove. |
-- | density="10%"	| float|string	| If specified, sets `max_steps` to be a percentage of the volume of the specified region instead of a static number. Numbers are interpreted to be multipliers by default (e.g., 0.1 is 10% of the defined region), but a percentage sign `%` considers the density value provided to be a percentage (and hence divides by 100 to get a multiplier) instead. |
-- | attempts=25	| int			| The number of attempts to make per-block to find a surface-touching node. |
-- | exposed=1		| int			| Min faces that must be exposed for a node to be eroded (aka removed). |
-- @returns bool,table|string	Success bool, followed by either a string if success=false or a table of statistics if success=true. Example table:
-- ```lua
-- {
-- 	nodes_replaced_target = 100,
-- 	nodes_replaced_actual = 80,
-- 	attempts_failed = 20,
-- }
-- ```
function worldeditadditions.erode.erode_3d(pos1, pos2, area, data, params_custom)
	---
	-- 1: param/argument parsing
	---
	
	-- Default values
	local params = {
		max_steps = nil, -- max number of nodes to remove from region. overrides density if set
		density = "10%",	-- %age of nodes in defined region to remove
		exposed = 1,		-- min faces that must be exposed to pick a node
		attempts = 25,		-- # of attempts to find an eligible node to remove before giving up and moving to the next one
	}
	weac.table.apply(params_custom, params)
	if params_custom.maxsteps ~= nil then params.max_steps = params_custom.maxsteps end
	
	-- ~
	
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	local max_steps
	
	-- Density parsing - guaranteed to be specified
	local volume = Vector3.volume(pos1, pos2+1) -- Vector3.volume iis half-inclusive not fully inclusive. In other words an 11³ region shows as 10³ instead by design
	local success_density, density = parse_density(params.density)
	if not success_density then return success_density, density end
	max_steps = math.floor(volume * density)
	print("DEBUG:erode_3d max_steps AFTER DENSITY", max_steps, "DENSITY", density, "params.density", params.density,
	"VOLUME", volume)
	
	if type(params.max_steps) == "number" then
		max_steps = params.max_steps
	end
	
	local min_exposed_faces = params.exposed
	if type(min_exposed_faces) == "string" then
		min_exposed_faces = tonumber(min_exposed_faces)
	elseif type(min_exposed_faces) ~= "number" then
		return false, "Error: Invalid type of parameter expose (string or number expected, found '"..type(min_exposed_faces).."' instead)"
	end
	if min_exposed_faces < 0 or min_exposed_faces > 6 then
		return false, "Error: The parameter 'exposed' may only be an integer in the range 0-6"
	end
	
	---
	-- 2: prop
	---
	
	-- nodeid airlike/not airlike cache ref performance
	-- this is not global in weac.is_airlike to save on memory
	local airlike = {}
	local not_airlike = {}
	
	local nodeid_air = minetest.get_content_id("air")
	
	---
	-- 3: main driver
	---
	
	local nodes_replaced = 0
	local attempts_taken = {}
	
	for i=1, max_steps do
		for i_attempt=1, params.attempts do
			local location = Vector3.new(
				math.floor(math.random(pos1.x, pos2.x)),
				math.floor(math.random(pos1.y, pos2.y)),
				math.floor(math.random(pos1.z, pos2.z))
			)
			-- Nodeids for the 6 carbinal directions
			local nodesids_nearby = {
				data[area:index(location.x + 1, location.y, location.z)],
				data[area:index(location.x - 1, location.y, location.z)],
				data[area:index(location.x, location.y + 1, location.z)],
				data[area:index(location.x, location.y - 1, location.z)],
				data[area:index(location.x, location.y, location.z + 1)],
				data[area:index(location.x, location.y, location.z - 1)]
			}
			
			-- .....but how many of those are airlike?
			local airlike_count = weac.table.reduce(
				nodesids_nearby,
				function(acc, nodeid)
					if not_airlike[nodeid] ~= true and airlike[nodeid] ~= true then
						if weac.is_airlike(nodeid) then
							airlike[nodeid] = true
						else
							not_airlike[nodeid] = true
						end
					end
					if airlike[nodeid] then
						acc = acc + 1
					end
					return acc
				end,
				0
			)
			
			-- everything below this gets a 50-50 chance to be removed
			local chance_100 = math.min(6, min_exposed_faces + 1)
			
			if airlike_count >= min_exposed_faces then
				-- okay, so it's eligible but if it has less faces exposed then we have less of a chance of removing it
				-- this is to avoid a 'swiss-cheese' effect from taking told too quickly
				if airlike_count < chance_100 and math.floor(math.random()*2) == 0 then
					break
				end
				
				data[area:index(location.x, location.y, location.z)] = nodeid_air
				nodes_replaced = nodes_replaced + 1
				table.insert(attempts_taken, i_attempt)
				break
			end
		end
	end
	
	---
	-- 4: return
	---
	
	local attempts_failed = max_steps - nodes_replaced
	
	local stats = {
		nodes_replaced_target = max_steps,
		nodes_replaced_actual = nodes_replaced,
		attempts_failed = attempts_failed,
		attempts_taken_average = weac.round(weac.average(attempts_taken), 1),
		-- required by commands/erode:
		added = 0,
		removed = nodes_replaced
	}
	
	-- no need to return the data table here, since tables are passed by reference
	return true, stats
end