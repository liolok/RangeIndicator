local G = GLOBAL
local T = { -- circle(s) of prefab
  deerclopseyeball_sentryward = { -- Ice Crystaleyezer
    { RADIUS = 35, COLOR = { 0, 0, 255, 0 } },
  },
  dragonflyfurnace = { -- Scaled Furnace
    { RADIUS = 9.5, COLOR = { 255, 0, 0, 0 } },
  },
  eyeturret = { -- Houndius Shootius (Build)
    { RADIUS = 18, COLOR = { 255, 0, 255, 0 } },
  },
  firesuppressor = { -- Ice Flingomatic
    { RADIUS = 15, COLOR = { 255, 255, 255, 0 } },
  },
  lightning_rod = { -- Lightning Rod
    { RADIUS = 40, COLOR = { 255, 255, 0, 0 } },
  },
  lunarthrall_plant = { -- Deadly Brightshade
    { RADIUS = 12, COLOR = { 255, 255, 0, 0 } },
    { RADIUS = 30, COLOR = { 0, 255, 0, 0 } },
  },
  mushroom_light = { -- Mushlight
    { RADIUS = 11.5, COLOR = { 0, 255, 255, 0 } },
  },
  mushroom_light2 = { -- Glowcap
    { RADIUS = 10.7, COLOR = { 0, 255, 255, 0 } },
  },
}
T.eyeturret_item = T.eyeturret -- Houndius Shootius (Dropped)
T.dug_sapling_moon = T.lunarthrall_plant -- Sapling (Moon) (Dropped)
T.sapling_moon = T.lunarthrall_plant -- Sapling (Moon) (Planted)

PLACER = { -- deploy helpers
  'dragonflyfurnace',
  'dug_sapling_moon',
  'eyeturret_item',
  'lightning_rod',
  'mushroom_light',
  'mushroom_light2',
}
for index, prefab in pairs(PLACER) do
  T[prefab .. '_placer'] = T[prefab] -- refer to the same circle(s)
  PLACER[index] = prefab .. '_placer' -- will add deploy helpers
end

local all_circles = {}

local function CreateCircle(inst, radius, color) -- Klei's function c_shworadius(), consolecommands.lua:L2017
  local circle = G.CreateEntity()
  circle.entity:SetParent(inst.entity)
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  local s = math.sqrt(1.385 * 1.385 / 12 * radius) -- credit: NoMu, 2914336761/scripts/prefabs/circular_placement.lua:L367
  local x, y, z = inst.Transform:GetScale() -- credit: Huxi, 3161117403/scripts/prefabs/hrange.lua:L19
  tf:SetScale(s / x, s / y, s / z) -- fight against parent's scale, be absolute.
  as:SetAddColour(G.unpack(color))

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

local function ToggleRangeIndicator(inst)
  if inst.circles then -- circles already created, remove.
    for _, v in ipairs(inst.circles) do
      if v:IsValid() then v:Remove() end
    end
    inst.circles = nil
    return
  end
  inst.circles = {} -- no circles yet, create.
  for _, V in pairs(T[inst.prefab]) do
    local circle = CreateCircle(inst, V.RADIUS, V.COLOR)
    table.insert(inst.circles, circle)
    table.insert(all_circles, circle)
  end
end

for _, prefab in ipairs(PLACER) do -- add deploy helper
  AddPrefabPostInit(prefab, ToggleRangeIndicator)
end

G.TheInput:AddMouseButtonHandler(function(button, down)
  if button == G.MOUSEBUTTON_MIDDLE and down then
    local entity = G.TheInput:GetWorldEntityUnderMouse()
    if entity and T[entity.prefab] then ToggleRangeIndicator(entity) end
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
