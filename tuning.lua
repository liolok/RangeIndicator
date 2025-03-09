local BLACK = { 0, 0, 0, 1 }
local BLUE = { 0, 0, 1, 1 } -- cold
local GREEN = { 0, 1, 0, 1 }
local CYAN = { 0, 1, 1, 1 } -- light
local RED = { 1, 0, 0, 1 } -- heat
local PINK = { 1, 0, 1, 1 } -- attack
local YELLOW = { 1, 1, 0, 1 }
local WHITE = { 1, 1, 1, 1 }

local data = {} -- circle(s) of all possible prefab
local function Circle(radius, color) return { radius = radius, color = color or WHITE } end

-- Cuckoo Spinwheel: block birds
data.carnivalgame_wheelspin_station = Circle(4, YELLOW)
-- Cannon Tower
data.crabking_cannontower = Circle(15, PINK)
-- Ice Crystaleyezer: freeze/light, generate Mini Glacier, cold
data.deerclopseyeball_sentryward = { Circle(3.5, CYAN), Circle(5), Circle(12), Circle(35, BLUE) }
-- Scaled Furnace: heat
data.dragonflyfurnace = Circle(9.5, RED)
-- Houndius Shootius
data.eyeturret = Circle(18, PINK)
-- Ice Flingomatic
data.firesuppressor = Circle(15)
-- Flower, Rose, Evil Flower: simplified model of honey production range
data.flower = Circle(42, YELLOW)
data.flower_rose = data.flower
data.flower_evil = data.flower
-- Gunpowder
data.gunpowder = Circle(3, PINK)
-- Magma: heat
data.lava_pond = Circle(10, RED)
-- Treeguard Idol
data.leif_idol = Circle(10, GREEN)
-- Lightning Rod
data.lightning_rod = Circle(40, YELLOW)
-- Deadly Brightshade, Grass, (Lunar) Sapling: Brightshade aggro and protect infection
data.lunarthrall_plant = { Circle(12, PINK), Circle(30, GREEN) }
data.grass = data.lunarthrall_plant
data.sapling = data.lunarthrall_plant
data.sapling_moon = data.lunarthrall_plant
-- Celestial Altar/Sanctum/Tribute/Fissure: max linking distance between two Lunar Altars
data.moon_altar = Circle(20, BLACK)
data.moon_altar_astral = data.moon_altar
data.moon_altar_cosmic = data.moon_altar
data.moon_fissure = data.moon_altar
-- Moon Stone: cold (with a Moon Caller's Staff), attract Hounds and Werepigs
data.moonbase = {Circle(8, BLUE), Circle(30)}
-- Mushlight, Glowcap: max light range
data.mushroom_light = Circle(11.5, CYAN)
data.mushroom_light2 = Circle(10.7, CYAN)
-- (Superior) Communal Kelp Dish: make Merms respawn faster
data.offering_pot = Circle(7, GREEN)
data.offering_pot_upgraded = Circle(7, GREEN)
-- Gramophone, Shell Bell: tend Farm Plants
data.phonograph = Circle(8, GREEN)
data.singingshell_octave3 = Circle(2, GREEN)
data.singingshell_octave4 = Circle(2, GREEN)
data.singingshell_octave5 = Circle(2, GREEN)
-- Pig King: The area around must be clear to initiate Wrestling Match
data.pigking = Circle(12)
-- Polar Light: cold
data.staffcoldlight = Circle(8, BLUE)
-- Dwarf Star: heat
data.stafflight = Circle(10, RED)
-- W.O.B.O.T. / W.I.N.bot
data.storage_robot = Circle(15, YELLOW)
data.winona_storage_robot = Circle(15, YELLOW)
-- Support Pillar, Dreadstone Pillar
data.support_pillar = Circle(40, YELLOW)
data.support_pillar_dreadstone = Circle(40, YELLOW)
-- Anenemy: attack, block birds
data.trap_starfish = { Circle(1.5, PINK), Circle(4, YELLOW) }
-- Umbralla: protection (while activated on the ground)
data.voidcloth_umbrella = Circle(16, GREEN)
-- Varg: howl and summon hounds
data.warg = Circle(30) -- SPAWN_DIST from components/hounded.lua
-- Great Tree Trunk, Above-Average Tree Trunk, Knobbly Tree and Nut, Pinchin' Winch: canopy shade
data.watertree_pillar = Circle(28, GREEN)
data.oceantree_pillar = Circle(22, GREEN)
data.oceantree = Circle(22, GREEN)
data.oceantreenut = Circle(22, GREEN)
data.winch = Circle(22, GREEN)
-- Winona's Catapult: min and max attack range
data.winona_catapult = { Circle(6, PINK), Circle(15, PINK) }
-- Winona's Spotlight: normal and "spacious" light range
data.winona_spotlight = { Circle(31, CYAN), Circle(37, CYAN) }

--------------------------------------------------------------------------------
-- Feature: Click

local mouse_button = GetModConfigData('mouse_button')
if mouse_button == 'MOUSEBUTTON_LEFT' then mouse_button = 1000 end -- to fix backward compatibility
if mouse_button == 'MOUSEBUTTON_RIGHT' then mouse_button = 1001 end
if mouse_button == 'MOUSEBUTTON_MIDDLE' then mouse_button = 1002 end
local can_click = {} -- support for clicked entity prefab
for prefab, _ in pairs(data) do
  can_click[prefab] = true
end

--------------------------------------------------------------------------------
-- Feature: Deploy

local prefab_placer = {
  'carnivalgame_wheelspin_kit', -- Cuckoo Spinwheel
  'dragonflyfurnace', -- Scaled Furnace
  'dug_trap_starfish', -- Anenemy Trap
  'eyeturret_item', -- Houndius Shootius
  'lightning_rod', -- Lightning Rod
  'mushroom_light', -- Mushlight
  'mushroom_light2', -- Glowcap
  'winch', -- Pinchin' Winch
}

for index, prefab in ipairs(prefab_placer) do
  local original_prefab = prefab:gsub('^dug_', ''):gsub('_item$', ''):gsub('_kit$', '_station')
  data[prefab .. '_placer'] = data[original_prefab] -- refer to the same circle(s)
  prefab_placer[index] = prefab .. '_placer'
end

--------------------------------------------------------------------------------
-- Feature: Hover

local enable_hover = false
local can_hover = {} -- support for hovered inventory item prefab
if GetModConfigData('hover_books') then
  enable_hover = true
  for prefab, circles in pairs({
    book_birds = { Circle(3), Circle(11.5) },
    book_fire = Circle(16, GREEN),
    book_fish = Circle(13), -- 10 + 3 from prefabs/books.lua
    book_gardening = Circle(30, GREEN),
    book_horticulture = Circle(30, GREEN),
    book_horticulture_upgraded = Circle(30, GREEN),
    book_light = Circle(3, CYAN),
    book_light_upgraded = Circle(3, CYAN),
    book_rain = Circle(4, GREEN),
    book_research_station = Circle(16, GREEN),
    book_silviculture = Circle(30, GREEN),
    book_sleep = Circle(30, GREEN),
    book_temperature = Circle(16, GREEN),
    book_tentacles = { Circle(3, PINK), Circle(8, PINK) },
    book_web = Circle(6), -- BOOK_WEB_GROUND_RADIUS
  }) do
    can_hover[prefab] = true
    data[prefab] = circles
  end
end

if GetModConfigData('hover_other') then
  enable_hover = true
  for prefab, circles in pairs({
    orangeamulet = Circle(4), -- The Lazy Forager
    panflute = Circle(15, GREEN), -- Pan Flute
    polly_rogershat = Circle(15), -- Polly Roger's Hat
    spider_whistle = Circle(16, GREEN), -- Webby Whistle
    wortox_soul = Circle(8, GREEN), -- Soul
  }) do
    can_hover[prefab] = true
    data[prefab] = circles
  end
  for _, prefab in ipairs({
    'gunpowder', -- Gunpowder
    'leif_idol', -- Treeguard Idol
    'phonograph', -- Gramophone
    'singingshell_octave3', -- Shell Bell (Baritone)
    'singingshell_octave4', -- Shell Bell (Alto)
    'singingshell_octave5', -- Shell Bell (Soprano)
    'storage_robot', -- W.O.B.O.T.
    'voidcloth_umbrella', -- Umbralla
  }) do
    if data[prefab] then can_hover[prefab] = true end
  end
end

--------------------------------------------------------------------------------
-- Export: create our mod namespace

GLOBAL.TUNING.RANGE_INDICATOR = {
  DATA = data,
  CLICK = {
    KEY = GetModConfigData('click_modifier'),
    BUTTON = mouse_button,
    SUPPORT = can_click,
    AUTO_HIDE = GetModConfigData('auto_hide'),
    DOUBLE_CLICK_WAIT = GetModConfigData('double_click_speed'),
  },
  DEPLOY = prefab_placer,
  HOVER = {
    ENABLE = enable_hover,
    SUPPORT = can_hover,
    KEY = GetModConfigData('hover_modifier'),
  },
}
