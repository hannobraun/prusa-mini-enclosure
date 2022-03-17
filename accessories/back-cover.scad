size_inner = [130.3, 69.5];

material = 1.0;
overhang = 8.0;


back_cover();


module back_cover() {
    base();

    module base() {
        linear_extrude(material)
        square(size = size_inner + 2 * [overhang, overhang], center = true);
    }
}
