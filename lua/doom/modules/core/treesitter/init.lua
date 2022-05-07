local treesitter = {}

treesitter.settings = {
  treesitter = {
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
      enable = true,
    },
    playground = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
        "vue",
        "markdown",
      },
    },
  },
}

treesitter.packages = {
  ["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    commit = "3e2ac54e1638da214dab58f9edf01ad93f57261d",
    run = ":TSUpdate",
    branch = "master",
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "7810f1fe706092290dd338f40e5e857bac4a03cf",
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "57035b5814f343bc6110676c9ae2eacfcd5340c2",
    after = "nvim-treesitter",
  },
}

treesitter.configs = {}
treesitter.configs["nvim-treesitter"] = function()
  local is_module_enabled = require("doom.utils").is_module_enabled
  require("nvim-treesitter.configs").setup(vim.tbl_deep_extend("force", doom.core.treesitter.settings.treesitter, {
    autopairs = {
      enable = is_module_enabled("autopairs"),
    },
  }))

  --  Check if user is using clang and notify that it has poor compatibility with treesitter
  --  WARN: 19/11/2021 | issues: #222, #246 clang compatibility could improve in future
  vim.defer_fn(function()
    local log = require("doom.utils.logging")
    local utils = require("doom.utils")
    -- Matches logic from nvim-treesitter
    local compiler = utils.find_executable_in_path({
      vim.fn.getenv("CC"),
      "cc",
      "gcc",
      "clang",
      "cl",
      "zig",
    })
    local version = vim.fn.systemlist(compiler .. (compiler == "cl" and "" or " --version"))[1]

    if version:match("clang") then
      log.warn(
        "doom-treesitter:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc, see issue #246 for details.  (https://github.com/NTBBloodbath/doom-nvim/issues/246)"
      )
    end
  end, 1000)
end

return treesitter
