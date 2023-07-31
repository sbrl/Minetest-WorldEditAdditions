-- Lists all currently loaded entities.

local weac = worldeditadditions_core

minetest.register_chatcommand("/listentities", {
	params = "",
	description =
	"Lists all currently loaded entities. This is a command for debugging and development. You will not need this unless you are developing a mod.",
	privs = { worldedit = true },
	func = function(name, params_text)
		local table_vals = {
			{ "ID", "Name", "Position" },
			{ "------", "-------", "---------" },
		}
		for id, obj in pairs(minetest.object_refs) do
			local obj_name = "[ObjectRef]"
			if obj.get_luaentity then
				local luaentity = obj:get_luaentity()
				if luaentity then
					obj_name = "[LuaEntity:"..luaentity.name.."]"
				else
					obj_name = "[LuaEntity:__UNKNOWN__]"
				end
			end
			local pos = weac.Vector3.clone(obj:get_pos())
			table.insert(table_vals, {
				id,
				obj_name,
				tostring(pos)
			})
		end
		worldedit.player_notify(name, table.concat({
			"Currently loaded entities:",
			weac.format.make_ascii_table(table_vals),
			"",
			"Total "..tostring(#table_vals).." objects"
		}, "\n"))
	end
})
