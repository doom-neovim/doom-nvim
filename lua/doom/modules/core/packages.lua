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
    commit = "9f5e422e1030e7073e593ad32c5354aa0bcb0176",
    opt = true,
    after = "nvim-treesitter",
  },
  ["nvim-tree-docs"] = {
    "nvim-treesitter/nvim-tree-docs",
    commit = "15135bd18c8f0c4d67dd1b36d3b2cd64579aab6f",
    opt = true,
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "80d427af7b898768c8d8538663d52dee133da86f",
    opt = true,
    after = "nvim-treesitter",
  },
  -- Required by some treesitter modules
  ["aniseed"] = {
    "Olical/aniseed",
    commit = "9c8f2cd17d454a38b11cedd323579b579ee27f9c",
    module_pattern = "aniseed",
  },
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "1c31adb35fcebe921f65e5c6ff6d5481fa5fa5ac",
    module = "plenary",
  },
  ["popup.nvim"] = {
    "nvim-lua/popup.nvim",
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
    module = "popup",
  },
  ["nest.nvim"] = {
    "LuigiPiucco/nest.nvim",
    branch = "integrations-api",
    after = "nvim-mapper",
  },
  ["nvim-mapper"] = {
    "lazytanuki/nvim-mapper",
    before = "telescope.nvim",
  },
}
