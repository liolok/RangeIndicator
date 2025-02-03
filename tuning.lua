local BLACK = { 0, 0, 0, 1 }
local BLUE = { 0, 0, 1, 1 } -- cold
local GREEN = { 0, 1, 0, 1 }
local CYAN = { 0, 1, 1, 1 } -- light
local RED = { 1, 0, 0, 1 } -- heat
local PINK = { 1, 0, 1, 1 } -- attack
local YELLOW = { 1, 1, 0, 1 }
local WHITE = { 1, 1, 1, 1 }

local data = {} -- circle(s) of all possible prefab

-- Cuckoo Spinwheel: block birds
data.carnivalgame_wheelspin_station = { { radius = 4, color = YELLOW } }
-- Ice Crystaleyezer: freeze/light, generate Mini Glacier, cold
data.deerclopseyeball_sentryward = {
  { radius = 3.5, color = CYAN },
  { radius = 5, color = WHITE },
  { radius = 12, color = WHITE },
  { radius = 35, color = BLUE },
}
-- Scaled Furnace: heat
data.dragonflyfurnace = { { radius = 9.5, color = RED } }
-- Houndius Shootius
data.eyeturret = { { radius = 18, color = PINK } }
-- Ice Flingomatic
data.firesuppressor = { { radius = 15, color = WHITE } }
-- Gunpowder
data.gunpowder = { { radius = 3, color = PINK } }
-- Magma: heat
data.lava_pond = { { radius = 10, color = RED } }
-- Treeguard Idol
data.leif_idol = { { radius = 10, color = GREEN } }
-- Deadly Brightshade, Grass, (Lunar) Sapling: Brightshade aggro and protect infection
data.lunarthrall_plant = { { radius = 12, color = PINK }, { radius = 30, color = GREEN } }
for _, prefab in ipairs({ 'grass', 'sapling', 'sapling_moon' }) do
  data[prefab] = data.lunarthrall_plant
end
-- Celestial Altar/Sanctum/Tribute/Fissure: max linking distance between two Lunar Altars
data.moon_altar = { { radius = 20, color = BLACK } }
for _, prefab in ipairs({ 'moon_altar_astral', 'moon_altar_cosmic', 'moon_fissure' }) do
  data[prefab] = data.moon_altar
end
-- Moon Stone: cold (with a Moon Caller's Staff)
data.moonbase = { { radius = 8, color = BLUE } }
-- Mushlight, Glowcap: max light range
data.mushroom_light = { { radius = 11.5, color = CYAN } }
data.mushroom_light2 = { { radius = 10.7, color = CYAN } }
-- (Superior) Communal Kelp Dish: make Merms respawn faster
data.offering_pot = { { radius = 7, color = GREEN } }
data.offering_pot_upgraded = data.offering_pot
-- Gramophone, Shell Bell: tend Farm Plants
data.phonograph = { { radius = 8, color = GREEN } }
data.singingshell_octave3 = { { radius = 2, color = GREEN } }
data.singingshell_octave4 = data.singingshell_octave3
data.singingshell_octave5 = data.singingshell_octave3
-- Polar Light: cold
data.staffcoldlight = { { radius = 8, color = BLUE } }
-- Dwarf Star: heat
data.stafflight = { { radius = 10, color = RED } }
-- W.O.B.O.T. / W.I.N.bot
data.storage_robot = { { radius = 15, color = YELLOW } }
data.winona_storage_robot = data.storage_robot
-- Support Pillar, Dreadstone Pillar
data.support_pillar = { { radius = 40, color = YELLOW } }
data.support_pillar_dreadstone = data.support_pillar
-- Anenemy: attack, block birds
data.trap_starfish = { { radius = 1.5, color = PINK }, { radius = 4, color = YELLOW } }
-- Umbralla: protection (while activated on the ground)
data.voidcloth_umbrella = { { radius = 16, color = GREEN } }
-- Great Tree Trunk, Above-Average Tree Trunk, Knobbly Tree and Nut, Pinchin' Winch: canopy shade
data.watertree_pillar = { { radius = 28, color = GREEN } }
data.oceantree_pillar = { { radius = 22, color = GREEN } }
for _, prefab in ipairs({ 'oceantree', 'oceantreenut', 'winch' }) do
  data[prefab] = data.oceantree_pillar
end
-- Winona's Catapult: min and max attack range
data.winona_catapult = { { radius = 6, color = PINK }, { radius = 15, color = PINK } }
-- simplified model of honey production range
if GetModConfigData('hover_beebox') then
  data.beebox = {{ radius = 42, color = YELLOW }}
end
-- Lightning Rod
if GetModConfigData('hover_lightning_rod') then
  data.lightning_rod = {{ radius = 40, color = YELLOW }}
end

-- Feature: Click --------------------------------------------------------------

local modifier_key = GetModConfigData('click_modifier')
local mouse_button = GetModConfigData('mouse_button')
if mouse_button == 'MOUSEBUTTON_LEFT' then mouse_button = 1000 end -- to fix backward compatibility
if mouse_button == 'MOUSEBUTTON_RIGHT' then mouse_button = 1001 end
if mouse_button == 'MOUSEBUTTON_MIDDLE' then mouse_button = 1002 end
local can_click = {} -- support for clicked entity prefab
for prefab, _ in pairs(data) do
  can_click[prefab] = true
end
local auto_hide = GetModConfigData('auto_hide')

-- Feature: Batch Toggle -------------------------------------------------------

local batch_show_tags = { -- for search entities
  'HASHEATER',
  'eyeturret',
  'lunarthrall_plant',
  'shadecanopy',
  'shadecanopysmall',
  'structure',
  'umbrella',
}

-- Feature: Deploy -------------------------------------------------------------

local prefab_placer = {}

for _, prefab in ipairs({
  'carnivalgame_wheelspin_kit', -- Cuckoo Spinwheel
  'dragonflyfurnace', -- Scaled Furnace
  'dug_trap_starfish', -- Anenemy Trap
  'eyeturret_item', -- Houndius Shootius
  'mushroom_light', -- Mushlight
  'mushroom_light2', -- Glowcap
  'winch', -- Pinchin' Winch
  (GetModConfigData('hover_beebox') and 'beebox') or nil, -- Beebox
  (GetModConfigData('hover_lightning_rod') and 'lightning_rod') or nil -- Lightning rod
}) do
  if prefab then
    table.insert(prefab_placer, prefab)
  end
end

-- 轉換 placer 版本
for index, prefab in ipairs(prefab_placer) do
  local original_prefab = prefab:gsub('^dug_', ''):gsub('_item$', ''):gsub('_kit$', '_station')
  if data[original_prefab] then
    data[prefab .. '_placer'] = data[original_prefab] -- refer to the same circle(s)
    prefab_placer[index] = prefab .. '_placer'
  end
end

-- Feature: Hover --------------------------------------------------------------

local enable_hover = false
local can_hover = {} -- support for hovered inventory item prefab
if GetModConfigData('hover_books') then
  enable_hover = true
  for prefab, circles in pairs({
    book_birds = { { radius = 3, color = WHITE }, { radius = 11.5, color = WHITE } },
    book_brimstone = { { radius = 3, color = PINK }, { radius = 15, color = PINK } },
    book_fire = { { radius = 16, color = WHITE } },
    book_fish = { { radius = 13, color = WHITE } }, -- 10 + 3 from prefabs/books.lua
    book_gardening = { { radius = 30, color = GREEN } },
    book_horticulture = { { radius = 30, color = GREEN } },
    book_horticulture_upgraded = { { radius = 30, color = GREEN } },
    book_light = { { radius = 3, color = CYAN } },
    book_light_upgraded = { { radius = 3, color = CYAN } },
    book_rain = { { radius = 4, color = GREEN } },
    book_research_station = { { radius = 16, color = WHITE } },
    book_silviculture = { { radius = 30, color = WHITE } },
    book_sleep = { { radius = 30, color = GREEN } },
    book_temperature = { { radius = 16, color = GREEN } },
    book_tentacles = { { radius = 3, color = PINK }, { radius = 8.6, color = PINK } },
    book_web = { { radius = 5.5, color = WHITE } },
  }) do
    can_hover[prefab] = true
    data[prefab] = circles
  end
end
if GetModConfigData('hover_other') then
  enable_hover = true
  for prefab, circles in pairs({
    panflute = { { radius = 15, color = GREEN } }, -- Pan Flute
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

-- Export ----------------------------------------------------------------------

GLOBAL.TUNING.RANGE_INDICATOR = { -- create our mod namespace
  DATA = data,
  CLICK = { KEY = modifier_key, BUTTON = mouse_button, SUPPORT = can_click, AUTO_HIDE = auto_hide },
  BATCH = { TAG = batch_show_tags },
  DEPLOY = prefab_placer,
  HOVER = { ENABLE = enable_hover, SUPPORT = can_hover },
}
