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

        translate([length_total * 0.25, base_height * slot_offset])
        square([width, base_height], center = true);

        translate([length_total * -0.25, base_height * slot_offset])
        square([width, base_height], center = true);
    }

    module lump(direction) {
        d = flex_width * 1.5;

        translate([d / 2, 0, 0] * direction)
        scale([1, 1.5])
        circle(d = d);
    }

    module chamfer(f) {
        r = 1.0;

        difference() {
            square([r, r] * 2, center = true);

            translate([f * r, r])
            circle(r = r);
        }
    }
}
