return {
  black = 0xff414868,
  white = 0xffc0caf5,
  white_dark = 0xff343b58,
  red = 0xfff7768e,
  red_dark = 0xff8c4351,
  green = 0xff9ece6a,
  blue = 0xff7aa2f7,
  yellow = 0xffe0af68,
  yellow_dark = 0xff8f5e15,
  orange = 0xffff9e64,
  orange_dark = 0xff965027,
  magenta = 0xffbb9af7,
  grey = 0xffa9b1d6,
  transparent = 0x00000000,
  cyan = 0xff7dcfff,

  bar = {
    bg = 0x002c2e34,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490,
  },
  bg1 = 0xff1a1b26,
  bg2 = 0xff24283b,
  dark_fore = 0xff1a1b26,

  gradient = {
    color0 = 0xff1a2439,
    color1 = 0xff23314e,
    color2 = 0xff415786,
    color3 = 0xff5c7bbf,
    color4 = 0xff7aa2f7,
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then
      return color
    end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
