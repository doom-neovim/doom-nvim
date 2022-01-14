local telescope = {}

telescope.defaults = {
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
    selection_caret = " ",
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

telescope.packer_config = {}
telescope.packer_config["telescope.nvim"] = function()
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
          ["<Leader>f"] = actions.close, -- works like a toggle, sometimes can be buggy
          ["<CR>"] = actions.select_default + actions.center,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        },
      },
    },
  }, doom.telescope))

  for _, ext in ipairs(doom.telescope.extensions) do
    telescope_package.load_extension(ext)
  end
end

return telescope
