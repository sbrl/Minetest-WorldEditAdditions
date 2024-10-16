-- ████████  ███████  ███████  ████████ 
--    ██     ██       ██          ██    
--    ██     █████    ███████     ██    
--    ██     ██            ██     ██    
--    ██     ███████  ███████     ██    

-- ██   ██   █████   ███    ██  ██████   ██       ███████  ██████  
-- ██   ██  ██   ██  ████   ██  ██   ██  ██       ██       ██   ██ 
-- ███████  ███████  ██ ██  ██  ██   ██  ██       █████    ██████  
-- ██   ██  ██   ██  ██  ██ ██  ██   ██  ██       ██       ██   ██ 
-- ██   ██  ██   ██  ██   ████  ██████   ███████  ███████  ██   ██ 

-- Metatable for tests
local metatable = {
	__call = function(self,name, ...)
		return xpcall(self.func, debug.traceback, name, ...)
	end,
	help = function(self)
		return "Params: " .. self.params .. "\n" .. self.description
	end
}
metatable.__index = metatable

local registered_tests = {}

local register_test = function(test_name, def)
	---
	-- 1: Validation
	---
	if type(test_name) ~= "string" then
		error("The test name is not a string.")
	end
	if type(def) ~= "table" then
		error("The test definition is not a table.")
	end
	if type(def.description) ~= "string" then
		error("The test description is not a string.")
	end
	if type(def.params) ~= "string" or #def.params == 0 then
		error("The test params param is not valid.")
	end
	if type(def.func) ~= "function" then
		error("The test function is not a function.")
	end
	
	---
	-- 2: Normalisation
	---
	setmetatable(def, metatable)
	registered_tests[test_name] = def
end

local normalize_test = {}
normalize_test.__index = normalize_test

normalize_test.__call = function(self, test_name, def)
	register_test(test_name, def)
end

normalize_test.get_registered_tests = function()
	local ret = {}
	for k, v in pairs(registered_tests) do
		ret[k] = v
	end
	return ret
end

return setmetatable({}, normalize_test)