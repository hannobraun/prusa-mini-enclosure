include <common.scad>;


$fn = 60;


power_supply_holder();


module power_supply_holder() {
    // Dimensions of the power supply, slightly rounded up
    power_supply_length = 174;
    power_supply_width  =  72;
    power_supply_height =  35;

    holders(
        length_total = power_supply_length + flex_width * 2,
        length_inner = power_supply_length,
        width_total  = power_supply_width + flex_width * 2,
        width_inner  = power_supply_width,
        height_total = power_supply_height + rigid_base * 2,
        height_inner = power_supply_height
    );
}
