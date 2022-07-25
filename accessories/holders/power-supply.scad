$fn = 60;


// Dimensions of the power supply, slightly rounded up
power_supply_length = 174;
power_supply_width  =  70;
power_supply_height =  35;

// Material strength
rigid_base = 5;
flex_width = 3;

// Dimensions of printed parts
length_inner = power_supply_length;
length_total = length_inner + flex_width * 2;
height_inner = power_supply_height;
height_total = height_inner + rigid_base * 2;


holder();


module holder() {
    base_height = height_total - height_inner;

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
    }

    module lump(direction) {
        d = flex_width * 1.5;

        translate([d / 2, 0, 0] * direction)
        scale([1, 1.5])
        circle(d = d);
    }
}
