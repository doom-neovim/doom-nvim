local firenvim = {}

firenvim.settings = {
  globalSettings = {
    alt = "all",
  },
  localSettings = {
    [".*"] = {
      cmdline = "neovim",
      content = "text",
      priority = 0,
      selector = "textarea",
      takeover = "never",
    },
    ["https?://github.com/"] = {
      takeover = "always",
      priority = 1,
    },
  },
  autocmds = {
    { "BufEnter", "github.com", "setlocal filetype=markdown" },
  },
}

firenvim.packages = {
  ["firenvim"] = {
    "glacambre/firenvim",
    commit = "a9ac769d3c87c9b4c4671e7c295cb3916b5400eb",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    opt = true,
  },
}

firenvim.configure_functions = {}
firenvim.configure_functions["firenvim"] = function()
  vim.g.firenvim_config = doom.modules.firenvim.settings

  for _, command in ipairs(doom.modules.firenvim.settings.autocmds) do
    vim.cmd(("autocmd %s %s_*.txt %s"):format(command[1], command[2], command[3]))
  end
end

return firenvim
