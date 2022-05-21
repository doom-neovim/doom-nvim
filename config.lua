-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
-- doom.use_package({
--   "ur4ltz/surround.nvim",
--   config = function()
--     require("surround").setup({mappings_style = "sandwich"})
--   end
-- })

-- ADDING A KEYBIND
--
-- doom.use_keybind({
--   -- The `name` field will add the keybind to whichkey
--   {"<leader>s", name = '+search', {
--     -- Bind to a vim command
--     {"g", "Telescope grep_string<CR>", name = "Grep project"},
--     -- Or to a lua function
--     {"p", function()
--       print("Not implemented yet")
--     end, name = ""}
--   }}
-- })

-- ADDING A COMMAND
--
-- doom.use_cmd({
--   {"CustomCommand1", function() print("Trigger my custom command 1") end},
--   {"CustomCommand2", function() print("Trigger my custom command 2") end}
-- })

-- ADDING AN AUTOCOMMAND
--
-- doom.use_autocmd({
--   { "FileType", "javascript", function() print('This is a javascript file') end }
-- })

-- Editor config
doom.indent = 2
doom.border_style = { "", "", "", "", "", "", "", "" }
doom.impatient_enabled = true
doom.autosave = false
doom.escape_sequences = {}
-- vim.lsp.set_log_level('trace')

vim.diagnostic.config({
  float = {
    source = "always",
  },
})

-- doom.modules.linter.settings.format_on_save = true
doom.core.reloader.settings.reload_on_save = false

if doom.modules.tabline then
  doom.modules.tabline.settings.options.diagnostics_indicator = function(_, _, diagnostics_dict, _)
    doom.modules.tabline.settings.options.numbers = nil -- Hide buffer numbers
    local s = ""
    for e, _ in pairs(diagnostics_dict) do
      local sym = e == "error" and " " or (e == "warning" and " " or " ")
      s = s .. sym
    end
    return s
  end
end

-- Colourscheme
doom.use_package("sainnhe/sonokai", "EdenEast/nightfox.nvim")
local options = {
  dim_inactive = true,
}
local palettes = {
  dawnfox = {
    bg2 = "#F9EFEC",
    bg3 = "#ECE3DE",
    sel1 = "#EEF1F1",
    sel2 = "#D8DDDD",
  },
}
local specs = {}
local all = {
  TelescopeNormal = { fg = "fg0", bg = "bg0" },
  TelescopePromptTitle = { fg = "pallet.green", bg = "bg1" },
  TelescopePromptBorder = { fg = "bg1", bg = "bg1" },
  TelescopePromptNormal = { fg = "fg1", bg = "bg1" },
  TelescopePromptPrefix = { fg = "fg1", bg = "bg1" },

  TelescopeResultsTitle = { fg = "pallet.green", bg = "bg2" },
  TelescopeResultsBorder = { fg = "bg2", bg = "bg2" },
  TelescopeResultsNormal = { fg = "fg1", bg = "bg2" },

  TelescopePreviewTitle = { fg = "pallet.green", bg = "bg1" },
  TelescopePreviewNormal = { bg = "bg1" },
  TelescopePreviewBorder = { fg = "bg1", bg = "bg1" },
  TelescopeMatching = { fg = "error" },
  CursorLine = { bg = "sel1", link = "" },
}
require("nightfox").setup({
  options = options,
  palettes = palettes,
  specs = specs,
  all = all,
})
doom.colorscheme = "dawnfox"

-- Extra packages
doom.use_package(
  "rafcamlet/nvim-luapad",
  "nvim-treesitter/playground",
  "tpope/vim-surround",
  "dstein64/vim-startuptime"
)

doom.langs.lua.packages["lua-dev.nvim"] = { "max397574/lua-dev.nvim", ft = "lua" }

vim.opt.guifont = { "Hack Nerd Font", "h12" }

vim.cmd("let g:neovide_refresh_rate=60")
vim.cmd("let g:neovide_cursor_animation_length=0.03")
vim.cmd("set laststatus=3")
-- vim: sw=2 sts=2 ts=2 expandtab
