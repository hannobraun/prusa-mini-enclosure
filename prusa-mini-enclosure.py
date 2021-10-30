import studio

studio.set_bounds([-10, -10, -10], [10, 10, 10])
studio.set_quality(8)
studio.set_resolution(10)

# I'm using libfive Studio to edit this file, and its editor doesn't give me any
# way to tell which column I'm currently in. The following line is 80 characters
# long and allows me to calibrate the width of the editor.
#
# ---------------------------------------------------------------------------- #

# # Prusa Mini Enclosure
#
# A friend offered to build an enclosure for my Prusa Mini out of plywood, as
# long as I design it. This file presents the design and documents the design
# intent. It is intentionally vague in some areas, as many decisions are left up
# to my friend.
#
# All units are in mm.
#
#
# ## Internal Dimensions
#
# Let's take a look at the internal dimensions of the enclosure, how I came up
# with them, and the constraints they are driven by. The design intent here is
# to define dimensions that fit the printer, allow me to handle the printer, but
# are otherwise as small as practical, to not make the enclosure overly large.
#
# ### Width
#
# The approximate width of the printer:
printer_width = 325

# We need some extra wiggle room to take the printer into or out of the
# enclosure. Here's a nice value for the left side:
margin_left = 30

# The right side needs a larger margin. You'd typically lift the printer by
# grasping the z-axis extrusion from the right. The following margin should
# allow me to do that comfortably:
margin_right = 60

# The final width is the sum of those numbers:
inner_width = printer_width + margin_left + margin_right

# ### Depth
#
# Measuring the depth of the printer is complicated by the fact that the y-axis
# is moving front-to-back.
#
# Let's start with the length of the y-axis assembly's base:
y_assembly_base_depth = 285

# Now let's add how much the print bed overhangs while the y-axis is in its
# front-most or back-most position, respectively.
#
# Front overhang, if y-axis is in front-most position:
print_bed_overhang_front = 55

# Back overhang, if y-axis is in back-most position:
print_bed_overhang_back = 50

# We can ignore the electronics enclosure. It protrudes behind the y-axis base,
# but is completely covered by the back overhang.
#
# In addition to the overhang, we need to consider the cable going to the
# heated bed. This should provide enough clearance for the plug and the cable,
# without bending it too much:
margin_heat_bed_cable = 60

# Lastly, we need a bit of margin in the front:
margin_front = 20

# Inner depth is the sum of all of these:
inner_depth = y_assembly_base_depth + print_bed_overhang_front + \
    print_bed_overhang_back + margin_heat_bed_cable + margin_front

# ### Height
#
# Now the height. This one is the most straight-forward. First, the printer
# height:
printer_height = 385

# Next, a bit of margin on top to take it into or out of the enclosure:
margin_top = 40

# Sum it up to get the total height:
inner_height = printer_height + margin_top

# These are the values for the inner dimensions:
assert inner_width == 415
assert inner_depth == 470
assert inner_height == 425


# ## Outer Dimensions
#
# To compute the outer dimensions, we need to know the material strength. The
# following is my current assumption:
material_strength = 12

# This gives us the following outer dimensions:
outer_width = inner_width + material_strength * 2
outer_depth = inner_depth + material_strength * 2
outer_height = inner_height + material_strength * 2

# These are the values for the outer dimensions:
assert outer_width == 439
assert outer_depth == 494
assert outer_height == 449


# ## References for Later
#
# Here's a bunch of stuff that's going to be useful in later stages of the
# planning process.
#
# Here are extension cables for the USB and the power switch on the Mini:
# https://shop.levendigdsgn.com/products/usb-powerswitch-extension-cable-prusa-mini
#
# The same shop also has printed parts for extending the display unit:
# - https://shop.levendigdsgn.com/products/usb-powerswitch-extension-printed-parts-front-prusa-mini
# - https://shop.levendigdsgn.com/collections/prusa-mini-mods-upgrades/products/usb-powerswitch-backplate-front-prusa-mini
