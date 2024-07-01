modimport('tuning')
local G = GLOBAL
local T = TUNING.RANGE_INDICATOR

local function CreateCircle(inst, radius, color) -- Klei's function c_shworadius(), consolecommands.lua:L2017
  local circle = G.CreateEntity()
  circle.is_range_indicator = true
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
  if inst.circles then return end -- circle(s) already created
  inst.circles = {}
  for _, data in pairs(T.DATA[prefab or inst.prefab] or {}) do
    local radius = type(data) == 'table' and data.radius or data
    local color = type(data) == 'table' and data.color or T.DEFAULT_COLOR
    local circle = CreateCircle(inst, radius, color)
    table.insert(inst.circles, circle)
  end
end

local function HideRangeIndicator(inst)
  if not inst.circles then return end -- circle(s) not created yet
  for _, v in ipairs(inst.circles) do
    if v:IsValid() then v:Remove() end
  end
  inst.circles = nil
end

local function ToggleRangeIndicator(inst)
  local fn = inst.circles and HideRangeIndicator or ShowRangeIndicator
  fn(inst)
end

for _, prefab in ipairs(T.PLACER) do
  AddPrefabPostInit(prefab, ShowRangeIndicator)
end

G.TheInput:AddMouseButtonHandler(function(button, down)
  local modifier = GetModConfigData('modifier_key')
  if modifier and not G.TheInput:IsKeyDown(G.rawget(G, modifier)) then return end
  if not (button == G.rawget(G, GetModConfigData('mouse_button')) and down) then return end
  local entity = G.TheInput:GetWorldEntityUnderMouse()
  if entity and T.CLICK[entity.prefab] then ToggleRangeIndicator(entity) end
end)

if GetModConfigData('enable_batch') then
  G.TheInput:AddKeyHandler(function(key, down)
    if not (key == G.rawget(G, GetModConfigData('batch_key')) and down) then return end
    local x, y, z = G.ThePlayer.Transform:GetWorldPosition()
    local entities = G.TheSim:FindEntities(x, y, z, 80, { 'CLASSIFIED', 'NOCLICK' })
    local clear = false
    for _, e in ipairs(entities) do
      if e.is_range_indicator and e:IsValid() then
        clear = true
        local parent = e.entity:GetParent()
        if parent and parent.circles then parent.circles = nil end
        e:Remove()
      end
    end
    if clear then return end
    local entities = G.TheSim:FindEntities(x, y, z, 80, nil, nil, T.TAGS)
    for _, e in ipairs(entities) do
      if T.CLICK[e.prefab] then ShowRangeIndicator(e) end
    end
  end)
end

if GetModConfigData('enable_hover') then
  AddClassPostConstruct('widgets/hoverer', function(self)
    if not self.text then return end
    local OldSetString = self.text.SetString
    local OldHide = self.text.Hide

    self.text.SetString = function(text, str, ...)
      HideRangeIndicator(G.ThePlayer)
      local e = G.TheInput:GetHUDEntityUnderMouse()
      local prefab = e and e.widget and e.widget.parent and e.widget.parent.item and e.widget.parent.item.prefab or nil
      if prefab and T.HOVER[prefab] then ShowRangeIndicator(G.ThePlayer, prefab) end
      return OldSetString(text, str, ...)
    end

    self.text.Hide = function(...)
      HideRangeIndicator(G.ThePlayer)
      return OldHide(...)
    end
  end)
end
