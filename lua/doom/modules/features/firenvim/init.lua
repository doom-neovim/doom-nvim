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
    commit = "b6be2e074b8f62815a45e31eb0966b4dd5e57810",
    build =  function()
      vim.fn["firenvim#install"](0)
    end,
    lazy = true,
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
