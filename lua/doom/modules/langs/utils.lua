local log = require("doom.utils.logging")

local module = {}

--- Stores the unique null_ls sources
local registered_sources = {}

--- Registers a null_ls source only if it's unique
-- @tparam  source
module.use_null_ls_source = function(sources)
  local null_ls = require("null-ls")
  for _, source in ipairs(sources) do
    -- Generate a unique key from the name/methods
    local methods = type(source.method) == "string" and source.method
      or table.concat(source.method, " ")
    local key = source.name .. methods
    -- If it's unique, register it
    if not registered_sources[key] then
      registered_sources[key] = source
      null_ls.register(source)
    else
      log.warn(
        string.format(
          "Attempted to register a duplicate null_ls source. ( %s with methods %s).",
          source.name,
          methods
        )
      )
    end
  end
end

---
---@param package_name string|nil Name of Mason.nvim package to install
---@param null_ls_path string Path of null-ls source i.e. `builtins.formatting.shfmt`
---@param configure_function function|nil optional configure function
---@language lua
--- ```lua
--- -- No mason.nvim package
--- langs_utils.use_null_ls(nil, "builtins.formatting.terrafmt")
--- -- Minimal
--- langs_utils.use_null_ls("stylua", "builtins.formatting.stylua")
--- -- Configure null_ls source
--- langs_utils.use_null_ls("shfmt", "builtins.formatting.shfmt", function(shfmt)
---   return shfmt.with({
---     extra_args = { "-i", "2", "-ci" },
---   })
--- end)
--- ```
module.use_null_ls = function(package_name, null_ls_path, configure_function)
  local start_null_ls = function()
    local null_ls = require("null-ls")
    local path = vim.split(null_ls_path, "%.")
    if #path ~= 3 then
      log.error(
        "Error setting up null-ls provider "
          .. null_ls_path
          .. ".  null_ls_path should have 3 segments i.e. `builtins.formatting.stylua"
      )
    end
    print(vim.inspect(path))
    local provider = null_ls[path[1]][path[2]][path[3]]

    if configure_function then
      provider = configure_function(provider)
    end

    module.use_null_ls_source({ provider })
  end

  -- Auto install package if necessary
  if doom.features.linter then
    if doom.features.auto_installer and package_name ~= nil then
      module.use_mason_package(package_name, start_null_ls)
    else
      vim.defer_fn(function()
        start_null_ls()
      end, 1)
    end
  end
end

--- Default error handler for use_mason_package utility function
---@param err_message string Reason for erroring out of installing mason package
local default_error_handler = function(err_message)
  require("doom.utils.logging")
  log.error("use_mason_package error: " .. vim.inspect(err_message))
end

--- Installs a mason package and provides an on-ready handler
---@param package_name string
---@param success_handler function
---@param error_handler function|nil
module.use_mason_package = function(package_name, success_handler, error_handler)
  local mason = require("mason-registry")
  local on_err = error_handler or default_error_handler
  local ok, err = pcall(function()
    local package = mason.get_package(package_name)
    if not package:is_installed() then
      package:install()
      package:on("install:success", success_handler)
      package:on("install:failed", function()
        on_err("Error installing mason package.")
      end)
    else
      success_handler(package, package.get_handle(package))
    end
  end)
  if not ok then
    on_err(err)
  end
end

--- Installs treesitter grammars
---@param grammars string|string[]
---
---@example
--- ```lua
--- langs_utils.use_tree_sitter("javascript")
--- langs_utils.use_tree_sitter({"c", "cpp"})
--- ````
module.use_tree_sitter = function(grammars)
  if type(grammars) == "table" then
    require("nvim-treesitter.install").ensure_installed(unpack(grammars))
  else
    require("nvim-treesitter.install").ensure_installed(grammars)
  end
end

module.use_lsp_mason = function(lsp_name, options)
  local utils = require("doom.utils")
  if not utils.is_module_enabled("features", "lsp") then
    return
  end
  local lsp = require("lspconfig")
  local lsp_configs = require("lspconfig.configs")

  local opts = options or {}
  local config_name = opts.name and opts.name or lsp_name
  local is_custom_config = opts.name ~= nil or lsp_configs[config_name] ~= nil

  if opts.config and is_custom_config then
    lsp_configs[config_name] = opts.config
  end

  -- Combine default on_attach with provided on_attach
  local on_attach_functions = {}
  if utils.is_module_enabled("features", "illuminate") then
    table.insert(on_attach_functions, utils.illuminate_attach)
  end
  if opts.config and opts.config.on_attach then
    table.insert(on_attach_functions, opts.config.on_attach)
  end

  local capabilities_config = {
    capabilities = module.get_capabilities(),
    on_attach = function(client)
      for _, handler in ipairs(on_attach_functions) do
        handler(client)
      end
    end,
  }

  -- Start server and bind to buffers
  local start_lsp = function()
    local final_config = vim.tbl_deep_extend("keep", opts.config or {}, capabilities_config)
    lsp[config_name].setup(final_config)
    local lsp_config_server = lsp[config_name]
    if lsp_config_server.manager then
      local buffer_handler = lsp_config_server.filetypes
          and lsp_config_server.manager.try_add_wrapper
        or lsp_config_server.manager.try_add
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        buffer_handler(bufnr)
      end
    end
  end

  -- Auto install if possible
  if utils.is_module_enabled("features", "auto_install") and not opts.no_installer then
    local mason = require("mason-registry")
    local lspconfig_to_package = require("mason-lspconfig.mappings.server").lspconfig_to_package
    local ok = pcall(function()
      local package = mason.get_package(lspconfig_to_package[lsp_name])
      if not package:is_installed() then
        vim.defer_fn(function()
          package:install()
        end, 50)
        package:on("install:success", function()
          start_lsp()
        end)
      else
        start_lsp()
      end
    end)
    if not ok then
      start_lsp()
    end
  else
    start_lsp()
  end
end

--- Helper to attach illuminate on LSP
module.illuminate_attach = function(client)
  require("illuminate").on_attach(client)
  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
end

--- Get LSP capabilities for DOOM
module.get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.codeAction = {
    dynamicRegistration = false,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = {
          "",
          "quickfix",
          "refactor",
          "refactor.extract",
          "refactor.inline",
          "refactor.rewrite",
          "source",
          "source.organizeImports",
        },
      },
    },
  }

  return capabilities
end

return module
