local _G = GLOBAL

local justlist =
{
    "dragonflyfurnace",
    "deerclopseyeball_sentryward",
    "mushroom_light",
    "mushroom_light2",
    "lunarthrall_plant",
    "eyeturret",
    "eyeturret_item",
    "lightning_rod",
    "firesuppressor"
}

local LUT =
{
    dragonflyfurnace            = { {scale = 1.233  , color = {255,   0,   0}} },
    deerclopseyeball_sentryward = { {scale = 1.82127, color = {  0,   0, 255}} },
    mushroom_light              = { {scale = 1.2655 , color = {  0, 255, 255}} },
    mushroom_light2             = { {scale = 1.2655 , color = {  0, 255, 255}} },
    lunarthrall_plant           = { {scale = 1.3863 , color = {255, 255,   0}},
                                    {scale = 2.192  , color = {  0, 255,   0}} },
    eyeturret                   = { {scale = 1.698  , color = {255, 0  , 255}} },
    eyeturret_item              = { {scale = 1.698  , color = {255, 0  , 255}} },
    lightning_rod               = { {scale = 2.531  , color = {255, 255,   0}} },
    firesuppressor              = { {scale = 1.549  , color = {255, 255, 255}} },
    default                     = { {scale = 1.0    , color = {  0,   0,   0}} },
}

local all_circles = {}
local toggleRange = false -- Default state is false

local function Inlist(sth, thelist)
    for i,v in ipairs(thelist) do
        if sth == v then
            return true
        end
    end
    return false
end

local function MakeC(sth, radius, color)
    local C = _G.CreateEntity()
    local tf = C.entity:AddTransform()
    local as = C.entity:AddAnimState()
    as:SetAddColour(color[1], color[2], color[3], 0)
    tf:SetScale(radius, radius, radius)

    as:SetBank("firefighter_placement")
    as:SetBuild("firefighter_placement")
    as:PlayAnimation("idle")
    as:SetOrientation(_G.ANIM_ORIENTATION.OnGround)
    as:SetLayer(_G.LAYER_BACKGROUND)
    as:SetSortOrder(3)
    C.persists = false

    C.entity:SetParent(sth.entity)
    C:AddTag("NOCLICK")
    return C
end

local function ShowRange(sth)
    if toggleRange then return end -- Exit function if toggleRange is true
    if sth.circles then
        for _,v in ipairs(sth.circles) do
            v:Remove()
        end
        sth.circles = nil
    else
        local prefab = sth.prefab
        if not Inlist(prefab, justlist) then
            prefab = prefab:gsub("_placer$", "") -- remove "_placer" suffix if present
        end
        sth.circles = {}
        for i,v in ipairs(LUT[prefab] or {}) do
            local circle = MakeC(sth, v.scale, v.color)
            table.insert(sth.circles, circle)
            table.insert(all_circles, circle)
        end
    end
end

local function RemoveAllCircles()
    for _,circle in ipairs(all_circles) do
        if circle.remove_task then
            circle.remove_task:Cancel()
        end
        circle:Remove()
    end
    all_circles = {}
end

local function ClearTaggedObjects()
    for _,circle in ipairs(all_circles) do
        if circle:IsValid() then
            circle:Remove()
        end
    end
    all_circles = {}
end

local key_toggle = GetModConfigData("key_toggle")
local key_clear = GetModConfigData("key_clear")

local function OnKeyPress(key, down)
    if down then
        if key == key_toggle then
            toggleRange = not toggleRange
            if toggleRange then
                RemoveAllCircles()
            end
        elseif key == key_clear then
            ClearTaggedObjects()
        end
    end
end

_G.TheInput:AddKeyHandler(OnKeyPress)

local controller = _G.require "components/playercontroller"
local OnRightClick_old = controller.OnRightClick
function controller:OnRightClick(down, ...)
    if (not down) and self:UsingMouse() and self:IsEnabled() and not _G.TheInput:GetHUDEntityUnderMouse() then
        local item = _G.TheInput:GetWorldEntityUnderMouse()
        if item then
            if Inlist(item.prefab, justlist) then
                ShowRange(item)
            end
        end
    end
    return OnRightClick_old(self, down, ...)
end

local function IceFlingOnRemove(inst)
    local pos = _G.Point(inst.Transform:GetWorldPosition())
    local range_indicators = _G.TheSim:FindEntities(pos.x,pos.y,pos.z, 2, {"range_indicator"})
    for i,v in ipairs(range_indicators) do
        if v:IsValid() then
            v:Remove()
        end
    end
end

local function IceFlingOnShow(inst)
    local pos = _G.Point(inst.Transform:GetWorldPosition())
    local range_indicators_client = TheSim:FindEntities(pos.x,pos.y,pos.z, 2, {"range_indicator"})
    if #range_indicators_client < 1 then
        local range = _G.SpawnPrefab("range_indicator")
        range.Transform:SetPosition(pos.x, pos.y, pos.z)
    end
end

local function IceFlingPostInit(inst)
    inst:ListenForEvent("onremove", IceFlingOnRemove)
end

local function IceFlingPlacerPostInit(inst)
    if not _G.TheNet:IsDedicated() then
        if not inst.components.deployhelper then
            inst:AddComponent("deployhelper")
            inst.components.deployhelper.onenablehelper = OnEnableHelper
        end
    end
    ShowRange(inst)
end

for i,v in ipairs(justlist) do
    AddPrefabPostInit(v, IceFlingPostInit)
    AddPrefabPostInit(v .. "_placer", IceFlingPlacerPostInit)
end
