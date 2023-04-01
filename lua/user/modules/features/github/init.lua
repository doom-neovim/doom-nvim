local M = {}

-- M.create_wk_mapping = function()
--   -- loop through all the mappings and create a wk mapping
--   local wk = require("which-key")
--   local buf_num = vim.fn.bufnr()
--
--   for topic, mappings in pairs(M.keys_mappings) do
--     -- print("topic: ", topic)
--     for func, mapping in pairs(mappings) do
--       -- print("func: ", func)
--       local lhs = mapping.lhs
--       local desc = mapping.desc
--
--       local wk_opts = { buffer = buf_num }
--       -- local wk_mapping = { lhs = lhs, opts = wk_opts, desc = desc }
--       local wk_mapping = {}
--       wk_mapping[lhs] = {
--         function()
--           print(func)
--         end,
--         desc,
--       }
--       wk.register(wk_mapping)
--     end
--   end
--   -- wk.register({ ["<leader>"] = { name = "Leader" } }, { prefix = "<leader>" })
-- end
M.settings = {}

M.packages = {

  ["octo.nvim"] = {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}
-- local function getMappings1()
--   return key_mappings;
-- end

M.configs = {
  ["octo.nvim"] = function()
    require("octo").setup({
      default_remote = { "origin", "upstream" },
      -- mappings = getMappings1()
    })
  end,
}
M.octo_menu = function()
  -- this.create_wk_mapping()
  -- local buf_num = vim.fn.bufnr()
  -- vim.api.nvim_buf_set_keymap(buf_num, "n", "<leader>ab", "<cmd>echo 1<CR>", { noremap = true, silent = true })
  -- vim.api.nvim_buf_set_keymap(buf_num, "n", "<leader>ac", "<cmd>echo 2<CR>", { noremap = true, silent = true })

  -- local opts = {buffer = buf_num, prefix = "<leader>"}
  -- local map = require("octo.mappings")
  --
  local buf_num = vim.fn.bufnr()
  -- local opts = { buffer = buf_num, prefix = "<leader>" }
  local handler
  if octo_buffers[buf_num] then
    local picker = require("user.modules.features.github.picker")
    -- print("in a octo buffer")
    handler = picker.show
  else
    -- print("not in a octo buffer")
    handler = require("octo.commands").actions
  end

  handler()
  -- local opts = { buffer = buf_num, prefix = "<leader>" }
  -- local wk_mappings = {
  --   ["g"] = {
  --     O = { handler, "Search Octo ops" },
  --     -- o= { map.open_issues , "reopen" },
  --     -- l= { map.list_issues , "list" },
  --     -- r= { map.reload , "reload(C-r)" },
  --     -- b= { map.open_in_browser , "open browser(C-b)" },
  --     -- y= { map.copy_url , "copy_url(c-y)" },
  --   },
  -- }
  -- local wk = require("which-key")
  -- wk.register(wk_mappings, opts)
end

-- M.autocmds = {
--   {
--     "FileType",
--     -- "*",
--     "*octo",
--     octo_help
--   },
-- }

M.cmds = {
  {
    "OctoMenu",
    function()
      print("TestOcto")
      local github = require("user.modules.features.github")
      github.octo_menu()

      -- local picker = require("user.modules.features.github.picker")
      -- local color = picker.show()
      -- print("color: ", color)
    end,
  },
}
-- M.requires_modules = { "features.auto_install" }
M.binds = {
  {
    "<leader>go",
    [[<cmd>OctoMenu<CR>]],
    name = "Octo menu",
    mode = "nv",
  },
}

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps

return M
