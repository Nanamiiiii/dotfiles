local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = 40,
    color = colors.bar.bg,
    padding_right = 8,
    padding_left = 8,
    y_offset = 3,
})
