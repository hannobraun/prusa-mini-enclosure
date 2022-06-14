// Print settings that this model is designed for
layer_height    = 0.25;
extrusion_width = 0.45;

increment_xy = extrusion_width * 2;
increment_z  = layer_height * 4;


$fn = 60;


holder(
    length = 100.0,
    width  = 50.0,
    height = 10.0
);


module holder(length, width, height) {
    base_height  = increment_xy * 2;
    flexer_width = increment_xy;

    lengthwise();
    // TASK: Add second lengthwise part.
    // TASK: Add widthwise parts.

    module lengthwise() {
        linear_extrude(increment_z * 4)
        union() {
            // TASK: Cut out slots for the widthwise parts.
            square([length, base_height]);

            flexer();

            translate([length, 0])
            mirror([1, 0, 0])
            flexer();
        }

        module flexer() {
            total_height = height + extrusion_width;

            union() {
                square([flexer_width, height]);

                d = flexer_width + extrusion_width;
                translate([d / 2, height])
                scale([1, 1.5])
                circle(d = d);

                corner();
            }

            module corner() {
                radius = flexer_width / 2;

                translate([flexer_width, base_height])
                difference() {
                    square([radius, radius]);

                    translate([radius, radius])
                    circle(r = radius);
                }
            }
        }
    }
}
