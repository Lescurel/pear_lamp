include <lamp.scad>

width_shade = middle_radius - 2*shade_offset;

m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
u_segment_y = sqrt(pow(upper_radius,2)-pow(upper_radius/2,2));
length_shade = sqrt(pow(m_segment_y-u_segment_y,2)+pow(middle_up,2));
u_width = upper_radius - 2*shade_offset;

m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
l_segment_y = sqrt(pow(lower_radius,2)-pow(lower_radius/2,2));
length_lower_shade = sqrt(pow(m_segment_y-l_segment_y,2)+pow(lower_middle,2));
l_width = lower_radius - 2*shade_offset;

union(){
2d_upper_shade(shade_offset);
translate([-width_shade/2,0,0])
square([width_shade,plywood]);
translate([0,plywood,0])
rotate([0,0,180])
2d_lower_shade(shade_offset);

//tabs
translate([-u_width/2, -length_shade-part_width])
square([u_width,part_width]);
translate([-l_width/2, length_lower_shade])
square([l_width,part_width]);
};