-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- ADDING A PACKAGE
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai") doom.use_package({
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

doom.indent = 2
doom.core.treesitter.settings.show_compiler_warning_message = false
doom.core.reloader.settings.reload_on_save = false

doom.langs.lua.settings.disable_lsp = true
doom.features.tabline.settings.options.enforce_regular_tabs = false
-- vim: sw=2 sts=2 ts=2 expandtab
--
-- custom keybindings for tabline
doom.features.tabline.binds = {
  {"H",
  name = "Left",
  function()
    require("bufferline").cycle(-1)
  end
  },
  {"L",
  name = "Left",
  function()
    require("bufferline").cycle(1)
  end
  },
}
-- custom keybindings for comments
--
doom.features.comment.binds = {
  {
    "gc",
    [[<Esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>]],
    name = "Comment line",
    mode = "v",
  }, {
    "gcc",
    [[<cmd>lua require("Comment.api").toggle.linewise.current()<CR>]],
    name = "Comment line",
  },
  {
    "gcA",
    [[<cmd>lua require("Comment.api").insert.linewise.eol()<CR>]],
    name = "Comment end of line",
    mode = "ni",
  },
}
--
--
-- some un categorized plugin here
-- TODO: Will move them into a module

-- doom.use_package({
--   "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
--   config = function()
--     require'toggle_lsp_diagnostics'.init()
--   end
-- })


-- Packer

doom.use_package({
  "folke/noice.nvim",
  config = function()
    require("noice").setup({

      notify = {enabled = false, view = "notify"},
      messages = {enabled = true, view = "mini"},
      lsp = {
        -- progress = {enabled = false},
        hover = {enabled = false},
        signature = { enabled = false}
      },
    })

  end,
  requires = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    }
})

-- fold setting
local opt = vim.opt
opt.foldlevel = 1
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
