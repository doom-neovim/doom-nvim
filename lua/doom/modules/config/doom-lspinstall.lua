return function()
  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
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

  local lspinstall = require("lspinstall")
  lspinstall.setup()

  -- Load langs from doomrc and install servers with +lsp
  local function install_servers()
    local installed_servers = lspinstall.installed_servers()
    local available_servers = lspinstall.available_servers()

    local doomrc = require("doom.core.config.doomrc").load_doomrc()
    local langs = doomrc.langs

    for _, lang in ipairs(langs) do
      local lang_str = lang
      lang = lang:gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")

      -- If the +lsp flag exists and the language server is not installed yet
      if lang_str:find("%+lsp") and (not utils.has_value(installed_servers, lang)) then
        -- Try to install the server only if there is a server available for
        -- the language, oterwise raise a warning
        if utils.has_value(available_servers, lang) then
          lspinstall.install_server(lang)
        else
          log.warn(
            "The language " .. lang .. ' does not have a server, please remove the "+lsp" flag'
          )
        end
      end
    end
  end

  install_servers()

  -- https://github.com/kabouzeid/nvim-lspinstall#advanced-configuration-recommended
  local function setup_servers()
    -- Provide the missing :LspInstall
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
