local M = {}

M.settings = {}

M.packages = {
  ["attempt.nvim"] = {
    "m-demare/attempt.nvim",
    requires = "nvim-lua/plenary.nvim",
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}

M.configs = {
  ["attempt.nvim"] = function()
    require("attempt").setup({
      dir = vim.fn.stdpath("data") .. "/attempt.nvim/",
    })
    local telescope = require("telescope")
    telescope.load_extension("attempt")
  end,
}

-- M.autocmds = {}
--
-- M.cmds = {}
-- M.requires_modules = { "features.auto_install" }

M.binds =
{
  {
    "<leader>S",
    name = "+Scratch pad",
    {
      { "n", function() require ("attempt").new_select() end, name = "New..." },
      { "N", function() require ("attempt").new_input_ext() end, name = "New(input)..." },
      { "!", function() require ("attempt").run() end, name = "Run..." },
      { "d", function() require ("attempt").delete_buf() end, name = "Delete..." },
      { "r", function() require ("attempt").rename_buf() end, name = "Rename..." },
      { "l", "<cmd> Telescope attempt <CR>", name = "List..." },
    }
  },
}

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps
return M
