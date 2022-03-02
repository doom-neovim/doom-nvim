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
    commit = "82389e52b6b50f712593079255ee088f1631b9cd",
    run = ":TSUpdate",
    branch = "master",
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "097df33c9ef5bbd3828105e4bee99965b758dc3f",
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "887fcd9e45ff112c4f39d2a8ba2594d04b99752a",
    after = "nvim-treesitter",
  },
}

treesitter.configure_functions = {}
treesitter.configure_functions["nvim-treesitter"] = function()
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled
  require("nvim-treesitter.configs").setup(vim.tbl_deep_extend("force", doom.modules.treesitter.settings.treesitter, {
    autopairs = {
      enable = not is_plugin_disabled("autopairs"),
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
