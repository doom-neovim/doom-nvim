local illuminate = {}

illuminate.settings = {
  cursorword_config = {
    delay = 100,
  },
  blacklist = {
    "help",
    "dashboard",
    "packer",
    "norg",
    "DoomInfo",
    "NvimTree",
    "Outline",
    "toggleterm",
  },
}

illuminate.packages = {
  ["mini.cursorword"] = {
    "echasnovski/mini.cursorword",
    commit = "21af5679b39cf1a6bc6bf4eeaabc35e1b5ee7110",
    event = "VeryLazy",
  },
}

illuminate.configs = {}
illuminate.configs["mini.cursorword"] = function()
  _G.cursorword_blocklist = function()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    local blacklist = doom.features.illuminate.settings.blacklist
    vim.b.minicursorword_disable = vim.tbl_contains(blacklist, filetype)
  end
  require("mini.cursorword").setup(doom.features.illuminate.cursorword_config)
end

return illuminate
