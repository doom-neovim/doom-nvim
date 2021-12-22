local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "`",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:n") })
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
            function()
              require("telescope.builtin.internal").colorscheme({ enable_preview = true })
            end,
            name = "Switch colorscheme",
          },
        },
      },
    },
  })

  if not is_plugin_disabled("lsp") then
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
end

return binds
