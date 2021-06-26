--- Split into table of characters.
-- @param	text	string	The string to iterate over
-- @param	sort	bool	Sort characters
-- @param	rem_dups	bool	Remove duplicate characters
-- @returns	table	A sequence table containing the substrings
function worldeditadditions.tochars(text,sort,rem_dups)
	local t, set = {}, {}
	if rem_dups then
		text:gsub(".",function(c) set[c] = true end)
		for k,v in pairs(set) do table.insert(t,k) end
	else
		text:gsub(".",function(c) table.insert(t,c) end)
	end
	
	if sort then table.sort(t) end
	
	return t
end

--- Split into a set of characters.
-- @param	text	string	The string to iterate over
-- @returns	table	A sequence set table containing the substrings
function worldeditadditions.tocharset(text)
	local t = {}
	text:gsub(".",function(c) t[c] = true end)
	return t
end
