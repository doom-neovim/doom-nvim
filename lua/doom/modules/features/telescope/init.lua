local telescope = {}

telescope.settings = {
  defaults = {
    find_command = {
      "rg",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    prompt_prefix = "   ",
    layout_config = {
      width = 0.75,
      preview_cutoff = 120,
      prompt_position = "bottom",
      vertical = { mirror = false },
      horizontal = {
        mirror = false,
        preview_width = 0.6,
      },
    },
    file_ignore_patterns = { "^%.git/", "^node_modules/", "^__pycache__/" },
    winblend = 0,
    scroll_strategy = "cycle",
    border = {},
    borderchars = {
      "─",
      "│",
      "─",
      "│",
      "╭",
      "╮",
      "╯",
      "╰",
    },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
  },
  extensions = { "mapper" },
}

telescope.packages = {
  ["telescope.nvim"] = {
    "nvim-telescope/telescope.nvim",
    commit = "d793de0f12d874c463e81edabee741b802c1a37a",
    cmd = "Telescope",
    opt = true,
  },
  ["telescope-file-browser.nvim"] = {
    "nvim-telescope/telescope-file-browser.nvim",
    commit = "4272c52078cc457dfaabce6fa3545e7495651d04",
    cmd = "Telescope browse_files",
    key = "<leader>.",
    after = "telescope.nvim",
    opt = true,
  },
}

telescope.configs = {}
telescope.configs["telescope.nvim"] = function()
  local telescope_package = require("telescope")
  local actions = require("telescope.actions")

  telescope_package.setup(vim.tbl_deep_extend("force", {
    defaults = {
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<CR>"] = actions.select_default + actions.center,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        },
      },
    },
  }, doom.features.telescope.settings))

  for _, ext in ipairs(doom.features.telescope.settings.extensions) do
    telescope_package.load_extension(ext)
  end
end

telescope.configs["telescope-file-browser.nvim"] = function()
  require("telescope").load_extension("file_browser")
end

telescope.binds = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

  local binds = {
    "<leader>",
    name = "+prefix",
    {
      {
        "`",
        function()
          vim.cmd(("Telescope find_files cwd=%s"):format(vim.fn.getcwd()))
        end,
        name = "Browse cwd",
      },
      { ".", "<cmd>Telescope file_browser<CR>", name = "Browse project" },
      { ",", "<cmd>Telescope buffers<CR>", name = "Search buffers" },
      { "/", "<cmd>Telescope live_grep<CR>", name = "Search text" },
      { ":", "<cmd>Telescope command_history<CR>", name = "Search recent commands" },
      {
        "b",
        name = "+buffer",
        {
          { "f", "<cmd>Telescope buffers show_all_buffers=true<CR>", name = "Find from all" },
          { "s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", name = "Search text" },
        },
      },
      {
        "f",
        name = "+file",
        {
          { "f", "<cmd>Telescope find_files<CR>", name = "Find in project" },
          { "r", "<cmd>Telescope oldfiles<CR>", name = "Find recent" },
        },
      },
      {
        "h",
        name = "+help",
        {
          { "t", "<cmd>Telescope help_tags<CR>", name = "Find tags" },
          { "k", "<cmd>Telescope mapper<CR>", name = "Open keybindings" },
        },
      },
      {
        "g",
        name = "+git",
        {
          { "s", "<cmd>Telescope git_status<CR>", name = "Status" },
          { "b", "<cmd>Telescope git_branches<CR>", name = "Branches" },
          { "c", "<cmd>Telescope git_commits<CR>", name = "Commits" },
        },
      },
      {
        "s",
        name = "+search",
        {
          { "r", "<cmd>Telescope resume<CR>", name = "Resume previous search" },
          { "t", "<cmd>Telescope live_grep<CR>", name = "Search text" },
          { "b", "<cmd>Telescope current_buffer_fuzzy_find<CR>", name = "Text in buffer" },
          { "h", "<cmd>Telescope command_history<CR>", name = "Recent commands" },
          { "m", "<cmd>Telescope marks<CR>", name = "Marks" },
        },
      },
      {
        "t",
        name = "+tweak",
        {
          {
            "C",
            "<cmd>Telescope colorscheme enable_preview=true<CR>",
            name = "Switch colorscheme",
          },
        },
      },
    },
  }
  if is_module_enabled("features", "lsp") then
    table.insert(binds, {
      "<leader>",
      name = "+prefix",
      {
        {
          "c",
          name = "+code",
          {
            { "s", "<cmd>Telescope lsp_document_symbols<CR>", name = "Lsp symbols" },
          },
        },
      },
    })
  end
  return binds
end

telescope.autocmds = {
  { "User", "TelescopePreviewerLoaded", "setlocal wrap" },
}

return telescope
