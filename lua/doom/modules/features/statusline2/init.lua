local statusline = {}

statusline.settings = {
}

statusline.packages = {
  ["lualine.nvim"] = {
    "nvim-lualine/lualine.nvim",
  },
}

statusline.configure_functions = {}
statusline.configure_functions["lualine.nvim"] = function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'nightfox',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end

return statusline
