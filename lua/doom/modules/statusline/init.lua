local statusline = {}

statusline.defaults = {
  short_line_list = {
    "NvimTree",
    "packer",
    "minimap",
    "Outline",
    "toggleterm",
    "netrw",
  },
  on_dashboard = true,
  show_file_path = true,
  sections = {},
}

statusline.packer_config = {}
statusline.packer_config["galaxyline.nvim"] = function()
  local utils = require("doom.utils")
  local is_plugin_disabled = utils.is_plugin_disabled

  local gl = require("galaxyline")
  local colors = require("galaxyline.themes.colors").get_color
  local lsp = require("galaxyline.providers.lsp")
  local buffer = require("galaxyline.providers.buffer")
  local condition = require("galaxyline.condition")
  local gls = gl.section

  local function is_dashboard()
    local buftype = buffer.get_buffer_filetype()
    return buftype == "DASHBOARD"
  end

  local function is_not_dashboard()
    local buftype = buffer.get_buffer_filetype()
    return buftype ~= "DASHBOARD"
  end

  gl.short_line_list = doom.statusline.short_line_list

  if not is_plugin_disabled("dashboard") and not doom.statusline.on_dashboard then
    table.insert(gl.exclude_filetypes, "dashboard")
  end

  local default_sections = {
    short_left = {
      {
        ShortRainbowLeft = {
          provider = function()
            return "▊ "
          end,
          highlight = { colors("blue"), colors("bg") },
        },
      },
      {
        BufferType = {
          provider = "FileTypeName",
          condition = is_not_dashboard,
          highlight = { colors("fg"), colors("bg") },
        },
      },
    },
    left = {
      {
        RainbowLeft = {
          provider = function()
            return "▊ "
          end,
          highlight = { colors("blue"), colors("bg") },
        },
      },
      {
        ViMode = {
          provider = function()
            -- auto change color according the vim mode
            -- TODO: find a less dirty way to set ViMode colors
            local mode_color = {
              n = colors("red"),
              i = colors("green"),
              v = colors("blue"),
              [""] = colors("blue"),
              V = colors("blue"),
              c = colors("magenta"),
              no = colors("red"),
              s = colors("orange"),
              S = colors("orange"),
              [""] = colors("orange"),
              ic = colors("yellow"),
              R = colors("magenta"),
              Rv = colors("magenta"),
              cv = colors("red"),
              ce = colors("red"),
              r = colors("cyan"),
              rm = colors("cyan"),
              ["r?"] = colors("cyan"),
              ["!"] = colors("red"),
              t = colors("red"),
            }
            vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()]())
            return "  "
          end,
          highlight = { colors("red"), colors("bg"), "bold" },
        },
      },
      {
        FileSize = {
          provider = "FileSize",
          condition = condition.buffer_not_empty and condition.hide_in_width,
          highlight = {
            colors("fg"),
            colors("bg"),
          },
          separator = " ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        FileIcon = {
          provider = "FileIcon",
          condition = condition.buffer_not_empty and is_not_dashboard,
          highlight = {
            require("galaxyline.providers.fileinfo").get_file_icon_color,
            colors("bg"),
          },
        },
      },
      {
        FileName = {
          provider = doom.statusline.show_file_path and "FilePath" or "FileName",
          condition = condition.buffer_not_empty and is_not_dashboard,
          highlight = { colors("fg"), colors("bg"), "bold" },
          separator = " ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        LineInfo = {
          provider = function()
            local line = vim.fn.line(".")
            local column = vim.fn.col(".")
            return string.format("%3d : %2d  ", line, column)
          end,
          condition = is_not_dashboard,
          highlight = { colors("fg_alt"), colors("bg") },
        },
      },
      {
        LinePercent = {
          provider = "LinePercent",
          condition = is_not_dashboard,
          highlight = { colors("fg_alt"), colors("bg") },
          separator = "  ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
    },
    short_right = {
      {
        BufferIcon = {
          provider = "BufferIcon",
          condition = is_not_dashboard,
          highlight = { colors("yellow"), colors("bg") },
        },
      },
      {
        ShortRainbowRight = {
          provider = function()
            return " ▊"
          end,
          highlight = { colors("blue"), colors("bg") },
        },
      },
    },
    right = {
      {
        FileFormat = {
          provider = "FileFormat",
          condition = condition.hide_in_width and is_not_dashboard,
          highlight = { colors("fg"), colors("bg") },
          separator = "  ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        FileEncode = {
          provider = "FileEncode",
          condition = condition.hide_in_width and is_not_dashboard,
          highlight = { colors("fg"), colors("bg") },
          separator = " ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        ShowLspClientOrFileType = {
          provider = function()
            -- Check if there's a LSP client running to avoid redundant
            -- statusline elements
            if lsp.get_lsp_client() ~= "No Active Lsp" then
              return string.format(" %s » %s ", vim.bo.filetype, lsp.get_lsp_client())
            else
              -- Use the filetype instead
              return string.format(" %s ", vim.bo.filetype)
            end
          end,
          condition = function()
            local tbl = { ["dashboard"] = true, [""] = true }
            if tbl[vim.bo.filetype] then
              return false
            end
            return true
          end,
          highlight = { colors("blue"), colors("bg") },
          separator = "  ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        GitIcon = {
          provider = function()
            return " "
          end,
          condition = condition.check_git_workspace,
          highlight = { colors("red"), colors("bg") },
          separator = " ",
          separator_highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        GitBranch = {
          provider = "GitBranch",
          condition = condition.check_git_workspace,
          highlight = { colors("green"), colors("bg"), "bold" },
        },
      },
      {
        DiffSeparator = {
          provider = function()
            return "   "
          end,
          condition = condition.hide_in_width,
          highlight = { colors("bg"), colors("bg") },
        },
      },
      {
        DiffAdd = {
          provider = "DiffAdd",
          condition = condition.hide_in_width,
          icon = " ",
          highlight = { colors("green"), colors("bg") },
        },
      },
      {
        DiffModified = {
          provider = "DiffModified",
          condition = condition.hide_in_width,
          icon = " ",
          highlight = { colors("orange"), colors("bg") },
        },
      },
      {
        DiffRemove = {
          provider = "DiffRemove",
          condition = condition.hide_in_width,
          icon = " ",
          highlight = { colors("red"), colors("bg") },
        },
      },
    },
    {
      DoomVersion = {
        provider = function()
          return "DOOM v" .. utils.doom_version .. " "
        end,
        condition = is_dashboard,
        highlight = { colors("blue"), colors("bg"), "bold" },
        separator = "  ",
        separator_highlight = {
          colors("bg"),
          colors("bg"),
        },
      },
    },
    {
      RainbowRight = {
        provider = function()
          return " ▊"
        end,
        highlight = { colors("blue"), colors("bg") },
      },
    },
  }

  if not is_plugin_disabled("lsp") then
    table.insert(default_sections.left, {
      DiagnosticError = {
        provider = "DiagnosticError",
        condition = is_not_dashboard,
        icon = doom.lsp.icons.error .. " ",
        highlight = { colors("red"), colors("bg") },
      },
    })
    table.insert(default_sections.left, {
      DiagnosticWarn = {
        provider = "DiagnosticWarn",
        condition = is_not_dashboard,
        icon = doom.lsp.icons.warn .. " ",
        highlight = { colors("orange"), colors("bg") },
      },
    })
    table.insert(default_sections.left, {
      DiagnosticInfo = {
        provider = "DiagnosticInfo",
        condition = is_not_dashboard,
        icon = doom.lsp.icons.hint .. " ",
        highlight = { colors("blue"), colors("bg") },
      },
    })
  end

  local merged_sections = vim.tbl_extend("force", default_sections, doom.statusline.sections)

  gls.left = merged_sections.left
  gls.right = merged_sections.right
  gls.short_line_left = merged_sections.short_left
  gls.short_line_right = merged_sections.short_right
end

return statusline
