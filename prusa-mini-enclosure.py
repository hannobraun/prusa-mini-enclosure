import libfive.stdlib.shapes as shapes
import studio


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
# All units are in millimeters.
#
#
# ## Basic Parameters
#
# First, we need to set some basic parameters of the CAD program. Leaving
# quality at the default value caused no problems so far, but I severely reduced
# resolution for performance reasons. It's the reciprocal of the minimum feature
# size, and we really don't need sub-millimeter features.
studio.set_quality(8)
studio.set_resolution(1)


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

# Now that we know the outer dimensions, we can define the bounds of our CAD
# modeling space.
#
# We need some extra space around our geometry, or it won't render correctly.
studio.set_bounds(
    [-1, -1, -1],
    [outer_width + 1, outer_depth + 1, outer_height + 1],
)


# ## Tolerances
#
# Since all dimensions are based on guesstimated margins, there is mostly some
# wiggle room. For width and depth, a few mm less or a few cm more won't matter.
#
# However, height is a *critical dimension*. A few mm less won't matter here
# either, but the height where I want to place the enclosure is limited. As
# planned, there are only going to be a few mm of space left above the
# enclosure.
#
# To be on the safe side, the height should be limited to this value:
assert outer_height < 450


# ## Structure
#
# Now that we got the dimensions, let's think about the structure of the
# enclosure. I figure, it's best for the stability of the construction, if
# there is a base piece where everything else rests on.
base = {
    "position": [
        0,
        0,
        0,
    ],
    "dimensions": [
        outer_width,
        outer_depth,
        material_strength,
    ],
}

# Left and right walls rest on the base and reach from front to back. They don't
# reach to the outer height, to leave room for the top.
left = {
    "position": [
        0,
        0,
        material_strength,
    ],
    "dimensions": [
        material_strength,
        outer_depth,
        inner_height,
    ],
}
right = {
    "position": [
        outer_width - material_strength,
        0,
        material_strength,
    ],
    "dimensions": left["dimensions"],
}

# The top rests on the left and right walls.
top = {
    "position": [
        0,
        0,
        outer_height - material_strength,
    ],
    "dimensions": base["dimensions"],
}

# The back fills in the room left by the other parts.
back = {
    "position": [
        material_strength,
        outer_depth - material_strength,
        material_strength,
    ],
    "dimensions": [
        inner_width,
        material_strength,
        inner_height,
    ],
}


# Let's model that up real quick.
components = [
    base,
    left,
    right,
    top,
    back,
]
result = None

for component in components:
    start = component["position"]
    end = [
        component["position"][i] + component["dimensions"][i]
            for i in range(3)
    ]
    shape = shapes.box_exact(start, end)
    if result is None:
        result = shape
    else:
        result = result.union(result, shape)

result


# ## Door
#
# The previous definition leaves out the door. How that's going to look exactly
# is going to be left to the builder, but here are a few thoughts:
# - There should be a window in there that's as large as possible, to watch
#   ongoing prints.
# - Hinges should be placed on the left side. When putting the printer in or
#   taking it out, the door is much more likely to be in the way on the right
#   side.
# - I can 3D print a handle, so if none is at hand during construction, that's
#   not a problem
#
# ### Magnets
#
# To hold the door closed, I think magnets are a good solution that's also
# easy to implement.
#
# I'm not sure how many would be appropriate, and where exactly to place them.
# But they should be closed as close to the edge of the door as practical, so
# their counterpart is not in the way when taking the printer into or out of the
# enclosure.
#
# I can easily print magnet holders that I can screw to the enclosure. This
# shouldn't be a problem and can easily be done after the enclosure has been
# built.


# ## Access Ports
#
# The printer needs to interface with the world outside of the enclosure in
# various ways:
# - Power cable
# - Network cable
# - USB ports
# - Filament
# - Power switch
#
# To accommodate these, the enclosure needs two openings. One on the back side,
# one on the right side.
#
# In addition to providing the means to guide cables/filament through, those
# openings need to be big enough to allow access to the printer's ports. Cables
# need to be connected/disconnected, filament needs to be loaded/unloaded, and
# the USB port takes a flash drive.
#
# I think the most practical way to address this, is to make the openings rather
# large, so it is easy to access the inside. To prevent this from causing an
# unwanted draft during printing, I can later print a panel that covers the
# openings, still lets cables and filament through, and can removed whenever
# anything needs to be plugged/unplugged/loaded/unloaded.
#
# Since both openings must allow for the same kind of access, they can both have
# the same height:
opening_height = 60

# In addition, the lower boundaries of both openings are flush with the upper
# surface of the base, i.e. the surface the printer stands on.
#
# Please note that the the position of those openings is specified in terms of
# the distances from the _inner_ surfaces of the back and right walls.


# ### Back Opening
#
# The back opening needs to accommodate the power and network ports. It requires
# the following width:
back_opening_width = 130

# Here's the distance from the inner surface of the right wall to the boundary
# of the opening:
back_opening_to_right_wall = margin_right + 30
assert back_opening_to_right_wall == 90


# ### Right Opening
#
# The right needs to accommodate the USB ports, filament, and power switch. It
# reqiores the following width:
right_opening_width = 140

# The distance from the inner surface of the back wall to the boundary of the
# opening:
right_opening_to_back_wall = 40


# ## References for Later
#
# Here's a bunch of stuff that's going to be useful in later stages of the
# planning process.
#
# These are extension cables for the USB and the power switch on the Mini:
# https://shop.levendigdsgn.com/products/usb-powerswitch-extension-cable-prusa-mini
#
# The same shop also has printed parts for extending the display unit:
# - https://shop.levendigdsgn.com/products/usb-powerswitch-extension-printed-parts-front-prusa-mini
# - https://shop.levendigdsgn.com/collections/prusa-mini-mods-upgrades/products/usb-powerswitch-backplate-front-prusa-mini
