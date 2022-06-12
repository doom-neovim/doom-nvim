local terminal = {}

terminal.settings = {
  size = 10,
  open_mapping = "<F4>",
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  float_opts = {
    border = "curved",
    width = 70,
    height = 20,
    winblend = 0,
    highlights = {
      border = "Special",
      background = "Normal",
    },
  },
}

-- https://github.com/rockerBOO/awesome-neovim#terminal-integration
--
-- https://github.com/zbirenbaum/nvim-chadterm
-- https://github.com/oberblastmeister/termwrapper.nvim
--
--
-- LoricAndre/OneTerm.nvim - Plugin framework for running commands in the terminal.
-- nikvdp/neomux - Control Neovim from shells running inside Neovim.
-- akinsho/nvim-toggleterm.lua - A Neovim Lua plugin to help easily manage multiple terminal windows.
-- norcalli/nvim-terminal.lua - A high performance filetype mode for Neovim which leverages conceal and highlights your buffer with the correct color codes.
-- numToStr/FTerm.nvim - No nonsense floating terminal written in Lua.
-- oberblastmeister/termwrapper.nvim - Wrapper for Neovim's terminal features to make them more user friendly.
-- pianocomposer321/consolation.nvim - A general-purpose terminal wrapper and management plugin for Neovim, written in Lua.
-- jghauser/kitty-runner.nvim - Poor man's REPL. Easily send buffer lines and commands to a kitty terminal.
-- jlesquembre/nterm.nvim - A Neovim plugin to interact with the terminal, with notifications.
-- s1n7ax/nvim-terminal - A simple & easy to use multi-terminal plugin.
terminal.packages = {
  ["toggleterm.nvim"] = {
    "akinsho/toggleterm.nvim",
    commit = "7941edf0732a1be3dce9cee6f564109ce4616224",
    cmd = { "ToggleTerm", "TermExec" },
    opt = true,
  },
}

terminal.configs = {}
terminal.configs["toggleterm.nvim"] = function()
  require("toggleterm").setup(doom.features.terminal.settings)
end

-- local function toggle_term_custom()
--   if doom.settings.term_exec_cmd == "" then
--     vim.cmd("ToggleTerm")
--   else
--     local cmd = string.format("TermExec cmd=\"%s\"", doom.settings.term_exec_cmd)
--     vim.cmd(cmd)
--   end
-- end

terminal.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "t", function()
          if doom.settings.term_exec_cmd == "" then
            vim.cmd("ToggleTerm")
          else
            local exec_cmd = string.format("TermExec cmd=\"%s\"", doom.settings.term_exec_cmd)
            vim.cmd(exec_cmd)
          end
        end, name = "Terminal" },
      },
    },
  },
}

return terminal
