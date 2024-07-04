local BLACK = { 0, 0, 0, 1 }
local BLUE = { 0, 0, 1, 1 }
local GREEN = { 0, 1, 0, 1 }
local CYAN = { 0, 1, 1, 1 }
local RED = { 1, 0, 0, 1 }
local PINK = { 1, 0, 1, 1 }
local YELLOW = { 1, 1, 0, 1 }
local WHITE = { 1, 1, 1, 1 }

local data = {} -- circle(s) of all possible prefab

-- Feature: Click --------------------------------------------------------------

local click = { -- circle(s) of clicked entity prefab
  carnivalgame_wheelspin_station = { 4 }, -- Cuckoo Spinwheel blocks birds
  deerclopseyeball_sentryward = { -- Ice Crystaleyezer
    { radius = 3.5, color = CYAN }, -- freeze
    { radius = 5, color = WHITE }, -- generate Mini Glacier (min)
    { radius = 12, color = WHITE }, -- generate Mini Glacier (max)
    { radius = 35, color = BLUE }, -- cold
  },
  dragonflyfurnace = { { radius = 9.5, color = RED } }, -- Scaled Furnace
  eyeturret = { { radius = 18, color = PINK } }, -- Houndius Shootius (Build)
  firesuppressor = { 15 }, -- Ice Flingomatic
  gunpowder = { { radius = 3, color = RED } }, -- Gunpowder
  lava_pond = { { radius = 10, color = RED } }, -- Magma
  leif_idol = { 10 }, -- Treeguard Idol
  lightning_rod = { { radius = 40, color = YELLOW } }, -- Lightning Rod
  lunarthrall_plant = { -- Deadly Brightshade
    { radius = 12, color = YELLOW }, -- aggro
    { radius = 30, color = GREEN }, -- protect infection
  },
  moon_altar = { 20 }, -- Celestial Altar
  moon_altar_astral = { 20 }, -- Celestial Sanctum
  moon_altar_cosmic = { 20 }, -- Celestial Tribute
  moon_fissure = { 20 }, -- Celestial Fissure
  moonbase = { 8 }, -- Moon Stone
  mushroom_light = { { radius = 11.5, color = CYAN } }, -- Mushlight
  mushroom_light2 = { { radius = 10.7, color = CYAN } }, -- Glowcap
  oceantree = { 22 }, -- Knobbly Tree
  oceantreenut = { 22 }, -- Knobbly Tree Nut
  oceantree_pillar = { 22 }, -- Above-Average Tree Trunk
  phonograph = { { radius = 8, color = GREEN } }, -- Gramophone
  singingshell_octave3 = { 2 }, -- Shell Bell (Baritone)
  singingshell_octave4 = { 2 }, -- Shell Bell (Alto)
  singingshell_octave5 = { 2 }, -- Shell Bell (Soprano)
  support_pillar = { { radius = 40, color = YELLOW } }, -- Support Pillar
  support_pillar_dreadstone = { { radius = 40, color = YELLOW } }, -- Dreadstone Pillar
  trap_starfish = { -- Anenemy (Planted)
    { radius = 1.5, color = RED }, -- attack
    { radius = 4, color = YELLOW }, -- block birds
  },
  voidcloth_umbrella = { 16 }, -- Umbralla
  watertree_pillar = { { radius = 28, color = GREEN } }, -- Great Tree Trunk
  winch = { 22 }, -- Pinchin' Winch
  winona_catapult = { -- Winona's Catapult
    { radius = 6, color = RED }, -- attack (min)
    { radius = 15, color = RED }, -- attack (max)
  },
}

-- Support these for range after infected by Deadly Brightshade
click.grass = click.lunarthrall_plant -- Grass
click.sapling = click.lunarthrall_plant -- Sapling
click.sapling_moon = click.lunarthrall_plant -- Lunar Sapling

for prefab, value in pairs(click) do
  data[prefab] = value
end

-- Feature: Quick Toggle -------------------------------------------------------

batch_show_tags = { -- for search entities
  'eyeturret',
  'lunarthrall_plant',
  'shadecanopy',
  'shadecanopysmall',
  'structure',
  'umbrella',
}

-- Feature: Deploy -------------------------------------------------------------

local prefab_placer = {
  'carnivalgame_wheelspin_kit', -- Cuckoo Spinwheel (Item)
  'dragonflyfurnace', -- Scaled Furnace
  'dug_trap_starfish', -- Anenemy Trap (Item)
  'eyeturret_item', -- Houndius Shootius (Item)
  'lightning_rod', -- Lightning Rod
  'mushroom_light', -- Mushlight
  'mushroom_light2', -- Glowcap
  'winch', -- Pinchin' Winch
}
for index, prefab in pairs(prefab_placer) do
  local original_prefab = prefab:gsub('^dug_', ''):gsub('_item$', ''):gsub('_kit$', '_station')
  local value = click[original_prefab]
  if value then
    local placer = prefab .. '_placer'
    data[placer] = value -- refer to the same circle(s)
    prefab_placer[index] = placer
  else
    prefab_placer[index] = nil -- original prefab data not found, remove.
  end
end

-- Feature: Hover --------------------------------------------------------------

local hover = {} -- circle(s) of hovered inventory item prefab

-- TODO: check these ranges
local book = { -- circle(s) of Wickerbottom books prefab
  book_birds = { 3, 11.5 },
  book_brimstone = { 3, 15 }, -- The End is Nigh! generates 16 consecutive Lightning strikes
  book_fire = { 16 }, -- Pyrokinetics Explained extinguishes all burning or smoldering objects
  book_fish = { 13 }, -- The Angler's Survival Guide summons Ocean Fish, 10 + 3 from Klei's prefabs/books.lua:L534-L586
  book_gardening = { 30 },
  book_horticulture = { 30 },
  book_horticulture_upgraded = { 30 },
  book_light = { 3 },
  book_light_upgraded = { 3 },
  book_rain = { 4 },
  book_research_station = { 16 },
  book_silviculture = { 30 },
  book_sleep = { 30 }, -- Sleepytime Stories
  book_temperature = { 16 },
  book_tentacles = { 3, 8.6 }, -- On Tentacles
  book_web = { 5.5 },
}

local misc = { -- circle(s) of other miscellaneous items prefab
  panflute = { 15 }, -- Pan Flute
}

local prefab_misc = {
  'gunpowder', -- Gunpowder
  'leif_idol', -- Treeguard Idol
  'phonograph', -- Gramophone
  'singingshell_octave3', -- Shell Bell (Baritone)
  'singingshell_octave4', -- Shell Bell (Alto)
  'singingshell_octave5', -- Shell Bell (Soprano)
  'voidcloth_umbrella', -- Umbralla
}

local enable_hover = false
if GetModConfigData('hover_books') then
  enable_hover = true
  for prefab, value in pairs(book) do
    hover[prefab] = value
  end
end
if GetModConfigData('hover_other') then
  enable_hover = true
  for prefab, value in pairs(misc) do
    hover[prefab] = value
  end
  for _, prefab in ipairs(prefab_misc) do
    hover[prefab] = click[prefab] or nil
  end
end

for prefab, value in pairs(hover) do
  data[prefab] = value
end

-- Export ----------------------------------------------------------------------

local function Raw(v) return GLOBAL.rawget(GLOBAL, GetModConfigData(v)) end

GLOBAL.TUNING.RANGE_INDICATOR = { -- create our mod namespace
  DATA = data,
  DEFAULT_COLOR = WHITE,

  CLICK = { MODIFIER_KEY = Raw('modifier_key'), MOUSE_BUTTON = GetModConfigData('mouse_button'), SUPPORT = click },

  BATCH = { KEY = Raw('batch_key'), TAG = batch_show_tags },

  DEPLOY = { PLACER = prefab_placer },

  HOVER = { ENABLE = enable_hover, SUPPORT = hover },
}
