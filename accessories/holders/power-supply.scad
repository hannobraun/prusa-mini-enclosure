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
length_inner = power_supply_length;
length_total = length_inner + flex_width * 2;
height_inner = power_supply_height;
height_total = height_inner + rigid_base * 2;


holder_lengthwise();

module holder_lengthwise() {
    holder(length_total, length_inner);
}

module holder(length_total, length_inner) {
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

        translate([length_total * 0.25, base_height])
        square([base_height, width], center = true);

        translate([length_total * -0.25, base_height])
        square([base_height, width], center = true);
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
