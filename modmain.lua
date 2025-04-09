modimport('keybind') -- refine key binding UI
modimport('tuning') -- load data and config

local G = GLOBAL
local T = TUNING.RANGE_INDICATOR

local function CreateCircle(inst, radius, color) -- CreatePlacerRing(), prefabs/winona_catapult.lua
  local circle = G.CreateEntity()
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  if T.IS_STANDALONE[inst.prefab] then
    local x, _, z = inst.Transform:GetWorldPosition()
    tf:SetPosition(x, 0, z)
  else
    circle.entity:SetParent(inst.entity)
  end

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

local function CreateCircles(feature, inst, prefab)
  local data = T.data[feature][prefab or inst.prefab]
  if not data then return end -- no circles to create
  if inst.circles then return end -- circles already created
  inst.circles = {}
  for _, v in pairs(data) do
    table.insert(inst.circles, CreateCircle(inst, v.radius, v.color))
  end
end

local function Click(...) return CreateCircles('click', ...) end
local function Place(...) return CreateCircles('place', ...) end
local function Hover(...) return CreateCircles('hover', ...) end

local function RemoveCircles(inst)
  if not inst.circles then return end -- no circles to remove
  for _, v in ipairs(inst.circles) do
    if v:IsValid() then v:Remove() end
  end
  inst.circles = nil
  if inst.remove_circles_task then
    inst.remove_circles_task:Cancel()
    inst.remove_circles_task = nil
  end
end

--------------------------------------------------------------------------------
-- Feature: Clear

local function Clear()
  if not G.ThePlayer then return end
  local x, y, z = G.ThePlayer.Transform:GetWorldPosition()
  local entities = G.TheSim:FindEntities(x, y, z, 80, { 'CLASSIFIED', 'NOCLICK', 'RANGE_INDICATOR' })
  for _, e in ipairs(entities) do
    if e:IsValid() then
      local parent = e.entity:GetParent()
      if parent and parent.circles then parent.circles = nil end
      e:Remove()
    end
  end
end

--------------------------------------------------------------------------------
-- Feature: Click to Toggle

local is_toggle_mod_key_enabled = false
local is_holding_toggle_mod_key = false
local waiting_for_double_click = {}

local AUTO_HIDE = GetModConfigData('auto_hide')
local DOUBLE_CLICK_WAIT = GetModConfigData('double_click_speed')

local function Toggle()
  if not G.ThePlayer then return end
  if is_toggle_mod_key_enabled and not is_holding_toggle_mod_key then return end -- modifier key
  local entity = G.TheInput:GetWorldEntityUnderMouse()
  if not entity then return end
  local prefab = entity.prefab
  if not T.data.click[prefab] then return end
  if prefab == 'storage_robot' or prefab == 'winona_storage_robot' then
    local as = entity.AnimState
    if not (as:IsCurrentAnimation('idle') or as:IsCurrentAnimation('idle_off')) then return end
  end
  if waiting_for_double_click[prefab] then
    waiting_for_double_click[prefab] = false
    local x, y, z = entity.Transform:GetWorldPosition()
    local entities = G.TheSim:FindEntities(x, y, z, 80, nil, { 'FX', 'NOCLICK', 'DECOR', 'INLIMBO' })
    for _, e in ipairs(entities) do
      if e ~= entity and e.prefab == prefab then
        if entity.circles then
          Click(e)
          if AUTO_HIDE then e.remove_circles_task = e:DoTaskInTime(AUTO_HIDE, function() RemoveCircles(e) end) end
        else
          RemoveCircles(e)
        end
      end
    end
  else
    if entity.circles then
      RemoveCircles(entity)
    else
      Click(entity)
      if AUTO_HIDE then
        entity.remove_circles_task = entity:DoTaskInTime(AUTO_HIDE, function() RemoveCircles(entity) end)
      end
    end
    waiting_for_double_click[prefab] = G.ThePlayer:DoTaskInTime(
      DOUBLE_CLICK_WAIT,
      function() waiting_for_double_click[prefab] = false end
    )
  end
end

--------------------------------------------------------------------------------
-- Feature: Place

for prefab, _ in pairs(T.data.place) do
  AddPrefabPostInit(prefab, Place)
end

--------------------------------------------------------------------------------
-- Feature: Hover

local function HackData() -- dirty hack
  local player = G.ThePlayer
  local skill_tree = player and player.components and player.components.skilltreeupdater or nil
  local heal_radius = 8
  if skill_tree and skill_tree:IsActivated('wortox_soulprotector_1') then heal_radius = 11 end
  if skill_tree and skill_tree:IsActivated('wortox_soulprotector_2') then heal_radius = 14 end
  T.data.hover.wortox_soul.heal.radius = heal_radius
end

local is_hover_mod_key_enabled = false
local is_holding_hover_mod_key = false

AddClassPostConstruct('widgets/hoverer', function(self)
  if not (self.text and T.ENABLE_HOVER) then return end

  local OldSetString = self.text.SetString
  self.text.SetString = function(...)
    RemoveCircles(G.ThePlayer)
    local e = G.TheInput:GetHUDEntityUnderMouse()
    local prefab = e and e.widget and e.widget.parent and e.widget.parent.item and e.widget.parent.item.prefab or nil
    if prefab and T.data.hover[prefab] then
      if prefab == 'wortox_soul' then HackData() end
      if not is_hover_mod_key_enabled or is_holding_hover_mod_key then Hover(G.ThePlayer, prefab) end
    end
    return OldSetString(...)
  end

  local OldHide = self.text.Hide
  self.text.Hide = function(...)
    RemoveCircles(G.ThePlayer)
    return OldHide(...)
  end
end)

--------------------------------------------------------------------------------
-- Key Binding

local callback = {
  clear_key = Clear,
  toggle_key = Toggle,
  toggle_modifier = {
    down = function() is_holding_toggle_mod_key = true end,
    up = function() is_holding_toggle_mod_key = false end,
  },
  hover_modifier = {
    down = function() is_holding_hover_mod_key = true end,
    up = function() is_holding_hover_mod_key = false end,
  },
}

local handler = {} -- config name to key event handlers

function KeyBind(name, key)
  -- disable old binding
  if handler[name] then handler[name]:Remove() end
  handler[name] = nil
  if name == 'toggle_modifier' then is_toggle_mod_key_enabled = false end
  if name == 'hover_modifier' then is_hover_mod_key_enabled = false end

  -- no binding
  if not key then return end

  -- new binding
  if key >= 1000 then -- it's a mouse button
    if name:match('modifier') then
      handler[name] = G.TheInput:AddMouseButtonHandler(function(button, down, x, y)
        if button ~= key then return end
        local fn = down and 'down' or 'up'
        callback[name][fn]()
      end)
    else
      handler[name] = G.TheInput:AddMouseButtonHandler(function(button, down, x, y)
        if button == key and down then callback[name]() end
      end)
    end
  else -- it's a keyboard key
    if name:match('modifier') then
      handler[name] = G.TheInput:AddKeyHandler(function(_key, down)
        if _key ~= key then return end
        local fn = down and 'down' or 'up'
        callback[name][fn]()
      end)
    else
      handler[name] = G.TheInput:AddKeyDownHandler(key, callback[name])
    end
  end
  if name == 'toggle_modifier' then is_toggle_mod_key_enabled = true end
  if name == 'hover_modifier' then is_hover_mod_key_enabled = true end
end
