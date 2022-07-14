-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/doom/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/doom/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/doom/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/doom/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/doom/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  aniseed = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/aniseed",
    url = "https://github.com/Olical/aniseed"
  },
  ["nest.nvim"] = {
    config = { "\27LJ\1\2þ\1\0\0\6\0\v\0\0284\0\0\0%\1\1\0>\0\2\0027\1\2\0004\2\0\0%\3\3\0>\2\2\0027\3\4\0024\4\0\0%\5\5\0>\4\2\0=\3\0\1\16\3\1\0%\4\6\0>\3\2\2\14\0\3\0T\3\6€4\3\0\0%\4\a\0>\3\2\0027\4\4\2\16\5\3\0>\4\2\0017\3\b\0024\4\t\0007\4\n\4>\3\2\1G\0\1\0\nbinds\tdoom\17applyKeymaps\31nest.integrations.whichkey\rwhichkey\29nest.integrations.mapper\venable\tnest\23is_plugin_disabled\15doom.utils\frequire\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/nest.nvim",
    url = "https://github.com/LuigiPiucco/nest.nvim"
  },
  ["nvim-mapper"] = {
    after = { "nest.nvim" },
    loaded = true,
    only_config = true
  },
  ["nvim-tree-docs"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/nvim-tree-docs",
    url = "https://github.com/nvim-treesitter/nvim-tree-docs"
  },
  ["nvim-treesitter"] = {
    after = { "nvim-ts-autotag", "nvim-ts-context-commentstring", "nvim-tree-docs" },
    loaded = true,
    only_config = true
  },
  ["nvim-ts-autotag"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["packer.nvim"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    config = { "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/doom/.local/share/nvim/site/pack/packer/opt/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^plenary"] = "plenary.nvim",
  ["^popup"] = "popup.nvim",
  aniseed = "aniseed"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: nvim-mapper
time([[Config for nvim-mapper]], true)
try_loadstring("\27LJ\1\2V\0\0\2\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\3\0007\1\4\0017\1\5\1>\0\2\1G\0\1\0\vmapper\tcore\tdoom\nsetup\16nvim-mapper\frequire\0", "config", "nvim-mapper")
try_loadstring("\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "config", "nvim-mapper")
time([[Config for nvim-mapper]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2é\3\0\0\a\0\17\0%4\0\0\0%\1\1\0>\0\2\0024\1\0\0%\2\2\0>\1\2\0027\2\3\0013\3\b\0004\4\4\0007\4\5\0047\4\6\4%\5\a\0>\4\2\2;\4\1\3>\2\2\0024\3\4\0007\3\5\0037\3\t\3\16\4\2\0\a\2\n\0T\5\2€%\5\v\0T\6\1€%\5\f\0$\4\5\4>\3\2\0028\3\1\3\16\5\3\0007\4\r\3%\6\14\0>\4\3\2\15\0\4\0T\5\3€7\4\15\0%\5\16\0>\4\2\1G\0\1\0¾\1doom-treesitter:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc, see issue #246 for details.  (https://github.com/NTBBloodbath/doom-nvim/issues/246)\twarn\nclang\nmatch\15 --version\5\acl\15systemlist\1\a\0\0\0\acc\bgcc\nclang\acl\bzig\aCC\vgetenv\afn\bvim\28find_executable_in_path\15doom.utils\23doom.utils.logging\frequire“\2\1\0\t\0\17\0\0304\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\0\0%\2\3\0>\1\2\0027\1\4\0014\2\5\0007\2\6\2%\3\a\0004\4\b\0007\4\t\0047\4\n\0043\5\14\0003\6\f\0\16\a\0\0%\b\v\0>\a\2\2\17\a\a\0:\a\r\6:\6\v\5>\2\4\0=\1\0\0014\1\5\0007\1\15\0011\2\16\0'\3è\3>\1\3\1G\0\1\0\0\rdefer_fn\1\0\0\venable\1\0\0\14autopairs\15treesitter\tcore\tdoom\nforce\20tbl_deep_extend\bvim\nsetup\28nvim-treesitter.configs\23is_plugin_disabled\15doom.utils\frequire\0", "config", "nvim-treesitter")
try_loadstring("\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nest.nvim ]]

-- Config for: nest.nvim
try_loadstring("\27LJ\1\2þ\1\0\0\6\0\v\0\0284\0\0\0%\1\1\0>\0\2\0027\1\2\0004\2\0\0%\3\3\0>\2\2\0027\3\4\0024\4\0\0%\5\5\0>\4\2\0=\3\0\1\16\3\1\0%\4\6\0>\3\2\2\14\0\3\0T\3\6€4\3\0\0%\4\a\0>\3\2\0027\4\4\2\16\5\3\0>\4\2\0017\3\b\0024\4\t\0007\4\n\4>\3\2\1G\0\1\0\nbinds\tdoom\17applyKeymaps\31nest.integrations.whichkey\rwhichkey\29nest.integrations.mapper\venable\tnest\23is_plugin_disabled\15doom.utils\frequire\0", "config", "nest.nvim")
try_loadstring("\27LJ\1\2\v\0\0\1\0\0\0\1G\0\1\0\0", "config", "nest.nvim")

time([[Sequenced loading]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
