local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  position = "right",
  graph = { color = colors.black },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { 
    string = icons.cpu,
    color = colors.dark_fore,
  },
  label = {
    string = "CPU ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
    color = colors.white_dark,
  },
  padding_right = settings.paddings + 6
})

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  local load = tonumber(env.total_load)
  cpu:push({ load / 100. })

  local color = colors.black
  if load > 30 then
    if load < 60 then
      color = colors.yellow_dark
    elseif load < 80 then
      color = colors.orange_dark
    else
      color = colors.red_dark
    end
  end

  cpu:set({
    graph = { color = color },
    label = "CPU " .. env.total_load .. "%",
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = {
    color = colors.gradient.color4,
    border_color = colors.gradient.color3,
  }
})

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings
})
