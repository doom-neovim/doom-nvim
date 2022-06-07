local statusline = {}

statusline.settings = {
}

statusline.packages = {
  ["lualine.nvim"] = {
    "nvim-lualine/lualine.nvim",
  },
}

statusline.configs = {}
statusline.configs["lualine.nvim"] = function()
  local config = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filesize', 'filename'},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }


  -- Inserts a component in lualine_c at left section
  local function ins_left(component, section)
    local section_name = section or 'lualine_c'
    table.insert(config.sections[section_name], component)
  end

  -- Inserts a component in lualine_x ot right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end
  ins_left({
    function()
      return '▊'
    end,
    -- color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
  }, 'lualine_a')

  ins_left ({
    -- mode component
    function()
      return ''
    end,
    padding = { right = 1 },
  }, 'lualine_a')

  ins_left('filesize')
  ins_left('filetype')
  ins_left('filename')
  ins_left('location')
  ins_left('progress')

  ins_right('encoding')
  ins_right('branch')
  require('lualine').setup(config)
end

return statusline
