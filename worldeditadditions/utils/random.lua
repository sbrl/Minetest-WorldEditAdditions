--- Implementation of the xoshiro++ random number generation algorithm.
-- Ported from C by Starbeamrainbowlabs
-- @ref https://en.wikipedia.org/wiki/Xorshift#xoshiro_and_xoroshiro
-- @class
local Xoshiro = {}
Xoshiro.__index = Xoshiro

--- Creates a new Xoshiro instance.
-- @returns		Xoshiro		The new Xoshiro instance.
function Xoshiro.new(seed)
	seed = seed or 4898416254654
	local result = {
		state = {
			34862381629 ^ seed,
			87782734023 ^ seed,
			59217486042 ^ seed,
			68724585416 ^ seed
		}
	}
	setmetatable(result, Xoshiro)
	return result
end

--- Polyfill for the bitshift left operator that's missing in Lua.
-- @source https://ebens.me/post/simulate-bitwise-shift-operators-in-lua/
-- @param	value	number	The number to bitshift left.
-- @param	places	number	The number of bits to shift it by to the left.
function Xoshiro._bitshift_left(value, places)
	return value * 2 ^ places
end

--- Polyfill for the bitshift right operator that's missing in Lua.
-- @source https://ebens.me/post/simulate-bitwise-shift-operators-in-lua/
-- @param	value	number	The number to bitshift right.
-- @param	places	number	The number of bits to shift it by to the right.
function Xoshiro._bitshift_right(value, places)
	return math.floor(value / 2 ^ places)
end

-- Bitwise OR polyfill.
-- The source also has polyfills for bitwise AND, NOT, and XOR.
-- @source https://stackoverflow.com/a/25594410/1460422
-- @param	a	number	The left-hand argument to the bitwise or operation.
-- @param	b	number	The right-hand argument to the bitwise or operation.
-- @returns	number		The result of the bitwise or operation.
function Xoshiro._bitwise_or(a,b)
    local p,c=1,0
    while a+b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>0 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end

-- Bitwise XOR polyfill.
-- The source also has polyfills for bitwise AND, OR, and NOT.
-- @source https://stackoverflow.com/a/25594410/1460422
-- @param	a	number	The left-hand argument to the bitwise xor operation.
-- @param	b	number	The right-hand argument to the bitwise xor operation.
-- @returns	number		The result of the bitwise xor operation.
function Xoshiro._bitwise_xor(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end


function Xoshiro._rol64(x, k)
	return Xoshiro._bitwise_or(
		Xoshiro._bitshift_left(x, k),
		Xoshiro._bitshift_right(x, 64 - k)
	)
end

function Xoshiro.random_raw(self)
	local result = self.state[1] + self.state[4]
	local t = Xoshiro._bitshift_right(self.state[2], 17)
	
	self.state[3] = Xoshiro._bitwise_xor(self.state[3], self.state[1])
	self.state[4] = Xoshiro._bitwise_xor(self.state[4], self.state[2])
	self.state[2] = Xoshiro._bitwise_xor(self.state[2], self.state[3])
	self.state[1] = Xoshiro._bitwise_xor(self.state[1], self.state[4])
	
	self.state[3] = Xoshiro._bitwise_xor(self.state[3], t)
	self.state[4] = Xoshiro._rol64(self.state[4], 45)
	
	return result
end

function Xoshiro.random(self)
	return self:random_raw()
end

print("_G", _G)

for key,value in pairs(_G) do
	print(key, "→", value)
end

return Xoshiro
