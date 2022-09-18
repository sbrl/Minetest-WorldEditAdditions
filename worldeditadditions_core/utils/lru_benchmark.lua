local LRU = require("lru")
local operations = 100000
local values = {
	"Abiu", "Açaí", "Acerola", "Ackee", "African cucumber", "Apple", "Apricot",
	"Avocado", "Banana", "Bilberry", "Blackberry", "Blackcurrant",
	"Black sapote", "Blueberry", "Boysenberry", "Breadfruit", "Cactus pear",
	"Canistel", "Cempedak", "Cherimoya", "Cherry", "Chico fruit", "Cloudberry",
	"Coco De Mer", "Coconut", "Crab apple", "Cranberry", "Currant", "Damson",
	"Date", "Dragonfruit (or Pitaya)", "Durian", "Egg Fruit", "Elderberry",
	"Feijoa", "Fig", "Finger Lime", "Goji berry", "Gooseberry", "Grape",
	"Raisin", "Grapefruit", "Grewia asiatica", "Guava", "Hala Fruit",
	"Honeyberry", "Huckleberry", "Jabuticaba", "Jackfruit", "Jambul",
	"Japanese plum", "Jostaberry", "Jujube", "Juniper berry", "Kaffir Lime",
	"Kiwano", "Kiwifruit", "Kumquat", "Lemon", "Lime", "Loganberry", "Longan",
	"Loquat"
}

-- From http://lua-users.org/wiki/SimpleRound
local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

--- Pads str to length len with char from right
-- @source https://snipplr.com/view/13092/strlpad--pad-string-to-the-left
local function str_padend(str, len, char)
	if char == nil then char = ' ' end
	return str .. string.rep(char, len - #str)
end
--- Pads str to length len with char from left
-- Adapted from the above
local function str_padstart(str, len, char)
	if char == nil then char = ' ' end
	return string.rep(char, len - #str) .. str
end


local values_count = #values

local function test(size)
	local cpu_start = os.clock()
	
	
	local lru = LRU.new(size)
	
	local hits = 0
	local misses = 0
	for i=1,operations do
		local key = values[math.random(1, values_count)]
		if math.random() >= 0.5 then
			-- set
			lru:set(key, math.random())
		else
			-- get
			if lru:get(key) == nil then
				misses = misses + 1
				lru:set(key, math.random())
			else
				hits = hits + 1
			end
		end
	end
	
	
	local cpu_end = os.clock()
	print(
		size,
		str_padend(tostring(round(cpu_end - cpu_start, 6)), 9),
		hits, misses,
		((hits/operations)*100)
	)
end


io.stderr:write("OPERATIONS\t"..operations.."\n")
print("size", "cpu time", "hits", "misses", "hit ratio (%)")
for i=3,256 do
	io.stderr:write("size "..i.."\r")
	test(i)
	
end
