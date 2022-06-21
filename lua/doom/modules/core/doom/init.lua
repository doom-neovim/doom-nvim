local required = {}

required.settings = {
  mapper = {},
}

required.packages = {
  ["packer.nvim"] = {
    "wbthomason/packer.nvim",
  },
  -- Required by some treesitter modules
  ["aniseed"] = {
    "Olical/aniseed",
    commit = "bfaefa11c9e6b36b17a7fe11f8f005198411c3e5",
    module_pattern = "aniseed",
  },
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "9c3239bc5f99b85be1123107f7290d16a68f8e64",
    module = "plenary",
  },
  ["popup.nvim"] = {
    "nvim-lua/popup.nvim",
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
    module = "popup",
  },
  ["nvim-web-devicons"] = {
    "kyazdani42/nvim-web-devicons",
    commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e",
    module = "nvim-web-devicons",
  },
  -- Must include impatient.nvim here, even though it's bootstrapped in
  -- core.modules.lua so that packer doesn't try and clean it up.
  ["impatient.nvim"] = {
    "lewis6991/impatient.nvim",
    disabled = not doom.settings.impatient_enabled,
  },
}

required.configs = {}

required.binds = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

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
  if doom.settings.disable_macros then
    table.insert(binds, { "q", "<Nop>" })
  end
  -- Conditionally disable ex mode
  if doom.settings.disable_ex then
    table.insert(binds, { "Q", "<Nop>" })
  end
  -- Conditionally disable suspension
  if doom.settings.disable_suspension then
    table.insert(binds, { "<C-z>", "<Nop>" })
  end

  -- Exit insert mode fast
  for _, esc_seq in pairs(doom.settings.escape_sequences) do
    table.insert(binds, { esc_seq, "<ESC>", mode = "i" })
  end

  if is_module_enabled("explorer") then
    table.insert(binds, { "<F3>", ":Lexplore%s<CR>", name = "Toggle explorer" })
    table.insert(binds, {
      "<leader>",
      name = "+prefix",
      {
        {
          "o",
          name = "+open/close",
          {
            { "e", ":Lexplore%s<CR>", name = "Explorer" },
          },
        },
      },
    })
  end

  local split_modes = {
    vertical = "vert ",
    horizontal = "",
    [false] = "e",
  }
  local split_prefix = split_modes[doom.settings.new_file_split]
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
          { "l", "<cmd>DoomReload<CR>", name = "Reload config" },
          { "r", "<cmd>DoomRollback<CR>", name = "Rollback" },
          { "R", "<cmd>DoomReport<CR>", name = "Report issue" },
          { "u", "<cmd>DoomUpdate<CR>", name = "Update" },
          { "s", "<cmd>PackerSync<CR>", name = "Sync packages" },
          { "I", "<cmd>PackerInstall<CR>", name = "Install packages" },
          { "C", "<cmd>PackerClean<CR>", name = "Clean packages" },
          { "b", "<cmd>PackerCompile<CR>", name = "Build packages" },
          { "S", "<cmd>PackerStatus<CR>", name = "Inform packages" },
          { "p", "<cmd>PackerProfile<CR>", name = "Profile" },
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
        "g",
        name = "+git",
        {
          { "p", [[<cmd>TermExec cmd="git pull"<CR>]], name = "Pull" },
          { "P", [[<cmd>TermExec cmd="git push"<CR>]], name = "Push" },
          {
            "C",
            name = "+commit",
            {
              { "c", [[<cmd>TermExec cmd="git commit"<CR>]], name = "commit" },
              { "a", [[<cmd>TermExec cmd="git commit --ammend"<CR>]], name = "ammend" },
            },
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

  if doom.settings.autosave then
    table.insert(autocmds, { "TextChanged,InsertLeave", "<buffer>", "silent! write" })
  end

  if doom.settings.highlight_yank then
    table.insert(autocmds, {
      "TextYankPost",
      "*",
      function()
        require("vim.highlight").on_yank({ higroup = "Search", timeout = 200 })
      end,
    })
  end

  if doom.settings.preserve_edit_pos then
    table.insert(autocmds, {
      "BufReadPost",
      "*",
      [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
    })
  end
  return autocmds
end

return required
