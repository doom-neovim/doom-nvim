local M = {}

M.settings = {}

M.packages = {

  ["copilot.lua"] = {
    "zbirenbaum/copilot.lua",
    -- cmd = "Copilot",
    -- event = "InsertEnter",
  },
  ["copilot-cmp"] = {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}
-- local function getMappings1()
--   return key_mappings;
-- end

M.configs = {
  ["copilot-cmp"] = function()
    require("copilot_cmp").setup()
  end,
  ["copilot.lua"] = function()
    -- require("copilot").setup({
    --   suggestion = {
    --     auto_trigger = true,
    --     keymap = {
    --       accept = "<C-a>",
    --     },
    --   },
    -- })
    vim.defer_fn(function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end, 100)

    -- require("copilot").setup({
    --   suggestion = { enabled = false },
    --   panel = { enabled = false },
    -- })
  end,
}

M.autocmds = {}

M.cmds = {}
-- M.requires_modules = { "features.auto_install" }
-- M.binds = {
--   {
--     "<leader>go",
--     [[<cmd>Octo actions<CR>]],
--     name = "Octo menu",
--     mode = "nv",
--   },
-- }

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps

return M
