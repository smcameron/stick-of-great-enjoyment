$fn=200;

print_handle = 1;
print_short_axle_pair = 1;
print_axle_cap_pair = 1;
print_long_axle = 1;
print_base = 1;
print_rings = 1;
hole_thru_handle = 0;
print_base_platform = 1;
print_base_platform_cap = 1;

ring_radius = 35;
inner_ring_radius = ring_radius * 0.75; 
axle_radius = 5;
ring_height = axle_radius * 3;
tolerance = 0.05;

module half_ring(h, ir, or, holer)
{
	translate(v = [0, 0, h / 2])
	rotate(a = 180, v = [0, 1, 0]) {
		difference() {
			translate(v = [0, 0, h / 4])
				cube(size = [or * 2, or * 2, h / 2], center = true);
			/* cylinder(h = h / 2, r = or); */
				cube(size = [ir * 2, ir * 2, h * 4], center = true);
			rotate(a = 90, v = [0, 1, 0])
				cylinder(h = or * 2.5, r = holer, center=true);
			rotate(a = 90, v = [0, 1, 0])
				rotate(a = 90, v = [1, 0, 0])
					cylinder(h = or * 2.5, r = holer, center=true);
		}
	}
}

module rings(h, ir, or, holer)
{
	translate(v = [or * 1.1, 0, 0])
		half_ring(h, ir, or, holer);
	translate(v = [-or * 1.1, 0, 0])
		half_ring(h, ir, or, holer);
}

module base_post(w, d, h, r)
{
	translate(v = [0, 0, h / 2]) {
		difference() {
			cube(size = [w, d, h], center = true);
			translate(v = [0, 0, axle_radius * 2.5])
				rotate(a = 90, v = [0, 1, 0]) {
					cylinder(h = w * 1.5, r = r, center = true);
			}
		}
	}
}

module base(h)
{
	r = ring_radius + 12;
	translate(v = [0, 0, h / 2]) {
		difference() {
		cylinder(h = h, r = r, center=true);
		cylinder(h = h * 2, r = r * 0.5, center=true);
		translate(v = [-r + 6, 0, 0])
			scale(v = [1.05, 1.03, 1.03])
				base_post(8, axle_radius * 4, axle_radius * 8, axle_radius); 
		translate(v = [r - 6, 0, 0])
			scale(v = [1.05, 1.05, 1.05])
				base_post(8, axle_radius * 4, axle_radius * 8, axle_radius); 
		}
	}
}

module base_posts(h)
{
	r = ring_radius + 12;
	translate(v = [-r * 1.2, -r * 2, 4])
		rotate(a = 90, v = [0, 1, 0])
			base_post(8, axle_radius * 4, axle_radius * 8, axle_radius); 
	translate(v = [r * 0.4, -r * 2, 4])
		rotate(a = 90, v = [0, 1, 0])
			base_post(8, axle_radius * 4, axle_radius * 8, axle_radius); 
}

module base_platform(h)
{
	r = ring_radius + 12;
	difference() {
		union() {
			translate(v = [0, 0, h])
				cylinder(h = h * 2, r = r * 0.5 * 0.95, center=true);
			translate(v = [0, 0, h / 2])
			cylinder(h = h, r = r * 1.25, center=true);
		}
		cylinder(h = h * 5, r = r * 0.2, center=true);
	}
}

module base_platform_cap(h)
{
	r = ring_radius + 12;
	union() {
		translate(v = [0, 0, h * 3.0 / 2.0])
			cylinder(h = h * 3, r = (r * 0.2) - 1.5, center=true);
		translate(v = [0, 0, h / 4.0])
			cylinder(h = h / 2, r = r * 0.7, center=true);
	}
}

module handle_base()
{
	multmatrix(m = [ [1, 0.2, 0.1, 0],
			 [0.2, 1, 0.1, 0],
			 [0, 0, 1, 0],
			 [0, 0, 0, 1]
		       ]) {
		difference() {
			cylinder(r = 23, h = 10);
			translate(v = [0, 0, -5])
				cylinder(r = 10, h = 170);
		}
	}
}

module long_axle()
{
	h = ring_radius * 2 + 10;
	difference() {
	union() {
		cylinder(h = h, r = axle_radius * 0.95);
		translate(v = [0, 5, h / 2])
		rotate(a = 90, v = [1, 0, 0])
			rotate(a = 45, v = [0, 0, 1])
				handle_base();
	}
	translate(v = [0, 0, h / 2])
		scale(v = [1, 1, 2]) 
		rotate(a = 90, v = [1, 0, 0])
		cylinder(h = 20, r = 8, center = true);
	}
}

module short_axle()
{
	h = ring_radius - inner_ring_radius + 20; 
	union() {
		cylinder(h = h, r = axle_radius * 0.95);
		cylinder(h = 5, r = 2.0 * axle_radius * 0.95);
	}
}

module axle_cap()
{
	difference() {
		cylinder(h = 5, r = 2.0 * axle_radius * 0.95);
		translate(v = [0, 0, 2])
			cylinder(h = 5, r = axle_radius);
	}
}

module short_axle_pair() {
	translate(v = [0, -2.3 * axle_radius, 0])
		short_axle();
	translate(v = [0, 2.3 * axle_radius, 0])
		short_axle();
}

module axle_cap_pair() {
	translate(v = [0, -3.0 * axle_radius, 0])
		axle_cap();
	translate(v = [0, 3.0 * axle_radius, 0])
		axle_cap();
}
 
module finger_notch(angle, fingerwidth, offset)
{
	rotate(a = angle, v = [0, 0, 1])
		translate(v = [31, 0, offset * fingerwidth])
			rotate(a = 90, v = [1, 0, 0])
				cylinder(h = 40, r = 15, center=true);
}

module finger_notches(angle, fingerwidth)
{
	finger_notch(angle, fingerwidth, 1);
	finger_notch(angle, fingerwidth, 2);
	finger_notch(angle, fingerwidth, 3);
	finger_notch(angle, fingerwidth, 4);
}

module full_set_of_finger_notches(fingerwidth)
{
	finger_notches(0, fingerwidth);
	finger_notches(90, fingerwidth);
	finger_notches(45, fingerwidth);
	finger_notches(23, fingerwidth);
	finger_notches(23 + 45, fingerwidth);
}

module handle_stage1()
{
	fingerwidth = 25;
	multmatrix(m = [ [1, 0.2, 0.1, 0],
			 [0.2, 1, 0.1, 0],
			 [0, 0, 1, 0],
			 [0, 0, 0, 1]
		       ])  {
		difference() {
			union() {
				cylinder(r1 = 23, r2 = 17, h = 120);
				translate(v = [0, 0, 100])	
				cylinder(r1 = 17, r2 = 22, h = 30);
				intersection() {
				translate(v = [0, 0, 90])
					cylinder(h = 50, r1 = 6, r2 = 30);
				translate(v = [0, 0, 115])
					cylinder(h = 50, r1 = 40, r2 = 10);
				}
			}
			if (hole_thru_handle == 1) {
				translate(v = [0, 0, -5])
					cylinder(r = 10, h = 170);
			}
			full_set_of_finger_notches(fingerwidth);
		/*
			translate(v = [-18, 40, 110])
				rotate(a = -50, v = [1, 0, 0])
				rotate(a = 20, v = [0, 1, 0]) scale(v = [0.9, 1.2, 1])
					cylinder(h = 200, r1 = 31, r2 = 10, center = true);
		 */

		}
	}
}

module handle()
{
	if (print_handle == 1) {
		translate(v = [70, 0, 0])
			rotate(a = 45, v = [0, 0, 1]) {
				difference() {
					handle_stage1();
					translate(v = [0, 0, 180])
					rotate(a = -45, v = [0, 0, 1])
					rotate(a = -60, v = [1, 0, 0])
						cylinder(h = 100, r = 55, center = true);
				}
			}
	}
}

module all_of_it()
{
	if (print_rings == 1) {
		translate(v = [0, -ring_radius * 2.4, 0]) {
			rings(ring_height, inner_ring_radius, ring_radius, axle_radius);
		}
	}

	if (print_base == 1) {
		translate(v = [ring_radius * -1.9, 0, 0])
		base(8);
	}
	base_posts(8);
	if (print_long_axle == 1) {
		translate(v = [ring_radius * -1.9, 0, 0])
			long_axle();
	}
	if (print_axle_cap_pair == 1) {
		translate(v = [70, ring_radius * 2.5, 0])
			axle_cap_pair();
	}
	if (print_short_axle_pair == 1) {
		translate(v = [-80, ring_radius * 2.5, 0])
			short_axle_pair();
	}
	handle();
	if (print_base_platform == 1) {
		translate(v = [0, 100, 0])
			base_platform(8);
	}
	if (print_base_platform_cap == 1) {
		translate(v = [15, 0, 0])
			base_platform_cap(8);
	}
}

all_of_it();
