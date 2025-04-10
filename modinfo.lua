local function T(en, zh, zht) return ChooseTranslationTable({ en, zh = zh, zht = zht or zh }) end

name = T('Range Indicator', '范围显示', '範圍顯示')
author = T('takaoinari, adai1198, (TW)Eric, liolok', 'takaoinari、adai1198、(TW)Eric、李皓奇')
local date = '2025-04-11'
version = date .. '' -- for revision in same day
description = T(
  'Show ranges by clicking, placing or hovering.',
  '通过点击、放置、光标覆盖来显示各种范围。',
  '透過點擊、放置、遊標覆蓋來顯示各種範圍。'
) .. '\n' .. T(
  'Support binding key at bottom of Settings > Controls page.',
  '支持在设置 > 控制页面底部实时调整键位绑定。',
  '支援在設定 > 控制頁面底部即時調整鍵位綁定。'
) .. '\n󰀰 ' .. date -- Florid Postern（绚丽之门）
api_version = 10
dst_compatible = true
client_only_mod = true
icon = 'modicon.tex'
icon_atlas = 'modicon.xml'

local keyboard = { -- from STRINGS.UI.CONTROLSSCREEN.INPUTS[1] of strings.lua, need to match constants.lua too.
  { 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause' },
  { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' },
  { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M' },
  { 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
  { 'Escape', 'Tab', 'CapsLock', 'LShift', 'LCtrl', 'LSuper', 'LAlt' },
  { 'Space', 'RAlt', 'RSuper', 'RCtrl', 'RShift', 'Enter', 'Backspace' },
  { 'BackQuote', 'Minus', 'Equals', 'LeftBracket', 'RightBracket' },
  { 'Backslash', 'Semicolon', 'Quote', 'Period', 'Slash' }, -- punctuation
  { 'Up', 'Down', 'Left', 'Right', 'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown' }, -- navigation
}
local numpad = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Period', 'Divide', 'Multiply', 'Minus', 'Plus' }
local mouse = { '\238\132\128', '\238\132\129', '\238\132\130', '\238\132\131', '\238\132\132' } -- Mouse Button Left/Right/Middle/4/5
local key_disabled = { description = T('Disabled', '禁用'), data = 'KEY_DISABLED' }
keys = { key_disabled }
for i = 1, #mouse do
  keys[#keys + 1] = { description = mouse[i], data = mouse[i] }
end
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

local function Header(...) return { name = T(...), options = { { description = '', data = 0 } }, default = 0 } end

configuration_options = {
  Header('Click to Toggle Ranges', '点击切换范围', '點擊切換範圍'),
  {
    name = 'toggle_modifier',
    label = T('Toggle Ranges Modifier Key', '切换范围组合键', '切換範組合鍵'),
    hover = T(
      'Click to toggle range only when this key pressed.',
      '按住此键时才可以点击切换范围显示',
      '按住此鍵時才可以點擊切換範圍顯示'
    ),
    options = keys,
    default = 'KEY_DISABLED',
  },
  {
    name = 'toggle_key',
    label = T('Toggle Ranges', '切换范围', '切換範圍'),
    hover = T(
      'Double click to toggle ranges of all objects of the same kind.',
      '双击切换所有同类物体的范围显示',
      '雙擊切換所有同類物體的範圍顯示'
    ),
    options = keys,
    default = '\238\132\130', -- Mouse Middle Button
  },
  {
    name = 'clear_key',
    label = T('Clear Ranges', '清除范围', '清除範圍'),
    hover = T(
      'Clear all ranges in your view.',
      '清除视野内所有的范围显示',
      '清除視野內所有的範圍顯示'
    ),
    options = keys,
    default = 'KEY_F5',
  },
  {
    name = 'auto_hide',
    label = T('Auto Hide', '自动隐藏', '自動隱藏'),
    options = {
      { data = false, description = T('Disabled', '禁用') },
      { data = 30, description = T('Half a Minute', '半分钟', '半分鐘') },
      { data = 60, description = T('One Minute', '一分钟', '一分鐘') },
      { data = 120, description = T('Two Minutes', '两分钟', '兩分鐘') },
    },
    default = false,
  },
  {
    name = 'double_click_speed',
    label = T('Double Click Speed', '双击速度', '雙擊速度'),
    options = {
      { data = 0.3, description = '0.3s' },
      { data = 0.4, description = '0.4s' },
      { data = 0.5, description = '0.5s' },
      { data = 0.6, description = '0.6s' },
      { data = 0.7, description = '0.7s' },
    },
    default = 0.5,
  },
  Header('Hover Inventory Item', '光标覆盖格子物品', '遊標覆蓋格子物品'),
  {
    name = 'hover_modifier',
    label = T('Hover Modifier Key', '光标覆盖组合键', '遊標覆蓋組合鍵'),
    hover = T(
      'Show range only when this key pressed and hovering.',
      '按住此键且光标覆盖物品时才显示范围',
      '按住此鍵且遊標覆蓋物品時才顯示範圍'
    ),
    options = keys,
    default = 'KEY_DISABLED',
  },
  {
    name = 'hover_books',
    label = T('Books', '书籍', '書籍'),
    hover = T(
      'Show range of Wickerbottom books?',
      '是否显示薇克巴顿（老奶奶/图书管理员）书籍的范围？',
      '是否顯示薇克巴頓（阿嬤/圖書館管理員）書籍的範圍？'
    ),
    options = {
      { data = true, description = T('Show', '显示', '顯示') },
      { data = false, description = T("Don't Show", '不显示', '不顯示') },
    },
    default = true,
  },
  {
    name = 'hover_other',
    label = T('Other', '其它'),
    hover = T(
      'Show range of other items?\nSuch as Gunpowder, Pan Flute, Treeguard Idol...',
      '是否显示其它物品的范围？\n比如火药、排箫、树精守卫雕像……',
      '是否顯示其它物品的範圍？\n如火藥、排簫、樹精守衛雕像……'
    ),
    options = {
      { data = true, description = T('Show', '显示', '顯示') },
      { data = false, description = T("Don't Show", '不显示', '不顯示') },
    },
    default = true,
  },
}
