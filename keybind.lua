local G = GLOBAL
local Widget = require('widgets/widget')
local Image = require('widgets/image')
local ImageButton = require('widgets/imagebutton')
local PopupDialog = require('screens/redux/popupdialog')

local KeyBindButton = Class(Widget, function(self, on_set_val_fn)
  Widget._ctor(self, 'KeyBindButton@' .. modname) -- avoid being messed up by other mods

  self.OnSetValue = on_set_val_fn
  self.valid = {} -- validated code/name of keys like 97/"KEY_A" or 306/"KEY_LCTRL"

  local button_width = 225 -- screens/redux/modconfigurationscreen.lua: spinner_width
  local button_height = 40 -- screens/redux/modconfigurationscreen.lua: item_height

  self.changed_image = self:AddChild(Image('images/global_redux.xml', 'wardrobe_spinner_bg.tex'))
  self.changed_image:SetTint(1, 1, 1, 0.3) -- screens/redux/optionsscreen.lua: BuildControlGroup()
  self.changed_image:ScaleToSize(button_width, button_height)
  self.changed_image:Hide()

  self.binding_btn = self:AddChild(ImageButton('images/global_redux.xml', 'blank.tex', 'spinner_focus.tex'))
  self.binding_btn:ForceImageSize(button_width, button_height)
  self.binding_btn:SetTextColour(G.UICOLOURS.GOLD_CLICKABLE)
  self.binding_btn:SetTextFocusColour(G.UICOLOURS.GOLD_FOCUS)
  self.binding_btn:SetFont(G.CHATFONT)
  self.binding_btn:SetTextSize(25) -- screens/redux/modconfigurationscreen.lua: same as LabelSpinner's default
  self.binding_btn:SetOnClick(function() self:PopupKeyBindDialog() end)

  self.focus_forward = self.binding_btn
end)

local function Raw(v) return G.rawget(G, v) end -- get keycode

local function Pretty(v)
  if v == 'KEY_DISABLED' then return G.STRINGS.UI.MODSSCREEN.DISABLE end
  return G.STRINGS.UI.CONTROLSSCREEN.INPUTS[1][Raw(v) or 0] -- localized name for the key, or "Unknown"
end

function KeyBindButton:ValidateValue(v) -- code/name of keys like 97/"KEY_A" or 306/"KEY_LCTRL"
  if type(v) == 'string' and v:find('^KEY_') and Raw(v) then self.valid[Raw(v)] = v end
end

function KeyBindButton:SetValue(v)
  if v == self.value then return end
  self.value = v
  self.OnSetValue(v)
  self.binding_btn:SetText(Pretty(v))
  if v == self.initial_value then self.changed_image:Hide() end
  if v ~= self.initial_value then self.changed_image:Show() end
end

function KeyBindButton:PopupKeyBindDialog()
  local body_text = G.STRINGS.UI.CONTROLSSCREEN.CONTROL_SELECT
    .. '\n\n'
    .. string.format(G.STRINGS.UI.CONTROLSSCREEN.DEFAULT_CONTROL_TEXT, Pretty(self.default_value))

  local buttons = { { text = G.STRINGS.UI.CONTROLSSCREEN.CANCEL, cb = function() TheFrontEnd:PopScreen() end } }
  if self.allow_disable then
    table.insert(buttons, 1, { -- prepend "Disable" button
      text = G.STRINGS.UI.MODSSCREEN.DISABLE,
      cb = function()
        self:SetValue('KEY_DISABLED')
        TheFrontEnd:PopScreen()
      end,
    })
  end

  local dialog = PopupDialog(self.title, body_text, buttons)
  dialog.OnRawKey = function(_, key, down)
    if down or not self.valid[key] then return end -- wait for releasing valid key
    self:SetValue(self.valid[key])
    TheFrontEnd:PopScreen()
    TheFrontEnd:GetSound():PlaySound('dontstarve/HUD/click_move')
  end

  TheFrontEnd:PushScreen(dialog)
end

AddClassPostConstruct('screens/redux/modconfigurationscreen', function(self)
  if self.modname ~= modname then return end -- avoid messing up other mods
  local keybind_button = 'keybind_button@' .. modname -- avoid being messed up by other mods

  for _, widget in ipairs(self.options_scroll_list.widgets_to_update) do
    local button = KeyBindButton(function(value)
      if value ~= widget.opt.data.initial_value then self:MakeDirty() end
      self.options[widget.real_index].value = value
      widget.opt.data.selected_value = value
      widget:ApplyDescription()
    end)
    button:Hide()
    button:SetPosition(widget.opt.spinner:GetPosition()) -- take original spinner's place

    widget.opt[keybind_button] = widget.opt:AddChild(button)
    widget.opt.focus_forward = function() return button.shown and button or widget.opt.spinner end
  end

  local OldApplyDataToWidget = self.options_scroll_list.update_fn
  self.options_scroll_list.update_fn = function(context, widget, data, ...)
    local result = OldApplyDataToWidget(context, widget, data, ...)
    local button = widget.opt[keybind_button]
    if not (button and data and not data.is_header) then return result end

    for _, v in ipairs(self.config) do
      if v.name == data.option.name then
        if not v.is_keybind then return result end

        button.title = v.label
        button.default_value = v.default
        button.initial_value = data.initial_value
        button:SetValue(data.selected_value)
        for _, option in ipairs(data.option.options) do
          button:ValidateValue(option.data)
          if option.data == 'KEY_DISABLED' then button.allow_disable = true end
        end

        widget.opt.spinner:Hide()
        button:Show()
        return result
      end
    end
  end

  self.options_scroll_list:RefreshView()
end)
