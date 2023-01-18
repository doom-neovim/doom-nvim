local required = {}

required.settings = {
  mapper = {},
}

required.packages = {
  ["lazy.nvim"] = {
    "folke/lazy.nvim",
  },
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "1c7e3e6b0f4dd5a174fcea9fda8a4d7de593b826",
  },
  ["nvim-web-devicons"] = {
    "kyazdani42/nvim-web-devicons",
    commit = "a8cf88cbdb5c58e2b658e179c4b2aa997479b3da",
  },
}

required.configs = {}

required.binds = function()
  local binds = {
    { "ZZ", require("doom.core.functions").quit_doom, name = "Fast exit" },
    { "<ESC>", ":noh<CR>", name = "Remove search highlight" },
    { "<Tab>", ":bnext<CR>", name = "Jump to next buffer" },
    { "<S-Tab>", ":bprevious<CR>", name = "Jump to prev buffer" },
    {
      "<C-",
      {
        { "h>", "<C-w>h", name = "Jump window left" },
        { "j>", "<C-w>j", name = "Jump window down" },
        { "k>", "<C-w>k", name = "Jump window up" },
        { "l>", "<C-w>l", name = "Jump window right" },
        {
          mode = "nv",
          {
            { "Left>", ":vertical resize -2<CR>", name = "Resize window left" },
            { "Down>", ":resize -2<CR>", name = "Resize window down" },
            { "Up>", ":resize +2<CR>", name = "Resize window up" },
            { "Right>", ":vertical resize +2<CR>", name = "Resize window right" },
          },
        },
      },
    },
    {
      "<a-",
      {
        { "j>", ":m .+1<CR>==", name = "Move line down" },
        { "k>", ":m .-2<CR>==", name = "Move line up" },
      },
    },
    {
      mode = "v",
      {
        {
          "<a-",
          {
            { "j>", ":m '<+1<CR>gv=gv", name = "Move line down", mode = "v" },
            { "k>", ":m '<-2<CR>gv=gv", name = "Move line up", mode = "v" },
          },
        },
        { ">", ">gv", mode = "v" }, -- Stay in visual after indent.
        { "<", "<gv", mode = "v" }, -- Stay in visual after indent.
      },
    },
    {
      mode = "i",
      {
        {
          "<a-",
          {
            { "j>", "<ESC>:m '<+1<CR>==gi", name = "Move line down", mode = "i" },
            { "k>", "<ESC>:m '<-2<CR>==gi", name = "Move line up", mode = "i" },
          },
        },
      },
    },
    { mode = "t", {
      { "<Esc>", "<C-\\><C-n>", name = "Exit insert in terminal" },
    } },
  }

  -- Conditionally disable macros
  if doom.disable_macros then
    table.insert(binds, { "q", "<Nop>" })
  end
  -- Conditionally disable ex mode
  if doom.disable_ex then
    table.insert(binds, { "Q", "<Nop>" })
  end
  -- Conditionally disable suspension
  if doom.disable_suspension then
    table.insert(binds, { "<C-z>", "<Nop>" })
  end

  -- Exit insert mode fast
  for _, esc_seq in pairs(doom.escape_sequences) do
    table.insert(binds, { esc_seq, "<ESC>", mode = "i" })
  end

  local split_modes = {
    vertical = "vert ",
    horizontal = "",
    [false] = "e",
  }
  local split_prefix = split_modes[doom.new_file_split]
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      { "m", "<cmd>w<CR>", name = "Write" },
      {
        "b",
        name = "+buffer",
        {
          { "b", "<cmd>e #<CR>", name = "Jump to recent" },
          { "d", "<cmd>bd<CR>", name = "Delete" },
        },
      },
      {
        "D",
        name = "+doom",
        {
          {
            "c",
            ("<cmd>e %s<CR>"):format(require("doom.core.config").source),
            name = "Edit config",
          },
          {
            "m",
            ("<cmd>e %s<CR>"):format(require("doom.core.modules").source),
            name = "Edit modules",
          },
          {
            "d",
            require("doom.core.functions").open_docs,
            name = "Open documentation",
          },
          { "l", "<cmd>DoomReload<CR>", name = "Reload config" },
          { "r", "<cmd>DoomRollback<CR>", name = "Rollback" },
          { "R", "<cmd>DoomReport<CR>", name = "Report issue" },
          { "u", "<cmd>DoomUpdate<CR>", name = "Update" },
          { "s", "<cmd>Lazy sync<CR>", name = "Sync packages" },
          { "I", "<cmd>Lazy install<CR>", name = "Install packages" },
          { "C", "<cmd>Lazy clean<CR>", name = "Clean packages" },
          -- { "b", "<cmd>Lazy build<CR>", name = "Build packages" },
          { "p", "<cmd>Lazy profile<CR>", name = "Profile" },
        },
      },
      {
        "f",
        name = "+file",
        {
          { "n", (":%snew<CR>"):format(split_prefix), name = "Create new" },
          { "w", "<cmd>w<CR>", name = "Write" },
          {
            "W",
            function()
              vim.fn.inputsave()
              local new_name = vim.fn.input("New name: ")
              vim.fn.inputrestore()
              vim.cmd("w " .. new_name)
            end,
            name = "Write as",
          },
          { "s", "<cmd>w<CR>", name = "Save" },
          {
            "S",
            function()
              vim.fn.inputsave()
              local new_name = vim.fn.input("New name: ")
              vim.fn.inputrestore()
              vim.cmd("w " .. new_name)
            end,
            name = "Save as",
          },
        },
      },
      {
        "h",
        name = "+help",
        {
          { "h", "<cmd>Man<CR>", name = "Manual pages", options = { silent = false } },
          { "D", "<cmd>DoomManual<CR>", name = "Open Doom" },
        },
      },
      {
        "j",
        name = "+jump",
        {
          { "a", "<C-^>", name = "Alternate file" },
          { "j", "<C-o>", name = "Older file" },
          { "k", "<C-i>", name = "Newer file" },
          { "p", "<cmd>tag<CR>", name = "Push tag" },
          { "P", "<cmd>pop<CR>", name = "Pop tag" },
        },
      },
      {
        "q",
        name = "+quit",
        {
          { "q", require("doom.core.functions").quit_doom, name = "Exit and save" },
          { "w", require("doom.core.functions").quit_doom, name = "Exit and save" },
          {
            "d",
            function()
              require("doom.core.functions").quit_doom(true, true)
            end,
            name = "Exit and discard",
          },
        },
      },
      {
        "t",
        name = "+tweak",
        {
          { "b", require("doom.core.functions").toggle_background, name = "Toggle background" },
          { "s", require("doom.core.functions").toggle_signcolumn, name = "Toggle sigcolumn" },
          { "i", require("doom.core.functions").set_indent, name = "Set indent" },
          { "n", require("doom.core.functions").change_number, name = "Toggle number" },
          { "S", require("doom.core.functions").toggle_spell, name = "Toggle spelling" },
          { "x", require("doom.core.functions").change_syntax, name = "Toggle syntax" },
        },
      },
      {
        "w",
        name = "+window",
        {
          { "w", "<C-w>p", name = "Jump to recent" },
          { "d", "<C-w>c", name = "Delete window" },
          { "-", "<C-w>s", name = "Split up/down" },
          { "|", "<C-w>v", name = "Split left/right" },
          { "s", "<C-w>s", name = "Split up/down" },
          { "v", "<C-w>v", name = "Split left/right" },
          { "h", "<C-w>h", name = "Jump left" },
          { "j", "<C-w>j", name = "Jump down" },
          { "k", "<C-w>k", name = "Jump up" },
          { "l", "<C-w>l", name = "Jump right" },
          { "H", "<C-w>H", name = "Move left" },
          { "J", "<C-w>J", name = "Move down" },
          { "K", "<C-w>K", name = "Move up" },
          { "L", "<C-w>L", name = "Move right" },
          { "=", "<C-w>=", name = "Move right" },
          {
            "<C-",
            {
              { "H>", "<C-w>5<", name = "Expand left" },
              { "J>", "<cmd>resize +5<CR>", name = "Expand down" },
              { "K>", "<cmd>resize -5<CR>", name = "Expand up" },
              { "L>", "<C-w>L", name = "Expand right" },
            },
          },
        },
      },
    },
  })

  return binds
end

required.autocmds = function()
  local autocmds = {}

  if doom.autosave then
    table.insert(autocmds, { "TextChanged,InsertLeave", "<buffer>", "silent! write" })
  end

  if doom.highlight_yank then
    table.insert(autocmds, {
      "TextYankPost",
      "*",
      function()
        require("vim.highlight").on_yank({ higroup = "Search", timeout = 200 })
      end,
    })
  end

  if doom.preserve_edit_pos then
    table.insert(autocmds, {
      "BufReadPost",
      "*",
      [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
    })
  end
  return autocmds
end

required.cmds = {
  { "DoomProfile", function(opts)
    local show_async = string.find(opts.args, "async") ~= nil
    require("doom.services.profiler").log({
      show_async = show_async,
    })
  end, { nargs = "*" } }
}

return required
