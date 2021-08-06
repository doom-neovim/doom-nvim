local M = {}

-- Dynamically change statusline colors,
-- defaults to doom-one dark variant colors.
--
-- @tparam string name The color name to be returned
-- @return string
M.get_color = function(name)
  return function()
    local colors = {
      bg = "#23272e",
      fg = "#bbc2cf",
      section_bg = "#5B6268",
      yellow = "#ECBE7B",
      cyan = "#46D9FF",
      green = "#98be65",
      orange = "#da8548",
      magenta = "#c678dd",
      blue = "#51afef",
      red = "#ff6c6b",
    }

    if vim.g.colors_name == "doom-one" and vim.opt.background:get() == "light" then
      colors = {
        bg = "#c6c7c7",
        fg = "#383a42",
        fg_alt = "#9ca0a4",
        yellow = "#986801",
        cyan = "#0184bc",
        green = "#50a14f",
        orange = "#da8548",
        magenta = "#a626a4",
        blue = "#4078f2",
        red = "#e45649",
      }
    elseif vim.g.colors_name:find("gruvbox") then
      colors = {
        bg = "#32302f",
        fg = "#d4be98",
        fg_alt = "#ddc7a1",
        yellow = "#d8a657",
        cyan = "#89b482",
        green = "#a9b665",
        orange = "#e78a4e",
        magenta = "#d3869b",
        blue = "#7daea3",
        red = "#ea6962",
      }
    elseif vim.g.colors_name:find("nord") then
      colors = {
        bg = "#3B4252",
        fg = "#ECEFF4",
        fg_alt = "#D8DEE9",
        yellow = "#EBCB8B",
        cyan = "#88C0D0",
        green = "#A3BE8C",
        orange = "#D08770",
        magenta = "#B48EAD",
        blue = "#5E81AC",
        red = "#BF616A",
      }
    elseif vim.g.colors_name:find("tokyonight") then
      colors = {
        bg = "#292e42",
        fg = "#c0caf5",
        fg_alt = "#a9b1d6",
        yellow = "#e0af68",
        cyan = "#1abc9c",
        green = "#9ece6a",
        orange = "#ff9e64",
        magenta = "#bb9af7",
        blue = "#2ac3de",
        red = "#f7768e",
      }
    elseif vim.g.colors_name:find("dracula") then
      colors = {
        bg = "#21222C",
        fg = "#F8F8F2",
        fg_alt = "#ABB2BF",
        yellow = "#F1FA8C",
        cyan = "#8BE9FD",
        green = "#50FA7B",
        orange = "#FFB86C",
        magenta = "#BD93F9",
        blue = "#A4FFFF",
        red = "#FF5555",
      }
    end
    return colors[name]
  end
end

return M
