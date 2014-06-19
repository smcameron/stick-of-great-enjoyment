
module button_bulge(small_radius, large_radius, midsection_height)
{
	cyl_height = (large_radius - small_radius) * 2;

	union() {
		cylinder(h = midsection_height, r = large_radius, center = true);
		translate(v = [0, 0, 0.99 * (midsection_height / 2 + cyl_height / 2)])
			cylinder(h = cyl_height, r1 = large_radius, r2 = small_radius, center = true);
		translate(v = [0, 0, 0.99 * (-midsection_height / 2 - cyl_height / 2)])
			cylinder(h = cyl_height, r2 = large_radius, r1 = small_radius, center = true);
	}
}

module captive_button_shaft(button_radius, midsection_height, height)
{
	union() {
		cylinder(h = height, r = button_radius, center = true);
		button_bulge(button_radius, button_radius + 4, midsection_height);
	}
}

module captive_button(button_radius, travel, height)
{
	union() {
		difference() {
			cylinder(h = height, r = (button_radius + 4) + 4, center = true);
			captive_button_shaft(button_radius + 2, travel * 2, height + 5);
		}
		captive_button_shaft(button_radius, travel, height);
	}
}

/*
difference() {
	captive_button(5, 4, 100);
	cube(size = [20, 20, 200]);
}
*/

