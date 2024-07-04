version = '2024.07.02.5'
api_version = 10
dst_compatible = true
client_only_mod = true
all_clients_require_mod = false
icon = 'modicon.tex'
icon_atlas = 'modicon.xml'

local S = {
  NAME = { 'Range Indicator', zh = '范围显示', zht = '範圍顯示' },
  AUTHOR = {
    'takaoinari, adai1198, (TW)Eric, liolok',
    zh = 'takaoinari、adai1198、(TW)Eric、李皓奇',
    zht = 'takaoinari、adai1198、(TW)Eric、李皓奇',
  },
  DESCRIPTION = {
    'Show ranges by clicking, deploying or hovering.',
    zh = '通过点击、部署、光标覆盖来显示各种范围。',
    zht = '透過點擊、部署、遊標覆蓋來顯示各種範圍。',
  },
  MOUSE_BUTTON = { 'Mouse Button', zh = '鼠标按键', zht = '滑鼠按鍵' },
  MOUSE_BUTTON_DETAIL = {
    'Which button do you wanna use to toggle indicator?',
    zh = '点击哪个按键切换范围显示？',
    zht = '點擊哪個按鍵切換範圍顯示？',
  },
  MODIFIER_KEY = { 'Modifier Key', zh = '组合键', zht = '組合鍵' },
  MODIFIRE_KEY_DETAIL = {
    "Bind a key to toggle indicator only when it's pressed.",
    zh = '绑定一个按键，只有按住时才可以点击切换显示。',
    zht = '綁定一個按鍵，只有按住時才可以點選切換顯示。',
  },
  NONE = { 'None', zh = '无', zht = '無' },
  LEFT = { 'Left', zh = '左', zht = '左' },
  RIGHT = { 'Right', zh = '右', zht = '右' },
  QUICK_TOGGLE = { 'Quick Toggle', zh = '快速切换', zht = '快速切換' },
  QUICK_TOGGLE_DETAIL = {
    'Do you wanna bind a key to toggle most of the indicators?',
    zh = '是否绑定切换大部分范围显示的按键',
    zht = '是否綁定切換大部分範圍顯示的按鍵',
  },
  ENABLE = { 'Enable', zh = '启用', zht = '啟用' },
  YES = { 'Yes', zh = '是', zht = '是' },
  NO = { 'No', zh = '否', zht = '否' },
  KEYBIND = { 'Keybind', zh = '按键绑定', zht = '按鍵綁定' },
  KEYBIND_DETAIL = {
    'Key to toggle most of the indicators',
    zh = '切换大部分范围显示的按键',
    zht = '切換大部分範圍顯示的按鍵',
  },
  HOVER = { 'Hover', zh = '光标覆盖', zht = '遊標覆蓋' },
  HOVER_DETAIL = {
    'Do you wanna show *any* indicator when hovering inventory items?',
    zh = '光标覆盖于格子物品上方时，是否显示*任何*范围？',
    zht = '當遊標覆蓋於格子物品上方時，是否顯示*任何*範圍？',
  },
  BOOKS = { 'Books', zh = '书籍', zht = '書籍' },
  BOOKS_DETAIL = {
    'Do you wanna show the indicator of Wickerbottom books?',
    zh = '是否显示薇克巴顿书籍的范围？',
    zht = '是否顯示阿嬤(圖書館管理員)書籍的範圍',
  },
  OTHER = { 'Other', zh = '其它', zht = '其它' },
  OTHER_DETAIL = {
    'Do you wanna show the indicator of other items?\nSuch as Gunpowder, Pan Flute, Treeguard Idol...',
    zh = '是否显示其它物品的范围？\n比如火药、排箫、树精雕像……',
    zht = '是否顯示其它物品的範圍？ \n如火藥、排簫、樹人雕像…',
  },
}
local T = ChooseTranslationTable

name = T(S.NAME)
author = T(S.AUTHOR)
description = T(S.DESCRIPTION)

-- stylua: ignore
local keys = {
  'Escape', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause',
  'Tilde', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Minus', 'Equals', 'Backspace',
  'Tab', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'LeftBracket', 'RightBracket', 'Backslash',
  'CapsLock', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Semicolon', 'Enter',
  'LShift', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Period', 'Slash', 'RShift', 'LCtrl', 'LAlt', 'Space', 'RAlt', 'RCtrl',
  'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown', 'Up', 'Down', 'Left', 'Right',
  'Keypad 0', 'Keypad 1', 'Keypad 2', 'Keypad 3', 'Keypad 4', 'Keypad 5', 'Keypad 6', 'Keypad 7', 'Keypad 8', 'Keypad 9',
  'Keypad Divide', 'Keypad Multiply', 'Keypad Minus', 'Keypad Plus', 'Keypad Enter', 'Keypad Equals',
}
for i = 1, #keys do
  keys[i] = { description = keys[i], data = 'KEY_' .. keys[i]:gsub('Keypad ', 'KP_'):upper() }
end

configuration_options = {
  {
    label = T(S.MOUSE_BUTTON),
    hover = T(S.MOUSE_BUTTON_DETAIL),
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
    label = T(S.MODIFIER_KEY),
    hover = T(S.MODIFIRE_KEY_DETAIL),
    options = {
      { description = T(S.NONE), data = false },
      { description = T(S.LEFT) .. ' Alt', data = 'KEY_LALT' },
      { description = T(S.RIGHT) .. ' Alt', data = 'KEY_RALT' },
      { description = T(S.LEFT) .. ' Ctrl', data = 'KEY_LCTRL' },
      { description = T(S.RIGHT) .. ' Ctrl', data = 'KEY_RCTRL' },
      { description = T(S.LEFT) .. ' Shift', data = 'KEY_LSHIFT' },
      { description = T(S.RIGHT) .. ' Shift', data = 'KEY_RSHIFT' },
    },
    default = false,
    name = 'modifier_key',
  },

  { name = T(S.QUICK_TOGGLE), options = { { description = '', data = 0 } }, default = 0 },
  {
    label = T(S.ENABLE),
    hover = T(S.QUICK_TOGGLE_DETAIL),
    options = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } },
    default = true,
    name = 'enable_batch',
  },
  {
    label = T(S.KEYBIND),
    hover = T(S.KEYBIND_DETAIL),
    options = keys,
    default = 'KEY_F5',
    name = 'batch_key',
  },

  { name = T(S.HOVER), options = { { description = '', data = 0 } }, default = 0 },
  {
    label = T(S.ENABLE),
    hover = T(S.HOVER_DETAIL),
    options = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } },
    default = true,
    name = 'enable_hover',
  },
  {
    label = T(S.BOOKS),
    hover = T(S.BOOKS_DETAIL),
    options = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } },
    default = true,
    name = 'hover_books',
  },
  {
    label = T(S.OTHER),
    hover = T(S.OTHER_DETAIL),
    options = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } },
    default = true,
    name = 'hover_other',
  },
}
