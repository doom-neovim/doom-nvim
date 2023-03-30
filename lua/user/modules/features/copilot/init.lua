local M = {}

M.settings = {}

M.packages = {

  ["copilot.vim"] = {
    "github/copilot.vim",
  },
}
-- local function getMappings1()
--   return key_mappings;
-- end

M.configs = {
  -- ["copilot-cmp"] = function()
  --   require("copilot_cmp").setup()
  -- end,
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
