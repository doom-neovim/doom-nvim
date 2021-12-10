---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local log = require("doom.extras.logging")
local utils, fs = require("doom.utils"), require("doom.utils.fs")
local system = require("doom.core.system")
local config = require("doom.core.config").config
local async = require("doom.modules.built-in.async")

local functions = {}

log.debug("Loading Doom functions module ...")

-- Load user-defined settings from the Neovim field in the doom_config.lua
-- @param settings_tbl The settings table to iterate over
-- @param scope The settings scope, e.g. autocmds
functions.load_custom_settings = function(settings_tbl, scope)
  -- If the provided settings table is not empty
  if next(settings_tbl) ~= nil then
    log.debug("Loading custom " .. scope .. " ...")
    if scope == "functions" then
      for _, func in ipairs(settings_tbl) do
        -- Copy the function table so we can modify it safely
        local func_tbl = func
        -- Remove the additional table parameters
        func_tbl.run_on_start = nil
        local func_name = vim.tbl_keys(func_tbl)[1]

        -- If we should run the function on launch or set it as a global function
        if func.run_on_start then
          func_tbl[func_name]()
        else
          _G[func_name] = func_tbl[func_name]
        end
      end
    elseif scope == "mappings" then
      for _, map in ipairs(settings_tbl) do
        -- scope, lhs, rhs, options
        vim.api.nvim_set_keymap(map[1], map[2], map[3], map[4] and map[4] or {})
      end
    elseif scope == "autocmds" then
      utils.create_augroups(settings_tbl)
    elseif scope == "commands" then
      for _, cmd in ipairs(settings_tbl) do
        vim.cmd(cmd)
      end
    elseif scope == "variables" then
      for var, val in pairs(settings_tbl) do
        vim.g[var] = val
      end
    elseif scope == "options" then
      for var, val in pairs(settings_tbl) do
        vim.opt[var] = val
      end
    end
  end
end

-- reload_custom_settings reloads all the user-defined configurations
-- in the 'doom_config.lua' file.
functions.reload_custom_settings = function()
  -- Get the user-defined settings, the 'nvim' field in our 'doom_config.lua'
  local custom_settings = require("doom.core.config").config.nvim
  -- iterate over all the custom settings fields, e.g. global_variables, mappings, etc.
  for scope, _ in pairs(custom_settings) do
    functions.load_custom_settings(custom_settings[scope], scope)
  end
end

-- Change the 'doom_config.lua' file configurations for the colorscheme and the
-- background if they were changed by the user within Neovim
functions.change_colors_and_bg = function()
  local changed_colorscheme, err = xpcall(function()
    log.debug("Checking if the colorscheme or background were changed ...")
    local target_colorscheme = vim.g.colors_name
    local target_background = vim.opt.background:get()

    -- Set the correct path for the 'doom_config.lua' file
    local doom_config_path = require("doom.core.config").source

    if target_colorscheme ~= config.doom.colorscheme then
      local doom_config = fs.read_file(doom_config_path)
      doom_config = string.gsub(
        doom_config,
        string.format('"%s"', utils.escape_str(config.doom.colorscheme)),
        string.format('"%s"', utils.escape_str(target_colorscheme))
      )
      fs.write_file(doom_config_path, doom_config, "w+")
      log.debug("Colorscheme successfully changed to " .. target_colorscheme)
    end
    if target_background ~= config.doom.colorscheme_bg then
      local doom_config = fs.read_file(doom_config_path)
      doom_config = string.gsub(
        doom_config,
        string.format('"%s"', config.doom.colorscheme_bg),
        string.format('"%s"', target_background)
      )
      fs.write_file(doom_config_path, doom_config, "w+")
      log.debug("Background successfully changed to " .. target_background)
    end
  end, debug.traceback)

  if not changed_colorscheme then
    log.error("Unable to write to the doom_config.lua file. Traceback:\n" .. err)
  end
end

-- Quit Neovim and change the colorscheme at doom_config.lua if the colorscheme is not the same,
-- dump all messages to doom.log file
-- @tparam bool write If doom should save before exiting
-- @tparam bool force If doom should force the exiting
functions.quit_doom = function(write, force)
  functions.change_colors_and_bg()

  local quit_cmd = ""
  if write then
    quit_cmd = "wa | "
  end
  if force then
    vim.cmd(quit_cmd .. "qa!")
  else
    vim.cmd(quit_cmd .. "q!")
  end
end

-- check_updates checks for plugins updates
functions.check_updates = function()
  local updated_plugins, err = xpcall(function()
    log.info("Updating the outdated plugins ...")
    vim.cmd("PackerSync")
  end, debug.traceback)

  if not updated_plugins then
    log.error("Unable to update plugins. Traceback:\n" .. err)
  end
end

-- Open Doom Nvim user manual and set extra options to buffer
functions.open_docs = function()
  -- NOTE: we aren't using the default Neovim way with ':h doom' because of some bugs
  -- with the tags and Neovim overriding the filetype, causing some highlighting issues

  -- Get the documentation path
  local docs_path
  if fs.file_exists(string.format("%s/doc/doom_nvim.norg", system.doom_root)) then
    docs_path = string.format("%s/doc/doom_nvim.norg", system.doom_root)
  else
    docs_path = string.format("%s/doc/doom_nvim.norg", system.doom_configs_root)
  end

  -- Open the documentation in a split window
  vim.cmd(string.format("split %s", docs_path))
  -- Move cursor to table of contents section
  vim.api.nvim_buf_call(vim.fn.bufnr("doom_nvim.norg"), function()
    vim.fn.cursor(12, 1)
  end)
  -- Set local documentation options
  vim.opt_local.modified = false
  vim.opt_local.modifiable = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.colorcolumn = "0"
  vim.opt_local.shiftwidth = 2
  vim.opt_local.tabstop = 2
  vim.opt_local.conceallevel = 2
  vim.opt_local.concealcursor = "n"
  vim.opt_local.textwidth = 100
  vim.opt_local.rightleft = false
end

-- create_report creates a markdown report. It's meant to be used when a bug
-- occurs, useful for debugging issues.
functions.create_report = function()
  local date = os.date("%Y-%m-%d %H:%M:%S")
  local created_report, err = xpcall(function()
    -- Get and save only the warning and error logs from today
    local today_logs = {}
    local doom_logs = vim.split(fs.read_file(system.doom_logs), "\n")
    for _, doom_log in ipairs(doom_logs) do
      local preinfo = doom_log:match("%[(.+)%]")
      if preinfo ~= nil then
        local is_current_day = preinfo:find(os.date("%a %d %b")) ~= nil
          and preinfo:find(os.date("%Y")) ~= nil
        local error_or_warn = preinfo:find("ERROR ") or preinfo:find("WARN ")
        if error_or_warn and is_current_day then
          table.insert(today_logs, doom_log)
        end
      end
    end

    -- Get the neovim version
    local nvim_version_info = vim.version()
    local nvim_version = string.format(
      "%d.%d.%d",
      nvim_version_info.major,
      nvim_version_info.minor,
      nvim_version_info.patch
    )
    if nvim_version_info.api_prerelease then
      nvim_version = nvim_version .. " (dev)"
    end

    -- Get the current OS and if the user is running Linux then get also the
    -- distribution name, e.g. Manjaro
    local user_os = vim.loop.os_uname().sysname
    if user_os == "Linux" then
      user_os = vim.trim(
        -- PRETTY_NAME="Distribution (Additional info)", e.g.
        --   PRETTY_NAME="Fedora 34 (KDE Plasma)"
        vim.fn.system(
          'cat /etc/os-release | grep "^PRETTY_NAME" | sed '
            .. "'s/^PRETTY_NAME=\"//' | sed "
            .. "'s/\"//'"
        )
      )
    end

    local report = string.format(
      [[# Doom Nvim crash report

> Report date: %s

## System and Doom Nvim information

- **OS**: %s
- **Neovim version**: %s
- **Doom Nvim information**:
  - **version**: %s
  - **`doom_root` variable**: `%s`
  - **`doom_configs_root` variable**: `%s`

### Begin error log dump

```
%s
```

### End log dump]],
      date,
      user_os,
      nvim_version,
      utils.doom_version,
      system.doom_root,
      system.doom_configs_root,
      table.concat(today_logs, "\n")
    )
    fs.write_file(system.doom_report, report, "w+")
    log.info("Report created at " .. system.doom_report)
  end, debug.traceback)

  if not created_report then
    log.error("Error while writing report. Traceback:\n" .. err)
  end
end

-- save_backup_hashes saves the commits or releases SHA for future rollbacks
local function save_backup_hashes()
  -- Check for the current branch
  local git_branch = utils.get_git_output("branch --show-current", true)

  if git_branch == "main" then
    local releases_database_path = string.format("%s%s.doom_releases", system.doom_root, system.sep)

    -- Fetch for a file containing the releases tags
    log.info("Saving the Doom releases for future rollbacks ...")
    local saved_releases, releases_err = xpcall(function()
      -- Get the releases
      log.debug('Executing "' .. system.git_workspace .. 'show-ref --tags"')
      local doom_releases = utils.get_git_output("show-ref --tags", false)

      -- Put all the releases into a table so we can sort them later
      local releases = {}
      for release in doom_releases:gmatch("[^\r\n]+") do
        table.insert(releases, release)
      end
      -- Sort the releases table
      local sorted_releases = {}
      for idx, release in ipairs(releases) do
        sorted_releases[#releases + 1 - idx] = release:gsub("refs/tags/", "")
      end

      -- Check if the database already exists so we can check if the
      -- database is up-to-date or if we should override it.
      --
      -- If the database does not exist yet then we will create it
      if vim.fn.filereadable(releases_database_path) == 1 then
        local current_releases = fs.read_file(releases_database_path)
        if current_releases ~= doom_releases then
          -- Write the first release in the list with 'w+' so the
          -- actual content will be overwritten by this one
          fs.write_file(releases_database_path, sorted_releases[1] .. "\n", "w+")
          -- Write the rest of the releases
          for idx, release in ipairs(sorted_releases) do
            -- Exclude the first release because we have already
            -- written it in the database file
            if idx ~= 1 then
              fs.write_file(releases_database_path, release .. "\n", "a+")
            end
          end
        end
      else
        for _, release in ipairs(sorted_releases) do
          fs.write_file(releases_database_path, release .. "\n", "a+")
        end
      end
    end, debug.traceback)

    if not saved_releases then
      log.error("Error while saving the Doom releases. Traceback:\n" .. releases_err)
    end
  else
    -- Get the current commit SHA and store it into a hidden file
    log.info("Saving the current commit SHA for future rollbacks ...")
    local saved_backup_hash, backup_err = xpcall(function()
      os.execute(
        system.git_workspace
          .. "rev-parse --short HEAD > "
          .. system.doom_root
          .. system.sep
          .. ".doom_backup_hash"
      )
    end, debug.traceback)

    if not saved_backup_hash then
      log.error("Error while saving the backup commit hash. Traceback:\n" .. backup_err)
    end
  end
end

-- update_doom saves the current commit/release hash into a file for future
-- restore if needed and then updates Doom.
functions.update_doom = function()
  save_backup_hashes()

  log.info("Pulling Doom remote changes ...")

  local updater = async:new({
    cmd = "git pull",
    cwd = system.doom_root,
    on_stdout = function(_, data)
      if data then
        log.info("Successfully updated Doom!")
        --- Completely reload Doom Nvim
        require("doom.modules.built-in.reloader").full_reload()
      end
    end,
    on_stderr = function(err, data)
      if err then
        log.error("Error while updating Doom. Traceback:\n" .. err)
      elseif data then
        log.error("Error while updating Doom. Traceback:\n" .. data:gsub("[\r\n]", ""))
      end
    end,
  })
  updater:start()
end

-- rollback_doom will rollback the local doom version to an older one
-- in case that the local one is broken
functions.rollback_doom = function()
  -- Backup file for main (stable) branch
  local releases_database_path = string.format("%s%s.doom_releases", system.doom_root, system.sep)
  -- Backup file for development branch
  local rolling_backup = string.format("%s%s.doom_backup_hash", system.doom_root, system.sep)

  -- Check if there's a rollback file and sets the rollback type
  if vim.fn.filereadable(releases_database_path) == 1 then
    -- Get the releases database and split it into a table
    local doom_releases = fs.read_file(releases_database_path)

    -- Put all the releases into a table so we can sort them later
    local releases = {}
    for release in doom_releases:gmatch("[^\r\n]+") do
      table.insert(releases, release)
    end
    -- Sort the releases table
    local sorted_releases = {}
    for idx, release in ipairs(releases) do
      sorted_releases[#releases + 1 - idx] = release:gsub("refs/tags/", "")
    end

    -- Check the current commit hash and compare it with the ones in the
    -- releases table
    local current_version
    local current_commit = utils.get_git_output("rev-parse HEAD", true)
    for _, version_info in ipairs(sorted_releases) do
      for release_hash, version in version_info:gmatch("(%w+)%s(%w+%W+%w+%W+%w+)") do
        if release_hash == current_commit then
          current_version = version
        end
      end
    end
    -- If the current_version variable is still nil then
    -- fallback to latest version
    if not current_version then
      -- next => index, SHA vX.Y.Z
      local _, release_info = next(releases, nil)
      -- split => { SHA, vX.Y.Z }, [2] => vX.Y.Z
      current_version = vim.split(release_info, " ")[2]
    end

    local rollback_sha, rollback_version
    local break_loop = false
    for _, version_info in ipairs(releases) do
      for commit_hash, release in version_info:gmatch("(%w+)%s(%w+%W+%w+%W+%w+)") do
        if release:gsub("v", "") < current_version:gsub("v", "") then
          rollback_sha = commit_hash
          rollback_version = release
          break_loop = true
          break
        end
      end
      if break_loop then
        break
      end
    end

    log.info("Reverting back to version " .. rollback_version .. " (" .. rollback_sha .. ") ...")
    local rolled_back, rolled_err = xpcall(function()
      os.execute(system.git_workspace .. "checkout " .. rollback_sha)
    end, debug.traceback)

    if not rolled_back then
      log.error(
        "Error while rolling back to version "
          .. rollback_version
          .. " ("
          .. rollback_sha
          .. "). Traceback:\n"
          .. rolled_err
      )
    end

    log.info(
      "Successfully rolled back Doom to version "
        .. rollback_version
        .. " ("
        .. rollback_sha
        .. "), please restart"
    )
  elseif vim.fn.filereadable(rolling_backup) == 1 then
    local backup_commit = fs.read_file(rolling_backup):gsub("[\r\n]+", "")
    log.info("Reverting back to commit " .. backup_commit .. " ...")
    local rolled_back, rolled_err = xpcall(function()
      os.execute(system.git_workspace .. "checkout " .. backup_commit)
    end, debug.traceback)

    if not rolled_back then
      log.error(
        "Error while rolling back to commit " .. backup_commit .. ". Traceback:\n" .. rolled_err
      )
    end

    log.info("Successfully rolled back Doom to commit " .. backup_commit .. ", please restart")
  else
    log.error("There are no backup files to rollback")
  end
end

-- edit_config creates a prompt to modify a doom configuration file
functions.edit_config = function()
  local selected_config = tonumber(vim.fn.inputlist({
    "Select a configuration file to edit:",
    "1. doom_config.lua",
    "2. doom_modules.lua",
    "3. doom_userplugins.lua",
  }))
  local direction = config.doom.vertical_split and "vert " or ""
  local open_command = config.doom.new_file_split and "split" or "edit"

  if selected_config == 1 then
    vim.cmd(("%s%s %s"):format(direction, open_command, require("doom.core.config").source))
  elseif selected_config == 2 then
    vim.cmd(("%s%s %s"):format(direction, open_command, require("doom.core.config.modules").source))
  elseif selected_config == 3 then
    vim.cmd(
      ("%s%s %s"):format(direction, open_command, require("doom.core.config.userplugins").source)
    )
  elseif selected_config ~= 0 then
    log.error("Invalid option selected.")
  end
end

-- followings are called from lua/doom/extras/keybindings/leader.lua
--
-- toggle_background() -- <leader>tb -- toggle background light/dark
functions.toggle_background = function()
  local background = vim.go.background
  if background == "light" then
    vim.go.background = "dark"
    print("background=dark")
  else
    vim.go.background = "light"
    print("background=light")
  end
end

-- toggle_completion() -- <leader>tc -- toggle completion
vim.g.cmp_toggle_flag = true -- initialize
local normal_buftype = function()
  return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
functions.toggle_completion = function()
  local ok, cmp = xpcall(require, debug.traceback, "cmp")
  if ok then
    local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
    if next_cmp_toggle_flag then
      print("completion on")
    else
      print("completion off")
    end
    cmp.setup({
      enabled = function()
        vim.g.cmp_toggle_flag = next_cmp_toggle_flag
        if next_cmp_toggle_flag then
          return normal_buftype
        else
          return next_cmp_toggle_flag
        end
      end,
    })
  else
    print("completion not available")
  end
end

-- toggle_signcolumn() -- <leader>tg -- signcolumn auto/no
functions.toggle_signcolumn = function()
  local signcolumn = vim.o.signcolumn
  if signcolumn == "no" then
    vim.o.signcolumn = "auto"
    print("signcolumn=auto")
  else
    vim.o.signcolumn = "no"
    print("signcolumn=no")
  end
end

-- set_indent() -- <leader>ti -- set the indent and tab related numbers
functions.set_indent = function()
  local indent = tonumber(
    vim.fn.input(
      "Set all tab related options to a specified number and set expandtab\n(0 to reset to vim defaults, ? to print current settings): "
    )
  )
  if (indent == nil) or (indent < 0) then
    vim.cmd("set softtabstop? tabstop? shiftwidth? expandtab?")
  elseif indent > 0 then
    vim.o.tabstop = indent
    vim.o.softtabstop = indent
    vim.o.shiftwidth = indent
    vim.o.expandtab = true
    print(("\nindent=%i, expandtab"):format(indent))
  else -- indent == 0
    vim.o.tabstop = 8
    vim.o.softtabstop = 0
    vim.o.shiftwidth = 8
    vim.o.expandtab = false
    print("\nindent=8, noexpandtab")
  end
end

-- change_number() -- <leader>tn -- change the number display modes
functions.change_number = function()
  local number = vim.o.number
  local relativenumber = vim.o.relativenumber
  if (number == false) and (relativenumber == false) then
    vim.o.number = true
    vim.o.relativenumber = false
    print("number on, relativenumber off")
  elseif (number == true) and (relativenumber == false) then
    vim.o.number = false
    vim.o.relativenumber = true
    print("number off, relativenumber on")
  elseif (number == false) and (relativenumber == true) then
    vim.o.number = true
    vim.o.relativenumber = true
    print("number on, relativenumber on")
  else -- (number == true) and (relativenumber == true) then
    vim.o.number = false
    vim.o.relativenumber = false
    print("number off, relativenumber off")
  end
end

-- toggle_autopairs() -- <leader>tp -- toggle autopairs
functions.toggle_autopairs = function()
  local ok, autopairs = xpcall(require, debug.traceback, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
      print("autopairs on")
    else
      autopairs.disable()
      print("autopairs off")
    end
  else
    print("autopairs not available")
  end
end

-- toggle_spell() -- <leader>ts -- toggle spell
functions.toggle_spell = function()
  if vim.o.spell then
    vim.o.spell = false
    print("spell off")
  else
    if vim.o.spelllang == nil then
      vim.o.spelllang = "en_us"
    end
    vim.o.spell = true
    print(("spell on, lang %s"):format(vim.o.spelllang))
  end
end

-- change_syntax() -- <leader>tx -- toggle syntax/treesetter
functions.change_syntax = function()
  local ok, parsers = xpcall(require, debug.traceback, "nvim-treesitter.parsers")
  if ok and parsers and parsers.has_parser() then
    if vim.o.syntax then
      vim.cmd("TSBufDisable highlight")
      vim.cmd("syntax off")
      print("syntax off, treesetter off")
    else
      vim.cmd("TSBufEnable highlight")
      vim.cmd("syntax on")
      print("syntax on, treesetter on")
    end
  else
    if vim.o.syntax then
      vim.cmd("syntax off")
      print("syntax off")
    else
      vim.cmd("syntax on")
      print("syntax on")
    end
  end
end

functions.sugar_folds = function()
  local start_line = vim.fn.getline(vim.v.foldstart):gsub("\t", ("\t"):rep(vim.opt.tabstop:get()))
  return string.format("%s ... (%d lines)", start_line, vim.v.foldend - vim.v.foldstart + 1)
end

return functions
