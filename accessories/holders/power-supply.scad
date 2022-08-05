include <common.scad>;


$fn = 60;


// Dimensions of the power supply, slightly rounded up
power_supply_length = 174;
power_supply_width  =  72;
power_supply_height =  35;


holders(
    length = power_supply_length,
    width  = power_supply_width,
    height = power_supply_height
);
