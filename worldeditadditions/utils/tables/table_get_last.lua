--- Returns only the last count items in a given numerical table-based list.
function worldeditadditions.table_get_last(tbl, count)
	return {worldeditadditions.table_unpack(
		tbl,
		math.max(0, (#tbl) - (count - 1))
	)}
end
