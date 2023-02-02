local treesitter = {}

treesitter.settings = {
  --- Checks if the user is using clang and tells them to use GCC if they are.
  --- @type boolean
  show_compiler_warning_message = true,

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
    commit = {
      ["nvim-0.7"] = "d76b0de6536c2461f97cfeca0550f8cb89793935",
      ["latest"] = "82767f3f33c903e92f059dc9a2b27ec38dcc28d7",
    },
    run = ":TSUpdate",
    branch = "master",
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "fdefe46c6807441460f11f11a167a2baf8e4534b",
    after = "nvim-treesitter",
  },
}

treesitter.configs = {}
treesitter.configs["nvim-treesitter"] = function()
  local is_module_enabled = require("doom.utils").is_module_enabled
  require("nvim-treesitter.configs").setup(
    vim.tbl_deep_extend("force", doom.core.treesitter.settings.treesitter, {
      autopairs = {
        enable = is_module_enabled("features", "autopairs"),
      },
    })
  )

  --  Check if user is using clang and notify that it has poor compatibility with treesitter
  --  WARN: 19/11/2021 | issues: #222, #246 clang compatibility could improve in future
  if doom.core.treesitter.settings.show_compiler_warning_message then
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
          "doom-treesitter:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc, see issue #246 for details.  (https://github.com/doom-neovim/doom-nvim/issues/246)\n"
            .. "Add this line to your config.lua to hide this message.\n\n"
            .. "doom.core.treesitter.settings.show_compiler_warning_message = false"
        )
      end
    end, 1000)
  end
end

return treesitter
