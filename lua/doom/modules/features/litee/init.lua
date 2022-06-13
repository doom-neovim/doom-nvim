local litee = {}

litee.settings = {}

litee.packages = {
  ["litee.nvim"] = {
    "ldelossa/litee.nvim",
    -- opt = "true",
  },
  ["litee-calltree.nvim"] = { "ldelossa/litee-calltree.nvim" },
  ["litee-bookmarks.nvim"] = { "ldelossa/litee-bookmarks.nvim" },
  ["litee-symboltree.nvim"] = { "ldelossa/litee-symboltree.nvim" },
}

litee.config = {}

litee.config["litee.nvim"] = function()
  require("litee").setup({})
end

return litee
