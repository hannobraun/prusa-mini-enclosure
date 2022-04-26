// Print settings that this model is designed for
layer_height    = 0.25;
extrusion_width = 0.45;

material_xy = layer_height * 4;
material_z  = extrusion_width * 2;

overhang = 8.0;


module back_cover() {
    size = [130.3, 69.5];

    difference() {
        cover(size);

        linear_extrude(overhang * 4, center = true)
        mirror([1, 0, 0])
        translate(-size / 2)
        union() {
            // Hole for power cable
            translate([20, 10])
            square([16, 16]);

            // Hole for network cable
            translate([40, 10])
            square([17, 17]);
        }
    }
}

module side_cover() {
    size = [118.6, 69.7];

    // TASK: Implement.
}

module cover(size) {
    base();

    translate([0, 0, material_z])
    half_holders();

    translate([0, 0, material_z + overhang])
    mirror([0, 0, 1])
    half_holders();

    module base() {
        linear_extrude(material_z)
        square(size = size + 2 * [overhang, overhang], center = true);
    }

    module half_holders() {
        interference = [0.2, 0.2];

        size_inner = size - interference;
        size_outer = size + interference;

        scale = [
            size_outer[0] / size_inner[0],
            size_outer[1] / size_inner[1],
        ];

        linear_extrude(height = overhang / 2, scale = scale)
        difference() {
            square(size = size_inner, center = true);
            square(
                size = size_inner - [material_xy, material_xy],
                center = true
            );

            corners = [
                [-size[0], -size[1]],
                [-size[0],  size[1]],
                [ size[0], -size[1]],
                [ size[0],  size[1]],
            ];
            for (corner = corners) {
                translate(corner / 2)
                square([overhang, overhang], center = true);
            }
        }
    }
}
