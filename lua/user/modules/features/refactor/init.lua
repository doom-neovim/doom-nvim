local M = {}

M.settings = {
}

M.packages = {
  ["refactoring.nvim"] = {
    "ThePrimeagen/refactoring.nvim",
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },

}

M.configs = {
  ["refactoring.nvim"] = function()
        require("refactoring").setup {}
        local has_telescope = pcall(require, "telescope")
        if (has_telescope) then -- TODO: integrate with telescope. Dont know why cannot load telescope here
            local res = require("telescope").load_extension("refactoring")
        end
  end,

}

M.autocmds = {
}

M.cmds = {
}
-- M.requires_modules = { "features.auto_install" }

M.binds = {
  {
    "<leader>co",
    name = "+Refactor",
    mode = "n",
    {
            {"v", [[<cmd>lua require('refactoring').debug.print_var({ normal = true })<CR>]], name = "Debug Printvar"},
            {"p", [[<cmd>lua require('refactoring').debug.printf({below = false})<CR>]], name = "Debug Print " },
            {"c", [[<cmd>lua require('refactoring').debug.cleanup({})<CR>]], name = "Clean Debug" }
    },
  },
}

return M
