Xoshiro = require("random")

rand = Xoshiro.new()

print(rand)

for i=1,25 do
	print(i, "→", rand:random())
end
