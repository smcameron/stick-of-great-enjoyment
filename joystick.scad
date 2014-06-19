$fn=200;

print_handle = 1;
print_short_axle_pair = 1;
print_axle_cap_pair = 1;
print_long_axle = 1;
print_base_posts = 1;
print_base = 1;
print_rings = 1;
hole_thru_handle = 0;
print_base_platform = 1;
print_base_platform_cap = 1;

print_plate_1 = 1;
print_plate_2 = 1;
print_plate_3 = 1;

show_replicator_build_plate = 1;
show_replicator_build_volume = 1;

ring_radius = 45;
inner_ring_radius = ring_radius * 0.75; 
axle_radius = 5;
axle_hole_radius = axle_radius + 1;
ring_height = axle_radius * 4;
tolerance = 0.05;

inches_to_mm = 25.4;

plate_1_offset = 0;
plate_2_offset = (print_plate_1 * 6.5 * inches_to_mm); 
plate_3_offset = (print_plate_1 + print_plate_2) * 6.5 * inches_to_mm;

module build_plate()
{
	if (show_replicator_build_plate == 1) {
		translate(v = [0, 0, -2.5]) {
			color([1.0, 0.0, 1.0, 0.5])
				cube(size = [11.2 * inches_to_mm, 6.0 * inches_to_mm, 5],
					center = true);
		}
	}
}

module build_volume()
{
	if (show_replicator_build_volume == 1) {
		translate(v = [0, 0, 6.1 * inches_to_mm / 2]) {
			color([0.0, 1.0, 0.0, 0.5])
				cube(size = [11.2 * inches_to_mm, 6.0 * inches_to_mm,
						6.1 * inches_to_mm], center = true);
		}
	}
}

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
	translate(v = [0, plate_1_offset, 0]) {
		translate(v = [or * 1.1, 0, 0])
			half_ring(h, ir, or, holer);
		translate(v = [-or * 1.1, 0, 0])
			half_ring(h, ir, or, holer);
	}
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
	r = ring_radius + 16;
	translate(v = [0, 0, h / 2]) {
		difference() {
		cylinder(h = h, r = r, center=true);
		cylinder(h = h * 2, r = r * 0.5, center=true);
		translate(v = [-r + 8, 0, 0])
			base_post(8 + 1, axle_radius * 4 + 1, axle_radius * 8.5, axle_hole_radius); 
		translate(v = [r - 8, 0, 0])
			base_post(8 + 1, axle_radius * 4 + 1, axle_radius * 8.5, axle_hole_radius); 
		}
	}
}

module base_posts(h)
{
	r = ring_radius + 16;
	translate(v = [-r * 1.2, 0, 4])
		rotate(a = 90, v = [0, 1, 0])
			base_post(8, axle_radius * 4, axle_radius * 8.5, axle_hole_radius); 
	translate(v = [r * 0.4, 0, 4])
		rotate(a = 90, v = [0, 1, 0])
			base_post(8, axle_radius * 4, axle_radius * 8.5, axle_hole_radius); 
}

module base_platform(h)
{
	r = ring_radius + 16;
	difference() {
		union() {
			translate(v = [0, 0, h])
				cylinder(h = h * 2, r = r * 0.5 * 0.95, center=true);
			translate(v = [0, 0, h / 2])
			cylinder(h = h, r = r * 1.20, center=true);
		}
		cylinder(h = h * 5, r = r * 0.2, center=true);
	}
}

module base_platform_cap(h)
{
	r = ring_radius + 16;
	post_height = h * 2 + h / 2;
	union() {
		translate(v = [0, 0, h * 3.0 / 2.0])
			cylinder(h = post_height, r = (r * 0.2) - 1, center=true);
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
			cylinder(h = 5, r = axle_hole_radius);
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

module finger_notches(angle, fingerwidth, xtranslate)
{
	translate(v = [2, 2, 0]) {
		translate(v = [0, 0, 0])
			finger_notch(angle, fingerwidth, 1);
		translate(v = [-2, -2, 0])
			finger_notch(angle, fingerwidth, 2);
		translate(v = [-4, -4, 0])
			finger_notch(angle, fingerwidth, 3);
		translate(v = [-6, -6, 0])
			finger_notch(angle, fingerwidth, 4);
	}
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

module handle_helper(zr, zh)
{
	difference() {
		handle_stage1();
		translate(v = [0, 0, 180])
		rotate(a = -45, v = [0, 0, 1])
		rotate(a = -60, v = [1, 0, 0])
			/* cylinder(h = 100, r = 55, center = true); */
			cube(size = [110, 110, 100], center = true);
		color([1.0, 0.0, 1.0, 0.5]) {
		  rotate(a = 45, v = [0, 0, 1])
		    translate(v = [15, 0, 139])
		      rotate(a = -33, v = [0, 1, 0])
			scale(v = [0.6 * 1, 0.6 * 0.60, 0.6 * 1]) {
			  difference() {
			    cylinder(h = zh, r1 = zr, r2 = 0, center = true);
			    translate(v = [0, 0, -10])
			      cylinder(h = zh, r1 = zr, r2 = 0, center = true);
			    translate(v = [0, 0, 20])
			      cylinder(h = zh, r1 = zr + 10, r2 = 60, center = true);
			  }
			}
	      }
	}
}

module handle()
{
	zr = 75;
	zh = 60;
	if (print_handle == 1 && print_plate_2) {
		translate(v = [110, plate_2_offset, 0])
			rotate(a = 45, v = [0, 0, 1]) {
				handle_helper(zr, zh);
			}
	}
}

module all_of_it()
{
	if (print_rings == 1 && print_plate_1 == 1) {
		translate(v = [0, 0, 0]) {
			rings(ring_height, inner_ring_radius, ring_radius, axle_hole_radius);
		}
	}

	if (print_base == 1 && print_plate_2) {
		translate(v = [ring_radius * -1.7, plate_2_offset, 0])
		base(8);
	}
	if (print_base_posts && print_plate_1) {
		translate(v = [0, plate_1_offset, 0])
			base_posts(8);
	}
	if (print_long_axle == 1 && print_plate_1) {
		translate(v = [50, plate_1_offset + 20, 0])
			long_axle();
	}
	if (print_axle_cap_pair == 1 && print_plate_1) {
		translate(v = [120, plate_1_offset, 0])
			axle_cap_pair();
	}
	if (print_short_axle_pair == 1 && print_plate_1) {
		translate(v = [-120, plate_1_offset, 0])
			short_axle_pair();
	}
	handle();
	if (print_base_platform == 1 && print_plate_3) {
		translate(v = [0, plate_3_offset, 0])
			base_platform(8);
	}
	if (print_base_platform_cap == 1 && print_plate_2) {
		translate(v = [35, plate_2_offset, 0])
			base_platform_cap(8);
	}
}

all_of_it();

build_plate();
build_volume();

