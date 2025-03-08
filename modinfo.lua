version = '2025.03.08'
api_version = 10
dst_compatible = true
client_only_mod = true
icon = 'modicon.tex'
icon_atlas = 'modicon.xml'

local S = { -- localized strings
  NAME = { 'Range Indicator', zh = '范围显示', zht = '範圍顯示' },
  AUTHOR = {
    'takaoinari, adai1198, (TW)Eric, liolok',
    zh = 'takaoinari、adai1198、(TW)Eric、李皓奇',
    zht = 'takaoinari、adai1198、(TW)Eric、李皓奇',
  },
  DESCRIPTION = {
    'Show ranges by clicking, deploying or hovering.\n'
      .. 'Also support binding "Clear Ranges" key at bottom of Settings > Controls page.',
    zh = '通过点击、部署、光标覆盖来显示各种范围。\n'
      .. '也支持在设置 > 控制页面底部实时调整「关闭显示」的键位绑定。',
    zht = '透過點擊、部署、遊標覆蓋來顯示各種範圍。\n'
      .. '也支援在設定 > 控制頁面底部即時調整「關閉顯示」的鍵位綁定。',
  },
  YES = { 'Yes', zh = '是', zht = '是' },
  NO = { 'No', zh = '否', zht = '否' },
  CLEAR = {
    'Clear Ranges',
    zh = '关闭显示',
    zht = '關閉顯示',
    DETAIL = {
      'Clear all ranges in your view.',
      zh = '关闭视野内所有的范围显示',
      zht = '關閉視野內所有的範圍顯示',
    },
  },
  CLICK = {
    'Click Toggle',
    zh = '点击切换',
    zht = '點擊切換',
    MODIFIER_KEY = {
      'Modifier Key',
      zh = '组合键',
      zht = '組合鍵',
      DETAIL = {
        'Click to toggle range only when this key pressed.',
        zh = '按住此键时才可以点击切换范围显示',
        zht = '按住此鍵時才可以點擊切換範圍顯示',
      },
    },
    MOUSE_BUTTON = { 'Mouse Button', zh = '鼠标按键', zht = '滑鼠按鍵' },
    AUTO_HIDE = {
      'Auto Hide',
      zh = '自动隐藏',
      zht = '自動隱藏',
      MINUTE = {
        HALF = { 'Half a Minute', zh = '半分钟', zht = '半分鐘' },
        ONE = { 'One Minute', zh = '一分钟', zht = '一分鐘' },
        TWO = { 'Two Minutes', zh = '两分钟', zht = '兩分鐘' },
      },
    },
    DOUBLE = {
      'Double Click Speed',
      zh = '双击速度',
      zht = '雙擊速度',
      DETAIL = {
        'Double click to toggle ranges of all objects of the same kind.',
        zh = '双击切换所有同类物体的范围显示',
        zht = '雙擊切換所有同類物體的範圍顯示',
      },
    },
  },
  HOVER = {
    'Hover Inventory Item',
    zh = '光标覆盖格子物品',
    zht = '遊標覆蓋格子物品',
    MODIFIER_KEY = {
      'Modifier Key',
      zh = '组合键',
      zht = '組合鍵',
      DETAIL = {
        'Show range only when this key pressed and hovering.',
        zh = '按住此键且光标覆盖物品时才显示范围',
        zht = '按住此鍵且遊標覆蓋物品時才顯示範圍',
      },
    },
    BOOKS = {
      'Books',
      zh = '书籍',
      zht = '書籍',
      DETAIL = {
        'Show range of Wickerbottom books?',
        zh = '是否显示薇克巴顿（老奶奶/图书管理员）书籍的范围？',
        zht = '是否顯示薇克巴頓（阿嬤/圖書館管理員）書籍的範圍？',
      },
    },
    OTHER = {
      'Other',
      zh = '其它',
      zht = '其它',
      DETAIL = {
        'Show range of other items?\nSuch as Gunpowder, Pan Flute, Treeguard Idol...',
        zh = '是否显示其它物品的范围？\n比如火药、排箫、树精守卫雕像……',
        zht = '是否顯示其它物品的範圍？\n如火藥、排簫、樹精守衛雕像…',
      },
    },
  },
}
local T = ChooseTranslationTable

name = T(S.NAME)
author = T(S.AUTHOR)
description = T(S.DESCRIPTION)

local keyboard = { -- from STRINGS.UI.CONTROLSSCREEN.INPUTS[1] of strings.lua, need to match constants.lua too.
  { 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause' },
  { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
  { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M' },
  { 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
  { 'Escape', 'Tab', 'CapsLock', 'LShift', 'LCtrl', 'LSuper', 'LAlt' },
  { 'Space', 'RAlt', 'RSuper', 'RCtrl', 'RShift', 'Enter', 'Backspace' },
  { 'Tilde', 'Minus', 'Equals', 'LeftBracket', 'RightBracket', 'Backslash', 'Semicolon', 'Period', 'Slash' }, -- punctuation
  { 'Up', 'Down', 'Left', 'Right', 'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown' }, -- navigation
}
local numpad = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Period', 'Divide', 'Multiply', 'Minus', 'Plus' }
local key_disabled = { description = 'Disabled', data = 'KEY_DISABLED' }
keys = { key_disabled }
for i = 1, #keyboard do
  for j = 1, #keyboard[i] do
    local key = keyboard[i][j]
    keys[#keys + 1] = { description = key, data = 'KEY_' .. key:upper() }
  end
  keys[#keys + 1] = key_disabled
end
for i = 1, #numpad do
  local key = numpad[i]
  keys[#keys + 1] = { description = 'Numpad ' .. key, data = 'KEY_KP_' .. key:upper() }
end

local function H(title) return { name = T(title), options = { { description = '', data = 0 } }, default = 0 } end -- header
local BOOL = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } } -- "Yes" or "No"

configuration_options = {
  {
    label = T(S.CLEAR),
    hover = T(S.CLEAR.DETAIL),
    options = keys,
    default = 'KEY_F5',
    name = 'clear_key',
  },
  H(S.CLICK),
  {
    label = T(S.CLICK.MODIFIER_KEY),
    hover = T(S.CLICK.MODIFIER_KEY.DETAIL),
    options = {
      { data = false, description = T(S.NO) },
      { data = 308, description = 'LAlt' },
      { data = 306, description = 'LCtrl' },
      { data = 304, description = 'LShift' },
    },
    default = false,
    name = 'click_modifier',
  },
  {
    label = T(S.CLICK.MOUSE_BUTTON),
    options = { -- emoji and keycode from strings.lua
      { description = '\238\132\128', data = 1000 }, -- Left Mouse Button
      { description = '\238\132\129', data = 1001 }, -- Right Mouse Button
      { description = '\238\132\130', data = 1002 }, -- Middle Mouse Button
      { description = '\238\132\131', data = 1005 }, -- Mouse Button 4
      { description = '\238\132\132', data = 1006 }, -- Mouse Button 5
    },
    default = 1002,
    name = 'mouse_button',
  },
  {
    label = T(S.CLICK.AUTO_HIDE),
    options = {
      { data = false, description = T(S.NO) },
      { data = 30, description = T(S.CLICK.AUTO_HIDE.MINUTE.HALF) },
      { data = 60, description = T(S.CLICK.AUTO_HIDE.MINUTE.ONE) },
      { data = 120, description = T(S.CLICK.AUTO_HIDE.MINUTE.TWO) },
    },
    default = false,
    name = 'auto_hide',
  },
  {
    label = T(S.CLICK.DOUBLE),
    hover = T(S.CLICK.DOUBLE.DETAIL),
    options = {
      { data = 0.3, description = '0.3s' },
      { data = 0.4, description = '0.4s' },
      { data = 0.5, description = '0.5s' },
      { data = 0.6, description = '0.6s' },
      { data = 0.7, description = '0.7s' },
    },
    default = 0.5,
    name = 'double_click_speed',
  },
  H(S.HOVER),
  {
    label = T(S.HOVER.MODIFIER_KEY),
    hover = T(S.HOVER.MODIFIER_KEY.DETAIL),
    options = {
      { data = false, description = T(S.NO) },
      { data = 308, description = 'LAlt' },
      { data = 306, description = 'LCtrl' },
      { data = 304, description = 'LShift' },
    },
    default = false,
    name = 'hover_modifier',
  },
  { label = T(S.HOVER.BOOKS), hover = T(S.HOVER.BOOKS.DETAIL), options = BOOL, default = true, name = 'hover_books' },
  { label = T(S.HOVER.OTHER), hover = T(S.HOVER.OTHER.DETAIL), options = BOOL, default = true, name = 'hover_other' },
}
