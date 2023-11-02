include <BOSL2/std.scad>

middle_diameter=500;
upper_diameter=150;
lower_diameter=400;

middle_up = 150;
lower_middle = -100;

lamp_hole=40;
plywood=15;
part_width=20;

//middle
linear_extrude(plywood)
difference(){
    hexagon(or=middle_diameter);
    hexagon(or=middle_diameter-part_width);
};

// up
translate([0,0,middle_up])
linear_extrude(plywood)
difference(){
    hexagon(or=upper_diameter);
    circle(lamp_hole);
};

//lower
translate([0,0,lower_middle])
linear_extrude(plywood)
difference(){
    hexagon(or=lower_diameter);
    hexagon(or=lower_diameter-part_width);
};


// connection
module connection(){
rotate([90,0,0])
linear_extrude(plywood)
union(){
polygon(
    [[middle_diameter,plywood],
     [middle_diameter-part_width,plywood],
     [upper_diameter-part_width, middle_up],
     [upper_diameter, middle_up]]
);
polygon(
    [[middle_diameter,0],
     [middle_diameter-part_width,0],
     [lower_diameter-part_width, lower_middle],
     [lower_diameter,lower_middle]]
);
};
};

for(i=[0:5]){
    rotate([0,0,i*60]) connection();
};
