local explorer = {}

explorer.settings = {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = true,
  hijack_cursor = true,
  update_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  view = {
    width = 35,
    side = "left",
    mappings = {
      custom_only = false,
    },
  },
  filters = {
    custom = { "^\\.git", "node_modules.editor", "^\\.cache", "__pycache__" },
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    highlight_git = true,
    root_folder_modifier = ":~",
    add_trailing = true,
    group_empty = true,
    special_files = {
      "README.md",
      "Makefile",
      "MAKEFILE",
    },
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "",
          untracked = "",
          deleted = "",
          ignored = "◌",
        },
      },
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  actions = {
    open_file = {
      resize_window = true, -- previously view.auto_resize
      window_picker = {
        exclude = {
          filetype = {
            "notify",
            "packer",
            "qf",
          },
          buftype = {
            "terminal",
          },
        },
      },
    },
  },
  diagnostics = {
    enable = false,
  },
}

explorer.packages = {
  ["nvim-tree.lua"] = {
    "nvim-tree/nvim-tree.lua",
    commit = "3ce0a8e770f70a135ef969e0a640bd8d05baf42c",
    cmd = {
      "NvimTreeClipboard",
      "NvimTreeClose",
      "NvimTreeFindFile",
      "NvimTreeOpen",
      "NvimTreeRefresh",
      "NvimTreeToggle",
    },
  },
}

explorer.configs = {}
explorer.configs["nvim-tree.lua"] = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

  local tree_cb = require("nvim-tree.config").nvim_tree_callback

  local override_table = {}
  if is_module_enabled("features", "lsp") then
    override_table = {
      diagnostics = {
        enable = true,
        icons = {
          hint = doom.features.lsp.settings.icons.hint,
          info = doom.features.lsp.settings.icons.info,
          warning = doom.features.lsp.settings.icons.warn,
          error = doom.features.lsp.settings.icons.error,
        },
      },
    }
  end
  local config = vim.tbl_deep_extend("force", {
    view = {
      mappings = {
        list = {
          { key = { "o", "<2-LeftMouse>" }, cb = tree_cb("edit") },
          { key = { "<CR>", "<2-RightMouse>", "<C-]>" }, cb = tree_cb("cd") },
          { key = "<C-v>", cb = tree_cb("vsplit") },
          { key = "<C-x>", cb = tree_cb("split") },
          { key = "<C-t>", cb = tree_cb("tabnew") },
          { key = "<BS>", cb = tree_cb("close_node") },
          { key = "<S-CR>", cb = tree_cb("close_node") },
          { key = "<Tab>", cb = tree_cb("preview") },
          { key = "I", cb = tree_cb("toggle_ignored") },
          { key = "H", cb = tree_cb("toggle_dotfiles") },
          { key = "R", cb = tree_cb("refresh") },
          { key = "a", cb = tree_cb("create") },
          { key = "d", cb = tree_cb("remove") },
          { key = "r", cb = tree_cb("rename") },
          { key = "<C-r>", cb = tree_cb("full_rename") },
          { key = "x", cb = tree_cb("cut") },
          { key = "c", cb = tree_cb("copy") },
          { key = "p", cb = tree_cb("paste") },
          { key = "[c", cb = tree_cb("prev_git_item") },
          { key = "]c", cb = tree_cb("next_git_item") },
          { key = "-", cb = tree_cb("dir_up") },
          { key = "q", cb = tree_cb("close") },
          { key = "g?", cb = tree_cb("toggle_help") },
        },
      },
    },
    filters = {
      dotfiles = not doom.settings.show_hidden,
    },
    git = {
      ignore = doom.settings.hide_gitignore,
    },
  }, doom.features.explorer.settings, override_table)
  require("nvim-tree").setup(config)
end

explorer.binds = {
  { "<F3>", ":NvimTreeToggle<CR>", name = "Toggle file explorer" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "e", "<cmd>NvimTreeToggle<CR>", name = "Explorer" },
        },
      },
    },
  },
}

explorer.autocmds = {
  {
    "BufEnter",
    "*",
    function()
      local name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      if vim.fn.isdirectory(name) == 1 then
        require("nvim-tree.api").tree.change_root(name)
      end
    end,
  },
}

return explorer
