local log = require("doom.utils.logging")
local profiler = require("doom.services.profiler")

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
  local profiler_msg = ("null_ls|setup `%s`"):format(null_ls_path)

  profiler.start(profiler_msg)
  if doom.features.linter then
    -- Check if null-ls is loaded and load it if not.
    local ok = pcall(require, "null-ls")
    if not ok then
      vim.cmd("packadd null-ls.nvim")
    end

    local start_null_ls = function()
      local null_ls = require("null-ls")
      local path = vim.split(null_ls_path, "%.", nil)
      if #path ~= 3 then
        log.error(
          (
            "Error setting up null-ls provider `%s`.\n\n  null_ls_path should have 3 segments i.e. `builtins.formatting.stylua"
          ):format(null_ls_path)
        )
        return
      end
      local provider = null_ls[path[1]][path[2]][path[3]]

      if configure_function then
        provider = configure_function(provider)
      end

      module.use_null_ls_source({ provider })
    end

    local on_error = function(_, message)
      log.error(
        ("There was an error setting up null_ls provider `%s`. Reason: \n%s"):format(
          null_ls_path,
          message
        )
      )
    end

    -- If auto_install module is enabled, try to install package before starting
    if doom.features.auto_install and package_name ~= nil then
      module.use_mason_package(package_name, start_null_ls, on_error)
    else
      vim.defer_fn(function()
        start_null_ls()
      end, 1)
    end
  end

  profiler.stop(profiler_msg)
end

--- Default error handler for use_mason_package utility function
---@param package_name string Name of the package that's being installed
---@param err_message string Reason for erroring out of installing mason package
local default_error_handler = function(package_name, err_message)
  error(("Error installing mason package `%s`.  Reason: \n%s "):format(package_name, err_message))
end

--- Installs a mason package and provides an on-ready handler
---@param package_name string|nil Name of mason.nvim package to install
---@param success_handler function
---@param error_handler function|nil
module.use_mason_package = function(package_name, success_handler, error_handler)
  local mason = require("mason-registry")
  local on_err = error_handler or default_error_handler
  if package_name == nil then
    on_err("nil", "No package_name provided.")
    return
  end
  profiler.start("mason|using package " .. package_name)
  local ok, err = xpcall(function()
    local package = mason.get_package(package_name)
    if not package:is_installed() then
      -- If statusline enabled, push the package to the statusline state
      -- So we can provide feedback to user
      local statusline = doom.features.statusline
      if statusline then
        statusline.state.start_mason_package(package_name)
      end

      package:install()
      package:on("install:success", function(handle)
        -- Remove package from statusline state to hide it
        if statusline then
          statusline.state.finish_mason_package(package_name)
        end
        vim.schedule(function()
          success_handler(handle)
        end)
        profiler.stop("mason|using package " .. package_name)
      end)
      package:on("install:failed", function(pkg)
        -- Remove package from statusline state to hide it
        if statusline then
          statusline.state.finish_mason_package(package_name)
        end
        local err = "Mason.nvim install failed.  Reason:\n"
        if pkg and pkg.stdio and pkg.stdio.buffers and pkg.stdio.buffers.stderr then
          for _, line in ipairs(pkg.stdio.buffers.stderr) do
            err = err .. line
          end
        end

        vim.schedule(function()
          on_err(package_name, err)
        end)
        profiler.stop("mason|using package " .. package_name)
      end)
    else
      profiler.stop("mason|using package " .. package_name)
      success_handler(package, package.get_handle(package))
    end
  end, debug.traceback)
  if not ok then
    profiler.stop("mason|using package " .. package_name)
    on_err(package_name, "There was an unknown error when installing.  Reason: \n" .. err)
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
  local profiler_msg = ("lsp|setup `%s`"):format(lsp_name)
  profiler.start(profiler_msg)

  local utils = require("doom.utils")
  if not utils.is_module_enabled("features", "lsp") then
    return
  end
  local lsp = require("lspconfig")
  local lsp_configs = require("lspconfig.configs")

  local opts = options or {}
  local config_name = opts.name and opts.name or lsp_name
  --- If the LSP is not extending / using a pre-existing lspconfig
  local is_unsupported_config = opts.name ~= nil or lsp[config_name] == nil

  -- Resolve the user config from `opts.config` if it's a function
  local user_config = nil
  if opts.config then
    user_config = type(opts.config) == "function" and opts.config() or opts.config
  end

  -- If the LSP is unsupported we need to add the entry to lspconfig
  if user_config ~= nil and is_unsupported_config then
    print(("%s is unsupported, creating it now"):format(config_name))
    lsp_configs[config_name] = user_config
  end

  -- Combine default on_attach with provided on_attach
  local on_attach_functions = {}
  if utils.is_module_enabled("features", "illuminate") then
    table.insert(on_attach_functions, utils.illuminate_attach)
  end
  if user_config and user_config.on_attach then
    table.insert(on_attach_functions, user_config.on_attach)
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
    local final_config = vim.tbl_deep_extend("keep", user_config or {}, capabilities_config)
    if lsp[config_name].setup == nil then
      log.warn(
        (
          "Cannot start LSP %s with config name %s. Reason: The LSP config does not exist, please create an issue so this can be resolved."
        ):format(lsp_name, config_name)
      )
      return
    end
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
    local lspconfig_to_package = require("mason-lspconfig.mappings.server").lspconfig_to_package
    module.use_mason_package(lspconfig_to_package[lsp_name], start_lsp)
  else
    start_lsp()
  end

  profiler.stop(profiler_msg)
end

-- module.use_dap = function(config_name, settings)
--   local utils = require("doom.utils")
--   if utils.is_module_enabled("features", "dap") then
--     vim.defer_fn(function()
--       local dap = require("dap")
--       dap.configurations.python = {
--         {
--           type = "python",
--           request = "launch",
--           name = "Launch file",
--           program = "${file}",
--           pythonPath = function()
--             return "/usr/bin/python"
--           end,
--         },
--       }
--     end)
--   end
-- end

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

--- Helper to wrap language setup functions with error handling + avoid raceconditions
---@param module_name string Name of module for error logging
---@param setup_fn function Function that sets up this language
---@return function Wrapped setup function
module.wrap_language_setup = function(module_name, setup_fn)
  local setup_language = function()
    vim.defer_fn(function()
      local ok, error = xpcall(setup_fn, debug.traceback)
      if not ok then
        log.error(("Error setting up language `%s`. \n%s"):format(module_name, error))
      end
    end, 1)
  end
  return setup_language
end

return module
