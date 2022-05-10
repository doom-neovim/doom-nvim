local utils = require("doom.utils")
local use_floating_win_packer = doom.settings.use_floating_win_packer
local log = require("doom.utils.logging")
local system = require("doom.core.system")

local pr = {}

pr.cmds = {
  {
    "DoomStartLocalPluginAutoReloaders",
    function()
      local function check_for_local_forks(name, spec)
        local function apply_reload_autocmd_to_local_fork(name, repo_path)
          local repo_lua_path = string.format("%s%slua", repo_path, system.sep)
          local autocmd_pattern = string.format("%s%s%s", repo_path, system.sep, "**/*.lua")
          local scan_dir = require("plenary.scandir").scan_dir
          local reload_module = require("plenary.reload").reload_module
          local scan_dir_opts = { search_pattern = ".", depth = 1, only_dirs = true }
          utils.make_augroup(name .. "_autoreloader", {
            {
              "BufWritePost",
              autocmd_pattern,
              function()
                if doom.settings.reload_local_plugins then
                  local t_lua_module_paths = scan_dir(vim.fn.expand(repo_lua_path), scan_dir_opts)
                  local t_lua_module_names = vim.tbl_map(function(s)
                    return s:match("/([_%w]-)$") -- capture only dirname
                  end, t_lua_module_paths)
                  for _, mname in ipairs(t_lua_module_names) do
                    print("reload module name:", mname)
                    reload_module(mname)
                  end
                end
              end,
            },
          })
          log.info(
            string.format(
              [[Create local reloader autocmd for: %s]],
              repo_path:match("/([_%w%.%-]-)$")
            )
          )
        end

        local repo_path = spec[1]
        local function is_local_path(s)
          return s:match("^~") or s:match("^/")
        end
        if is_local_path(repo_path) then
          apply_reload_autocmd_to_local_fork(name, repo_path)
        end
        if spec.requires ~= nil then
          for _, rspec in pairs(spec.requires) do
            local rspec_repo_path = rspec
            if type(rspec) == "table" then
              rspec_repo_path = rspec[1]
            end
            if is_local_path(rspec_repo_path) then
              apply_reload_autocmd_to_local_fork(rspec[1]:match("/([_%w%.%-]-)$"), rspec[1])
            end
          end
        end
      end

      for module_name, module in pairs(doom.modules) do
        if module.packages then
          for dependency_name, packer_spec in pairs(module.packages) do
            check_for_local_forks(dependency_name, packer_spec)
          end
        end
      end
    end,
  },
}

return pr
