local z_pos = {
	right = {
		axis = "x",
		sign = 1
	},
	x = 0.30876246094704,
	y = -0.22614130377769,
	up = {
		axis = "y",
		sign = 1
	},
	left = {
		axis = "x",
		sign = -1
	},
	back = {
		axis = "z",
		sign = -1
	},
	front = {
		axis = "z",
		sign = 1
	},
	down = {
		axis = "y",
		sign = -1
	},
	z = 0.92386466264725,
	facing = {
		axis = "z",
		sign = 1
	}
}

local x_pos = {
	right = {
		axis = "z",
		sign = -1
	},
	x = 0.9800808429718,
	y = -0.095324546098709,
	up = {
		axis = "y",
		sign = 1
	},
	left = {
		axis = "z",
		sign = 1
	},
	back = {
		axis = "x",
		sign = -1
	},
	front = {
		axis = "x",
		sign = 1
	},
	down = {
		axis = "y",
		sign = -1
	},
	z = -0.17422623932362,
	facing = {
		axis = "x",
		sign = 1
	}
}

local z_neg = {
	right = {
		axis = "x",
		sign = -1
	},
	x = -0.29956161975861,
	y = -0.16453117132187,
	up = {
		axis = "y",
		sign = 1,
	},
	left = {
		axis = "x",
		sign = 1,
	},
	back = {
		axis = "z",
		sign = 1
	},
	front = {
		axis = "z",
		sign = -1
	},
	down = {
		axis = "y",
		sign = -1
	},
	z = -0.93978309631348,
	facing = {
		axis = "z",
		sign = -1
	}
}

local x_neg = {
	right = {
		axis = "z",
		sign = 1
	},
	x = -0.96041119098663,
	y = -0.20227454602718,
	up = {
		axis = "y",
		sign = 1
	},
	left = {
		axis = "z",
		sign = -1
	},
	back = {
		axis = "x",
		sign = 1
	},
	front = {
		axis = "x",
		sign = -1
	},
	down = {
		axis = "y",
		sign = -1
	},
	z = 0.19156044721603,
	facing = {
		axis = "x",
		sign = -1
	}
}

return {
	x_pos = x_pos,
	z_pos = z_pos,
	x_neg = x_neg,
	z_neg = z_neg
}
