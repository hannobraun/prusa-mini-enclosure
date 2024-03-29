// Material strength
base_height = 10;
base_width  = 10;
flex_width  = 3;


module holders(
    length,
    width,
    height,
    slot_offset_lengthwise = 0.25,
    slot_offset_widthwise  = 0.25
) {
    length_total = length + flex_width * 2;
    length_inner = length;
    width_total  = width + flex_width * 2;
    width_inner  = width;
    height_total = height + base_height;
    height_inner = height;

    holder_lengthwise(
        length_total = length_total,
        length_inner = length_inner,
        height_total = height_total,
        height_inner = height_inner,
        slot_offset  = slot_offset_lengthwise
    );

    translate([0, 30, 0])
    holder_widthwise(
        width_total  = width_total,
        width_inner  = width_inner,
        height_total = height_total,
        height_inner = height_inner,
        slot_offset  = slot_offset_widthwise
    );
}

module holder_lengthwise(
    length_total,
    length_inner,
    height_total,
    height_inner,
    slot_offset
) {
    holder(
        length_total = length_total,
        length_inner = length_inner,
        height_total = height_total,
        height_inner = height_inner,
        slot_offset  = slot_offset,
        slot_height  = 0.0
    );
}

module holder_widthwise(
    width_total,
    width_inner,
    height_total,
    height_inner,
    slot_offset
) {
    holder(
        length_total = width_total,
        length_inner = width_inner,
        height_total = height_total,
        height_inner = height_inner,
        slot_offset  = slot_offset,
        slot_height  = 1.0
    );
}

module holder(
    length_total,
    length_inner,
    height_total,
    height_inner,
    slot_offset,
    slot_height
) {
    difference() {
        linear_extrude(base_width)
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

            slot_size = [base_width + 0.2, base_height];

            translate([length_total * slot_offset, base_height * slot_height])
            square(slot_size, center = true);

            translate([length_total * -slot_offset, base_height * slot_height])
            square(slot_size, center = true);
        }

        translate([-slot_offset * length_total, 0, 0])
        hole();

        translate([slot_offset * length_total, 0, 0])
        hole();
    }

    module lump(direction) {
        s = 1.5;
        d = flex_width * 2.0;
        r = d / 2;

        union() {
            scale([1, s])
            translate([r * direction, r])
            circle(d = d);

            overlap = 1;
            square_x = flex_width;
            square_y = r * s;

            translate([square_x / 2 * direction, (square_y - overlap) / 2])
            square([square_x, square_y + overlap], center = true);
        }
    }

    module chamfer(f) {
        r = 1.0;

        difference() {
            square([r, r] * 2, center = true);

            translate([f * r, r])
            circle(r = r);
        }
    }

    module hole() {
        protrusion = 2;

        hole_diameter = 4.5;
        hole_height   = base_height;
        head_diameter = 9;
        head_height   = 3.5;

        translate([0, hole_height + protrusion, base_width / 2])
        rotate(90, [1, 0, 0])
        union() {
            cylinder(d = hole_diameter, h = hole_height + protrusion * 2);
            cylinder(d = head_diameter, h = head_height + protrusion);
        }
    }
}
