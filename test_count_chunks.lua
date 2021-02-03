--[[
test_count_chunks

Test script for the new count_chunks implementation for //subdivide.
The new implementation does the maths properly and is functionally identical to
the previous algorithm - we've tested it with 1000 totally random pos1, pos2,
and chunk_size values.
]]--

local function count_chunks(pos1, pos2, chunk_size)
	local count = 0
	for z = pos2.z, pos1.z, -chunk_size.z do
		for y = pos2.y, pos1.y, -chunk_size.y do
			for x = pos2.x, pos1.x, -chunk_size.x do
				count = count + 1
			end
		end
	end
	return count
end

local function count_chunks_new(pos1, pos2, chunk_size)
	-- Assume pos1 & pos2 are sorted
	local dimensions = {
		x = pos2.x - pos1.x + 1,
		y = pos2.y - pos1.y + 1,
		z = pos2.z - pos1.z + 1,
	}
	-- print("[new] dimensions", dimensions.x, dimensions.y, dimensions.z)
	return math.ceil(dimensions.x / chunk_size.x)
		* math.ceil(dimensions.y / chunk_size.y)
		* math.ceil(dimensions.z / chunk_size.z)
end


local pos1	= { x = 16000, y = 0, z = 16000 }
local pos2	= { x = 16100, y = 100, z = 16100 }
local count	= { x = 7, y = 9, z = 10 }

print("Reference: ", count_chunks(pos1, pos2, count))
print("New: ", count_chunks_new(pos1, pos2, count))

local ok = 0
local failed = false
for i=1,1000 do
	pos1.x = 16000 + math.floor(math.random() * 99)
	pos1.y = 16000 + math.floor(math.random() * 99)
	pos1.z = 16000 + math.floor(math.random() * 99)

	pos2.x = 16100 + math.floor(math.random() * 2000)
	pos2.y = 16100 + math.floor(math.random() * 2000)
	pos2.z = 16100 + math.floor(math.random() * 2000)
	
	count.x = math.floor(math.random() * 25) + 1
	count.y = math.floor(math.random() * 25) + 1
	count.z = math.floor(math.random() * 25) + 1
	
	io.write(ok..": ( "..pos1.x..", "..pos1.y..", "..pos1.z.." ) - ( "..pos2.x..", "..pos2.y..", "..pos2.z.." ), size ( ", count.x, ", ", count.y, ", ", count.z, " ) | ")
	
	local val_ref = count_chunks(pos1, pos2, count)
	local val_new = count_chunks_new(pos1, pos2, count)
	
	if val_ref == val_new then
		print("OK")
		ok = ok + 1
	else
		print("FAIL! ( "..val_ref.." / "..val_new.." )")
		failed = true
		break
	end
	
end

io.write(ok.." ok")
if failed then io.write(", 1 failed") end
print()
