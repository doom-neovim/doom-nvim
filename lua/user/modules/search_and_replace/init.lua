local search_and_replace = {}

search_and_replace.packages = {
  ["nvim-search-and-replace"] = { "s1n7ax/nvim-search-and-replace" },
  ["nvim-spectre"] = { "nvim-pack/nvim-spectre" },
  -- ["sad.nvim"] = {"ray-x/sad.nvim"}, -- TODO: this one next
  -- https://github.com/brooth/far.vim
}

search_and_replace.configs = {}

search_and_replace.configs["nvim-search-and-replace"] = function()
  require("nvim-search-and-replace").setup(
    -- {
    -- -- file patters to ignore
    -- ignore = {'**/node_modules/**', '**/.git/**',  '**/.gitignore', '**/.gitmodules','build/**'},
    --
    -- -- save the changes after replace
    -- update_changes = false,
    --
    -- -- keymap for search and replace
    -- replace_keymap = '<leader>gr',
    --
    -- -- keymap for search and replace ( this does not care about ignored files )
    -- replace_all_keymap = '<leader>gR',
    --
    -- -- keymap for search and replace
    -- replace_and_save_keymap = '<leader>gu',
    --
    -- -- keymap for search and replace ( this does not care about ignored files )
    -- replace_all_and_save_keymap = '<leader>gU',
    --}
  )
end

-- get v sel
--  https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
-- THESE TWO HAVE THE BEST SUGGESTIONS
-- https://jdhao.github.io/2020/03/14/nvim_search_replace_multiple_file/
-- https://phelipetls.github.io/posts/extending-vim-with-ripgrep/

-- https://www.freecodecamp.org/news/how-to-search-and-replace-across-multiple-files-in-vim/
-- https://stackoverflow.com/questions/37424689/search-and-replace-in-multiple-files-using-vim
-- https://irian.to/blogs/how-to-search-and-replace-string-across-multiple-files-in-vim/
-- https://vim.fandom.com/wiki/Search_and_replace_in_multiple_buffers
-- https://www.reddit.com/r/vim/comments/n8x2xr/til_find_and_replace_multiple_files_with_and/
-- https://github.com/brooth/far.vim

search_and_replace.binds = {
  {
    "gz",
    "viw:lua require('spectre').open_file_search()<cr>",
    name = "spectre n",
    options = { silent = false },
  },
  {
    "gz",
    "<cmd>lua require('spectre').open_visual()<CR>",
    name = "spectre visual",
    mode = "v",
    options = { silent = false },
  },
}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(search_and_replace.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "s",
        name = "+search",
        {
          { "g", [[<cmd>Telescope repo cached_list<CR>]], name = "repos cached" },
          { "G", [[<cmd>Telescope repo list<CR>]], name = "repos build" },
          { "f", [[/\v\c]], name = "text case", options = { silent = false } },
          {
            "s",
            name = "+replace",
            {
              { "z", ":SReplace ", name = "s1n7ax SnR", options = { silent = false } },
              {
                "p",
                "<cmd>lua require('spectre').open()<CR>",
                name = "spectre open",
                options = { silent = false },
              },
              {
                "P",
                "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
                name = "spectre word",
                options = { silent = false },
              },
              { "l", ":s//g<Left><Left>", name = "line", options = { silent = false } },
              { "l", ":s//g<Left><Left>", name = "line", options = { silent = false } },
              {
                "L",
                '"zyiw:s/<c-r>z//g<Left><Left>',
                name = "line iw",
                options = { silent = false },
              },
              {
                "o",
                '"zyiW:s/<c-r>z//g<Left><Left>',
                name = "line iW",
                options = { silent = false },
              },
              {
                "O",
                '"zyiw:s/\\<<c-r>z\\>//g<Left><Left>',
                name = "line iw solo",
                options = { silent = false },
              },
              { "a", ":%s//g<Left><Left>", name = "file", options = { silent = false } },
              {
                "w",
                '"zyiw:%s/<c-r>z//g<Left><Left>',
                name = "word",
                options = { silent = false },
              },
              --
              -- {
              --    "n",
              --    "<leader>rfs",
              --    "\"zyiw:%s/\\<<c-r>z\\>//g<Left><Left>",
              --    { silent = false },
              --    "Replace Inner (w)ord Solo",
              --    "replace_inner_word_solo",
              --    "Replace (w)ord Solo"
              -- },
              -- {
              --    "n",
              --    "<leader>rfW",
              --    "\"zyiW:%s/<c-r>z//g<Left><Left>",
              --    { silent = false },
              --    "Replace Inner (W)ord",
              --    "replace_inner_word_big",
              --    "Replace (W)ord"
              -- },
            },
          }, -- search > replace
          -- {
          --   "R",
          --   name = "+grep/cdo",
          --   {
          -- -- ripgrep search empty
          -- {
          --    "n",
          --    "<leader>rg",
          --    ":grep ",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },
          -- -- ripgrep search word
          -- {
          --    "n",
          --    "<leader>rw",
          --    "\"zyiw:grep <c-r>z",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },
          -- -- ripgrep search WORD
          -- {
          --    "n",
          --    "<leader>rW",
          --    "\"zyiW:grep <c-r>z",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },

          -- -- TODO: add vimgrep variants
          -- -- vimgrep search empty
          -- {
          --    "n",
          --    "<leader>rg",
          --    ":grep ",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },
          -- -- vimgrep search word
          -- {
          --    "n",
          --    "<leader>rw",
          --    "\"zyiw:grep <c-r>z",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },
          -- -- vimgrep search WORD
          -- {
          --    "n",
          --    "<leader>rW",
          --    "\"zyiW:grep <c-r>z",
          --    { silent = false },
          --    "Ripgrep Search Empty",
          --    "ripgrep_search_empty",
          --    "Ripgrep Search Empty"
          -- },
          -- -- vimgrep search word solo
          -- -- vimgrep search WORD solo
          -- -- :cdo empty
          -- {
          --    "n",
          --    "<leader>rce",
          --    ":cdo s//gc<Left><Left><Left>",
          --    { silent = false },
          --    "Quickfix cdo Empty",
          --    "quickfix_cdo_empty",
          --    "Quickfix cdo Empty"
          -- },
          -- -- :cdo replace word
          -- {
          --    "n",
          --    "<leader>rcw",
          --    "\"zyiw:cdo s/<c-r>z//gc<Left><Left><Left>",
          --    { silent = false },
          --    "Quickfix cdo (w)ord",
          --    "quickfix_cdo_word_small",
          --    "Quickfix cdo (w)ord",
          -- },
          -- -- :cdo replace WORD
          -- {
          --    "n",
          --    "<leader>rcW",
          --    "\"zyiW:cdo s/<c-r>z//gc<Left><Left><Left>",
          --    { silent = false },
          --    "Quickfix cdo (W)ord",
          --    "quickfix_cdo_word_big",
          --    "Quickfix cdo (W)ord",
          -- },
          -- -- :cdo solo word
          -- {
          --    "n",
          --    "<leader>rcs",
          --    "\"zyiw:cdo s/\\<<c-r>z\\>//gc<Left><Left><Left>",
          --    { silent = false },
          --    "Quickfix cdo solo (w)ord",
          --    "quickfix_cdo_solo_word_small",
          --    "Quickfix cdo solo(w)ord",
          -- },
          -- -- :cdo solo WORD
          -- {
          --    "n",
          --    "<leader>rcS",
          --    "\"zyiW:cdo s/\\<<c-r>z\\>//gc<Left><Left><Left>",
          --    { silent = false },
          --    "Quickfix cdo solo (W)ord",
          --    "quickfix_cdo_solo_word_big",
          --    "Quickfix cdo solo (W)ord",
          -- },
          -- },
          -- },
        },
      }, -- search
    }, -- leader
  })
end

return search_and_replace
