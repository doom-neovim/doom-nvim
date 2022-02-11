local required = {}

required.defaults = {
  mapper = {},
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
local is_plugin_disabled = require("doom.utils").is_plugin_disabled

required.packages = {
  ["packer.nvim"] = {
    "wbthomason/packer.nvim",
    opt = true,
  },
  ["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    commit = "d91d94aa9f55631855efb46a2b4a459a4a1439",
    run = ":TSUpdate",
    branch = vim.fn.has("nvim-0.6.0") == 1 and "master" or "0.5-compat",
  },
  ["nvim-ts-context-commentstring"] = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "097df33c9ef5bbd3828105e4bee99965b758dc3f",
    opt = true,
    after = "nvim-treesitter",
  },
  ["nvim-ts-autotag"] = {
    "windwp/nvim-ts-autotag",
    commit = "32bc46ee8b21f88f87d97b976ae6674595b311b5",
    opt = true,
    after = "nvim-treesitter",
  },
  -- Required by some treesitter modules
  ["aniseed"] = {
    "Olical/aniseed",
    commit = "7968693e841ea9d2b4809e23e8ec5c561854b6d6",
    module_pattern = "aniseed",
  },
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "563d9f6d083f0514548f2ac4ad1888326d0a1c66",
    module = "plenary",
  },
  ["popup.nvim"] = {
    "nvim-lua/popup.nvim",
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
    module = "popup",
  },
  ["nest.nvim"] = {
    "connorgmeehan/nest.nvim",
    branch = "integrations-api",
    after = "nvim-mapper",
  },
  ["nvim-mapper"] = {
    "lazytanuki/nvim-mapper",
    before = is_plugin_disabled("telescope") or "telescope.nvim",
  },
  ["nvim-web-devicons"] = {
    "kyazdani42/nvim-web-devicons",
    commit = "634e26818f2bea9161b7efa76735746838971824",
    module = "nvim-web-devicons",
  },
  ['nvim-web-devicons'] = {
    'kyazdani42/nvim-web-devicons',
    commit = "8df4988ecf8599fc1f8f387bbf2eae790e4c5ffb",
    module = "nvim-web-devicons",
  }
}

required.configure_functions = {}
required.configure_functions["nest.nvim"] = function()
  local utils = require("doom.utils")
  local is_plugin_disabled = utils.is_plugin_disabled

  local nest_package = require("nest")

  nest_package.enable(require("nest.integrations.mapper"))
  if not is_plugin_disabled("whichkey") then
    local whichkey_integration = require("nest.integrations.whichkey")
    nest_package.enable(whichkey_integration)
  end

  for module_name, module in pairs(_doom.modules) do
    if module.binds then
      nest_package.applyKeymaps(type(module.binds) == 'function' and module.binds() or module.binds)
    end
  end
end
required.configure_functions["nvim-mapper"] = function()
  require("nvim-mapper").setup(doom.core.mapper)
end
required.configure_functions["nvim-treesitter"] = function()
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled
  require("nvim-treesitter.configs").setup(vim.tbl_deep_extend("force", doom.core.treesitter, {
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

required.binds = function ()
  local utils = require("doom.utils")
  local is_plugin_disabled = utils.is_plugin_disabled

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

  if is_plugin_disabled("explorer") then
    table.insert(binds, { "<F3>", ":Lexplore%s<CR>", name = "Toggle explorer" })
    if not is_plugin_disabled("whichkey") then
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
  end

  if not is_plugin_disabled("whichkey") then
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
              ("<cmd>e %s<CR>"):format(require("doom.core.config.modules").source),
              name = "Edit modules",
            },
            { "l", "<cmd>DoomConfigsReload<CR>", name = "Reload config" },
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
  end

  return binds
end

required.autocommands = function ()
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled

  local autocmds = {
    { "BufWritePost", "*/doom/**/*.lua", function() require("doom.utils.reloader").full_reload() end },
    {
      "BufWritePost",
      "*/doom-nvim/modules.lua,*/doom-nvim/config.lua",
      function() require("doom.utils.reloader").full_reload() end,
    },
  }

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
      [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
    })
  end

  if is_plugin_disabled("explorer") then
    table.insert(autocmds, {
      "FileType",
      "netrw",
      require("doom.core.netrw").set_maps,
    })
    table.insert(autocmds, {
      "FileType",
      "netrw",
      require("doom.core.netrw").draw_icons,
    })
    table.insert(autocmds, {
      "TextChanged",
      "*",
      require("doom.core.netrw").draw_icons,
    })
  end

  return autocmds
end

return required
