local is_plugin_disabled = require("doom.utils").is_plugin_disabled

return {
  ["packer.nvim"] = {
    "wbthomason/packer.nvim",
    opt = true,
  },
  ["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    commit = vim.fn.has("nvim-0.6.0") == 1 and "afed686e6a8fc1035475d8c56c1b5ff252c346e5"
      or "47cfda2c6711077625c90902d7722238a8294982",
    run = ":TSUpdate",
    branch = vim.fn.has("nvim-0.6.0") == 1 and "master" or "0.5-compat",
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "097df33c9ef5bbd3828105e4bee99965b758dc3f",
    opt = true,
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "32bc46ee8b21f88f87d97b976ae6674595b311b5",
    opt = true,
    after = "nvim-treesitter",
  },
  -- Required by some treesitter modules
  ["aniseed"] = {
    "Olical/aniseed",
    commit = "7968693e841ea9d2b4809e23e8ec5c561854b6d6",
    module_pattern = "aniseed",
  },
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "563d9f6d083f0514548f2ac4ad1888326d0a1c66",
    module = "plenary",
  },
  ["popup.nvim"] = {
    "nvim-lua/popup.nvim",
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
    module = "popup",
  },
  ["nest.nvim"] = {
    "connorgmeehan/nest.nvim",
    branch = "integrations-api",
    after = "nvim-mapper",
  },
  ["nvim-mapper"] = {
    "lazytanuki/nvim-mapper",
    before = is_plugin_disabled("telescope") or "telescope.nvim",
  },
  ["nvim-web-devicons"] = {
    "kyazdani42/nvim-web-devicons",
    commit = "634e26818f2bea9161b7efa76735746838971824",
    module = "nvim-web-devicons",
  },
  ['nvim-web-devicons'] = {
    'kyazdani42/nvim-web-devicons',
    commit = "8df4988ecf8599fc1f8f387bbf2eae790e4c5ffb",
    module = "nvim-web-devicons",
  }
}
