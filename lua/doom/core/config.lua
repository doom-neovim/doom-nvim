--  doom.core.config
--
--  Responsible for setting some vim global defaults, managing the `doom.field_name`
--  config options, pre-configuring the user's modules from `modules.lua`, and
--  running the user's `config.lua` file.

local utils = require("doom.utils")
local system = require("doom.core.system")
local config = {}
local filename = "config.lua"

config.source = nil


--- Entry point to bootstrap doom-nvim.
config.load = function()
  -- Set vim defaults on first load. To override these, the user can just
  -- override vim.opt in their own config, no bells or whistles attached.
  vim.opt.hidden = true
  vim.opt.updatetime = 200
  vim.opt.timeoutlen = 400
  vim.opt.background = "dark"
  vim.opt.completeopt = {
    "menu",
    "menuone",
    "preview",
    "noinsert",
    "noselect",
  }
  vim.opt.shortmess = "atsc"
  vim.opt.inccommand = "split"
  vim.opt.path = "**"
  vim.opt.signcolumn = "auto:2-3"
  vim.opt.foldcolumn = "auto:9"
  vim.opt.colorcolumn = "80"
  vim.opt.formatoptions:append("j")
  vim.opt.fillchars = {
    vert = "▕",
    fold = " ",
    eob = " ",
    diff = "─",
    msgsep = "‾",
    foldopen = "▾",
    foldclose = "▸",
    foldsep = "│",
  }
  vim.opt.smartindent = true
  vim.opt.copyindent = true
  vim.opt.preserveindent = true
  vim.opt.clipboard = "unnamedplus"
  vim.opt.cursorline = true
  vim.opt.splitright = false
  vim.opt.splitbelow = true
  vim.opt.scrolloff = 4
  vim.opt.showmode = false
  vim.opt.mouse = "a"
  vim.opt.wrap = false
  vim.opt.swapfile = false
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.expandtab = true
  vim.opt.conceallevel = 0
  vim.opt.foldenable = true
  vim.opt.foldtext = require("doom.core.functions").sugar_folds()

  -- Combine enabled modules (`modules.lua`) with core modules.
  local enabled_modules = require("doom.core.modules").enabled_modules
  local all_modules = vim.tbl_deep_extend('keep', {
    core = {
      'doom',
      'nest',
      'treesitter',
      'reloader',
    }
  },enabled_modules)

  local config_path = vim.fn.stdpath("config")

  local function glob_modules(cat)
    local glob = config_path .. "/lua/"..cat.."/modules/*/*/"
    return vim.split(vim.fn.glob(glob), "\n")
  end

  local function get_all_module_paths()
    local glob_doom_modules = glob_modules("doom")
    local glob_user_modules = glob_modules("user")

    local all = glob_doom_modules

    for _, p in ipairs(glob_user_modules) do
      table.insert(all, p)
    end
    return all
  end

  local all_m = get_all_module_paths()

  -- A. first create all of the module skeletons.
  local prep_all_m = { doom = {}, user = {} }
  for _, p in ipairs(all_m) do
    local m_origin, m_section, m_name =  p:match("/([_%w]-)/modules/([_%w]-)/([_%w]-)/$") -- capture only dirname
    if prep_all_m[m_origin][m_section] == nil then
      prep_all_m[m_origin][m_section] = {}
    end
    prep_all_m[m_origin][m_section][m_name] = {
      failed = false,
      enabled = false,
      name = m_name,
      section = m_section,
      origin = m_origin,
      path_real = p
    }
  end

  -- B. Iterate over each enabled module and extend the module skeleton.
  for section_name, section_modules in pairs(all_modules) do
    for _, module_name in pairs(section_modules) do
      local module, origin

      -- If the section is `user` resolves from `lua/user/modules`
      local search_paths = {
        ("user.modules.%s.%s"):format(section_name, module_name),
        ("doom.modules.%s.%s"):format(section_name, module_name)
      }

      local ok, result
      for _, path in ipairs(search_paths) do
        ok, result = xpcall(require, debug.traceback, path)
        if ok then
          origin = path:sub(1,4)
          break;
        end
      end

      -- get prepared module skeleton
      -- if prep_all_m[origin][section_name][module_name] ~= nil then
        module = prep_all_m[origin][section_name][module_name]
      -- end

      -- extend the module
      if ok then
        module = vim.tbl_extend("force", module, result)
      else
        module["failed"] = true
        local msg = string.format(
          "There was an error loading module '%s.%s'. Traceback:\n%s",
          section_name,
          module_name,
          result
        )
        module["msg"] = msg
        require("doom.utils.logging").error(msg)
      end

      -- print(vim.inspect(module))

      doom[section_name][module_name] = module
    end
  end

  -- Execute user's `config.lua` so they can modify the doom global object.
  local ok, err = xpcall(dofile, debug.traceback, config.source)
  local log = require("doom.utils.logging")
  if not ok and err then
    log.error("Error while running `config.lua. Traceback:\n" .. err)
  end

  -- Apply the necessary `doom.field_name` options
  vim.opt.shiftwidth = doom.settings.indent
  vim.opt.softtabstop = doom.settings.indent
  vim.opt.tabstop = doom.settings.indent
  if doom.settings.guicolors then
    if vim.fn.exists("+termguicolors") == 1 then
      vim.opt.termguicolors = true
    elseif vim.fn.exists("+guicolors") == 1 then
      vim.opt.guicolors = true
    end
  end

  if doom.settings.auto_comment then
    vim.opt.formatoptions:append("croj")
  end
  if doom.settings.movement_wrap then
    vim.cmd("set whichwrap+=<,>,[,],h,l")
  end

  if doom.settings.undo_dir then
    vim.opt.undofile = true
    vim.opt.undodir = doom.settings.undo_dir
  else
    vim.opt.undofile = false
    vim.opt.undodir = nil
  end
end

-- Path cases:
--   1. stdpath('config')/../doom-nvim/config.lua
--   2. stdpath('config')/config.lua
--   3. <runtimepath>/doom-nvim/config.lua
config.source = utils.find_config(filename)
return config
