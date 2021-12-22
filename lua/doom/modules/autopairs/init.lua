local autopairs = {}

autopairs.defaults = {
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_moveright = true,
}

autopairs.packer_config = {}
autopairs.packer_config["nvim-autopairs"] = function()
  require("nvim-autopairs").setup(vim.tbl_deep_extend("force", doom.autopairs, { check_ts = true }))
end

return autopairs
