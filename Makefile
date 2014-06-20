
all:	joystick-plate-1.stl joystick-plate-2.stl joystick-plate-3.stl

joystick-plate-1.stl:	joystick.scad captive-button.scad
	openscad -o joystick-plate-1.stl -D print_plate_1=1 \
		-D print_plate_2=0 -D print_plate_3=0 \
		-D show_replicator_build_plate=0 \
		-D show_replicator_build_volume=0 joystick.scad

joystick-plate-2.stl:	joystick.scad captive-button.scad
	openscad -o joystick-plate-2.stl -D print_plate_1=0 \
		-D print_plate_2=1 -D print_plate_3=0 \
		-D show_replicator_build_plate=0 \
		-D show_replicator_build_volume=0 joystick.scad

joystick-plate-3.stl:	joystick.scad captive-button.scad
	openscad -o joystick-plate-3.stl -D print_plate_1=0 \
		-D print_plate_2=0 -D print_plate_3=1 \
		-D show_replicator_build_plate=0 \
		-D show_replicator_build_volume=0 joystick.scad

clean:
	rm -f joystick-plate-1.stl \
		joystick-plate-2.stl \
		joystick-plate-3.stl
