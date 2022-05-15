  local enabled_modules = require("doom.core.modules").enabled_modules
  local all_modules = vim.tbl_deep_extend('keep', {
    core = {
      ['doom'] = true,
      ['nest'] = true,
      ['treesitter'] = true,
      ['reloader'] = true,
    }
  },enabled_modules)
  for section_name, section_modules in pairs(all_modules) do
    for module_name, is_enabled in pairs(section_modules) do
      local root_folder = section_name == "user" and "user.modules"
        or ("doom.modules.%s"):format(section_name)
      local module = {
            failed = false,
            name = module_name,
            enabled = is_enabled,
            section = section_name,
            require_path = ("%s.%s"):format(root_folder, module_name),
            path = utils.real_path_from_lua { root_folder, section_name, module_name },
      }
      if module.enabled then
        local ok, result = xpcall(require, debug.traceback, module.require_path)
        if ok then module = vim.tbl_extend("force", module, result)
        else
          module["failed"] = true
          local tmp_str = "There was an error loading module '%s.%s'. Traceback:\n%s"
          local err_msg = string.format(tmp_str, section_name, module_name, result)
          module["msg"] = err_msg
          local log = require("doom.utils.logging")
          log.error(err_msg)
        end
      end
      doom[section_name][module_name] = module
    end
  end

