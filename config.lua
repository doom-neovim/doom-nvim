-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
doom.use_package({
  "ur4ltz/surround.nvim",
  config = function()
    require("surround").setup({ mappings_style = "sandwich" })
  end,
})

doom.use_package("averms/black-nvim")

doom.use_package({ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" })

doom.use_package({
  "nvim-orgmode/orgmode",
  config = function()
    require("orgmode").setup_ts_grammar()
    require("orgmode").setup({
      -- These are nnoremap maps
      mappings = {
        org = {
          org_todo = { "t", "cit" },
          org_insert_heading_respect_content = { "<Enter>", "<Leader>oih" },
          org_cycle = { "<TAB>", "za" },
          org_global_cycle = { "<S-TAB>", "zA" },
        },
      },
    })
  end,
})

-- Orgmode: input mode tab and shift-tab to promote/demote subtree
doom.use_cmd({
  {
    "MyTabOrgDemote",
    function()
      local ok, orgMappings = pcall(require, "orgmode.org.mappings")
      if ok and orgMappings and vim.bo.filetype == "org" then
        orgMappings.do_demote({ args = { true }, opts = { desc = "org demote subtree" } })
      end
    end,
  },
  {
    "MyTabOrgPromote",
    function()
      local ok, orgMappings = pcall(require, "orgmode.org.mappings")
      if ok and orgMappings and vim.bo.filetype == "org" then
        orgMappings.do_promote({ args = { true }, opts = { desc = "org demote subtree" } })
      end
    end,
  },
})
doom.use_keybind({
  {
    mode = "i",
    {
      { "<TAB>",   "<cmd>MyTabOrgDemote<CR>" },
      { "<S-TAB>", "<cmd>MyTabOrgPromote<CR>" },
    },
  },
})

doom.use_package({
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
  end,
})
doom.use_keybind({
  -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
  {
    mode = "i",
    {
      {
        options = { expr = true, script = true, replace_keycodes = false },
        {
          { "<C-g>", 'copilot#Accept("<CR>")' },
          { "<C-CR>", 'copilot#Accept("<CR>")' },
        },
      },
      { "<C-j>", "<Plug>(copilot-next)" },
      { "<C-k>", "<Plug>(copilot-previous)" },
      { "<C-o>", "<Plug>(copilot-dismiss)" },
      { "<C-f>", "<Plug>(copilot-suggest)" },
    },
  },
})

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

-- vim: sw=2 sts=2 ts=2 expandtab

-- PATCH: in order to address the message:
-- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
--   This feature will be removed in Nvim version 0.10
local orig_notify = vim.notify
local filter_notify = function(text, level, opts)
  -- more specific to this case
  if
      type(text) == "string"
      and (string.find(text, "get_query", 1, true) or string.find(text, "get_node_text", 1, true))
  then
    -- for all deprecated and stack trace warnings
    -- if type(text) == "string" and (string.find(text, ":help deprecated", 1, true) or string.find(text, "stack trace", 1, true)) then
    return
  end
  orig_notify(text, level, opts)
end
vim.notify = filter_notify
