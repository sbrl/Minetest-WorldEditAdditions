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

local bit_local

if minetest.global_exists("bit") then
	bit_local = bit
else
	bit_local = {
		bits = 32,
		powtab = { 1 }
	}	
	for b = 1, bit_local.bits - 1 do
		bit_local.powtab[#bit_local.powtab + 1] = math.pow(2, b)
	end
end


-- Functions
-- bit_local.band
if not bit_local.band then
	bit_local.band = function(a, b)
		local result = 0
		for x = 1, bit_local.bits do
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

-- bit_local.bor
if not bit_local.bor then
	bit_local.bor = function(a, b)
		local result = 0
		for x = 1, bit_local.bits do
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

-- bit_local.bnot
if not bit_local.bnot then
	bit_local.bnot = function(x)
		return bit_local.bxor(x, math.pow((bit_local.bits or math.floor(math.log(x, 2))), 2) - 1)
	end
end

-- bit_local.lshift
if not bit_local.lshift then
	bit_local.lshift = function(a, n)
		if (n > bit_local.bits) then
			a = 0
		else
			a = a * bit_local.powtab[n]
		end
		return a
	end
end

-- bit_local.rshift
if not bit_local.rshift then
	bit_local.rshift = function(a, n)
		if (n > bit_local.bits) then
			a = 0
		elseif (n > 0) then
			if (a < 0) then
				a = a - bit_local.powtab[#bit_local.powtab]
				a = a / bit_local.powtab[n]
				a = a + bit_local.powtab[bit_local.bits - n]
			else
				a = a / bit_local.powtab[n]
			end
		end
		return a
	end
end

-- bit_local.arshift
if not bit_local.arshift then
	bit_local.arshift = function(a, n)
		if (n >= bit_local.bits) then
			if (a < 0) then
				a = -1
			else
				a = 0
			end
		elseif (n > 0) then
			if (a < 0) then
				a = a - bit_local.powtab[#bit_local.powtab]
				a = a / bit_local.powtab[n]
				a = a - bit_local.powtab[bit_local.bits - n]
			else
				a = a / bit_local.powtab[n]
			end
		end
		return a
	end
end

-- bit_local.bxor
if not bit_local.bxor then
	bit_local.bxor = function(a, b)
		local result = 0
		for x = 1, bit_local.bits, 1 do
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

-- bit_local.rol
if not bit_local.rol then
	bit_local.rol = function(a, b)
		local bits = bit_local.band(b, bit_local.bits - 1)
		a = bit_local.band(a, 0xffffffff)
		a = bit_local.bor(bit_local.lshift(a, b), bit_local.rshift(a, ((bit_local.bits - 1) - b)))
		return bit_local.band(n, 0xffffffff)
	end
end

-- bit_local.ror
if not bit_local.ror then
	bit_local.ror = function(a, b)
		return bit_local.rol(a, - b)
	end
end

-- bit_local.bswap
if not bit_local.bswap then
	bit_local.bswap = function(n)
		local a = bit_local.band(n, 0xff)
		n = bit_local.rshift(n, 8)
		local b = bit_local.band(n, 0xff)
		n = bit_local.rshift(n, 8)
		local c = bit_local.band(n, 0xff)
		n = bit_local.rshift(n, 8)
		local d = bit_local.band(n, 0xff)
		return bit_local.lshift(bit_local.lshift(bit_local.lshift(a, 8) + b, 8) + c, 8) + d
	end
end

-- bit_local.tobit
if not bit_local.tobit then
	bit_local.tobit = function(n)
		local MOD = 2^32
		n = n % MOD
		if (n >= 0x80000000) then
			n = n - MOD
		end
		return n
	end
end

-- bit_local.tohex
if not bit_local.tohex then
	bit_local.tohex = function(x, n)
		n = n or 8
		local up
		if n <= 0 then
			if n == 0 then
				return ''
			end
			up = true
			n = -n
		end
		x = bit_local.band(x, 16^n - 1)
		return ('%0'..n..(up and 'X' or 'x')):format(x)
	end
end

return bit_local
