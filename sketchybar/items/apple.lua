local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
  icon = {
    font = { size = 16.0 },
    string = icons.apple,
    padding_right = 8,
    padding_left = 8,
  },
  label = {
      width = 0,
      padding_left = 0,
      padding_right = 8,
      string = "Menu",
  },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1
  },
  padding_left = 1,
  padding_right = 1,
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  }
})

apple:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
        apple:set({
            label = { width = "dynamic" }
        })
    end)
end)

apple:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
        apple:set({
            label = { width = 0 }
        })
    end)
end)

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
