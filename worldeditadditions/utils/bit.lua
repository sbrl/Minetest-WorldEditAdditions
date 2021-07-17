-- ██████  ██ ████████
-- ██   ██ ██    ██
-- ██████  ██    ██
-- ██   ██ ██    ██
-- ██████  ██    ██

-- LuaJIT bit polyfill
-- @source https://github.com/Rabios/polyfill.lua/blob/master/polyfill.lua
-- Adapted for Minetest by Starbeamrainbowlabs
-- Note that this file is MIT licenced, and NOT MPL-2.0!
-- @licence MIT
-- Docs: http://bitop.luajit.org/api.html

-- module: bit
local bit = bit or {}

bit.bits = 32
bit.powtab = { 1 }

for b = 1, bit.bits - 1 do
	bit.powtab[#bit.powtab + 1] = math.pow(2, b)
end

-- Functions
-- bit.band
if not bit.band then
	bit.band = function(a, b)
		local result = 0
		for x = 1, bit.bits do
			result = result + result
			if (a < 0) then
				if (b < 0) then
					result = result + 1
				end
			end
			a = a + a
			b = b + b
		end
		return result
	end
end

-- bit.bor
if not bit.bor then
	bit.bor = function(a, b)
		local result = 0
		for x = 1, bit.bits do
			result = result + result
			if (a < 0) then
				result = result + 1
			elseif (b < 0) then
				result = result + 1
			end
			a = a + a
			b = b + b
		end
		return result
	end
end

-- bit.bnot
if not bit.bnot then
	bit.bnot = function(x)
		return bit.bxor(x, math.pow((bit.bits or math.floor(math.log(x, 2))), 2) - 1)
	end
end

-- bit.lshift
if not bit.lshift then
	bit.lshift = function(a, n)
		if (n > bit.bits) then
			a = 0
		else
			a = a * bit.powtab[n]
		end
		return a
	end
end

-- bit.rshift
if not bit.rshift then
	bit.rshift = function(a, n)
		if (n > bit.bits) then
			a = 0
		elseif (n > 0) then
			if (a < 0) then
				a = a - bit.powtab[#bit.powtab]
				a = a / bit.powtab[n]
				a = a + bit.powtab[bit.bits - n]
			else
				a = a / bit.powtab[n]
			end
		end
		return a
	end
end

-- bit.arshift
if not bit.arshift then
	bit.arshift = function(a, n)
		if (n >= bit.bits) then
			if (a < 0) then
				a = -1
			else
				a = 0
			end
		elseif (n > 0) then
			if (a < 0) then
				a = a - bit.powtab[#bit.powtab]
				a = a / bit.powtab[n]
				a = a - bit.powtab[bit.bits - n]
			else
				a = a / bit.powtab[n]
			end
		end
		return a
	end
end

-- bit.bxor
if not bit.bxor then
	bit.bxor = function(a, b)
		local result = 0
		for x = 1, bit.bits, 1 do
			result = result + result
			if (a < 0) then
				if (b >= 0) then
					result = result + 1
				end
			elseif (b < 0) then
				result = result + 1
			end
			a = a + a
			b = b + b
		end
		return result
	end
end

-- bit.rol
if not bit.rol then
	bit.rol = function(a, b)
		local bits = bit.band(b, bit.bits - 1)
		a = bit.band(a, 0xffffffff)
		a = bit.bor(bit.lshift(a, b), bit.rshift(a, ((bit.bits - 1) - b)))
		return bit.band(n, 0xffffffff)
	end
end

-- bit.ror
if not bit.ror then
	bit.ror = function(a, b)
		return bit.rol(a, - b)
	end
end

-- bit.bswap
if not bit.bswap then
	bit.bswap = function(n)
		local a = bit.band(n, 0xff)
		n = bit.rshift(n, 8)
		local b = bit.band(n, 0xff)
		n = bit.rshift(n, 8)
		local c = bit.band(n, 0xff)
		n = bit.rshift(n, 8)
		local d = bit.band(n, 0xff)
		return bit.lshift(bit.lshift(bit.lshift(a, 8) + b, 8) + c, 8) + d
	end
end

-- bit.tobit
if not bit.tobit then
	bit.tobit = function(n)
		local MOD = 2^32
		n = n % MOD
		if (n >= 0x80000000) then
			n = n - MOD
		end
		return n
	end
end

-- bit.tohex
if not bit.tohex then
	bit.tohex = function(x, n)
		n = n or 8
		local up
		if n <= 0 then
			if n == 0 then
				return ''
			end
			up = true
			n = -n
		end
		x = bit.band(x, 16^n - 1)
		return ('%0'..n..(up and 'X' or 'x')):format(x)
	end
end

return bit
