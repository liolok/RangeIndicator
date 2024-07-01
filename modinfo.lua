name = 'Range Indicator'
description = 'Show ranges by clicking, deploying or hovering.'
author = 'liolok, (TW)Eric'
version = '2024.06.30.1'
api_version = 10
dst_compatible = true
client_only_mod = true
all_clients_require_mod = false
icon = 'modicon.tex'
icon_atlas = 'modicon.xml'

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
    label = 'Mouse Button',
    hover = 'Which button do you wanna use to toggle indicator?',
    options = { -- emoji code from Klei's strings.lua:L12661
      { description = '\238\132\128', data = 'MOUSEBUTTON_LEFT', hover = 'Left Mouse Button' },
      { description = '\238\132\130', data = 'MOUSEBUTTON_MIDDLE', hover = 'Middle Mouse Button' },
      { description = '\238\132\129', data = 'MOUSEBUTTON_RIGHT', hover = 'Right Mouse Button' },
    },
    default = 'MOUSEBUTTON_MIDDLE',
    name = 'mouse_button',
  },
  {
    label = 'Modifier Key',
    hover = "Bind a key to toggle indicator only when it's pressed.",
    options = {
      { description = 'None', data = false },
      { description = 'Left Alt', data = 'KEY_LALT' },
      { description = 'Right Alt', data = 'KEY_RALT' },
      { description = 'Left Ctrl', data = 'KEY_LCTRL' },
      { description = 'Right Ctrl', data = 'KEY_RCTRL' },
      { description = 'Left Shift', data = 'KEY_LSHIFT' },
      { description = 'Right Shift', data = 'KEY_RSHIFT' },
    },
    default = false,
    name = 'modifier_key',
  },

  { name = 'Quick Toggle', options = { { description = '', data = 0 } }, default = 0 },
  {
    label = 'Enable',
    hover = 'Do you wanna bind a key to toggle most of the indicators?',
    options = { { description = 'Yes', data = true }, { description = 'No', data = false } },
    default = true,
    name = 'enable_batch',
  },
  {
    label = 'Keybind',
    hover = 'Key to toggle most of the indicators',
    options = keys,
    default = 'KEY_F5',
    name = 'batch_key',
  },

  { name = 'Show on Hover', options = { { description = '', data = 0 } }, default = 0 },
  {
    label = 'Enable',
    hover = 'Do you wanna show *any* indicator when hovering inventory items?',
    options = { { description = 'Yes', data = true }, { description = 'No', data = false } },
    default = true,
    name = 'enable_hover',
  },
  {
    label = 'Books',
    hover = 'Do you wanna show the indicator of Wickerbottom books?',
    options = { { description = 'Yes', data = true }, { description = 'No', data = false } },
    default = true,
    name = 'hover_books',
  },
  {
    label = 'Other',
    hover = 'Do you wanna show the indicator of other items?\nSuch as Gunpowder, Pan Flute, Treeguard Idol...',
    options = { { description = 'Yes', data = true }, { description = 'No', data = false } },
    default = true,
    name = 'hover_other',
  },
}
