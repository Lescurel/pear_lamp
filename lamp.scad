middle_radius=250;
upper_radius=100;
lower_radius=200;

middle_up = 120;
lower_middle = -80;

lamp_hole_radius=20;
plywood=10;
paper=0.1;
part_width=20;
slot_width=5;
shade_offset=15;

module hexagon(or){
    polygon([for(t=[0:5]) [cos(t*60)*or,sin(t*60)*or]]);
};

module 2d_connection(){
    chamfer=plywood/(2*tan(60));
    union(){
    // upper connection
    polygon(
        [[middle_radius-chamfer,plywood],
         [middle_radius-part_width,plywood],
         [upper_radius-chamfer, middle_up-slot_width],
         [upper_radius-chamfer, middle_up+plywood+slot_width]]
    );
    // upper slot
    translate([upper_radius-chamfer-part_width,middle_up-slot_width,0]) square([part_width,slot_width]);
    translate([upper_radius-chamfer-part_width,middle_up+plywood,0]) square([part_width,slot_width]);
    // lower connection
    polygon(
        [[middle_radius-chamfer,0],
         [middle_radius-part_width,0],
         [lower_radius-chamfer, lower_middle+plywood+slot_width],
         [lower_radius-chamfer,lower_middle-slot_width]]
    );
    // lower slot
    translate([lower_radius-chamfer-part_width,lower_middle-slot_width,0]) square([part_width,slot_width]);
    translate([lower_radius-chamfer-part_width,lower_middle+plywood,0]) square([part_width,slot_width]);
    // middle slot
    translate([middle_radius-part_width-plywood,0,0]) square([plywood,1.5*plywood]);
    translate([middle_radius-part_width-plywood,0,0])
    difference(){
        scale([1,2.5,1]) circle(r=plywood);    
        translate([-plywood, 0,0])scale([1,4,1]) circle(r=plywood);
        };
    };
};

// connection
module connection(){    
    rotate([90,0,0])
    linear_extrude(plywood, center=true) 2d_connection();
};

// shades
module shade(shade_offset=20){
    m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
    u_segment_y = sqrt(pow(upper_radius,2)-pow(upper_radius/2,2));
    l_segment_y = sqrt(pow(lower_radius,2)-pow(lower_radius/2,2));
    length_shade = sqrt(pow(m_segment_y-u_segment_y,2)+pow(middle_up,2));
    length_lower_shade = sqrt(pow(m_segment_y-l_segment_y,2)+pow(lower_middle,2));
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

module lamp(){
    union(){
        //middle
        linear_extrude(plywood)
        difference(){
            offset(delta=2*plywood,chamfer=true)offset(delta=-2*plywood)
            hexagon(or=middle_radius);
            offset(delta=2*plywood, chamfer=true)
            hexagon(or=middle_radius-part_width-2*plywood);
        };

        // up
        translate([0,0,middle_up])
        linear_extrude(plywood)
        union(){
        difference(){
            offset(delta=2*plywood,chamfer=true)offset(delta=-2*plywood)
            hexagon(or=upper_radius);
            hexagon(or=upper_radius-part_width);
        };
        difference(){
            hexagon(or=lamp_hole_radius+part_width);
            circle(lamp_hole_radius);
        };
        for(i=[0:5]) rotate([0,0,i*60])
        translate([(upper_radius-lamp_hole_radius-part_width)/2+lamp_hole_radius,0,0])
        square([upper_radius-lamp_hole_radius-part_width, part_width], center=true);

        };

        //lower
        translate([0,0,lower_middle])
        linear_extrude(plywood)
        difference(){
            offset(delta=2*plywood,chamfer=true)offset(delta=-2*plywood)
            hexagon(or=lower_radius);
            hexagon(or=lower_radius-part_width);
        };

        for(i=[0:5]){
            rotate([0,0,i*60]) connection();
            rotate([0,0,i*60]) shade(shade_offset=shade_offset);
        };
    };
};