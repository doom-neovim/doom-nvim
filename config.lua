-- luacheck: ignore 113 143 148 542
-- the above line is a special comment to fix annoying lua check warnings

-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- Fix annoying lua check warnings
-- Need to use both to top level inline comment and this one
doom.modules.langs.lua.settings.lsp_config.settings.Lua.diagnostics = {
  globals = { "vim", "doom" },
  std = {
    globals = { "vim", "doom" },
  },
  disable = { "missing-fields", "incomplete-signature-doc" },
}

-- vim.g.python3_host_prog = "/home/k/mambaforge/envs/python311/bin/python3"
vim.g.python3_host_prog = "/home/k/mambaforge/bin/python"
vim.o.linebreak = true

doom.use_keybind({
  {
    "<leader>",
    {
      {
        "f",
        name = "+file",
        {
          { "f", "<cmd>Telescope file_browser<CR>", name = "File browser" },
          { "F", "<cmd>Telescope find_files<CR>", name = "Find in project" },
        },
      },
    },
  },
})

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
--
doom.use_package({
  "ur4ltz/surround.nvim",
  config = function()
    require("surround").setup({ mappings_style = "sandwich" })
  end,
})

doom.use_package("averms/black-nvim")

-- doom.use_package({"kiyoon/jupynium.nvim", build = "pip3 install --user ."})
doom.use_package({
  "kiyoon/jupynium.nvim",
  config = function()
    require("jupynium").setup({
      -- python_host = "python"
    })
  end,
})
doom.use_package({
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      background_colour = "#000000",
    })
  end,
})
doom.use_package("stevearc/dressing.nvim")

-- Jupynium keybinds
doom.use_keybind({
  {
    "<leader>",
    {
      { "x", "<NOP>", name = "Execute current cell" },
      -- { "c",  "<NOP>", name = "Clear current cell" },
      {
        "j",
        {
          name = "+jump/Jupynium",
          { "j", "<NOP>", name = "Go to cell seperator" },
          { "S", ":JupyniumStartAndAttachToServer<CR>", name = "Start and attach to server" },
          { "f", ":JupyniumStartSync<CR>", name = "Sync this fille" },
          { "d", ":JupyniumDownloadIpynb<CR>", name = "Save as ipynb" },
          { "l", ":JupyniumLoadFromIpynbTab 2<CR>", name = "Load from browser tab (2nd tab)" },
          {
            "k",
            {
              name = "Kernel",
              { "s", ":JupyniumKernelSelect<CR>", name = "Select Kernel" },
              { "r", ":JupyniumKernelRestart<CR>", name = "Restart Kernel" },
              { "i", ":JupyniumKernelInterrupt<CR>", name = "Interrupt Kernel" },
            },
          },
        },
      },
    },
  },
  {
    "[",
    {
      { "j", "<NOP>", name = "Go to prev cell" },
    },
  },
  {
    "]",
    {
      { "j", "<NOP>", name = "Go to next cell" },
    },
  },
  {
    "va",
    {
      { "j", "<NOP>", name = "Select current cell [:)" },
      { "J", "<NOP>", name = "Select current cell [:]" },
    },
  },
  {
    "vi",
    {
      { "j", "<NOP>", name = "Select current inner cell (:)" },
      { "J", "<NOP>", name = "Select current inner cell (:]" },
    },
  },
})

-- doom.use_package("luk400/vim-jukit")
-- vim.cmd[[highlight jukit_cellmarker_colors guifg=#1d615a guibg=#1d615a ctermbg=22 ctermfg=22]]

-- -- Legit jukit settings
-- vim.g.jukit_terminal = "kitty"
-- -- Only map jukit keys in these filetypes
-- vim.g.jukit_mappings_ext_enabled= {'py', 'ipynb'}
-- -- For kitty, split output in an os window
-- vim.g.jukit_output_new_os_window = 1
-- vim.g.jukit_hl_ext_enabled = {'py', 'ipynb'}
-- vim.g.jukit_highlight_markers = 1
-- vim.g.jukit_enable_textcell_bg_hl = 1
-- vim.g.jukit_enable_textcell_syntax = 1
-- local vimruntime = vim.fn.expand('$VIMRUNTIME')
-- local jukit_text_syntax_file = vimruntime .. '/syntax/markdown.vim'
-- vim.g.jukit_text_syntax_file = jukit_text_syntax_file
-- vim.g.jukit_notebook_viewer = 'code'
-- -- vim.g.jukit_hist_use_ueberzug = 1
-- -- vim.g.jukit_ueberzug_use_cached = 1
-- -- Remove all default mappings
-- vim.g.jukit_mappings = 0
--
-- -- luacheck: ignore 113 143 148 542
-- doom.use_keybind({
--   { '<leader>o',  {
--     { 's', ':call jukit#splits#output()<CR>', name = 'jukit#splits#output' },
--     { 'hs', ':call jukit#splits#output_and_history()<CR>', name = 'jukit#splits#output_and_history' },
--     { 'd', ':call jukit#splits#close_output_split()<CR>', name = 'jukit#splits#close_output_split' },
--     { 'hd', ':call jukit#splits#close_output_and_history(1)<CR>', name = 'jukit#splits#close_output_and_history' }
--   } },
--   { '<leader>t',  {
--     { 's', ':call jukit#splits#term()<CR>', name = 'jukit#splits#term' }
--   } },
--   { '<leader>h',  {
--     { 's', ':call jukit#splits#history()<CR>', name = 'jukit#splits#history' },
--     { 'd', ':call jukit#splits#close_history()<CR>', name = 'jukit#splits#close_history' },
--     { 't', ':call jukit#convert#save_nb_to_file(0,1,\'html\')<CR>', name = 'jukit#convert#save_nb_to_file' }
--   } },
--   { '<leader>s',  {
--     { 'o', ':call jukit#splits#show_last_cell_output(1)<CR>', name = 'jukit#splits#show_last_cell_output' },
--     { 'l', ':call jukit#layouts#set_layout()<CR>', name = 'jukit#layouts#set_layout' }
--   } },
--   -- { '<leader>j',  {
--   --   { '', ':call jukit#splits#out_hist_scroll(1)<CR>', name = 'jukit#splits#out_hist_scroll' }
--   -- } },
--   -- { '<leader>k',  {
--   --   { '', ':call jukit#splits#out_hist_scroll(0)<CR>', name = 'jukit#splits#out_hist_scroll' }
--   -- } },
--   { '<leader>a',  {
--     { 'h', ':call jukit#splits#toggle_auto_hist()<CR>', name = 'jukit#splits#toggle_auto_hist' }
--   } },
--   { '<leader>c',  {
--     { 'o', ':call jukit#cells#create_below(0)<CR>', name = 'jukit#cells#create_below' },
--     { 'O', ':call jukit#cells#create_above(0)<CR>', name = 'jukit#cells#create_above' },
--     { 't', ':call jukit#cells#create_below(1)<CR>', name = 'jukit#cells#create_below' },
--     { 'T', ':call jukit#cells#create_above(1)<CR>', name = 'jukit#cells#create_above' },
--     { 'd', ':call jukit#cells#delete()<CR>', name = 'jukit#cells#delete' },
--     { 's', ':call jukit#cells#split()<CR>', name = 'jukit#cells#split' },
--     { 'M', ':call jukit#cells#merge_above()<CR>', name = 'jukit#cells#merge_above' },
--     { 'm', ':call jukit#cells#merge_below()<CR>', name = 'jukit#cells#merge_below' },
--     { 'k', ':call jukit#cells#move_up()<CR>', name = 'jukit#cells#move_up' },
--     { 'j', ':call jukit#cells#move_down()<CR>', name = 'jukit#cells#move_down' }
--   } },
--   { '<leader>j',  {
--     { '', ':call jukit#cells#jump_to_next_cell()<CR>', name = 'jukit#cells#jump_to_next_cell' }
--   } },
--   { '<leader>k',  {
--     { '', ':call jukit#cells#jump_to_previous_cell()<CR>', name = 'jukit#cells#jump_to_previous_cell' }
--   } },
--   { '<leader>d',  {
--     { 'do', ':call jukit#cells#delete_outputs(0)<CR>', name = 'jukit#cells#delete_outputs' },
--     { 'da', ':call jukit#cells#delete_outputs(1)<CR>', name = 'jukit#cells#delete_outputs' }
--   } },
--   { '<leader>n',  {
--     { 'p', ':call jukit#convert#notebook_convert("jupyter-notebook")<CR>', name = 'jukit#convert#notebook_convert' }
--   } },
--   { '<leader>r',  {
--     { 'ht', ':call jukit#convert#save_nb_to_file(1,1,\'html\')<CR>', name = 'jukit#convert#save_nb_to_file' },
--     { 'pd', ':call jukit#convert#save_nb_to_file(1,1,\'pdf\')<CR>', name = 'jukit#convert#save_nb_to_file' }
--   } },
--   { '<leader>p',  {
--     { 'd', ':call jukit#convert#save_nb_to_file(0,1,\'pdf\')<CR>', name = 'jukit#convert#save_nb_to_file' }
--   } }
-- })
-- doom.use_keybind({
--   { '<leader>',  {
--     { '<space>', ':call jukit#send#section(0)<CR>', name = 'jukit#send#section' }
--   } },
--   { '<cr>',  {
--     { '', ':call jukit#send#line()<CR>', name = 'jukit#send#line' }
--   } },
--   { '<leader>c',  {
--     { 'c', ':call jukit#send#until_current_section()<CR>', name = 'jukit#send#until_current_section' }
--   } },
--   { '<leader>a',  {
--     { 'll', ':call jukit#send#all()<CR>', name = 'jukit#send#all' }
--   } }
-- })

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
      { "<TAB>", "<cmd>MyTabOrgDemote<CR>" },
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
