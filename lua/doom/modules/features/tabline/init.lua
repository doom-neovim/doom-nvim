local tabline = {}

local utils_g = require("doom.utils")

tabline.settings = {
  options = {
    numbers = function(opts)
      return string.format("%s", opts.id)
    end,
    indicator_icon = "▎",
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 20,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 25,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(_, _, diagnostics_dict, _)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and "  " or (e == "warning" and "  " or "  ")
        s = s .. n .. sym
      end
      return s
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = function(buf_number)
      if vim.bo[buf_number].filetype ~= "dashboard" then
        return true
      end
    end,
    -- groups = {
    --   options = {
    --     toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
    --   },
    --   items = {
    --     {
    --       name = "Tests",
    --       auto_close = true,
    --       matcher = function(buf)
    --         return buf.filename:match("%_test") or buf.filename:match("%_spec")
    --       end,
    --     },
    --     {
    --       name = "Docs",
    --       auto_close = true,
    --       matcher = function(buf)
    --         return buf.filename:match("%.md") or buf.filename:match("%.txt")
    --       end,
    --     },
    --   },
    -- },
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
      },
      {
        filetype = "netrw",
        text = "File Explorer",
        text_align = "center",
      },
      {
        filetype = "minimap",
        text = "Minimap",
        text_align = "center",
      },
      {
        filetype = "Outline",
        text = "Symbols",
        text_align = "center",
      },
      {
        filetype = "packer",
        text = "Plugins manager",
        text_align = "center",
      },
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thick",
    enforce_regular_tabs = true,
    always_show_bufferline = false,
    sort_by = "directory",
    custom_areas = {
      right = function()
        local result = {}
        local error = utils_g.get_diagnostic_count(0, [[Error]])
        local warning = utils_g.get_diagnostic_count(0, [[Warning]])
        local info = utils_g.get_diagnostic_count(0, [[Information]])
        local hint = utils_g.get_diagnostic_count(0, [[Hint]])

        if error ~= 0 then
          result[1] = {
            text = "  " .. error,
            guifg = "#ff6c6b",
          }
        end

        if warning ~= 0 then
          result[2] = {
            text = "  " .. warning,
            guifg = "#ECBE7B",
          }
        end

        if hint ~= 0 then
          result[3] = {
            text = "  " .. hint,
            guifg = "#98be65",
          }
        end

        if info ~= 0 then
          result[4] = {
            text = "  " .. info,
            guifg = "#51afef",
          }
        end
        return result
      end,
    },
  },
}

tabline.packages = {
  ["bufferline.nvim"] = {
    "akinsho/bufferline.nvim",
    branch = "main",
    commit = "2d5266d14b7b5dbc54923469b4599f0349f7cedc",
  },
  ["scope.nvim"] = {
    "tiagovla/scope.nvim",
  },
}

tabline.configs = {}
tabline.configs["bufferline.nvim"] = function()
  print("bufferline.nvim setup")
  require("bufferline").setup(doom.features.tabline.settings)
end
tabline.configs["scope.nvim"] = function()
  require("scope").setup()
end

tabline.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "b",
      name = "+buffer",
      {
        {
          "n",
          function()
            require("bufferline").cycle(1)
          end,
          name = "Jump to next",
        },
        {
          "]",
          function()
            require("bufferline").cycle(1)
          end,
          name = "Jump to next",
        },
        {
          "p",
          function()
            require("bufferline").cycle(-1)
          end,
          name = "Jump to prev",
        },
        {
          "[",
          function()
            require("bufferline").cycle(-1)
          end,
          name = "Jump to prev",
        },
      },
    },
  },
}

return tabline
