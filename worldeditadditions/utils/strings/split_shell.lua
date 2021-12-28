-- worldeditadditions = { modpath="/home/sbrl/.minetest/worlds/Mod-Sandbox/worldmods/WorldEditAdditions/worldeditadditions/" }
local table_map = dofile(worldeditadditions.modpath.."/utils/tables/table_map.lua")

local function is_whitespace(char)
	return char:match("%s")
end

local function split_shell(text, autotrim)
	local text_length = #text
	local scan_pos = 1
	local result = {  }
	local acc = {}
	local mode = "NORMAL"	-- NORMAL, INSIDE_QUOTES_SINGLE, INSIDE_QUOTES_DOUBLE
	
	
	for i=1,text_length do
		local prevchar = ""
		local curchar = text:sub(i,i)
		local nextchar = ""
		local nextnextchar = ""
		if i > 1 then prevchar = text:sub(i-1, i-1) end
		if i < text_length then nextchar = text:sub(i+1, i+1) end
		if i+1 < text_length then nextnextchar = text:sub(i+2, i+2) end
		
		-- print("mode", mode, "prevchar", prevchar, "curchar", curchar, "nextchar", nextchar)
		
		if mode == "NORMAL" then
			if is_whitespace(curchar) and #acc > 0 then
				local nextval = worldeditadditions.trim(table.concat(acc, ""))
				if #nextval > 0 then
					table.insert(result, table.concat(acc, ""))
				end
				acc = {}
			elseif (curchar == "\"" or curchar == "'") and #acc == 0 and prevchar ~= "\\" then
				if curchar == "\"" then
					mode = "INSIDE_QUOTES_DOUBLE"
				else
					mode = "INSIDE_QUOTES_SINGLE"
				end
			else
				table.insert(acc, curchar)
			end
		elseif mode == "INSIDE_QUOTES_DOUBLE" then
			if curchar == "\"" and prevchar ~= "\\" and (is_whitespace(nextchar) or #nextchar == 0) then
				-- It's the end of a quote!
				mode = "NORMAL"
				
			elseif (curchar == "\\" and (
				nextchar ~= "\""
				or (nextchar == "\"" and not is_whitespace(nextnextchar))
			)) or curchar ~= "\\" then
				-- It's a regular character
				table.insert(acc, curchar)
			end
		elseif mode == "INSIDE_QUOTES_SINGLE" then
			if curchar == "'" and prevchar ~= "\\" and is_whitespace(nextchar) then
				-- It's the end of a quote!
				mode = "NORMAL"
			elseif (curchar == "\\" and (
				nextchar ~= "'"
				or (nextchar == "'" and not is_whitespace(nextnextchar))
			)) or curchar ~= "\\" then
				-- It's a regular character
				table.insert(acc, curchar)
			end
		end
	end
	
	if #acc > 0 then
		table.insert(result, table.concat(acc, ""))
	end
	
	-- Unwind all escapes by 1 level
	return table_map(result, function(str)
		return str:gsub("\\([\"'\\])", "%1")
	end)
end

return split_shell

-- local function test(text)
-- 	print("Source", text)
-- 	for i,value in ipairs(split_shell(text)) do
-- 		print("i", i, "→", value)
-- 	end
-- 	print("************")
-- end
-- 
-- test("yay yay yay")
-- test("dirt \"snow block\"")
-- test("yay \"yay yay\" yay")
-- test("yay \"yay\\\" yay\" yay")
-- test("yay \"yay 'inside quotes' yay\\\"\" yay")
-- test("yay 'inside quotes' another")
-- test("y\"ay \"yay 'in\\\"side quotes' yay\" y\\\"ay")
