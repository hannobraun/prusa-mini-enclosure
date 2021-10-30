(set-bounds! [-10 -10 -10] [10 10 10])
(set-quality! 8)
(set-resolution! 10)

; Guile Reference Manual is available here:
; https://www.gnu.org/software/guile/manual/guile.html

; I'm using libfive Studio to edit this file, and its editor doesn't give me any
; way to tell which column I'm currently in. The following line is 80 characters
; long and allows me to calibrate the width of the editor.
;
; ---------------------------------------------------------------------------- ;

; All units are mm.

; # Internal Dimensions
;
; Let's take a look at the internal dimensions of the enclosure, how I came up
; with them, and the constraints they are driven by. The design intent here is
; to define dimensions that fit the printer, allow me to handle the printer, but
; are otherwise as small as practical, to not make the enclosure overly large.
;
; ## Width
;
; The approximate width of the printer:
(define printer-width 325)

; We need some extra wiggle room to take the printer into or out of the
; enclosure. Here's a nice value for the left side:
(define margin-left 30)

; The right side needs a larger margin. You'd typically lift the printer by
; grasping the z-axis extrusion from the right. The following margin should
; allow me to do that comfortably:
(define margin-right 60)

; The final width is the sum of those numbers:
(define inner-width (+ printer-width margin-left margin-right))

; ## Depth
;
; Measuring the depth of the printer is complicated by the fact that the y-axis
; is moving front-to-back.
;
; Let's start with the length of the y-axis assembly's base:
(define y-assembly-base-depth 285)

; Now let's add how much the print bed overhangs while the y-axis is in its
; front-most or back-most position, respectively.
;
; Front overhang, if y-axis is in front-most position:
(define print-bed-overhang-front 55)

; Back overhang, if y-axis is in back-most position:
(define print-bed-overhang-back 50)

; We can ignore the electronics enclosure. It protrudes behind the y-axis base,
; but is completely covered by the back overhang.
;
; In addition to the overhang, we need to consider the cable going to the
; heated bed. This should provide enough clearance for the plug and the cable,
; without bending it too much:
(define margin-heat-bed-cable 60)

; Lastly, we need a bit of margin in the front:
(define margin-front 20)

; Inner depth is the sum of all of these:
(define inner-depth (+
                      y-assembly-base-depth
                      print-bed-overhang-front
                      print-bed-overhang-back
                      margin-heat-bed-cable
                      margin-front))

; # Height
;
; Now the height. This one is the most straight-forward. First, the printer
; height:
(define printer-height 385)

; Next, a bit of margin on top to take it into or out of the enclosure:
(define margin-top 40)

; Sum it up to get the total height:
(define inner-height (+ printer-height margin-top))

; To summarize, these are the inner dimensions:
; width  = 415mm
; depth  = 470mm
; height = 425mm
;
; TASK: Add assertions here to make sure these are the correct values.

; # References for Later
;
; Here's a bunch of stuff that's going to be useful in later stages of the
; planning process.
;
; Here are extension cables for the USB and the power switch on the Mini:
; https://shop.levendigdsgn.com/products/usb-powerswitch-extension-cable-prusa-mini
;
; The same shop also has printed parts for extending the display unit:
; - https://shop.levendigdsgn.com/products/usb-powerswitch-extension-printed-parts-front-prusa-mini
; - https://shop.levendigdsgn.com/collections/prusa-mini-mods-upgrades/products/usb-powerswitch-backplate-front-prusa-mini
