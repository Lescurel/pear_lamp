include <BOSL2/std.scad>

middle_radius=250;
upper_radius=100;
lower_radius=200;

middle_up = 100;
lower_middle = -100;

lamp_hole=20;
plywood=10;
paper=0.1;
part_width=20;

//middle
linear_extrude(plywood)
difference(){
    hexagon(or=middle_radius);
    hexagon(or=middle_radius-part_width);
};

// up
translate([0,0,middle_up])
linear_extrude(plywood)
difference(){
    hexagon(or=upper_radius);
    circle(lamp_hole);
};

//lower
translate([0,0,lower_middle])
linear_extrude(plywood)
difference(){
    hexagon(or=lower_radius);
    hexagon(or=lower_radius-part_width);
};


// connection
module connection(){
rotate([90,0,0])
linear_extrude(plywood, center=true)
union(){
polygon(
    [[middle_radius,plywood],
     [middle_radius-part_width,plywood],
     [upper_radius-part_width, middle_up],
     [upper_radius, middle_up]]
);
polygon(
    [[middle_radius,0],
     [middle_radius-part_width,0],
     [lower_radius-part_width, lower_middle],
     [lower_radius,lower_middle]]
);
};
};

// shades
module shade(shade_offset=20){
m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
u_segment_y = sqrt(pow(upper_radius,2)-pow(upper_radius/2,2));
l_segment_y = sqrt(pow(lower_radius,2)-pow(lower_radius/2,2));
length_shade = sqrt(pow(m_segment_y-u_segment_y,2)+pow(middle_up,2));
length_lower_shade = sqrt(pow(m_segment_y-l_segment_y,2)+pow(lower_middle,2));
echo(length_shade);
angle_shade = atan((middle_up)/(m_segment_y-u_segment_y));
angle_lower_shade = atan((lower_middle)/(m_segment_y-l_segment_y));

translate([0,m_segment_y,plywood])
rotate([-angle_shade,0,0])
linear_extrude(paper)
polygon(
    [[middle_radius/2-shade_offset, 0],
     [-middle_radius/2+shade_offset, 0],
     [-upper_radius/2+shade_offset, -length_shade],
     [upper_radius/2-shade_offset, -length_shade]]
);

translate([0,m_segment_y,0])
rotate([-angle_lower_shade,0,0])
linear_extrude(paper)
polygon(
    [[middle_radius/2-shade_offset, 0],
     [-middle_radius/2+shade_offset, 0],
     [-lower_radius/2+shade_offset, -length_lower_shade],
     [lower_radius/2-shade_offset, -length_lower_shade]]
);
};

for(i=[0:5]){
    rotate([0,0,i*60]) connection();
    rotate([0,0,i*60]) shade();
};