%.dxf: %.scad
	openscad -m make -o $@ $<
