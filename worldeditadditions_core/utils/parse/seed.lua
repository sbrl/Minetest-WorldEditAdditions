--- Makes a seed from a string.
-- If the input is a number, it is returned as-is.
-- If the input is a string and can be converted to a number with tonumber(),
-- the output of tonumber() is returned.
-- Otherwise, the string is converted to a number via a simple hashing algorithm
-- (caution: certainlly NOT crypto-secure!).
-- @param   {string}    str     The string to convert.
-- @source https://stackoverflow.com/a/2624210/1460422 The idea came from here
function worldeditadditions.parse.seed(str)
    if type(str) == "number" then return str end
    if tonumber(str) ~=  nil then return tonumber(str) end
    local result = 0
    for i = 1, #str do
        result = (result*91) + (string.byte(str:sub(i, i)) * 31)
    end
    return result
end
