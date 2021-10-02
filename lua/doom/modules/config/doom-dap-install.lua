return function()
  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
  -- Init dap-install
  local dap_install = require("dap-install")
  dap_install.setup({
	  verbosely_call_debuggers = true,
	  installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
  })

  local dap_lang_lookup = {
    cpp = {'ccppr_vsc'},
    c = {'ccppr_vsc'},
    rust = {'ccppr_vsc'},
    go = {'go_delve'},
    javascript = { 'chrome', 'jsnode' },
    typescript = { 'chrome', 'jsnode' },
    ruby = {'ruby_vsc'}
  }

  -- Iterates through langs and installs clients where possible
  local install_dap_clients = function()
    local installed_clients = require("dap-install.api.debuggers").get_installed_debuggers()
    -- NOTE: not all the clients follows the 'language_dbg' standard and this
    --       can give some problems to us (maybe?)
    local available_clients = vim.tbl_keys(require("dap-install.api.debuggers").get_debuggers())

    local modules = require("doom.core.config.modules").modules
    local langs = modules.langs

    for _, lang in ipairs(langs) do
      local lang_str = lang
      lang = lang:gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")

      -- DAPInstall.nvim has different names for the DAPs so sometimes we need to lookup the correct DAP to install
      if utils.has_value(dap_lang_lookup, lang) then
        lang = dap_lang_lookup[lang]
      else
        lang = { lang }
      end

      -- Iterate over DAPs installing them one by one
      for _, dap_name in ipairs(lang) do
        -- If the +debug flag exists and the language client is not installed yet
        if lang_str:find("%+debug") and (not utils.has_value(installed_clients, dap_name)) then

          -- Try to install the client only if there is a client available for
          -- the language, oterwise raise a warning
          if utils.has_value(available_clients, dap_name) then
            require('dap-install.core.install').install_debugger(dap_name)
          else
            log.warn(
              "The language "
                .. dap_name
                .. ' does not have a DAP client, please remove the "+debug" flag'
            )
          end
        end
      end
    end
  end

  install_dap_clients()
end
