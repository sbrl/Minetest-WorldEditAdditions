local json
if minetest == nil then
	json = require("json")
end

return function(source)
	if minetest ~= nil then
		return minetest.parse_json(source)
	else
		return json.decode(source)
	end
end