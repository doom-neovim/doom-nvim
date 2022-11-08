local DoomModule = require("doom.modules").DoomModule

---@toc doom.features.zen
---@text # Zen
---
--- Code with tranquility and enter zen mode.
---

local zen = DoomModule.new("zen")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.zen")
zen.settings = {
  window = {
    backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    -- * a function that returns the width or the height
    width = 120, -- width of the Zen window
    height = 1, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      -- signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
    gitsigns = { enabled = false }, -- disables git signs
    tmux = { enabled = false }, -- disables the tmux statusline
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = false,
      font = "+4", -- font size increment
    },
  },
  -- callback where you can add custom code when the Zen window opens
  on_open = function(_) end,
  -- callback where you can add custom code when the Zen window closes
  on_close = function() end,
}
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.zen")
zen.packages = {
  ["zen-mode.nvim"] = {
    "folke/zen-mode.nvim",
    commit = "6f5702db4fd4a4c9a212f8de3b7b982f3d93b03c",
    cmd = { "ZenMode" },
  },
}

zen.configs = {}
zen.configs["zen-mode.nvim"] = function()
  require("zen-mode").setup(doom.features.zen.settings)
end

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.zen")
zen.binds = {
  { "<leader>t", name = "+tweaks", {
    { "z", ":ZenMode<CR>", name = "Toggle Zen" },
  } },
}

return zen
