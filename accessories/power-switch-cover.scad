// Power Switch Cover
//
// After installing the power switch extension cable, I now have a hole in the
// electronics enclosure where the powerswitch used to be. This is a small cover
// to, well, cover it.

width  = 20;
height = 14;

material = 1;

overhang = 2;

union() {
    cube([
        width + 2 * overhang,
        height + 2 * overhang,
        material
    ]);

    translate([overhang, 0, 0])
    thing();

    translate([width + overhang, 0, 0])
    mirror([1, 0, 0])
    thing();
}

// This is the part that extends into the electronics enclosure and keeps the
// cover in place. No idea what to call it.
module thing() {
    depth = 5;

    translate([0, overhang + height, material])
    rotate([90, 0, 0])
    linear_extrude(height)
    polygon([
        [ material * 0.25, 0.0],
        [ material       , 0.0],
        [ material       , depth],
        [-material * 0.25, depth],
    ]);
}
