size = [130.3, 69.5];

material = 1.0;
overhang = 8.0;


back_cover();


module back_cover() {
    base();
    holders();

    module base() {
        linear_extrude(material)
        square(size = size + 2 * [overhang, overhang], center = true);
    }

    module holders() {
        size = size - [material, material] * 0.5;
        size_plus = (size + [material, material]);
        scale = [
            size_plus[0] / size[0],
            size_plus[1] / size[1],
        ];

        translate([0, 0, material])
        linear_extrude(height = overhang, scale = scale)
        difference() {
            square(size = size, center = true);
            square(size = size - [material, material], center = true);

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
