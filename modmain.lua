modimport('keybind') -- refine key binding UI
modimport('tuning') -- load data and config

local G = GLOBAL
local T = TUNING.RANGE_INDICATOR

local function CreateCircle(inst, radius, color) -- CreatePlacerRing(), prefabs/winona_catapult.lua
  local circle = G.CreateEntity()
  circle.entity:SetParent(inst.entity)
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  local x, y, z = inst.Transform:GetScale() -- credit: Huxi, 3161117403/scripts/prefabs/hrange.lua
  tf:SetScale(1 / x, 1 / y, 1 / z) -- fight against parent's scale, be absolute.
  as:SetScale(radius / 9.7, radius / 9.7) -- scale by catapult texture size

  -- credit: CarlZalph, https://forums.kleientertainment.com/forums/topic/69594-solved-how-to-make-character-glow-a-certain-color/#comment-804165
  as:SetMultColour(G.unpack(color)) -- erase original color
  as:SetAddColour(G.unpack(color))

  circle.entity:SetCanSleep(false)
  circle.persists = false
  circle:AddTag('CLASSIFIED')
  circle:AddTag('NOCLICK')
  circle:AddTag('RANGE_INDICATOR')
  as:SetBank('winona_catapult_placement')
  as:SetBuild('winona_catapult_placement')
  as:PlayAnimation('idle')
  as:Hide('inner')
  as:SetLightOverride(1)
  as:SetOrientation(G.ANIM_ORIENTATION.OnGround)
  as:SetLayer(G.LAYER_BACKGROUND)
  as:SetSortOrder(1)

  return circle
end

local function ShowRangeIndicator(inst, prefab)
  local data = T.DATA[prefab or inst.prefab]
  if not data then return end -- prefab not supported
  if inst.circles then return end -- circle(s) already created
  inst.circles = {}
  for _, v in pairs(data) do
    table.insert(inst.circles, CreateCircle(inst, v.radius, v.color))
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

-- Feature: Click --------------------------------------------------------------

G.TheInput:AddMouseButtonHandler(function(button, down)
  if T.CLICK.KEY and not G.TheInput:IsKeyDown(T.CLICK.KEY) then return end -- modifier key
  if not (button == T.CLICK.BUTTON and down) then return end
  local entity = G.TheInput:GetWorldEntityUnderMouse()
  if entity and T.CLICK.SUPPORT[entity.prefab] then
    ToggleRangeIndicator(entity)
    if entity.circles and T.CLICK.AUTO_HIDE then
      G.ThePlayer:DoTaskInTime(T.CLICK.AUTO_HIDE, function() HideRangeIndicator(entity) end)
    end
  end
end)

-- Feature: Batch Toggle -------------------------------------------------------

local function BatchToggle()
  if not G.ThePlayer then return end
  local x, y, z = G.ThePlayer.Transform:GetWorldPosition()
  local entities = G.TheSim:FindEntities(x, y, z, 80, { 'CLASSIFIED', 'NOCLICK', 'RANGE_INDICATOR' })
  local cleared = false
  for _, e in ipairs(entities) do
    if e:IsValid() then
      local parent = e.entity:GetParent()
      if parent and parent.circles then parent.circles = nil end
      e:Remove()
      cleared = true
    end
  end
  if cleared then return end
  local entities = G.TheSim:FindEntities(x, y, z, 80, nil, nil, T.BATCH.TAG)
  for _, e in ipairs(entities) do
    ShowRangeIndicator(e)
  end
end
local handler = nil
function KeyBind(_, key)
  if handler then handler:Remove() end
  handler = key and G.TheInput:AddKeyDownHandler(key, BatchToggle) or nil
end

-- Feature: Deploy -------------------------------------------------------------

for _, prefab in ipairs(T.DEPLOY) do
  AddPrefabPostInit(prefab, ShowRangeIndicator)
end

-- Feature: Hover --------------------------------------------------------------

AddClassPostConstruct('widgets/hoverer', function(self)
  if not (self.text and T.HOVER.ENABLE) then return end

  local OldSetString = self.text.SetString
  self.text.SetString = function(text, str, ...)
    HideRangeIndicator(G.ThePlayer)
    local e = G.TheInput:GetHUDEntityUnderMouse()
    local prefab = e and e.widget and e.widget.parent and e.widget.parent.item and e.widget.parent.item.prefab or nil
    if prefab and T.HOVER.SUPPORT[prefab] then ShowRangeIndicator(G.ThePlayer, prefab) end
    return OldSetString(text, str, ...)
  end

  local OldHide = self.text.Hide
  self.text.Hide = function(...)
    HideRangeIndicator(G.ThePlayer)
    return OldHide(...)
  end
end)
