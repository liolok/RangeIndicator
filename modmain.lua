modimport('keybind') -- refine key binding UI
modimport('tuning') -- load data and config

local G = GLOBAL
local T = TUNING.RANGE_INDICATOR

local function CreateCircle(inst, radius, color) -- CreatePlacerRing(), prefabs/winona_catapult.lua
  local circle = G.CreateEntity()
  local tf = circle.entity:AddTransform()
  local as = circle.entity:AddAnimState()

  if inst.prefab == 'storage_robot' or inst.prefab == 'winona_storage_robot' then
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

local function CreateCircles(inst, prefab)
  local data = T.DATA[prefab or inst.prefab]
  if not data then return end -- prefab not supported
  if inst.circles then return end -- circle(s) already created
  inst.circles = {}
  if data.radius then data = { data } end -- only one circle
  for _, v in pairs(data) do
    table.insert(inst.circles, CreateCircle(inst, v.radius, v.color))
  end
end

local function RemoveCircles(inst)
  if not inst.circles then return end -- circle(s) not created yet
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

local handler = nil
function KeyBind(_, key)
  if handler then handler:Remove() end
  handler = key and G.TheInput:AddKeyDownHandler(key, Clear) or nil
end

--------------------------------------------------------------------------------
-- Feature: Click

local waiting_for_double_click = {}

G.TheInput:AddMouseButtonHandler(function(button, down)
  if not G.ThePlayer then return end
  if T.CLICK.KEY and not G.TheInput:IsKeyDown(T.CLICK.KEY) then return end -- modifier key
  if not (button == T.CLICK.BUTTON and down) then return end
  local entity = G.TheInput:GetWorldEntityUnderMouse()
  if not entity then return end
  local prefab = entity.prefab
  if not T.CLICK.SUPPORT[prefab] then return end
  if waiting_for_double_click[prefab] then
    waiting_for_double_click[prefab] = false
    local x, y, z = entity.Transform:GetWorldPosition()
    local entities = G.TheSim:FindEntities(x, y, z, 80, nil, { 'FX', 'NOCLICK', 'DECOR', 'INLIMBO' })
    for _, e in ipairs(entities) do
      if e ~= entity and e.prefab == prefab then
        if entity.circles then
          CreateCircles(e)
          if T.CLICK.AUTO_HIDE then
            e.remove_circles_task = e:DoTaskInTime(T.CLICK.AUTO_HIDE, function() RemoveCircles(e) end)
          end
        else
          RemoveCircles(e)
        end
      end
    end
  else
    if entity.circles then
      RemoveCircles(entity)
    else
      CreateCircles(entity)
      if T.CLICK.AUTO_HIDE then
        entity.remove_circles_task = entity:DoTaskInTime(T.CLICK.AUTO_HIDE, function() RemoveCircles(entity) end)
      end
    end
    waiting_for_double_click[prefab] = G.ThePlayer:DoTaskInTime(
      T.CLICK.DOUBLE_CLICK_WAIT,
      function() waiting_for_double_click[prefab] = false end
    )
  end
end)

--------------------------------------------------------------------------------
-- Feature: Deploy

for _, prefab in ipairs(T.DEPLOY) do
  AddPrefabPostInit(prefab, CreateCircles)
end

--------------------------------------------------------------------------------
-- Feature: Hover

local function HackData() -- dirty hack
  local player = G.ThePlayer
  local skill_tree = player and player.components and player.components.skilltreeupdater or nil
  local heal_range = 8
  if skill_tree and skill_tree:IsActivated('wortox_soulprotector_1') then heal_range = 11 end
  if skill_tree and skill_tree:IsActivated('wortox_soulprotector_2') then heal_range = 14 end
  T.DATA['wortox_soul'].radius = heal_range
end

AddClassPostConstruct('widgets/hoverer', function(self)
  if not (self.text and T.HOVER.ENABLE) then return end

  local OldSetString = self.text.SetString
  self.text.SetString = function(...)
    RemoveCircles(G.ThePlayer)
    local e = G.TheInput:GetHUDEntityUnderMouse()
    local prefab = e and e.widget and e.widget.parent and e.widget.parent.item and e.widget.parent.item.prefab or nil
    if prefab and T.HOVER.SUPPORT[prefab] then
      if prefab == 'wortox_soul' then HackData() end
      local holding_modifier_key = not T.HOVER.KEY or G.TheInput:IsKeyDown(T.HOVER.KEY)
      if holding_modifier_key then CreateCircles(G.ThePlayer, prefab) end
    end
    return OldSetString(...)
  end

  local OldHide = self.text.Hide
  self.text.Hide = function(...)
    RemoveCircles(G.ThePlayer)
    return OldHide(...)
  end
end)
