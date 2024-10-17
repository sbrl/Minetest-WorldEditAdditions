-- Test registry
local test_id_paths = {
	"credits.test.lua",
	"notify.test.lua",
	"notify_bad.test.lua",
	"notify_suppress.test.lua",
	"stacktrace.test.lua",
}

-- Helper functions
local update = function(a,k,v) a[k] = v end

-- Test loader
local test_loader = function (path)
	for _, v in ipairs(test_id_paths) do dofile(path .. v) end
end

return test_loader