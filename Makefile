%.dxf: %.scad
	openscad -m make -o $@ $<
%.svg : %.scad
	openscad -m make -o $@ $<
%.stl: %.scad
	openscad -m make -o $@ $<
release: upper.dxf
release: middle.dxf
release: lower.dxf
release: clamp.dxf
release: connection.dxf
release: shade.svg
release: lamp.stl
clean: $(PHONY)
	rm *.dxf *.svg *.stl
