#!/usr/bin/env node

/**
 * Rotate a given point around an origin point in 3d space.
 * NOTE: This function is not as intuitive as it sounds.
 * A whiteboard and a head for mathematics is recommended before using this
 * function.
 * @source	GitHub Copilot
 * @warning	Not completely tested! Pending a thorough evaluation.
 * @param	{Vector3}	origin	The origin point to rotate around
 * @param	{Vector3}	point	The point to rotate.
 * @param	{Number}	x	Rotate this much around the X axis (yz plane), in radians.
 * @param	{Number}	y	Rotate this much around the Y axis (xz plane), in radians.
 * @param	{Number}	z	Rotate this much around the Z axis (xy plane), in radians.
 * @return	{Vector3}	The rotated point.
 */
function rotate_point_3d(origin, point, x, y, z)
{
	point = [...point];
	point[0] = point[0] - origin[0];
	point[1] = point[1] - origin[1];
	point[2] = point[2] - origin[2];
	
	// rotate around x
	var x1 = point[0];
	var y1 = point[1] * Math.cos(x) - point[2] * Math.sin(x);
	var z1 = point[1] * Math.sin(x) + point[2] * Math.cos(x);

	// rotate around y
	var x2 = x1 * Math.cos(y) + z1 * Math.sin(y);
	var y2 = y1;
	var z2 = -x1 * Math.sin(y) + z1 * Math.cos(y);

	// rotate around z
	var x3 = x2 * Math.cos(z) - y2 * Math.sin(z);
	var y3 = x2 * Math.sin(z) + y2 * Math.cos(z);
	var z3 = z2;
	
	return [x3+origin[0], y3+origin[1], z3+origin[2]];
}

function deg_to_rad(deg)
{
	return deg * Math.PI / 180;
}

function point_to_string(point, decimal_places=3)
{
	return "(x " + point[0].toFixed(decimal_places) + ", y " + point[1].toFixed(decimal_places) + ", z " + point[2].toFixed(decimal_places) + ")";
}

function do_test(origin, point, ...args) {
	const result = rotate_point_3d(origin, point, ...args);
	console.log(`ORIGIN`, point_to_string(origin), `\tPOINT`, point_to_string(point), `\tRESULT`, point_to_string(result));
}

do_test(
	[1, 0, 0],
	[5, 0, 0],
	deg_to_rad(0),		// rotate around x axis = yz plane
	deg_to_rad(0),		// rotate around y axis = xz plane
	deg_to_rad(180)		// rotate around z axis = xy plane
);
do_test(
	[1, 0, 0],
	[0, 1, 0],
	deg_to_rad(0),		// rotate around x axis = yz plane
	deg_to_rad(0),		// rotate around y axis = xz plane
	deg_to_rad(180)		// rotate around z axis = xy plane
);
do_test(
	[10, 100, 0],
	[0, 0, 0],
	deg_to_rad(0),		// rotate around x axis = yz plane
	deg_to_rad(0),		// rotate around y axis = xz plane
	deg_to_rad(180)		// rotate around z axis = xy plane
);