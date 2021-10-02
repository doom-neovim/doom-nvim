return function()
  -- Init dap-install
  local dap_install = require("dap-install")
  dap_install.setup({
	  verbosely_call_debuggers = true,
	  installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
  })

  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
  local installed_clients = require("dap-install.api.debuggers").get_installed_debuggers()
  -- NOTE: not all the clients follows the 'language_dbg' standard and this
  --       can give some problems to us (maybe?)
  local available_clients = vim.tbl_keys(require("dap-install.api.debuggers").get_debuggers())

  local modules = require("doom.core.config.modules").modules
  local langs = modules.langs

  for _, lang in ipairs(langs) do
    local lang_str = lang
    lang = lang:gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")

    -- If the +debug flag exists and the language client is not installed yet
    if lang_str:find("%+debug") and (not utils.has_value(installed_clients, lang)) then
      -- Try to install the client only if there is a client available for
      -- the language, oterwise raise a warning
      if utils.has_value(available_clients, lang) then
        require('dap-install.core.install').install_debugger(lang)
      else
        log.warn(
          "The language "
            .. lang
            .. ' does not have a DAP client, please remove the "+debug" flag'
        )
      end
    end
  end
end
