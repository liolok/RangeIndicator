version = '2024.07.05.1'
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
  YES = { 'Yes', zh = '是', zht = '是' },
  NO = { 'No', zh = '否', zht = '否' },
  CLICK = { 'Click', zh = '点击', zht = '點擊' },
  MODIFIER_KEY = {
    'Modifier Key',
    zh = '组合键',
    zht = '組合鍵',
    DETAIL = {
      "Bind a key to toggle indicator only when it's pressed.",
      zh = '绑定一个按键，只有按住时才可以点击切换显示。',
      zht = '綁定一個按鍵，只有按住時才可以點擊切換顯示。',
    },
  },
  MOUSE_BUTTON = {
    'Mouse Button',
    zh = '鼠标按键',
    zht = '滑鼠按鍵',
    DETAIL = {
      'Which button do you wanna use to toggle indicator?',
      zh = '点击哪个按键切换范围显示？',
      zht = '點擊哪個按鍵切換範圍顯示？',
    },
  },
  QUICK_TOGGLE = {
    'Quick Toggle',
    zh = '快速切换',
    zht = '快速切換',
    DETAIL = {
      'Bind a key to toggle most of the indicators?',
      zh = '绑定切换大部分范围显示的按键',
      zht = '綁定切換大部分範圍顯示的按鍵',
    },
  },
  HOVER = { 'Hover', zh = '光标覆盖', zht = '遊標覆蓋' },
  BOOKS = {
    'Books',
    zh = '书籍',
    zht = '書籍',
    DETAIL = {
      'Do you wanna show the indicator of Wickerbottom books?',
      zh = '是否显示薇克巴顿书籍的范围？',
      zht = '是否顯示阿嬤(圖書館管理員)書籍的範圍',
    },
  },
  OTHER = {
    'Other',
    zh = '其它',
    zht = '其它',
    DETAIL = {
      'Do you wanna show the indicator of other items?\nSuch as Gunpowder, Pan Flute, Treeguard Idol...',
      zh = '是否显示其它物品的范围？\n比如火药、排箫、树精雕像……',
      zht = '是否顯示其它物品的範圍？ \n如火藥、排簫、樹人雕像…',
    },
  },
}
local T = ChooseTranslationTable

name = T(S.NAME)
author = T(S.AUTHOR)
description = T(S.DESCRIPTION)

-- stylua: ignore
local keys = { -- from STRINGS.UI.CONTROLSSCREEN.INPUTS[1] of strings.lua, need to match constants.lua too.
  'Disabled', 'Escape', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'Print', 'ScrolLock', 'Pause',
  'Disabled', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  'Disabled', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  'Disabled', 'Tab', 'CapsLock', 'LShift', 'LCtrl', 'LAlt', 'Space', 'RAlt', 'RCtrl', 'Period', 'Slash', 'RShift',
  'Disabled', 'Minus', 'Equals', 'Backspace', 'LeftBracket', 'RightBracket', 'Backslash', 'Semicolon', 'Enter',
  'Disabled', 'Up', 'Down', 'Left', 'Right', 'Insert', 'Delete', 'Home', 'End', 'PageUp', 'PageDown', -- navigation
  'Disabled', 'Num 0', 'Num 1', 'Num 2', 'Num 3', 'Num 4', 'Num 5', 'Num 6', 'Num 7', 'Num 8', 'Num 9', -- numberic keypad
  'Num Period', 'Num Divide', 'Num Multiply', 'Num Minus', 'Num Plus', 'Disabled',
}
for i = 1, #keys do
  keys[i] = { description = keys[i], data = 'KEY_' .. keys[i]:gsub('^Num ', 'KP_'):upper() }
end

local function h(title) return { name = title, options = { { description = '', data = 0 } }, default = 0 } end -- header
local booleans = { { description = T(S.YES), data = true }, { description = T(S.NO), data = false } } -- "Yes" or "No"

configuration_options = {
  h(T(S.CLICK)),
  {
    label = T(S.MODIFIER_KEY),
    hover = T(S.MODIFIER_KEY.DETAIL),
    options = keys,
    default = 'KEY_DISABLED',
    name = 'modifier_key',
    is_keybind = true,
  },
  {
    label = T(S.MOUSE_BUTTON),
    hover = T(S.MOUSE_BUTTON.DETAIL),
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
    label = T(S.QUICK_TOGGLE),
    hover = T(S.QUICK_TOGGLE.DETAIL),
    options = keys,
    default = 'KEY_F5',
    name = 'batch_key',
    is_keybind = true,
  },

  h(T(S.HOVER)),
  { label = T(S.BOOKS), hover = T(S.BOOKS.DETAIL), options = booleans, default = true, name = 'hover_books' },
  { label = T(S.OTHER), hover = T(S.OTHER.DETAIL), options = booleans, default = true, name = 'hover_other' },
}
