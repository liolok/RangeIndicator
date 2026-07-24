Show ranges by clicking, placing or hovering.
Support binding key at bottom of Settings > Controls page.

## Features

- By default, use middle mouse button to click object to show/hide its range.
(Configurable modifier key, double click to toggle ranges of all objects of the same kind.)
- By default, press F5 to clear all ranges in your view.
- Show range when placing (deploy/build/plant).
(Geometric Placement mod's Evergreen sapling button takes control.)
- Show range when inventory item hovered by cursor.
(Configurable modifier key, could be partially/completely disabled.)

## Compatibility

### Click to Toggle

- Nautopilot and Nautopilot Beacon
- Cactus: regrowth
- Hollow Stump: regrowth
- Cave Banana Tree: regrowth
- Cuckoo Spinwheel: block birds
- Cannon Tower
- Gem Deer: Cast magical circle
- Ice Crystaleyezer: freeze/light, generate Mini Glacier, cold
- Scaled Furnace: heat
- Houndius Shootius
- T.I.N.G.L.E. Node
- Ice Flingomatic
- Flower, Rose, Evil Flower: Butterfly spawn range, simplified model of honey production range
- Light Flower: regrowth
- Icker Preserve with Scorching Sunfish: keep warm in range of Ice Crystaleyezer
- Gunpowder, Slurtle Slime: Explosion
- Sign, Directional Sign: block Lunar/Shadow Rift
- Magma: burn, heat
- Treeguard Idol
- Lightning Rod
- Deadly Brightshade, Grass, (Lunar) Sapling: Brightshade aggro and protect infection
- Lureplant: Attract Wild Fire
- Queen of Moon Quay: Risk of Pirate Raid, Red/Yellow/Green for High/Med/Low.
- Celestial Altar/Sanctum/Tribute/Fissure: max linking distance between two Lunar Altars
- Mysterious Energy, Lunar Siphonator: max range of meteors when spawning Celestial Champion
- Moon Stone: cold (with a Moon Caller's Staff), attract Hounds and Werepigs
- Mushlight, Glowcap: max light range
- (Superior) Communal Kelp Dish: make Merms respawn faster
- Gramophone, B.U.D.D.Y., Shell Bell: tend Farm Plants
- Pig King: The area around must be clear to initiate Wrestling Match
- Rabbit Hole: regrowth
- Red Mushroom, Green Mushroom, Blue Mushroom: regrowth
- Reeds: regrowth
- Friendly Scarecrow: replace Crow with Canary
- Spider Den: Attack back (other seasons and Spring), (tier 3) spawn Spider Queen with player nearby.
- Polar Light: cold
- Dwarf Star: heat
- W.O.B.O.T. / W.I.N.bot
- Support Pillar, Dreadstone Pillar
- Tentacle: pop up, attack
- Shadow Thurible: prevent bone cage
- Anenemy: attack, block birds
- Umbralla: protection (while activated on the ground)
- Terramite: work
- Varg， Possessed Varg: howl and summon hounds
- Killer Bee Hive
- Great Tree Trunk, Above-Average Tree Trunk, Knobbly Tree and Nut: canopy shade
- Pinchin' Winch: salvage, Above-Average Tree Trunk's canopy shade
- Winona's Catapult: min and max attack range
- Winona's Spotlight: normal and "spacious" light range

### Place (Deploy/Build/Plant)

- Nautopilot Kit
- Cuckoo Spinwheel Kit: block birds
- Scaled Furnace: heat
- Anenemy Trap: attack, block birds
- Icker Preserve with Scorching Sunfish: keep warm in range of Ice Crystaleyezer
- Houndius Shootius
- Sign, Directional Sign: block Lunar/Shadow Rift
- Lightning Rod
- Lureplant: Attract Wild Fire
- Incomplete Experiment: max range of meteors when spawning Celestial Champion
- Mushlight, Glowcap: max light range
- Friendly Scarecrow: replace Crow with Canary
- Pinchin' Winch: salvage, Above-Average Tree Trunk's canopy shade

### Hover on Inventory Item

- Wickerbottom's Books
- Wigfrid's Battle Calls
- Nautopilot Beacon
- Luxury Fan: cool down body temperature, put out fire
- Gunpowder, Slurtle Slime: Explosion
- Beefalo Horn: gather Beefalo, tend Farm Plants
- Treeguard Idol
- One-man Band: befriend Pigs or Bunnymen, tend Farm Plants
- The Lazy Forager
- Pan Flute
- Gramophone, B.U.D.D.Y., Shell Bell, Strident Trident, Gnarwail Horn: tend Farm Plants
- Polly Roger's Hat
- Webby Whistle
- W.O.B.O.T.
- Shadow Thurible: prevent bone cage
- Gloomerang: Attack
- Umbralla: protection (while activated on the ground)
- Terramite: work
- Soul: heal after release

## Console Commands

To show a custom range for entity under mouse or character, run command:

```
ri_show(radius, color)
```

First argument is radius, 4 is one tile.
Second argument is optional color defaults to white, valid values are:

- 'black'
- 'blue' cold
- 'green'
- 'cyan' light
- 'red' heat
- 'pink' attack
- 'yellow'
- 'white' default

To show custom ranges for all of the same kind of entity under mouse, run command:

```
ri_show_all(radius, color)
```

To hide these ranges, run command:

```
ri_hide()
```

Or just press key bound to clear all ranges in your view.

## Contributors

冰汽, Huxi, takaoinari, adai1198, (TW)Eric, liolok

---

[Source code](https://github.com/liolok/RangeIndicator)
