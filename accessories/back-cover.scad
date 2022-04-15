// Print settings that this model is designed for
layer_height    = 0.25;
extrusion_width = 0.45;

size = [130.3, 69.5];

material = 1.0;
overhang = 8.0;


back_cover();


module back_cover() {
    base();

    translate([0, 0, material])
    holders();

    translate([0, 0, material + overhang])
    mirror([0, 0, 1])
    holders();

    module base() {
        linear_extrude(material)
        square(size = size + 2 * [overhang, overhang], center = true);
    }

    module holders() {
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
            square(size = size_inner - [material, material], center = true);

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
