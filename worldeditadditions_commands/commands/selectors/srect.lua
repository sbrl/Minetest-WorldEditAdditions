-- ███████ ██████  ███████  ██████ ████████
-- ██      ██   ██ ██      ██         ██
-- ███████ ██████  █████   ██         ██
--      ██ ██   ██ ██      ██         ██
-- ███████ ██   ██ ███████  ██████    ██
-- lua parse_params_srect("10")
-- local
function parse_params_srect(params_text)
  local find, _, sn1, ax1, sn2, ax2, len = params_text:find("([+-]?)([xyz]?)%s*([+-]?)([xyz]?)%s*(%d*)")

  -- If ax1 is nil set to player facing dir
  if ax1 == "" then ax1 = "get"
  else ax1 = {tonumber(sn1..1),string.lower(ax1)}
	end
  -- If ax2 is nil set to +y
  if ax2 == "" then ax2 = "y" end
  ax2 = {tonumber(sn2..1),string.lower(ax2)}

  len = tonumber(len)
  if len == nil then
    return false, "No length specified."
  end

  return true, ax1, ax2, len
end
worldedit.register_command("srect", {
	params = "[<axis1> [<axis2>]] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 2 axes.",
	privs = {worldedit=true},
  require_pos = 1,
  parse = function(params_text)
		local values = {parse_params_srect(params_text)}
		return unpack(values)
	end,
	func = function(name, axis1, axis2, len)
    if axis1 == "get" then axis1 = worldeditadditions.player_axis2d(name) end

		local pos1 = worldedit.pos1[name]
    local p2 = {["x"] = pos1.x,["y"] = pos1.y,["z"] = pos1.z}

    p2[axis1[2]] = p2[axis1[2]] + tonumber(len) * axis1[1]
    p2[axis2[2]] = p2[axis2[2]] + tonumber(len) * axis2[1]

		worldedit.pos2[name] = p2
		worldedit.mark_pos2(name)
		worldedit.player_notify(name, "position 2 set to " .. minetest.pos_to_string(p2))
	end,
})

-- Tests
-- params_text = "-x z 13"
