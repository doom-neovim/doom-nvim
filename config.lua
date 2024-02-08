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
doom.colorscheme = "catppuccin"

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

doom.use_package({
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
  end,
})

doom.use_package({ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async",
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }
    local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
    for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
            capabilities = capabilities
            -- you can add other fields for setting up lsp server in this table
        })
    end
    require('ufo').setup()
  end,
})

doom.use_package({
  "lewis6991/hover.nvim",
  config = function()
    require("hover").setup({
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        -- require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.man')
        -- require('hover.providers.dictionary')
      end,
      preview_opts = {
        border = "single",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    })
    -- Setup keymaps
    vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
  end,
})

doom.use_package({
  "folke/noice.nvim",
  -- event = "VeryLazy",
  lazy = false,
  opts = {
    -- add any options here
    routes = {
      {
        filter = {
          event = "msg_show",
          find = "lines --",
        },
        opts = { skip = true },
      },
      {
        filter = {
          warning = true,
          find = "vim.treesitter.query.get_query() is deprecated",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = false },
        progress = { enabled = false },
        message = { enabled = false },
        hover = {
          silent = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    })

    -- PATCH: in order to address the message:
    -- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
    --   This feature will be removed in Nvim version 0.10
    -- PATCH: in order to address the message:
    -- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
    --   This feature will be removed in Nvim version 0.10
    local orig_notify = require("noice")
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
  end,
})

doom.use_package({
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = true,
})

doom.use_package({
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
    })
  end,
})

doom.use_package({
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python",
  },
  opts = {
    -- Your options go here
    -- name = "venv",
    auto_refresh = false,
    anaconda_envs_path = "~/mambaforge/envs",
  },
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
})

doom.use_package({
  "stevearc/aerial.nvim",
  opts = {},
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
})

doom.use_package({
  "nvim-pack/nvim-spectre",
})

doom.use_package({
  "ur4ltz/surround.nvim",
  config = function()
    require("surround").setup({ mappings_style = "sandwich" })
  end,
})

doom.use_package("averms/black-nvim")

-- doom.use_package({"kiyoon/jupynium.nvim", build = "pip3 install --user ."})
-- doom.use_package({
--   "kiyoon/jupynium.nvim",
--   config = function()
--     require("jupynium").setup({
--       -- python_host = "python"
--     })
--   end,
-- })
--
doom.use_package({
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      background_colour = "#000000",
    })

    -- PATCH: in order to address the message:
    -- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
    --   This feature will be removed in Nvim version 0.10
    local orig_notify = vim.notify
    local filter_notify = function(text, level, opts)
      -- more specific to this case
      -- if type(text) == "string" and (string.find(text, "get_query", 1, true) or string.find(text, "get_node_text", 1, true)) then
      -- for all deprecated and stack trace warnings
      if
          type(text) == "string"
          and (
            string.find(text, ":help deprecated", 1, true)
            or string.find(text, "stack trace", 1, true)
          )
      then
        return
      end
      orig_notify(text, level, opts)
    end
    vim.notify = filter_notify
  end,
})
doom.use_package("stevearc/dressing.nvim")

doom.use_package({"jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "sh /home/k/openaikey.sh",
        openai_params = {
             model = "gpt-4-turbo-preview",
        },
        openai_edit_params = {
          model = "gpt-4-turbo-preview",
        },
    })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
})

-- Keybinds
doom.use_keybind({
  {
    "<leader>",
    {
      {
        "f",
        name = "+file",
        {
          { "f", "<cmd>Telescope file_browser<CR>", name = "File browser" },
          { "F", "<cmd>Telescope find_files<CR>",   name = "Find in project" },
        },
      },
      {
        "v",
        name = "+venv",
        {
          { "s", "<cmd>VenvSelect<CR>",       name = "Select venv" },
          { "c", "<cmd>VenvSelectCached<CR>", name = "Select cached venv" },
        },
      },
      {
        "t",
        name = "+tweak/toggle",
        {
          { "t", "<cmd>TodoTelescope<CR>", name = "Project TODOs" },
          { "w", "<cmd>set wrap!<CR>",     name = "Toggle word wrap" },
          { "a", "<cmd>AerialToggle!<CR>", name = "Toggle Aerial Code Outline" },
        },
      },
      {
        "h",
        name = "+help",
        {
          { "x", "<cmd>Telescope commands<CR>",  name = "Plugin Commands" },
          { "t", "<cmd>Telescope help_tags<CR>", name = "Built-in commands(tags)" },
        },
      },
      {
        "s",
        name = "+search",
        {
          { "s", "<cmd>lua require('spectre').toggle()<CR>", name = "Search and replace" },
        },
      },
      { ":", "<cmd>Telescope commands<CR>", name = "Plugin Commands" },
    },
  },
})

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
          { "j", "<NOP>",                               name = "Go to cell seperator" },
          { "S", ":JupyniumStartAndAttachToServer<CR>", name = "Start and attach to server" },
          { "f", ":JupyniumStartSync<CR>",              name = "Sync this fille" },
          { "d", ":JupyniumDownloadIpynb<CR>",          name = "Save as ipynb" },
          { "l", ":JupyniumLoadFromIpynbTab 2<CR>",     name = "Load from browser tab (2nd tab)" },
          {
            "k",
            {
              name = "Kernel",
              { "s", ":JupyniumKernelSelect<CR>",    name = "Select Kernel" },
              { "r", ":JupyniumKernelRestart<CR>",   name = "Restart Kernel" },
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

-- Sane jk behaviour
doom.use_keybind({
  {
    { "j", "gj" },
    { "k", "gk" },
  },
})

-- Copilot keybinds
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

-- nvim.ufo keybinds
doom.use_keybind({
  {
    mode = "n",
    {
      { "zO", "<cmd>lua require('ufo').openAllFolds()<CR>" },
      { "zC", "<cmd>lua require('ufo').closeAllFolds()<CR>" },
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
