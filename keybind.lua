local G = GLOBAL
local S = GLOBAL.STRINGS

local Widget = require('widgets/widget')
local Image = require('widgets/image')
local ImageButton = require('widgets/imagebutton')
local PopupDialogScreen = require('screens/redux/popupdialog')

local KeyBindButton = Class(Widget, function(self, onchanged_fn)
  Widget._ctor(self, 'KeyBindButton')

  self.OnChanged = onchanged_fn
  self.is_valid = {} -- whether contains support for certain keycode
  self.name = {} -- keycode name like "KEY_A" or "KEY_LCTRL"

  local button_width = 225 -- screens/redux/modconfigurationscreen.lua: spinner_width
  local button_height = 40 -- screens/redux/modconfigurationscreen.lua: item_height

  self.changed_image = self:AddChild(Image('images/global_redux.xml', 'wardrobe_spinner_bg.tex'))
  self.changed_image:SetTint(1, 1, 1, 0.3)
  self.changed_image:ScaleToSize(button_width, button_height)
  self.changed_image:Hide()

  self.binding_btn = self:AddChild(ImageButton('images/global_redux.xml', 'blank.tex', 'spinner_focus.tex'))
  self.binding_btn:ForceImageSize(button_width, button_height)
  self.binding_btn:SetTextColour(G.UICOLOURS.GOLD_CLICKABLE)
  self.binding_btn:SetTextFocusColour(G.UICOLOURS.GOLD_FOCUS)
  self.binding_btn:SetFont(G.CHATFONT)
  self.binding_btn:SetTextSize(25)
  self.binding_btn:SetOnClick(function() self:PopupKeyBindDialog() end)

  self.binding_btn:SetHelpTextMessage(S.UI.CONTROLSSCREEN.CHANGEBIND)
  self.binding_btn:SetDisabledFont(G.CHATFONT)

  self:Set(self.initial_value)

  self.focus_forward = self.binding_btn
end)

function KeyBindButton:Insert(key)
  local code = G.rawget(G, key)
  if not code then return end
  self.is_valid[code] = true
  self.name[code] = key
end

local function Display(key)
  if key == false then return S.UI.MODSSCREEN.DISABLE end -- keybind disabled
  local NAME = S.UI.CONTROLSSCREEN.INPUTS[1] -- localized names of Keyboard / Mouse buttons
  return NAME[G.rawget(G, key) or 0] -- name for the key, or "Unknown"
end

function KeyBindButton:Set(key)
  if key == self.key then return end
  self.key = key
  self.OnChanged(key)
  self.binding_btn:SetText(Display(key))
  if key == self.initial_value then self.changed_image:Hide() end
  if key ~= self.initial_value then self.changed_image:Show() end
end

function KeyBindButton:PopupKeyBindDialog()
  local select = S.UI.CONTROLSSCREEN.CONTROL_SELECT
  local default = S.UI.CONTROLSSCREEN.DEFAULT_CONTROL_TEXT
  local body_text = select .. '\n\n' .. string.format(default, Display(self.default_value))

  local buttons = { { text = S.UI.CONTROLSSCREEN.CANCEL, cb = function() TheFrontEnd:PopScreen() end } }
  if self.allow_disable then -- prepend disable button
    table.insert(buttons, 1, {
      text = S.UI.MODSSCREEN.DISABLE,
      cb = function()
        self:Set(false) -- disable keybind
        TheFrontEnd:PopScreen()
      end,
    })
  end

  local popup = PopupDialogScreen(self.title, body_text, buttons)
  for _, item in ipairs(popup.dialog.actions.items) do
    item:ClearFocusDirs()
  end
  popup.default_focus = nil
  TheFrontEnd:PushScreen(popup)
  popup.OnRawKey = function(_, key, down)
    if not down and self.is_valid[key] then
      self:Set(self.name[key])
      TheFrontEnd:PopScreen()
      TheFrontEnd:GetSound():PlaySound('dontstarve/HUD/click_move')
      return true
    end
  end
end

AddClassPostConstruct('screens/redux/modconfigurationscreen', function(self)
  local modded_button = 'keybind_button@' .. self.modname -- avoid messing with others

  for _, widget in ipairs(self.options_scroll_list.widgets_to_update) do
    if widget.opt[modded_button] then return end -- avoid overlapping when multiple mods run this code
    local button = KeyBindButton(function(value)
      if value ~= widget.opt.data.initial_value then self:MakeDirty() end
      self.options[widget.real_index].value = value
      widget.opt.data.selected_value = value
      widget:ApplyDescription()
    end)

    button:SetPosition(widget.opt.spinner:GetPosition()) -- take original spinner's place
    widget.opt[modded_button] = widget.opt:AddChild(button)

    widget.opt.focus_forward = function()
      local button, spinner = widget.opt[modded_button], widget.opt.spinner
      return button.shown and button or spinner
    end
  end

  local OldApplyDataToWidget = self.options_scroll_list.update_fn
  self.options_scroll_list.update_fn = function(context, widget, data, ...)
    local result = OldApplyDataToWidget(context, widget, data, ...)
    local button = widget.opt[modded_button]
    if not button then return result end
    button:Hide()
    if not data or data.is_header then return result end

    for _, v in ipairs(self.config) do
      if v.name == data.option.name then
        if not v.is_keybind then return result end

        button.title = v.label
        button.default_value = v.default
        button.initial_value = data.initial_value
        button:Set(data.selected_value)
        for _, option in ipairs(data.option.options) do
          local key = option.data
          if type(key) == 'string' and key:find('^KEY_') then button:Insert(key) end
          if key == false then button.allow_disable = true end
        end

        widget.opt.spinner:Hide()
        button:Show()
        return result
      end
    end
  end

  self.options_scroll_list:RefreshView()
end)
