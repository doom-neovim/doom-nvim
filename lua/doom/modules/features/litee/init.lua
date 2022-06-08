local litee = {}

litee.settings = {}

litee.packages = {
  ["litee.nvim"] = {
    "ldelossa/litee.nvim",
    -- opt = "true",
    config = function()
      require("litee").setup({})
    end,
  },
  ["litee-calltree.nvim"] = { "ldelossa/litee-calltree.nvim" },
  ["litee-bookmarks.nvim"] = { "ldelossa/litee-bookmarks.nvim" },
  ["litee-symboltree.nvim"] = { "ldelossa/litee-symboltree.nvim" },
}

return litee
