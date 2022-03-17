size_inner = [130.3, 69.5];

material = 1.0;
overhang = 8.0;

size_outer = [
    inner_to_outer(size_inner[0]),
    inner_to_outer(size_inner[1]),
];


function inner_to_outer(inner) = inner + 2*overhang;


back_cover();


module back_cover() {
    base();

    module base() {
        linear_extrude(material)
        square(size = size_outer, center = true);
    }
}
