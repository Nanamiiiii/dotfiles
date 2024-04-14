local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    padding_left = 20,
    padding_right = 20,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
    color = colors.bg1,
  },
  background = {
    color = colors.white,
    border_width = 0,
    height = 26,
    border_color = colors.gray,
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
