# rogue-organizer

A modular, 3D-printable desktop case that organizes the **`rogue`** home-server
stack (Beelink SER6 Pro running Proxmox + its USB NAS drives) and tidies the
cabling.

Holds:

- **4× Orico 3.5" single-drive USB enclosures** — stood vertically in a vented,
  lidded box (smallest footprint, best convection cooling between drives)
- **1× Beelink SER6 Pro mini PC** — open-top vented cradle
- **1× USB hub** — clip-in tray
- **Cables** — rear comb "spine" with cable channels + zip-tie slots, plus
  standalone snap clips and zip-tie anchor points built into the box/cradle

Everything is one parametric OpenSCAD file: `rogue-organizer.scad`.

![assembled preview](img/layout.png)

> The lid is shown exploded above the box. Orange faces in the per-part renders
> are just OpenSCAD's preview shading of interior surfaces — not errors.

## Parts

| Part | File | Footprint (mm) | Notes |
|------|------|----------------|-------|
| Drive box (4 bays) | `stl/drive_box.stl` | 162 × 195 × 125 | vented, dovetail groove on one side |
| Drive lid | `stl/drive_lid.stl` | 153 × 195 × 11 | friction-fit, vented, finger notch |
| Drive lid + fan | `stl/drive_lid_fan.stl` | 153 × 195 × 11 | active-cooling variant: 80/92 mm fan bore + printed guard + M4 holes |
| Mini-PC cradle | `stl/minipc_cradle.stl` | 141 × 122 × 29 | vented floor on standoffs, dovetail tongue |
| USB hub tray | `stl/hub_tray.stl` | 109 × 64 × 19 | keyhole wall mount |
| Power-brick caddy | `stl/brick_caddy.stl` | 183 × 124 × 45 | 5 vertical slots, vented, rear cable slots + zip-tie anchors |
| Cable spine | `stl/cable_spine.stl` | 200 × 8 × 28 | comb + zip-tie slots + screw ears |
| Cable clip | `stl/cable_clip.stl` | 16 × 14 × 12 | print several |

Print **either** `drive_lid` (passive) **or** `drive_lid_fan` (active) — not both.

### Arts & Crafts stacked tower (print-ready)

A space-saving alternative to the side-by-side layout: the mini PC stacks
**on top** of the drive box, in a Craftsman/Mission aesthetic. Footprint drops to
~159 × 201 mm; total height ~190 mm. Four parts, all manifold + support-free:

| Part | File | Footprint (mm) | Notes |
|------|------|----------------|-------|
| Drive section | `stl/ac_drive.stl` | 159 × 201 × 132 | 4 bays, pierced front, side louvers, corner tenons |
| Fan mid-deck | `stl/ac_deck.stl` | 153 × 195 × 32 | 80/92 mm fan + spoke guard; standoffs form the exhaust plenum |
| PC cradle | `stl/ac_cradle.stl` | 141 × 128 × 29 | vented floor, register holes, pierced front |
| Cloud-lift cap | `stl/ac_cap.stl` | 149 × 136 × 28 | overhanging top, vented, friction skirt |
| Caddy link bracket | `stl/link_bracket.stl` | 18 × 40 × 21 | keyhole hangs on tower's low peg, C-clip grips caddy front wall (print on its back) |

Render the stack with `part="ac_tower"` (assembled) or `"ac_tower_x"` (exploded).

**Integration:** the drive section has a rear **hook peg** that the USB hub
tray's keyhole hangs on, so the hub mounts directly to the tower. The power-brick
caddy stays desk-sited beside/behind the tower (an open-top tray can't hang
vertically without the bricks sliding out) and is tied into the run by the cable
spine. A **`link_bracket`** mechanically locks the caddy to the tower: it hangs on
a second (low) hook peg on the tower rear and C-clips over the caddy's front wall,
fixing the gap so the caddy can't drift. Render the whole assembly with
`part="full_system"`.

**Cooling:** the mid-deck fan pulls hot air **up** out of the drive bays and the
corner standoffs hold the PC cradle ~16 mm above the deck, so that air vents
**sideways out the reveal gap** between the two sections instead of dumping onto
the mini PC. The cradle floor is also vented for some upward flow. Run the fan as
an **exhaust** (blowing up). Assembly order: drive section → drop the deck spigot
in → press the cradle onto the deck's register pegs → friction-fit the cap.

### Drawing

`img/drawing.png` is a dimensioned top-view spec (regenerate with
`part="drawing"`, orthographic top camera). Box + cradle sit side-by-side
(~294 mm wide × 195 mm deep); the hub and brick caddy mount wherever convenient.

All parts are manifold single bodies and fit a **220 × 220 mm** bed.
(The drive box is 195 mm deep, so it will **not** fit a 180 mm bed such as a
Bambu A1 mini — see caveats.)

## >>> Before you print: confirm the measurements <<<

The model is driven entirely by variables at the top of the `.scad`. Edit and
re-export — no CAD skills needed.

```scad
orico       = [186, 118, 31.4];  // your enclosure L x W x T  (measured)
beelink     = [126, 113, 42];    // mini PC W x D x H          (spec sheet)
hub         = [100, 45, 15];     // USB hub W x D x H          (ASSUMED - measure!)
fan_size    = 80;                // 80 or 92 mm (drive_lid_fan); set fan_screw to match
brick       = [115, 50, 30];     // power-brick L x W x T      (ASSUMED - measure!)
brick_count = 5;                 // how many brick slots in the caddy
```

Fit tuning (loosen/tighten for your printer):

```scad
clear   = 1.5;   // gap around each inserted part
lid_gap = 0.35;  // lid skirt clearance
dt_cl   = 0.4;   // dovetail joint clearance
```

## Print settings (suggested)

- Material: **PETG** preferred (the drives + Ryzen run warm; PLA can creep/soften
  in a hot enclosure). PLA is fine if the lid stays off.
- Layer height: 0.2–0.28 mm
- Walls: 3 perimeters · Infill: 15–20% gyroid
- **Supports: none needed.** Every part is designed to print flat-side-down:
  louvers are horizontal slots (self-bridging), holes are ≤10 mm.
- Orientation: print each part as exported (box opening up, lid top-up, cradle
  floor-down, spine on its base).

## Assembly

1. Print all parts (×4 enclosures share one box, so just one `drive_box`).
2. **Box ↔ cradle:** slide the cradle's dovetail tongue down into the box's
   side groove. Snug? Increase `dt_cl`. Loose? Decrease it, or add a drop of
   glue / an M3 screw through the joint.
3. Stand the 4 Orico enclosures in the box bays, ports facing the **rear** (the
   rear wall has a cable slot per bay).
4. Drop the Beelink into the cradle (it rests on the internal standoffs for
   under-airflow). Use the corner cutouts to lift it back out.
5. Hang the hub tray on an M3 screw via its keyhole, or zip-tie it to the spine.
6. Route power/USB leads through the rear cable slots into the spine's channels;
   cinch bundles with zip ties through the slots; mount the spine to the desk or
   the box rear via its two screw ears.
7. Snap the lid onto the box (leave it off if you want maximum cooling).

## Regenerate STLs / images

```bash
# one part
openscad -o stl/drive_box.stl -D 'part="drive_box"' rogue-organizer.scad

# preview image (headless needs a virtual framebuffer)
xvfb-run -a openscad -o img/drive_box.png -D 'part="drive_box"' \
  --imgsize=1200,900 --colorscheme=Tomorrow --projection=p --viewall --autocenter \
  rogue-organizer.scad
```

Valid `part` values: `layout` (preview-only), `drive_box`, `drive_lid`,
`minipc_cradle`, `hub_tray`, `cable_spine`, `cable_clip`.

## Styled stacked variations (concept)

To shrink the desk footprint, the mini PC can stack **on top of** the drive box
as a tower (footprint drops from ~294 mm wide to just the box's ~162 × 195 mm).
Two aesthetic concepts are included as renders (`part="tower_steampunk"` /
`"tower_artscraft"`):

- **Steampunk** (`img/tower_steampunk.png`) — brass tone, riveted porthole vents,
  riveted corner straps, side louvers, and pipe/valve/pressure-gauge top fittings.
- **Arts & Crafts** (`img/tower_artscraft.png`) — warm wood tone, Mission-style
  pierced rectilinear vents, exposed square through-tenon corner pegs, an
  overhanging cloud-lift top cap, and a plinth base with block feet.

The **steampunk** concept (brass, rivets, pipe fittings) is still a render-only
concept. The **Arts & Crafts** direction has since been developed into real
print-ready parts with a mid-deck fan — see *Arts & Crafts stacked tower* above.

## Cross-vet — known weak points

In the spirit of this repo, here are the design's honest counter-arguments:

1. **Heat is still the main risk.** Four 3.5" HDDs plus a Ryzen 9 6900HX in/near
   a closed box generate meaningful heat. Mitigations now built in: passive
   louvers + floor vents, an open-top cradle, and the **`drive_lid_fan`**
   active-cooling lid (80/92 mm fan). For a spinning-rust NAS, running the fan
   as a gentle **exhaust** (pulling air up and out the lid) is recommended. Power
   it from a USB or 12 V header — a fan controller/header is out of scope here.
2. **Brick caddy holds 5 slots; sizes are assumed.** `brick_caddy` organizes the
   wall-warts in vertical slots, but `brick = [115,50,30]` and `brick_count = 5`
   are placeholders — measure your bricks and adjust. Very large or oddly shaped
   bricks may need a wider slot or fewer slots. The power *strip* itself is not
   enclosed (most are too long); route its cable through the spine.
3. **Bed size assumed 220 mm.** The drive box (195 mm deep) won't fit smaller
   beds; it would need splitting into front/back halves for a 180 mm printer.
4. **Joint clearances are printer-dependent.** `lid_gap` and `dt_cl` are first
   guesses — print one corner test if you want to dial them in before committing
   to the big box.
5. **Hub dimensions are assumed.** `hub = [100, 45, 15]` is a placeholder; the
   tray will be wrong until you measure the actual hub.

## Provenance

Mini PC identified from the home-lab vault note *"Beelink SER6 Pro Mini PC —
Home Server Setup Guide"* (hostname `rogue`). Enclosure dimensions measured by
the user off the packaging. Beelink dimensions cross-checked against the
manufacturer spec sheet.
