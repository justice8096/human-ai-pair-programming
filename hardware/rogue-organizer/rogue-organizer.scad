// =============================================================================
//  rogue-organizer.scad
//  A modular, 3D-printable desktop case for the "rogue" home-server stack:
//    - 4x Orico 3.5" single-drive USB enclosures (stand vertically in slots)
//    - 1x Beelink SER6 Pro mini PC (vented cradle)
//    - 1x USB hub (clip tray)
//    - cable management: rear cable spine (comb + zip-tie slots) + clips
//
//  The whole assembled unit is larger than a typical print bed, so it is
//  split into separate PARTS that join with printed dovetails (+ optional M3
//  screws). Render/export one part at a time with the `part` selector below,
//  or render "layout" to preview everything assembled.
//
//  ALL hardware dimensions are variables -- if you re-measure something,
//  change ONE line and re-export. Units are millimetres.
// =============================================================================

// ---------- WHICH PART TO RENDER --------------------------------------------
//  "layout"        -> all parts assembled (PREVIEW ONLY, do not print)
//  "drive_box"     -> the 4-bay vented box body
//  "drive_lid"     -> friction-fit vented lid for the box
//  "minipc_cradle" -> vented cradle for the Beelink SER6 Pro
//  "hub_tray"      -> clip tray for the USB hub
//  "cable_spine"   -> one rear cable-comb segment (print as many as needed)
//  "cable_clip"    -> a single snap cable clip (print a handful)
part = "layout";   // [layout, drive_box, drive_lid, minipc_cradle, hub_tray, cable_spine, cable_clip]

// =============================================================================
//  HARDWARE DIMENSIONS  --  >>> MEASURE YOUR OWN AND EDIT THESE <<<
// =============================================================================
// Orico 3.5" enclosure, as measured off the packaging: L x W x T
orico        = [186, 118, 31.4];   // [length, width, thickness]
orico_count  = 4;

// Beelink SER6 Pro mini PC (spec sheet 126 x 113 x 42): W x D x H
beelink      = [126, 113, 42];

// USB hub (ASSUMED -- edit when measured): W x D x H
hub          = [100, 45, 15];

// =============================================================================
//  FIT / PRINT TUNING
// =============================================================================
clear   = 1.5;   // clearance per side around inserted hardware
wall    = 3.0;   // outer wall thickness
div     = 3.0;   // divider thickness between drive bays
floor_t = 3.0;   // floor thickness
foot_h  = 4.0;   // vent gap under hardware (airflow + clears rubber feet)
lid_lip = 8.0;   // depth of the lid's friction skirt
lid_gap = 0.35;  // skirt clearance (loosen if too tight on your printer)

// dovetail joint (vertical slide) between drive_box and minipc_cradle
dt_p    = 6;     // protrusion depth
dt_neck = 6;     // width at the wall (narrow neck)
dt_tip  = 11;    // width at the tip (wide -> locks)
dt_cl   = 0.4;   // dovetail clearance (groove is this much bigger)

// active-cooling fan option (mounts on the drive-box lid)
fan_size  = 80;      // 80 or 92 (mm)
fan_screw = 71.5;    // screw spacing: 80mm->71.5, 92mm->82.5, 120mm->105
fan_bore  = fan_size - 6;

// power bricks  --  >>> MEASURE YOURS <<< (placeholders for typical units): L x W x T
brick       = [115, 50, 30];   // largest ~100W barrel brick (Beelink); others smaller
brick_count = 5;               // how many bricks to slot

eps = 0.02;
$fn = 40;

// ---------- DERIVED: DRIVE BOX ----------------------------------------------
// Drives stand on their long edge: thickness -> slot width, width -> height,
// length -> box depth. Ports end up at the REAR vertical face.
slot_w   = orico[2] + 2*clear;                       // X per bay
in_w     = orico_count*slot_w + (orico_count-1)*div; // internal width (X)
in_d     = orico[0] + 2*clear;                       // internal depth (Y)
in_h     = orico[1] + clear + 2;                     // internal height (Z, above floor)

ext_w = in_w + 2*wall;
ext_d = in_d + 2*wall;
ext_h = floor_t + in_h;

// =============================================================================
//  HELPERS
// =============================================================================

// rounded-corner box footprint, extruded
module rbox(sz, r=2){
    linear_extrude(sz[2])
        offset(r) offset(-r) square([sz[0], sz[1]], center=true);
}

// horizontal louver vents cut into a wall whose normal is +/-X (at x = wx)
module vents_X(wx, depth, z0, z1, bar=4, gap=5, margin=10){
    pitch = bar + gap;
    for (z = [z0 : pitch : z1])
        translate([wx, 0, z])
            cube([wall + 2*eps + 2, depth - 2*margin, bar], center=true);
}

// horizontal louver vents cut into a wall whose normal is +/-Y (at y = wy)
module vents_Y(wy, width, z0, z1, bar=4, gap=5, margin=10){
    pitch = bar + gap;
    for (z = [z0 : pitch : z1])
        translate([0, wy, z])
            cube([width - 2*margin, wall + 2*eps + 2, bar], center=true);
}

// a grid of round vent holes through a flat panel lying in XY (cut in Z)
module vent_holes(width, depth, t, d=6, gap=6, margin=10){
    pitch = d + gap;
    nx = floor((width  - 2*margin + gap) / pitch);
    ny = floor((depth  - 2*margin + gap) / pitch);
    tx = (nx-1)*pitch;  ty = (ny-1)*pitch;
    for (i = [0:nx-1], j = [0:ny-1])
        translate([-tx/2 + i*pitch, -ty/2 + j*pitch, 0])
            cylinder(h = t + 2, d = d, center = true);
}

// two close through-slots so a zip tie can loop a cable bundle to a wall
module ziptie_pair(spacing=10, slot=3.2, len=10){
    for (s = [-1, 1])
        translate([s*spacing/2, 0, 0])
            cube([slot, wall + 2*eps + 2, len], center=true);
}

// dovetail cross-section (protrudes +X), narrow at neck, wide at tip
module dovetail_2d(grow=0){
    n = dt_neck + 2*grow;  tp = dt_tip + 2*grow;  p = dt_p;
    polygon([[-eps,-n/2],[p,-tp/2],[p,tp/2],[-eps,n/2]]);
}
// vertical dovetail rail of height h, protruding from a wall at +X
module dovetail_rail(h, grow=0){
    rotate([0,0,0]) linear_extrude(h) dovetail_2d(grow);
}

// =============================================================================
//  PART: DRIVE BOX
// =============================================================================
module drive_box(){
    difference(){
        // outer shell
        translate([0,0,0]) rbox([ext_w, ext_d, ext_h], r=3);

        // main cavity
        translate([0,0,floor_t])
            rbox([in_w, in_d, in_h + eps], r=2);

        // side-wall louvers (both X walls)
        vents_X(+ext_w/2, in_d, floor_t+8, ext_h-8);
        vents_X(-ext_w/2, in_d, floor_t+8, ext_h-8);

        // front-wall louvers (+Y)
        vents_Y(+ext_d/2, in_w, floor_t+8, ext_h-8);

        // REAR (-Y): one cable/port slot per bay, opening from the floor up
        for (i = [0:orico_count-1]){
            x = -in_w/2 + slot_w/2 + i*(slot_w+div);
            translate([x, -ext_d/2, floor_t + (in_h*0.55)/2])
                cube([slot_w*0.7, wall+2*eps+2, in_h*0.55], center=true);
        }
        // zip-tie anchors along the rear wall (tidy the exiting bundle)
        for (s=[-1,1])
            translate([s*in_w/4, 0, 0])
                translate([0,-ext_d/2,ext_h-12]) ziptie_pair();

        // floor vents under the drives
        translate([0,0,floor_t/2]) vent_holes(in_w, in_d, floor_t, d=7, gap=8);
    }

    // internal dividers between bays (with a big lightening/airflow hole)
    for (i = [1:orico_count-1]){
        x = -in_w/2 + i*slot_w + (i-1)*div + div/2;
        translate([x, 0, floor_t])
            difference(){
                translate([-div/2, -in_d/2, 0]) cube([div, in_d, in_h-6]);
                translate([0,0,(in_h-6)/2]) rotate([90,0,0])
                    cylinder(h=in_d+2, d=min(in_d,in_h)*0.6, center=true);
            }
    }

    // dovetail GROOVE on the +X wall is cut here so the cradle's rail slides in
    // (we add a thickened boss, then the groove is subtracted)
    // -- implemented as: boss with groove --
    translate([ext_w/2 - eps, 0, 0])
        difference(){
            translate([0,-dt_tip/2-3, 0]) cube([dt_p+3, dt_tip+6, ext_h]);
            translate([0,0,-eps]) dovetail_rail(ext_h+2*eps, grow=dt_cl);
        }
}

// =============================================================================
//  PART: DRIVE LID  (friction-fit cap with vented top)
// =============================================================================
module drive_lid(){
    cap_w = ext_w; cap_d = ext_d; top_t = 2.5;
    difference(){
        union(){
            // top plate
            translate([0,0,0]) rbox([cap_w, cap_d, top_t], r=3);
            // downward friction skirt that drops INTO the box opening
            translate([0,0,-lid_lip])
                difference(){
                    rbox([in_w - 2*lid_gap, in_d - 2*lid_gap, lid_lip+eps], r=2);
                    translate([0,0,-eps])
                        rbox([in_w-2*lid_gap-4, in_d-2*lid_gap-4, lid_lip+1], r=2);
                }
        }
        // vented top
        translate([0,0,top_t/2]) vent_holes(in_w, in_d, top_t, d=7, gap=7);
        // finger notch to lift the lid off
        translate([0, cap_d/2, top_t/2]) cube([24, 10, top_t+2], center=true);
    }
}

// =============================================================================
//  PART: MINI PC CRADLE  (Beelink SER6 Pro, vented, open top)
// =============================================================================
module minipc_cradle(){
    cin_w = beelink[0] + 2*clear;
    cin_d = beelink[1] + 2*clear;
    wallz = 22;                       // wall height (< unit height, top stays open)
    cext_w = cin_w + 2*wall;
    cext_d = cin_d + 2*wall;
    cext_h = floor_t + foot_h + wallz;

    difference(){
        rbox([cext_w, cext_d, cext_h], r=3);
        // cavity (sits on standoff feet for airflow)
        translate([0,0,floor_t+foot_h])
            rbox([cin_w, cin_d, wallz+eps], r=2);
        // big floor vents (under the PC, which runs hot)
        translate([0,0,(floor_t+foot_h)/2])
            vent_holes(cin_w, cin_d, floor_t+foot_h, d=10, gap=7, margin=8);
        // side louvers
        vents_X(+cext_w/2, cin_d, floor_t+foot_h+4, cext_h-4);
        vents_X(-cext_w/2, cin_d, floor_t+foot_h+4, cext_h-4);
        // rear cable slot + zip-tie
        translate([0,-cext_d/2, floor_t+foot_h+wallz/2])
            cube([cin_w*0.6, wall+2*eps+2, wallz], center=true);
        translate([0,-cext_d/2, cext_h-8]) ziptie_pair();
        // corner cutouts so you can grip the PC to remove it
        for (s=[-1,1])
            translate([s*cext_w/2, cext_d/2, cext_h-1])
                cube([18,18,wallz], center=true);
    }
    // standoff feet inside (raise the PC for under-airflow)
    for (sx=[-1,1], sy=[-1,1])
        translate([sx*(cin_w/2-8), sy*(cin_d/2-8), floor_t])
            cylinder(h=foot_h, d=8);

    // dovetail TONGUE on the -X wall (slides down into the drive_box groove)
    translate([-cext_w/2 + eps, 0, 0])
        mirror([1,0,0]) dovetail_rail(cext_h);
}

// =============================================================================
//  PART: USB HUB TRAY  (clip-in tray, mounts via keyhole to a wall)
// =============================================================================
module hub_tray(){
    tin_w = hub[0] + 2*clear;
    tin_d = hub[1] + 2*clear;
    wallz = min(hub[2] + 4, 16);
    text_w = tin_w + 2*wall;
    text_d = tin_d + 2*wall;
    text_h = floor_t + wallz;

    difference(){
        rbox([text_w, text_d, text_h], r=2);
        translate([0,0,floor_t]) rbox([tin_w, tin_d, wallz+eps], r=1.5);
        // FRONT (+Y): full-height cable slot
        translate([0, text_d/2, floor_t+wallz/2])
            cube([tin_w*0.7, wall+2*eps+2, wallz], center=true);
        // REAR (-Y): only the lower 55% is cut, leaving a top wall strip that
        // the mount tab fuses to (otherwise the tab prints detached)
        translate([0, -text_d/2, floor_t + (wallz*0.55)/2])
            cube([tin_w*0.7, wall+2*eps+2, wallz*0.55], center=true);
        // floor vents
        translate([0,0,floor_t/2]) vent_holes(tin_w, tin_d, floor_t, d=5, gap=6, margin=6);
    }
    // back-mount keyhole tab (hangs the tray on an M3 screw / peg).
    // Overlap the rear wall by 2mm so it fuses into one printable body.
    translate([0, -text_d/2 - 6 + 2, text_h-10])
        difference(){
            cube([24, 12, 8], center=true);
            rotate([90,0,0]) cylinder(h=20, d=6, center=true);   // head clearance
            translate([0,0,-4]) rotate([90,0,0]) cylinder(h=20, d=3.2, center=true); // slot
        }
}

// =============================================================================
//  PART: CABLE SPINE  (one rear comb segment; chain several across the back)
// =============================================================================
// Set spine_len to your assembled rear width (or your bed width and butt two
// bars end-to-end behind the units -- the cable runs hide the seam).
spine_len   = 200;   // length of one printed bar
spine_t     = 8;     // base bar depth (Y)
base_h      = 12;    // solid base height (Z)
finger_w    = 4;     // comb finger thickness
finger_h    = 16;    // comb finger height above the base
finger_gap  = 14;    // cable channel width between fingers

module cable_spine(){
    pitch = finger_gap + finger_w;
    n     = floor(spine_len / pitch);
    tot   = (n-1)*pitch;
    difference(){
        union(){
            // solid base bar (rounded ends)
            translate([0,0,base_h/2])
                rotate([90,0,0])
                    linear_extrude(spine_t, center=true)
                        offset(2) offset(-2) square([spine_len, base_h], center=true);
            // comb fingers -> cable channels between them
            for (i=[0:n-1])
                translate([-tot/2 + i*pitch, -spine_t/2, base_h-eps])
                    cube([finger_w, spine_t, finger_h]);
        }
        // a zip-tie slot in the base under each channel
        for (i=[0:n-2])
            translate([-tot/2 + i*pitch + pitch/2, 0, base_h*0.5])
                cube([3.2, spine_t+2, base_h*0.5], center=true);
        // screw-down holes near each end (mount to desk / rear of the box)
        for (s=[-1,1])
            translate([s*(spine_len/2-8), 0, -1])
                cylinder(h=base_h+2, d=4.2);
    }
}

// =============================================================================
//  PART: CABLE CLIP  (standalone snap clip; print several)
// =============================================================================
module cable_clip(d=8){
    // C-shaped clip on a flat base with a keyhole mount
    linear_extrude(12)
        difference(){
            union(){
                translate([0, d/2+2]) circle(d=d+5);
                translate([-8,-2]) square([16,4]);     // base
            }
            translate([0, d/2+2]) circle(d=d);
            // mouth opening
            translate([0, d/2+2+d/2]) square([d*0.7, d], center=true);
        }
}

// =============================================================================
//  DISPATCH / LAYOUT
// =============================================================================
module layout(){
    color("SteelBlue")  drive_box();
    color("LightGray")  translate([0,0,ext_h+40]) drive_lid();   // exploded above
    // cradle mated to the +X side
    color("DarkSeaGreen")
        translate([ext_w/2 + dt_p + 3 + (beelink[0]+2*clear)/2 + wall, 0, 0])
            minipc_cradle();
    // hub tray perched at the rear
    color("Goldenrod")
        translate([0, -ext_d/2 - 30, 0]) hub_tray();
    // cable spine behind everything
    color("Salmon")
        translate([0, -ext_d/2 - 80, 0]) cable_spine();
}

// =============================================================================
//  PART: DRIVE LID WITH FAN  (active-cooling variant of the lid)
// =============================================================================
module lid_skirt(){
    translate([0,0,-lid_lip])
        difference(){
            rbox([in_w - 2*lid_gap, in_d - 2*lid_gap, lid_lip+eps], r=2);
            translate([0,0,-eps])
                rbox([in_w-2*lid_gap-4, in_d-2*lid_gap-4, lid_lip+1], r=2);
        }
}
module drive_lid_fan(){
    top_t = 3;
    difference(){
        union(){ rbox([ext_w, ext_d, top_t], r=3); lid_skirt(); }
        // fan bore
        translate([0,0,top_t/2]) cylinder(h=top_t+2, d=fan_bore, center=true);
        // fan screw holes (M4 clearance)
        for (sx=[-1,1], sy=[-1,1])
            translate([sx*fan_screw/2, sy*fan_screw/2, top_t/2])
                cylinder(h=top_t+2, d=4.3, center=true);
        // perimeter vent holes everywhere EXCEPT under the fan footprint
        difference(){
            translate([0,0,top_t/2]) vent_holes(in_w, in_d, top_t, d=6, gap=7, margin=8);
            translate([0,0,top_t/2]) cylinder(h=top_t+4, d=fan_size+10, center=true);
        }
        // finger notch
        translate([0, ext_d/2, top_t/2]) cube([24, 10, top_t+2], center=true);
    }
    // printed finger guard across the bore
    intersection(){
        cylinder(h=3, d=fan_bore+1);
        union() for (a=[0:45:179])
            rotate([0,0,a]) translate([0,0,1.5]) cube([fan_bore+2, 2.5, 3], center=true);
    }
}

// =============================================================================
//  PART: POWER-BRICK CADDY  (vertical slots for wall-warts; tidies the bricks)
// =============================================================================
module brick_caddy(){
    bslot = brick[2] + 2*clear;                       // slot width (brick thickness)
    bin_w = brick_count*bslot + (brick_count-1)*div;  // internal width
    bin_d = brick[0] + 2*clear;                        // depth (brick length)
    bin_h = brick[1] - 8;                              // wall height (< brick, easy to grab)
    bext_w = bin_w + 2*wall;
    bext_d = bin_d + 2*wall;
    bext_h = floor_t + bin_h;

    difference(){
        rbox([bext_w, bext_d, bext_h], r=3);
        translate([0,0,floor_t]) rbox([bin_w, bin_d, bin_h+eps], r=2);
        // floor vents (bricks get warm)
        translate([0,0,floor_t/2]) vent_holes(bin_w, bin_d, floor_t, d=8, gap=8);
        // rear cable slot per bay
        for (i=[0:brick_count-1]){
            x = -bin_w/2 + bslot/2 + i*(bslot+div);
            translate([x, -bext_d/2, floor_t + bin_h*0.5])
                cube([bslot*0.6, wall+2*eps+2, bin_h], center=true);
        }
        // zip-tie anchors along the rear
        for (s=[-1,1]) translate([s*bin_w/4, -bext_d/2, bext_h-10]) ziptie_pair();
    }
    // dividers between bricks
    for (i=[1:brick_count-1]){
        x = -bin_w/2 + i*bslot + (i-1)*div + div/2;
        translate([x - div/2, -bin_d/2, floor_t]) cube([div, bin_d, bin_h-4]);
    }
}

// =============================================================================
//  DIMENSIONED DRAWING  (top-view spec drawing; render orthographic top)
// =============================================================================
line_w = 1.4;
module htick(x,y,h=5){ translate([x-line_w/2,y-h/2,0.2]) cube([line_w,h,1]); }
module vtick(x,y,w=5){ translate([x-w/2,y-line_w/2,0.2]) cube([w,line_w,1]); }
module hdim(x1,x2,y,txt){
    color([0.1,0.1,0.1]){
        translate([min(x1,x2),y-line_w/2,0.2]) cube([abs(x2-x1),line_w,1]);
        htick(x1,y); htick(x2,y);
        translate([(x1+x2)/2, y+7, 0.2]) linear_extrude(1)
            text(txt, size=8, halign="center", valign="center");
    }
}
module vdim(y1,y2,x,txt){
    color([0.1,0.1,0.1]){
        translate([x-line_w/2,min(y1,y2),0.2]) cube([line_w,abs(y2-y1),1]);
        vtick(x,y1); vtick(x,y2);
        translate([x-8,(y1+y2)/2,0.2]) rotate([0,0,90]) linear_extrude(1)
            text(txt, size=8, halign="center", valign="center");
    }
}
module drawing(){
    // footprints (flat outlines) of the assembled parts
    color([0.62,0.74,0.86]) translate([0,0,0]) rbox([ext_w, ext_d, 0.4], r=3);
    color([0.74,0.84,0.70]) translate([cradle_cx,0,0])
        rbox([beelink[0]+2*clear+2*wall, beelink[1]+2*clear+2*wall, 0.4], r=3);
    cr_r = cradle_cx + (beelink[0]+2*clear+2*wall)/2;
    hubW = hub[0]+2*clear+2*wall;  hubD = hub[1]+2*clear+2*wall;
    dhub_x = cr_r + 30 + hubW/2;   // hub drawn to the RIGHT of the cradle (clear of dims)
    color([0.95,0.78,0.45]) translate([dhub_x,0,0]) rbox([hubW, hubD, 0.4], r=2);
    color([0.95,0.6,0.55]) translate([0,-ext_d/2-30,0]) cube([spine_len,spine_t,0.4],center=true);

    // overall + component dimensions
    // (overall = box+cradle row only; the hub mounts separately, drawn aside)
    hdim(-ext_w/2, cr_r, -ext_d/2-55, str("box + cradle width  ", round(cr_r+ext_w/2), " mm"));
    color([0.45,0.45,0.45]) translate([dhub_x, -hubD/2-10, 0.2]) linear_extrude(1)
        text("(mounts separately)", size=6, halign="center", valign="center");
    hdim(-ext_w/2,  ext_w/2, ext_d/2+30, str("box  ", round(ext_w), " mm"));
    vdim(-ext_d/2, ext_d/2, -ext_w/2-22, str("box depth  ", round(ext_d), " mm"));
    hdim(cradle_cx-(beelink[0]+2*clear+2*wall)/2, cr_r, ext_d/2+30,
         str("cradle  ", round(beelink[0]+2*clear+2*wall), " mm"));
    // labels
    color([0.1,0.1,0.1]){
        translate([0, ext_d/2+58,0.2]) linear_extrude(1)
            text("rogue-organizer  -  top view (assembled footprint)", size=10, halign="center");
        translate([0, 0, 0.5]) linear_extrude(1)
            text("4x ORICO 3.5\"", size=10, halign="center", valign="center");
        translate([cradle_cx, 0, 0.5]) linear_extrude(1)
            text("BEELINK", size=9, halign="center", valign="center");
        translate([dhub_x, 0, 0.5]) linear_extrude(1)
            text("HUB", size=8, halign="center", valign="center");
    }
}

// =============================================================================
//  MOCKUP  --  assembled organizer populated with translucent hardware ghosts
//             (PREVIEW ONLY). show_lid toggles the box lid.
// =============================================================================
cext_w = beelink[0] + 2*clear + 2*wall;
cradle_cx = ext_w/2 + dt_p + cext_w/2;   // cradle mated to box +X side

module ghost(sz, c){ color(c) cube(sz, center=true); }

// flat ground-plane text label
module label(txt, x, y, size=9, c=[0.15,0.15,0.15]){
    color(c) translate([x, y, 0.2]) linear_extrude(1)
        text(txt, size=size, halign="center", valign="center");
}

hub_cx = cradle_cx;
hub_cy = ext_d/2 + 45;        // hub tray sits on the desk in front of the cradle

module mockup(show_lid=true){
    // --- printed parts ---
    color("SteelBlue")    drive_box();
    color("DarkSeaGreen") translate([cradle_cx, 0, 0]) minipc_cradle();
    color("Salmon")       translate([0, -ext_d/2 - 30, 0]) cable_spine();
    color("Goldenrod")    translate([hub_cx, hub_cy, 0]) hub_tray();
    if (show_lid) color([0.85,0.85,0.85,0.92]) translate([0,0,ext_h]) drive_lid();

    // --- hardware (opaque, so it actually reads) ---
    // 4 Orico enclosures standing in their bays
    for (i=[0:orico_count-1]){
        x = -in_w/2 + slot_w/2 + i*(slot_w+div);
        translate([x, 0, floor_t + orico[1]/2])
            ghost([orico[2], orico[0], orico[1]], [0.22,0.22,0.26]);
    }
    // Beelink SER6 Pro in its cradle
    translate([cradle_cx, 0, floor_t+foot_h + beelink[2]/2])
        ghost([beelink[0], beelink[1], beelink[2]], [0.12,0.12,0.14]);
    // USB hub in its tray
    translate([hub_cx, hub_cy, floor_t + hub[2]/2])
        ghost([hub[0], hub[1], hub[2]], [0.10,0.10,0.55]);

    // --- annotations ---
    label("4x ORICO 3.5\" (vertical, lid removed)", 0, ext_d/2 + 18, 10);
    label("BEELINK SER6 PRO", cradle_cx, -ext_d/2 - 6, 10);
    label("USB HUB", hub_cx, hub_cy + 42, 9);
    label("CABLE SPINE", 0, -ext_d/2 - 52, 9, [0.6,0.2,0.2]);
}

if      (part == "mockup")        mockup(true);
else if (part == "mockup_open")   mockup(false);
else if (part == "drawing")       drawing();
else if (part == "drive_lid_fan") drive_lid_fan();
else if (part == "brick_caddy")   brick_caddy();
else if (part == "layout")        layout();
else if (part == "drive_box")     drive_box();
else if (part == "drive_lid")     drive_lid();
else if (part == "minipc_cradle") minipc_cradle();
else if (part == "hub_tray")      hub_tray();
else if (part == "cable_spine")   cable_spine();
else if (part == "cable_clip")    cable_clip();
