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
    commit = "e90f87872b313df15a06119ddbb84cdf1599657c",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    opt = true,
  },
}

firenvim.configs = {}
firenvim.configs["firenvim"] = function()
  vim.g.firenvim_config = doom.features.firenvim.settings

  for _, command in ipairs(doom.features.firenvim.settings.autocmds) do
    vim.cmd(("autocmd %s %s_*.txt %s"):format(command[1], command[2], command[3]))
  end
end

return firenvim
