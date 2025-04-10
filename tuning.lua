-- stylua: ignore
local COLOR = {
  black  = { 0, 0, 0, 1 },
  blue   = { 0, 0, 1, 1 }, -- cold,
  green  = { 0, 1, 0, 1 },
  cyan   = { 0, 1, 1, 1 }, -- light
  red    = { 1, 0, 0, 1 }, -- heat
  pink   = { 1, 0, 1, 1 }, -- attack
  yellow = { 1, 1, 0, 1 },
  white  = { 1, 1, 1, 1 }, -- default
}

TUNING.RANGE_INDICATOR = { data = { click = {}, place = {}, hover = {} } }
local data = TUNING.RANGE_INDICATOR.data
local tonumber = GLOBAL.tonumber
local function Circle(feature, prefabs, radius, color, name)
  local data = data[feature]
  local prefab_suffix = feature == 'place' and '_placer' or ''
  for _, prefab in ipairs(type(prefabs) == 'table' and prefabs or { prefabs }) do
    local prefab = prefab .. prefab_suffix
    if not data[prefab] then data[prefab] = {} end
    local data = data[prefab]
    local color = COLOR[color] or COLOR.white
    for _, r in ipairs(type(radius) == 'table' and radius or { radius }) do
      local r = tonumber(r)
      if r then data[name or (#data + 1)] = { radius = r, color = color } end
    end
  end
end

TUNING.RANGE_INDICATOR.IS_STANDALONE = {}
local function Standalone(prefab) TUNING.RANGE_INDICATOR.IS_STANDALONE[prefab] = true end

--------------------------------------------------------------------------------
-- Feature: Click to Toggle

local function Click(...) Circle('click', ...) end

-- Nautopilot and Nautopilot Beacon
Click({ 'boat_magnet', 'boat_magnet_beacon' }, 24, 'yellow')
-- Cactus: regrowth
Click({ 'cactus', 'oasis_cactus' }, 20)
-- Hollow Stump: regrowth
Click('catcoonden', 20)
-- Cave Banana Tree: regrowth
Click('cave_banana_tree', 20)
-- Cuckoo Spinwheel: block birds
Click('carnivalgame_wheelspin_station', 4, 'yellow')
-- Cannon Tower
Click('crabking_cannontower', 15, 'pink')
-- Gem Deer: Cast magical circle
Click('deer_blue', 15, 'blue')
Click('deer_red', 15, 'red') -- DEER_GEMMED_CAST_MAX_RANGE rather than 12 from DEER_GEMMED_CAST_RANGE
-- Ice Crystaleyezer: freeze/light, generate Mini Glacier, cold
Click('deerclopseyeball_sentryward', 3.5, 'cyan')
Click('deerclopseyeball_sentryward', { 5, 12 })
Click('deerclopseyeball_sentryward', 35, 'blue')
-- Scaled Furnace: heat
Click('dragonflyfurnace', 9.5, 'red')
-- Houndius Shootius
Click('eyeturret', 18, 'pink')
-- Ice Flingomatic
Click('firesuppressor', 15)
-- Flower, Rose, Evil Flower: simplified model of honey production range
Click({ 'flower', 'flower_rose', 'flower_evil' }, 42, 'yellow')
-- Light Flower: regrowth
Click({ 'flower_cave', 'flower_cave_double', 'flower_cave_triple', 'lightflier_flower' }, 20)
-- Gunpowder
Click('gunpowder', 3, 'pink')
-- Sign, Directional Sign: block Lunar/Shadow Rift
Click({ 'homesign', 'arrowsign_post' }, 24)
-- Magma: heat
Click('lava_pond', 10, 'red')
-- Treeguard Idol
Click('leif_idol', 10, 'green')
-- Lightning Rod
Click('lightning_rod', 40, 'yellow')
Standalone('lightning_rod')
-- Deadly Brightshade, Grass, (Lunar) Sapling: Brightshade aggro and protect infection
Click({ 'lunarthrall_plant', 'grass', 'sapling', 'sapling_moon' }, 12, 'pink')
Click({ 'lunarthrall_plant', 'grass', 'sapling', 'sapling_moon' }, 30, 'green')
-- Queen of Moon Quay: Risk of Pirate Raid, Red/Yellow/Green for High/Med/Low.
Click('monkeyqueen', 300, 'red')
Click('monkeyqueen', 600, 'yellow')
Click('monkeyqueen', 800, 'green')
Standalone('monkeyqueen')
-- Celestial Altar/Sanctum/Tribute/Fissure: max linking distance between two Lunar Altars
Click({ 'moon_altar', 'moon_altar_astral', 'moon_altar_cosmic', 'moon_fissure' }, 20, 'black')
-- Moon Stone: cold (with a Moon Caller's Staff), attract Hounds and Werepigs
Click('moonbase', 8, 'blue')
Click('moonbase', 30)
-- Mushlight, Glowcap: max light range
Click('mushroom_light', 11.5, 'cyan')
Click('mushroom_light2', 10.7, 'cyan')
-- (Superior) Communal Kelp Dish: make Merms respawn faster
Click({ 'offering_pot', 'offering_pot_upgraded' }, 7, 'green')
-- Gramophone, Shell Bell: tend Farm Plants
Click('phonograph', 8, 'green')
Click({ 'singingshell_octave3', 'singingshell_octave4', 'singingshell_octave5' }, 2, 'green')
-- Pig King: The area around must be clear to initiate Wrestling Match
Click('pigking', 12)
-- Rabbit Hole: regrowth
Click('rabbithole', 20)
-- Red Mushroom, Green Mushroom, Blue Mushroom: regrowth
Click({ 'red_mushroom', 'green_mushroom', 'blue_mushroom' }, 20)
-- Reeds: regrowth
Click('reeds', 20)
-- Polar Light: cold
Click('staffcoldlight', 8, 'blue')
-- Dwarf Star: heat
Click('stafflight', 10, 'red')
-- W.O.B.O.T. / W.I.N.bot
Click({ 'storage_robot', 'winona_storage_robot' }, 15, 'yellow')
Standalone('storage_robot')
Standalone('winona_storage_robot')
-- Support Pillar, Dreadstone Pillar
Click({ 'support_pillar', 'support_pillar_dreadstone' }, 40, 'yellow')
Standalone('support_pillar')
Standalone('support_pillar_dreadstone')
-- Anenemy: attack, block birds
Click('trap_starfish', 1.5, 'pink')
Click('trap_starfish', 4, 'yellow')
-- Umbralla: protection (while activated on the ground)
Click('voidcloth_umbrella', 16, 'green')
-- Varg: howl and summon hounds
Click('warg', 30) -- SPAWN_DIST from components/hounded.lua
-- Killer Bee Hive
Click('wasphive', 10, 'pink')
-- Great Tree Trunk, Above-Average Tree Trunk, Knobbly Tree and Nut, Pinchin' Winch: canopy shade
Click('watertree_pillar', 28, 'green')
Click({ 'oceantree_pillar', 'oceantree', 'oceantreenut', 'winch' }, 22, 'green')
-- Winona's Catapult: min and max attack range
Click('winona_catapult', { 6, 15 }, 'pink')
-- Winona's Spotlight: normal and "spacious" light range
Click('winona_spotlight', { 31, 37 }, 'cyan')

--------------------------------------------------------------------------------
-- Feature: Place

local function Place(...) Circle('place', ...) end

-- Nautopilot Kit
Place('boat_magnet_kit', 24, 'yellow')
-- Cuckoo Spinwheel: block birds
Place('carnivalgame_wheelspin_kit', 4, 'yellow')
-- Scaled Furnace: heat
Place('dragonflyfurnace', 9.5, 'red')
-- Anenemy Trap: attack, block birds
Place('dug_trap_starfish', 1.5, 'pink')
Place('dug_trap_starfish', 4, 'yellow')
-- Houndius Shootius
Place('eyeturret_item', 18, 'pink')
-- Sign, Directional Sign: block Lunar/Shadow Rift
Place({ 'homesign', 'arrowsign_post' }, 24)
-- Lightning Rod
Place('lightning_rod', 40, 'yellow')
-- Mushlight, Glowcap: max light range
Place('mushroom_light', 11.5, 'cyan')
Place('mushroom_light2', 10.7, 'cyan')
-- Pinchin' Winch: Above-Average Tree Trunk's canopy shade
Place('winch', 22, 'green')

--------------------------------------------------------------------------------
-- Feature: Hover

local HOVER_BOOKS = GetModConfigData('hover_books')
local HOVER_OTHER = GetModConfigData('hover_other')
TUNING.RANGE_INDICATOR.ENABLE_HOVER = HOVER_BOOKS or HOVER_OTHER

local function Hover(...) Circle('hover', ...) end

if HOVER_BOOKS then
  Hover('book_birds', { 3, 11.5 })
  Hover('book_fire', 16, 'green')
  Hover('book_fish', 13) -- 10 + 3 from prefabs/books.lua
  Hover({ 'book_gardening', 'book_silviculture', 'book_sleep' }, 30, 'green')
  Hover({ 'book_horticulture', 'book_horticulture_upgraded' }, 30, 'green')
  Hover({ 'book_light', 'book_light_upgraded' }, 3, 'cyan')
  Hover('book_rain', 4, 'green')
  Hover({ 'book_research_station', 'book_temperature' }, 16, 'green')
  Hover('book_tentacles', { 3, 8 }, 'pink')
  Hover('book_web', 6) -- BOOK_WEB_GROUND_RADIUS
end

if HOVER_OTHER then
  -- Nautopilot Beacon
  Hover('boat_magnet_beacon', 24, 'yellow')
  -- Gunpowder
  Hover('gunpowder', 3, 'pink')
  -- Treeguard Idol
  Hover('leif_idol', 10, 'green')
  -- The Lazy Forager
  Hover('orangeamulet', 4)
  -- Pan Flute
  Hover('panflute', 15, 'green')
  -- Gramophone, Shell Bell: tend Farm Plants
  Hover('phonograph', 8, 'green')
  Hover({ 'singingshell_octave3', 'singingshell_octave4', 'singingshell_octave5' }, 2, 'green')
  -- Polly Roger's Hat
  Hover('polly_rogershat', 15)
  -- Webby Whistle
  Hover('spider_whistle', 16, 'green')
  -- W.O.B.O.T.
  Hover('storage_robot', 15, 'yellow')
  -- Umbralla: protection (while activated on the ground)
  Hover('voidcloth_umbrella', 16, 'green')
  -- Soul: heal after release
  Hover('wortox_soul', 8, 'green', 'heal')
end

--------------------------------------------------------------------------------
-- Console Commands

GLOBAL.ri_click = Click
GLOBAL.ri_hover = Hover
