local doom_themes = {}

doom_themes.settings = {}

doom_themes.configs = {}

doom_themes.packages = {
  ["doom-themes.nvim"] = {
    "GustavoPrietoP/doom-themes.nvim",
    event = "ColorScheme",
    lazy = true,
  },
}

return doom_themes
