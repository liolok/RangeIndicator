local G = GLOBAL

-- Colors
-- stylua: ignore start
local BLACK   = { 0, 0, 0, 1 }
local BLUE    = { 0, 0, 1, 1 }
local GREEN   = { 0, 1, 0, 1 }
local CYAN    = { 0, 1, 1, 1 }
local RED     = { 1, 0, 0, 1 }
local PINK    = { 1, 0, 1, 1 }
local YELLOW  = { 1, 1, 0, 1 }
local WHITE   = { 1, 1, 1, 1 }
-- stylua: ignore end

local CIRCLE = { -- circle(s) of prefab
  book_birds = { 3, 10 },
  book_brimstone = { 3, 15 }, -- The End is Nigh! generates 16 consecutive Lightning strikes
  book_fire = { 16 }, -- Pyrokinetics Explained extinguishes all burning or smoldering objects
  book_fish = { 13 }, -- The Angler's Survival Guide summons a school of Ocean Fish that can appear in the ocean type | 10 + 3 from Klei's prefabs/books.lua:L534-L586
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
  book_tentacles = { 3, 8 }, -- On Tentacles
  book_web = { 8 },
  deerclopseyeball_sentryward = { -- Ice Crystaleyezer
    { RADIUS = 3.5, COLOR = CYAN }, -- freeze
    { RADIUS = 5, COLOR = WHITE }, -- generate Mini Glacier (min)
    { RADIUS = 12, COLOR = WHITE }, -- generate Mini Glacier (max)
    { RADIUS = 35, COLOR = BLUE }, -- cold
  },
  dragonflyfurnace = { { RADIUS = 9.5, COLOR = RED } }, -- Scaled Furnace
  eyeturret = { { RADIUS = 18, COLOR = PINK } }, -- Houndius Shootius (Build)
  eyeturret_item = { { RADIUS = 18, COLOR = PINK } }, -- Houndius Shootius (Dropped)
  firesuppressor = { 15 }, -- Ice Flingomatic
  gunpowder = { { RADIUS = 3, COLOR = RED } }, -- Gunpowder
  lava_pond = { { RADIUS = 10, COLOR = RED } }, -- Magma
  leif_idol = { 10 }, -- Treeguard Idol
  lightning_rod = { { RADIUS = 40, COLOR = YELLOW } }, -- Lightning Rod
  lunarthrall_plant = { -- Deadly Brightshade
    { RADIUS = 12, COLOR = YELLOW }, -- aggro
    { RADIUS = 30, COLOR = GREEN }, -- protect infection
  },
  moon_altar = { 20 }, -- Celestial Altar
  moon_altar_astral = { 20 }, -- Celestial Sanctum
  moon_altar_cosmic = { 20 }, -- Celestial Tribute
  moon_fissure = { 20 }, -- Celestial Fissure
  moonbase = { 8 }, -- Moon Stone
  mushroom_light = { { RADIUS = 11.5, COLOR = CYAN } }, -- Mushlight
  mushroom_light2 = { { RADIUS = 10.7, COLOR = CYAN } }, -- Glowcap
  oceantree = { 22 }, -- Knobbly Tree
  oceantreenut = { 22 }, -- Knobbly Tree Nut
  oceantree_pillar = { 22 }, -- Above-Average Tree Trunk
  winch = { 22 }, -- Pinchin' Winch
  panflute = { 15 }, -- Pan Flute
  phonograph = { { RADIUS = 8, COLOR = GREEN } }, -- Gramophone
  singingshell_octave3 = { 2 },
  singingshell_octave4 = { 2 },
  singingshell_octave5 = { 2 },
  support_pillar = { { RADIUS = 40, COLOR = YELLOW } }, -- Support Pillar
  support_pillar_dreadstone = { { RADIUS = 40, COLOR = YELLOW } }, -- Dreadstone Pillar
  voidcloth_umbrella = { 16 }, -- Umbralla
  watertree_pillar = { { RADIUS = 28, COLOR = GREEN } }, -- Great Tree Trunk
}
CIRCLE.dug_sapling_moon = CIRCLE.lunarthrall_plant -- Sapling (Moon) (Dropped)
CIRCLE.sapling_moon = CIRCLE.lunarthrall_plant -- Sapling (Moon) (Planted)

local show_range_on_hover = {
  gunpowder = true,
  leif_idol = true,
  panflute = true,
  phonograph = true,
  voidcloth_umbrella = true,
}
for prefab, _ in pairs(CIRCLE) do
  if prefab:find('^book') or prefab:find('^sing') then show_range_on_hover[prefab] = true end
end

local deploy_helpers = {
  'dragonflyfurnace',
  'dug_sapling_moon',
  'eyeturret_item',
  'lightning_rod',
  'mushroom_light',
  'mushroom_light2',
  'winch',
}
for index, prefab in pairs(deploy_helpers) do
  CIRCLE[prefab .. '_placer'] = CIRCLE[prefab] -- refer to the same circle(s)
  deploy_helpers[index] = prefab .. '_placer'
end

local all_circles = {} -- track all the circles we create

local function CreateCircle(inst, radius, color) -- Klei's function c_shworadius(), consolecommands.lua:L2017
  local circle = G.CreateEntity()
  circle.entity:SetParent(inst.entity)
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  local s = math.sqrt(1.385 * 1.385 / 12 * radius) -- credit: NoMu, 2914336761/scripts/prefabs/circular_placement.lua:L367
  local x, y, z = inst.Transform:GetScale() -- credit: Huxi, 3161117403/scripts/prefabs/hrange.lua:L19
  tf:SetScale(s / x, s / y, s / z) -- fight against parent's scale, be absolute.

  -- credit: CarlZalph, https://forums.kleientertainment.com/forums/topic/69594-solved-how-to-make-character-glow-a-certain-color/#comment-804165
  as:SetAddColour(G.unpack(color))
  as:SetMultColour(G.unpack(color)) -- try to erase original color

  circle.entity:SetCanSleep(false)
  circle.persists = false
  circle:AddTag('CLASSIFIED')
  circle:AddTag('NOCLICK')
  as:SetBank('firefighter_placement')
  as:SetBuild('firefighter_placement')
  as:PlayAnimation('idle')
  as:SetLightOverride(1)
  as:SetOrientation(G.ANIM_ORIENTATION.OnGround)
  as:SetLayer(G.LAYER_BACKGROUND)
  as:SetSortOrder(1)

  return circle
end

local function ShowRangeIndicator(inst, prefab)
  if not CIRCLE[prefab or inst.prefab] then return end
  if inst.circles and #inst.circles > 0 then return end
  inst.circles = {}
  for _, C in pairs(CIRCLE[prefab or inst.prefab]) do
    local circle = nil
    if type(C) == 'number' then -- only radius, use white as fallback
      circle = CreateCircle(inst, C, WHITE)
    elseif type(C) == 'table' then -- both radius and custom color
      circle = CreateCircle(inst, C.RADIUS, C.COLOR)
    end
    if not circle then return end
    table.insert(inst.circles, circle)
    table.insert(all_circles, circle)
  end
end

local function HideRangeIndicator(inst)
  if not inst.circles then return end
  for _, v in ipairs(inst.circles) do
    if v:IsValid() then v:Remove() end
  end
  inst.circles = nil
end

local function ToggleRangeIndicator(inst)
  local fn = inst.circles and HideRangeIndicator or ShowRangeIndicator
  fn(inst)
end

for _, prefab in ipairs(deploy_helpers) do
  AddPrefabPostInit(prefab, ShowRangeIndicator)
end

AddClassPostConstruct('widgets/hoverer', function(self)
  if not self.text then return end
  local OldSetString = self.text.SetString
  local OldHide = self.text.Hide

  self.text.SetString = function(text, str, ...)
    local e = G.TheInput:GetHUDEntityUnderMouse()
    local prefab = e and e.widget and e.widget.parent and e.widget.parent.item and e.widget.parent.item.prefab or nil
    if prefab and show_range_on_hover[prefab] then ShowRangeIndicator(G.ThePlayer, prefab) end
    return OldSetString(text, str, ...)
  end

  self.text.Hide = function(...)
    HideRangeIndicator(G.ThePlayer)
    return OldHide(...)
  end
end)

G.TheInput:AddMouseButtonHandler(function(button, down)
  if button == G.MOUSEBUTTON_MIDDLE and down then
    local entity = G.TheInput:GetWorldEntityUnderMouse()
    if entity and CIRCLE[entity.prefab] then ToggleRangeIndicator(entity) end
  end
end)

local key_clear = GetModConfigData('key_clear')
G.TheInput:AddKeyHandler(function(key, down)
  if key == key_clear and down then
    for _, c in ipairs(all_circles) do
      if c:IsValid() then c:Remove() end
    end
    all_circles = {}
  end
end)
