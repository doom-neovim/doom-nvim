local explorer = {}

explorer.settings = {
  refresh_wait = true,
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  auto_close = false,
  open_on_tab = true,
  hijack_cursor = true,
  update_cwd = true,
  respect_buf_cwd = true,
  special_files = {
    "README.md",
    "Makefile",
    "MAKEFILE",
  },
  window_picker_exclude = {
    filetype = {
      "notify",
      "packer",
      "qf",
    },
    buftype = {
      "terminal",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  view = {
    width = 35,
    side = "left",
    auto_resize = true,
    mappings = {
      custom_only = false,
    },
  },
  indent_markers = true,
  git_highlight = true,
  traling_dir_slash = true,
  group_empty = true,
  show_icons = {
    git = true,
    folders = true,
    files = true,
    folder_arrows = true,
  },
  icons = {
    default = "",
    symlink = "",
    git = {
      unstaged = "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = "",
      ignored = "◌",
    },
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
  },
}

explorer.uses = {
  ["nvim-tree.lua"] = {
    "kyazdani42/nvim-tree.lua",
    commit = "9b03ab40e843e251f01bccec2eca5ea9dcdebc0d",
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

  vim.g.nvim_tree_ignore = { ".git", "node_modules.editor", ".cache", "__pycache__" }

  vim.g.nvim_tree_indent_markers = utils.bool2num(doom.modules.explorer.settings.indent_markers)

  vim.g.nvim_tree_respect_buf_cwd = utils.bool2num(doom.modules.explorer.settings.respect_buf_cwd)

  vim.g.nvim_tree_hide_dotfiles = utils.bool2num(not doom.show_hidden)

  vim.g.nvim_tree_git_hl = utils.bool2num(doom.modules.explorer.settings.git_highlight)

  vim.g.nvim_tree_gitignore = utils.bool2num(doom.hide_gitignore)

  vim.g.nvim_tree_root_folder_modifier = ":~"

  vim.g.nvim_tree_add_trailing = utils.bool2num(doom.modules.explorer.settings.trailing_dir_slash)

  vim.g.nvim_tree_group_empty = utils.bool2num(doom.modules.explorer.settings.group_empty)

  vim.g.nvim_tree_refresh_wait = utils.bool2num(doom.modules.explorer.settings.refresh_wait)

  vim.g.nvim_tree_window_picker_exclude = doom.modules.explorer.settings.window_picker_exclude

  local special_files = {}
  for _, file in ipairs(doom.modules.explorer.settings.special_files) do
    special_files[file] = 1
  end
  vim.g.nvim_tree_special_files = special_files

  local show_icons = {}
  for key, value in pairs(doom.modules.explorer.settings.show_icons) do
    show_icons[key] = utils.bool2num(value)
  end
  vim.g.nvim_tree_show_icons = show_icons

  local override_icons = {}
  if is_module_enabled("lsp") then
    override_icons = {
      lsp = {
        hint = doom.modules.lsp.settings.icons.hint,
        info = doom.modules.lsp.settings.icons.info,
        warning = doom.modules.lsp.settings.icons.warn,
        error = doom.modules.lsp.settings.icons.error,
      },
    }
  end
  vim.g.nvim_tree_icons = vim.tbl_deep_extend("force", doom.modules.explorer.settings.icons, override_icons)

  local override_table = {
    diagnostics = {
      enable = false,
    },
  }
  if is_module_enabled("lsp") then
    override_table = {
      diagnostics = {
        enable = true,
        icons = {
          hint = doom.modules.lsp.settings.icons.hint,
          info = doom.modules.lsp.settings.icons.info,
          warning = doom.modules.lsp.settings.icons.warn,
          error = doom.modules.lsp.settings.icons.error,
        },
      },
    }
  end
  require("nvim-tree").setup(vim.tbl_deep_extend("force", {
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
  }, doom.modules.explorer.settings, override_table))
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
  }
}

return explorer
