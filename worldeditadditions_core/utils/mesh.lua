local wea = worldeditadditions


-- ███████  █████   ██████ ███████
-- ██      ██   ██ ██      ██
-- █████   ███████ ██      █████
-- ██      ██   ██ ██      ██
-- ██      ██   ██  ██████ ███████

--- A single face of a Mesh.
-- @class
local Face = {}
Face.__index = Face

--- Creates a new face from a list of vertices.
-- The list of vertices should be anti-clockwise.
-- @param	vertices	Vector3[]	A list of Vector3 vertices that define the face.
function Face.new(vertices)
	local result = { vertices = vertices }
	setmetatable(result, Face)
	return result
end

--- Determines whether this face is equal to another face or not.
-- @param	a	Face	The first face to compare.
-- @param	b	Face	The second face to compare.
-- @returns	bool		Whether the 2 faces are equal or not.
function Face.equal(a, b)
	if #a.vertices ~= #b.vertices then return false end
	for i,vertex in ipairs(a) do
		if vertex ~= b.vertices[i] then return false end
	end
	return true
end
function Face.__eq(a, b) return Face.equal(a, b) end


-- ███    ███ ███████ ███████ ██   ██
-- ████  ████ ██      ██      ██   ██
-- ██ ████ ██ █████   ███████ ███████
-- ██  ██  ██ ██           ██ ██   ██
-- ██      ██ ███████ ███████ ██   ██

--- A mesh of faces.
-- @class
local Mesh = {}
Mesh.__index = Mesh

--- Creates a new empty mesh object container.
-- @returns	Mesh
function Mesh.new()
	local result = { faces = {} }
	setmetatable(result, Mesh)
end

--- Adds a face to this mesh.
-- @param	self	Mesh	The mesh instance to operate on.
-- @param	face	Face	The face to add.
-- @returns	void
function Mesh.add_face(self, face)
	table.insert(self.faces, face)
end

--- Deduplicate the list of faces in this Mesh.
-- Removes all faces that are exactly equal to one another. This reduces the
-- filesize.
-- @returns	number	The number of faces removed.
function Mesh.dedupe(self)
	-- Find the faces to remove
	local toremove = {}
	for i,face_check in ipairs(self.faces) do
		for j,face_next in ipairs(self.faces) do
			if i ~= j	-- If we're not comparing a face to itself...
				and face_check == face_next -- ....and the 2 faces are equal....
				and not wea.table.contains(toremove, j) then -- ...and we haven't already marked it for removal...
				-- Mark it for removal
				table.insert(toremove, j)
			end
		end
	end
	-- Sort the list of indexes marked for removal from largest to smallest
	-- This way, removing smaller items doesn't alter the index of larger ones
	table.sort(toremove, function(a, b) return a > b end)
	
	-- Remove the faces marked for removal
	for i, remove_index in ipairs(toremove) do
		table.remove(self.faces, remove_index)
	end
	return #toremove
end


return Mesh, Face
