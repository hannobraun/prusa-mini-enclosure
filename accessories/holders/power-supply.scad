$fn = 60;


// Dimensions of the power supply, slightly rounded up
power_supply_length = 174;
power_supply_width  =  70;
power_supply_height =  35;

// Material strength
rigid_base = 5;
flex_width = 3;
width      = 10;

// Dimensions of printed parts
height_inner = power_supply_height;
height_total = height_inner + rigid_base * 2;


holder_lengthwise();

translate([0, 30, 0])
holder_widthwise();


module holder_widthwise() {
    holder(power_supply_width + flex_width * 2, power_supply_width, 0.0);
}

module holder_lengthwise() {
    holder(power_supply_length + flex_width * 2, power_supply_length, 1.0);
}

module holder(length_total, length_inner, slot_offset) {
    base_height = height_total - height_inner;

    difference() {
        linear_extrude(width)
        difference() {
            union() {
                polygon([
                    [-length_total / 2, 0],
                    [ length_total / 2, 0],
                    [ length_total / 2, height_total],
                    [ length_inner / 2, height_total],
                    [ length_inner / 2, base_height],
                    [-length_inner / 2, base_height],
                    [-length_inner / 2, height_total],
                    [-length_total / 2, height_total],
                ]);

                translate([-length_total / 2, height_total])
                lump(1);

                translate([length_total / 2, height_total])
                lump(-1);

                translate([-length_inner / 2, base_height])
                chamfer(1.0);

                translate([length_inner / 2, base_height])
                chamfer(-1.0);
            }

            slot_size = [width * 1.05, base_height];

            translate([length_total * 0.25, base_height * slot_offset])
            square(slot_size, center = true);

            translate([length_total * -0.25, base_height * slot_offset])
            square(slot_size, center = true);
        }

        translate([-0.25 * length_total, 0, 0])
        hole();

        translate([0.25 * length_total, 0, 0])
        hole();
    }

    module lump(direction) {
        s = 1.5;
        d = flex_width * 2.5;
        r = d / 2;

        union() {
            scale([1, s])
            translate([r * direction, r])
            circle(d = d);

            overlap = 1;
            square_x = flex_width;
            square_y = r * s;

            translate([square_x / 2 * direction, (square_y - overlap) / 2])
            square([square_x, square_y + overlap], center = true);
        }
    }

    module chamfer(f) {
        r = 1.0;

        difference() {
            square([r, r] * 2, center = true);

            translate([f * r, r])
            circle(r = r);
        }
    }

    module hole() {
        protrusion = 2;

        hole_diameter = 4.5;
        hole_height   = base_height;
        head_diameter = 9;
        head_height   = 3.5;

        translate([0, hole_height + protrusion, width / 2])
        rotate(90, [1, 0, 0])
        union() {
            cylinder(d = hole_diameter, h = hole_height + protrusion * 2);
            cylinder(d = head_diameter, h = head_height + protrusion);
        }
    }
}
