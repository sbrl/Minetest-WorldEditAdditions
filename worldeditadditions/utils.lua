worldeditadditions.vector = {}

function worldeditadditions.vector.tostring(v)
	return "(" .. v.x ..", " .. v.y ..", " .. v.z ..")"
end

function worldeditadditions.vector.lengthsquared(v)
	return v.x*v.x + v.y*v.y + v.z*v.z
end

function worldeditadditions.vector.floor(v)
	v.x = math.floor(v.x)
	v.y = math.floor(v.y)
	v.z = math.floor(v.z)
end
