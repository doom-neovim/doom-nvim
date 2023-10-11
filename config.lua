-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- Fix annoying lua check warnings
doom.modules.langs.lua.settings.lsp_config.settings.Lua.diagnostics = {
  globals = {"vim", "doom"},
  disable = {"missing-fields", "incomplete-signature-doc"},
}

vim.g.python3_host_prog = "/home/k/mambaforge/envs/python311/bin/python3"
vim.o.linebreak = true

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

doom.use_package("luk400/vim-jukit")

doom.use_keybind({
  {
    "<leader>o",
    {
      { "s",  "<NOP>", name = "jukit#splits#output" },
      { "hs", "<NOP>", name = "jukit#splits#output_and_history" },
      { "d",  "<NOP>", name = "jukit#splits#close_output_split" },
      { "hd", "<NOP>", name = "jukit#splits#close_output_and_history" },
    },
  },
  { "<leader>t", {
    { "s", "<NOP>", name = "jukit#splits#term" },
  } },
  {
    "<leader>h",
    {
      { "s", "<NOP>", name = "jukit#splits#history" },
      { "d", "<NOP>", name = "jukit#splits#close_history" },
      { "t", "<NOP>", name = "jukit#convert#save_nb_to_file" },
    },
  },
  {
    "<leader>s",
    {
      { "o", "<NOP>", name = "jukit#splits#show_last_cell_output" },
      { "l", "<NOP>", name = "jukit#layouts#set_layout" },
    },
  },
  -- { "<leader>j", {
  --   { "", "<NOP>", name = "jukit#splits#out_hist_scroll" },
  -- } },
  -- { "<leader>k", {
  --   { "", "<NOP>", name = "jukit#splits#out_hist_scroll" },
  -- } },
  { "<leader>a", {
    { "h", "<NOP>", name = "jukit#splits#toggle_auto_hist" },
  } },
  {
    "<leader>c",
    {
      { "o", "<NOP>", name = "jukit#cells#create_below" },
      { "O", "<NOP>", name = "jukit#cells#create_above" },
      { "t", "<NOP>", name = "jukit#cells#create_below markdown" },
      { "T", "<NOP>", name = "jukit#cells#create_above markdown" },
      { "d", "<NOP>", name = "jukit#cells#delete" },
      { "s", "<NOP>", name = "jukit#cells#split" },
      { "M", "<NOP>", name = "jukit#cells#merge_above" },
      { "m", "<NOP>", name = "jukit#cells#merge_below" },
      { "k", "<NOP>", name = "jukit#cells#move_up" },
      { "j", "<NOP>", name = "jukit#cells#move_down" },
    },
  },
  { "<leader>j", {
    { "", "call jukit#cells#jump_to_next_cel()<CR>", name = "jukit#cells#jump_to_next_cell" },
  } },
  { "<leader>k", {
    { "", "call jukit#cells#jump_to_previous_cell()<CR>", name = "jukit#cells#jump_to_previous_cell" },
  } },
  {
    "<leader>d",
    {
      { "do", "<NOP>", name = "jukit#cells#delete_outputs" },
      { "da", "<NOP>", name = "jukit#cells#delete_outputs" },
    },
  },
  { "<leader>n", {
    { "p", "<NOP>", name = "jukit#convert#notebook_convert" },
  } },
  -- {
  --   "<leader>r",
  --   {
  --     { "ht", "<NOP>", name = "jukit#convert#save_nb_to_file" },
  --     { "pd", "<NOP>", name = "jukit#convert#save_nb_to_file" },
  --   },
  -- },
  -- { "<leader>p", {
  --   { "d", "<NOP>", name = "jukit#convert#save_nb_to_file" },
  -- } },
})
doom.use_keybind({
  { "<leader>", {
    { "<space>", "<NOP>", name = "jukit#send#section" },
  } },
  { "<cr>", {
    { "", "<NOP>", name = "jukit#send#line" },
  } },
  -- { "<leader>c", {
  --   { "c", "<NOP>", name = "jukit#send#until_current_section" },
  -- } },
  { "<leader>a", {
    { "ll", "<NOP>", name = "jukit#send#all" },
  } },
})

doom.use_package({
  "nvim-orgmode/orgmode",
  config = function()
    require("orgmode").setup_ts_grammar()
    require("orgmode").setup({
      -- These are nnoremap maps
      mappings = {
        org = {
          org_todo = { "t", "cit" },
          org_insert_heading_respect_content = { "<S-CR>", "<Leader>oih" },
          org_cycle = { "<TAB>", "za" },
          org_global_cycle = { "<S-TAB>", "zA" },
        },
      },
    })
  end,
})
doom.use_keybind({
  {
    "<leader>o",
    name = "+open/close",
    {
      { "a", "<NOP>", name = "Org Agenda" },
      { "c", "<NOP>", name = "Org Capture" },
    },
  },
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

-- Sane jk behaviour
doom.use_keybind({
  {
    { "j", "gj" },
    { "k", "gk" },
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
          { "<C-g>",  'copilot#Accept("<CR>")' },
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

doom.use_keybind({
  -- The `name` field will add the keybind to whichkey
  {
    "<leader>t",
    name = "+tweak/toggle",
    {
      -- Bind to a vim command
      { "w", "<cmd>set wrap!<CR>", name = "Toggle word wrap" },
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
