-- Test registry
local test_id_paths = {
	"notify.test.lua",
	-- "stacktrace.test.lua",
}

-- Helper functions
local update = function(a,k,v) a[k] = v end

-- Test loader
local test_loader = function (path)
	local ret = {}
	for _, v in ipairs(test_id_paths) do
		update(ret, dofile(path .. v))
	end
	return ret
end

return test_loader