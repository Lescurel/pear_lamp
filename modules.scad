// Radius of the 3 hexagonal planes
middle_radius=250;
upper_radius=100;
lower_radius=200;

// vertical distance between the planes
middle_up = 120;
lower_middle = -80;

// Radius of the lightbulb holder
lamp_hole_radius=20;
// thickness of the material
plywood=4;
// Size of the chamfer, no need to change
chamfer=plywood/(2*tan(60));

// thickness of the shade. It's almost a placeholder, it is there to
// ensure that the model is fully 3D
paper=0.1;

// Width of each hex plane. Lowering this too much might weaken the lamp's
// structural integrity
part_width=20;
// Size/height of the clamps "arms"
slot_width=3;

// Openwork between the armature and the shade
shade_offset=15;

// Module to define a hexagon
module hexagon(or){
    polygon([for(t=[0:5]) [cos(t*60)*or,sin(t*60)*or]]);
};

// Define the connecting arm in 2D
module 2d_connection(){
    $fn=20;
    chamfer=plywood/(2*tan(60));
    difference(){
    offset(r=2,chamfer=true) offset(r=-2)
    union(){
        // upper connection
        polygon(
            [[middle_radius-chamfer,plywood],
             [middle_radius-part_width,plywood],
             [upper_radius-chamfer, middle_up-slot_width],
             [upper_radius-chamfer, middle_up+plywood+slot_width]]
        );
        translate([upper_radius-part_width-chamfer,middle_up-slot_width,0])
        square([part_width, plywood+2*slot_width]);
        // lower connection
        polygon(
            [[middle_radius-chamfer,0],
             [middle_radius-part_width,0],
             [lower_radius-chamfer, lower_middle+plywood+slot_width],
             [lower_radius-chamfer,lower_middle-slot_width]]
        );
        translate([lower_radius-part_width-chamfer,lower_middle-slot_width,0])
        square([part_width, plywood+2*slot_width]);
        translate([middle_radius-part_width,0,0])
        union(){
        square([part_width-chamfer, plywood]);
        square([part_width/2, 30],center=true);
            };
    };
    //slots
    tr = 0.87;
    union(){
        translate([upper_radius-part_width-chamfer,middle_up+plywood*((1-tr)/2),0])
        square([part_width*3/4, plywood*tr]);
        translate([lower_radius-part_width-chamfer,lower_middle+plywood*((1-tr)/2),0])
        square([part_width*3/4, plywood*tr]);
        translate([middle_radius-part_width*3/4,0,0])
        square([part_width*3/4, plywood*tr]);
        };
};
};

// Extrude the 2d connection and rotate it to the vertical plane
module connection(){
    rotate([90,0,0])
    linear_extrude(plywood, center=true) 2d_connection();
};

// 2D upper shade: i.e a trapezoid
module 2d_upper_shade(shade_offset=20){
    m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
    u_segment_y = sqrt(pow(upper_radius,2)-pow(upper_radius/2,2));
    length_shade = sqrt(pow(m_segment_y-u_segment_y,2)+pow(middle_up,2));
    polygon(
        [[middle_radius/2-shade_offset, 0],
         [-middle_radius/2+shade_offset, 0],
         [-upper_radius/2+shade_offset, -length_shade],
         [upper_radius/2-shade_offset, -length_shade]]
    );
};

// 2D lower shade: a trapezoid
module 2d_lower_shade(shade_offset=20){
    m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
    l_segment_y = sqrt(pow(lower_radius,2)-pow(lower_radius/2,2));
    length_lower_shade = sqrt(pow(m_segment_y-l_segment_y,2)+pow(lower_middle,2));
    polygon(
        [[middle_radius/2-shade_offset, 0],
         [-middle_radius/2+shade_offset, 0],
         [-lower_radius/2+shade_offset, -length_lower_shade],
         [lower_radius/2-shade_offset, -length_lower_shade]]
    );
};

// Rotate and extrude the shade to place it in the 3D space
module shade(shade_offset=20){
    m_segment_y = sqrt(pow(middle_radius,2)-pow(middle_radius/2,2));
    u_segment_y = sqrt(pow(upper_radius,2)-pow(upper_radius/2,2));
    l_segment_y = sqrt(pow(lower_radius,2)-pow(lower_radius/2,2));

    angle_shade = atan((middle_up)/(m_segment_y-u_segment_y));
    angle_lower_shade = atan((lower_middle)/(m_segment_y-l_segment_y));

    translate([0,m_segment_y,plywood])
    rotate([-angle_shade,0,0])
    linear_extrude(paper)
    2d_upper_shade(shade_offset);

    translate([0,m_segment_y,0])
    rotate([-angle_lower_shade,0,0])
    linear_extrude(paper)
    2d_lower_shade(shade_offset);

};

// Upper Plane, with the lightbulb holder hole
module upper_part(){
    chamfer=plywood/(2*tan(60));
    difference(){
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
            // holes for weight, overall looks
            for(i=[0:5]) rotate([0,0,i*60])
            translate([(upper_radius-lamp_hole_radius-part_width)/2+lamp_hole_radius,0,0])
            square([upper_radius-lamp_hole_radius-part_width, part_width], center=true);
        };
        // slots
        for(i=[0:5])
        rotate([0,0,i*60])
        translate([upper_radius-chamfer-part_width/8,0,0])
        square([part_width/4, plywood], center=true);
    };
};

// Middle Plane
module middle_part(){
    difference(){
        offset(delta=2*plywood,chamfer=true)offset(delta=-2*plywood)
        hexagon(or=middle_radius);
        offset(delta=2*plywood, chamfer=true)offset(delta=-2*plywood)
        hexagon(or=middle_radius-part_width);
        // slots
        for(i=[0:5])
        rotate([0,0,i*60])
        translate([middle_radius-part_width,0,0])
        square([part_width/4, plywood], center=true);
    };
};

// Lower plane
module lower_part(){
    difference(){
        offset(delta=2*plywood,chamfer=true)offset(delta=-2*plywood)
        hexagon(or=lower_radius);
        hexagon(or=lower_radius-part_width);
        // slots
        for(i=[0:5])
        rotate([0,0,i*60])
        translate([lower_radius-chamfer-part_width/8,0,0])
        square([part_width/4, plywood], center=true);
    };
};

// Build the 3D model of the lamp
module lamp(){
    union(){
        //middle
        linear_extrude(plywood) middle_part();
        // up
        translate([0,0,middle_up]) linear_extrude(plywood) upper_part();

        //lower
        translate([0,0,lower_middle]) linear_extrude(plywood) lower_part();

        for(i=[0:5]){
            rotate([0,0,i*60]) connection();
            rotate([0,0,i*60]) shade(shade_offset=shade_offset);
        };
    };
};

// Clamps for holding the shades to the armature
module clamp(tr=0.9){
    //tolerance
    // the laser cutter removes part of the material to get a tight fit for the
    // clamp, we reduce the size to slightly less than the actual material
    $fn = 20;
    difference(){
        offset(r=3,chamfer=true) offset(r=-3)
        square([part_width, plywood+2*slot_width]);
        translate([0,slot_width+plywood*((1-tr)/2),0])
        square([part_width*3/4, plywood*tr]);
    };
};
