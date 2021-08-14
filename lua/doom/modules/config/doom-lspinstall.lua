return function()
  local nvim_lsp = require("lspconfig")
  local lua_lsp = require("lua-dev").setup({
    lspconfig = {
      settings = {
        Lua = {
          workspace = {
            preloadFileSize = 200,
          },
        },
      },
    },
  })

  -- https://github.com/kabouzeid/nvim-lspinstall#advanced-configuration-recommended
  local function setup_servers()
    -- Provide the missing :LspInstall
    require("lspinstall").setup()
    local servers = require("lspinstall").installed_servers()
    for _, server in pairs(servers) do
      -- Configure sumneko for neovim lua development
      if server == "lua" then
        nvim_lsp.lua.setup(lua_lsp)
      else
        -- Use default settings for all the other language servers
        nvim_lsp[server].setup({})
      end
    end
  end

  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require("lspinstall").post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
end
