include <common.scad>;


$fn = 60;


// Dimensions of the power supply, slightly rounded up
power_supply_length = 174;
power_supply_width  =  72;
power_supply_height =  35;


holders(
    length_total = power_supply_length + flex_width * 2,
    length_inner = power_supply_length,
    width        = power_supply_width,
    height       = power_supply_height
);
