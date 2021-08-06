---[[---------------------------------------]]---
--      functions - Doom Nvim Functions        --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local log = require("doom.extras.logging")
local utils = require("doom.utils")
local system = require("doom.core.system")
local config = require("doom.core.config").load_config()

local M = {}

log.debug("Loading Doom functions module ...")

-- check_plugin checks if the given plugin exists
-- @tparam string plugin_name The plugin name, e.g. nvim-tree.lua
-- @tparam string path Where should be searched the plugin in packer's path, defaults to `start`
-- @return bool
M.check_plugin = function(plugin_name, path)
  if not path then
    path = "start"
  end

  return vim.fn.isdirectory(
    vim.fn.stdpath("data") .. "/site/pack/packer/" .. path .. "/" .. plugin_name
  ) == 1
end

-- is_plugin_disabled checks if the given plugin is disabled in doomrc
-- @tparam string plugin The plugin identifier, e.g. statusline
-- @return bool
M.is_plugin_disabled = function(plugin)
  local doomrc = require("doom.core.config.doomrc").load_doomrc()

  -- Iterate over all doomrc sections (e.g. ui) and their plugins
  for _, section in pairs(doomrc) do
    if utils.has_value(section, plugin) then
      return false
    end
  end

  return true
end

-- Load user-defined settings from the Neovim field in the doomrc
-- @param settings_tbl The settings table to iterate over
-- @param scope The settings scope, e.g. autocmds
M.load_custom_settings = function(settings_tbl, scope)
  -- If the provided settings table is not empty
  if next(settings_tbl) ~= nil then
    log.debug("Loading custom " .. scope .. " ...")
    if scope == "autocmds" then
      utils.create_augroups(settings_tbl)
    elseif scope == "commands" then
      for _, cmd in ipairs(settings_tbl) do
        vim.cmd(cmd)
      end
    elseif scope == "functions" then
      for _, func_body in pairs(settings_tbl) do
        func_body()
      end
    elseif scope == "mappings" then
      for _, map in ipairs(settings_tbl) do
        -- scope, lhs, rhs, options
        vim.api.nvim_set_keymap(map[1], map[2], map[3], map[4] and map[4] or {})
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
M.reload_custom_settings = function()
  -- Get the user-defined settings, the 'nvim' field in our 'doom_config.lua'
  local custom_settings = require("doom.core.config").load_config().nvim
  -- iterate over all the custom settings fields, e.g. global_variables, mappings, etc.
  for scope, _ in pairs(custom_settings) do
    M.load_custom_settings(custom_settings[scope], scope)
  end
end

-- Change the 'doom_config.lua' file configurations for the colorscheme and the
-- background if they were changed by the user within Neovim
M.change_colors_and_bg = function()
  local changed_colorscheme, err = pcall(function()
    log.debug("Checking if the colorscheme or background were changed ...")
    local target_colorscheme = vim.g.colors_name
    local target_background = vim.opt.background:get()

    -- Set the correct path for the 'doom_config.lua' file
    local doom_config_path
    if
      utils.file_exists(string.format("%s%sdoom_config.lua", system.doom_configs_root, system.sep))
    then
      doom_config_path = string.format("%s%sdoom_config.lua", system.doom_configs_root, system.sep)
    elseif
      utils.file_exists(string.format("%s%sdoom_config.lua", system.doom_root, system.sep))
    then
      doom_config_path = string.format("%s%sdoom_config.lua", system.doom_root, system.sep)
    end

    if target_colorscheme ~= config.doom.colorscheme then
      local doom_config = utils.read_file(doom_config_path)
      doom_config = string.gsub(
        doom_config,
        string.format('"%s"', config.doom.colorscheme:gsub("[%-]", "%%%1")),
        string.format('"%s"', target_colorscheme:gsub("[%-]", "%%%1"))
      )
      utils.write_file(doom_config_path, doom_config, "w+")
      log.debug("Colorscheme successfully changed to " .. target_colorscheme)
    end
    if target_background ~= config.doom.colorscheme_bg then
      local doom_config = utils.read_file(doom_config_path)
      doom_config = string.gsub(
        doom_config,
        string.format('"%s"', config.doom.colorscheme_bg),
        string.format('"%s"', target_background)
      )
      utils.write_file(doom_config_path, doom_config, "w+")
      log.debug("Background successfully changed to " .. target_background)
    end
  end)

  if not changed_colorscheme then
    log.error("Unable to write to the doom_config.lua file. Traceback:\n" .. err)
  end
end

-- Quit Neovim and change the colorscheme at doomrc if the colorscheme is not the same,
-- dump all messages to doom.log file
-- @tparam bool write If doom should save before exiting
-- @tparam bool force If doom should force the exiting
M.quit_doom = function(write, force)
  M.change_colors_and_bg()

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
M.check_updates = function()
  local updated_plugins, err = pcall(function()
    log.info("Updating the outdated plugins ...")
    vim.cmd("PackerSync")
  end)

  if not updated_plugins then
    log.error("Unable to update plugins. Traceback:\n" .. err)
  end
end

-- create_report creates a markdown report. It's meant to be used when a bug
-- occurs, useful for debugging issues.
M.create_report = function()
  local date = os.date("%Y-%m-%d %H:%M:%S")
  local log_date_format = os.date("%a %d %b %Y")

  local created_report, err = pcall(function()
    -- Get and save only the warning and error logs from today
    local today_logs = {}
    local doom_logs = vim.split(utils.read_file(system.doom_logs), "\n")
    for _, doom_log in ipairs(doom_logs) do
      if
        string.find(doom_log, "ERROR " .. log_date_format)
        or string.find(doom_log, "WARN  " .. log_date_format)
      then
        table.insert(today_logs, doom_log)
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
    utils.write_file(system.doom_report, report, "w+")
    log.info("Report created at " .. system.doom_report)
  end)

  if not created_report then
    log.error("Error while writing report. Traceback:\n" .. err)
  end
end

-- save_backup_hashes saves the commits or releases SHA for future rollbacks
local function save_backup_hashes()
  -- Check for the current branch
  local branch_handler = io.popen(system.git_workspace .. "branch --show-current")
  local git_branch = branch_handler:read("*a"):gsub("[\r\n]", "")
  branch_handler:close()

  if git_branch == "main" then
    local releases_database_path = string.format("%s%s.doom_releases", system.doom_root, system.sep)

    -- Fetch for a file containing the releases tags
    log.info("Saving the Doom releases for future rollbacks ...")
    local saved_releases, releases_err = pcall(function()
      -- Get the releases
      log.debug('Executing "' .. system.git_workspace .. 'show-ref --tags"')
      local releases_handler = io.popen(system.git_workspace .. "show-ref --tags")
      local doom_releases = releases_handler:read("*a")
      releases_handler:close()

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
        local current_releases = utils.read_file(releases_database_path)
        if current_releases ~= doom_releases then
          -- Write the first release in the list with 'w+' so the
          -- actual content will be overwritten by this one
          utils.write_file(releases_database_path, sorted_releases[1] .. "\n", "w+")
          -- Write the rest of the releases
          for idx, release in ipairs(sorted_releases) do
            -- Exclude the first release because we have already
            -- written it in the database file
            if idx ~= 1 then
              utils.write_file(releases_database_path, release .. "\n", "a+")
            end
          end
        end
      else
        for _, release in ipairs(sorted_releases) do
          utils.write_file(releases_database_path, release .. "\n", "a+")
        end
      end
    end)

    if not saved_releases then
      log.error("Error while saving the Doom releases. Traceback:\n" .. releases_err)
    end
  else
    -- Get the current commit SHA and store it into a hidden file
    log.info("Saving the current commit SHA for future rollbacks ...")
    local saved_backup_hash, backup_err = pcall(function()
      os.execute(
        system.git_workspace
          .. "rev-parse --short HEAD > "
          .. system.doom_root
          .. system.sep
          .. ".doom_backup_hash"
      )
    end)

    if not saved_backup_hash then
      log.error("Error while saving the backup commit hash. Traceback:\n" .. backup_err)
    end
  end
end

-- update_doom saves the current commit/release hash into a file for future
-- restore if needed and then updates Doom.
M.update_doom = function()
  save_backup_hashes()

  log.info("Pulling Doom remote changes ...")
  local updated_doom, update_err = pcall(function()
    os.execute(system.git_workspace .. "pull -q")
  end)

  if not updated_doom then
    log.error("Error while updating Doom. Traceback:\n" .. update_err)
  end
  -- Run syntax_on event to fix UI if it's broke after the git pull
  vim.cmd("syntax on")

  log.info("Successfully updated Doom, please restart")
end

-- rollback_doom will rollback the local doom version to an older one
-- in case that the local one is broken
M.rollback_doom = function()
  -- Backup file for main (stable) branch
  local releases_database_path = string.format("%s%s.doom_releases", system.doom_root, system.sep)
  -- Backup file for development branch
  local rolling_backup = string.format("%s%s.doom_backup_hash", system.doom_root, system.sep)

  -- Check if there's a rollback file and sets the rollback type
  if vim.fn.filereadable(releases_database_path) == 1 then
    -- Get the releases database and split it into a table
    local doom_releases = utils.read_file(releases_database_path)

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
    local commit_handler = io.popen(system.git_workspace .. "rev-parse HEAD")
    local current_commit = commit_handler:read("*a"):gsub("[\r\n]", "")
    commit_handler:close()
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
    local rolled_back, rolled_err = pcall(function()
      os.execute(system.git_workspace .. "checkout " .. rollback_sha)
    end)

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
    local backup_commit = utils.read_file(rolling_backup):gsub("[\r\n]+", "")
    log.info("Reverting back to commit " .. backup_commit .. " ...")
    local rolled_back, rolled_err = pcall(function()
      os.execute(system.git_workspace .. "checkout " .. backup_commit)
    end)

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
M.edit_config = function()
  local selected_config = tonumber(vim.fn.inputlist({
    "Select a configuration file to edit:",
    "1. doom_config.lua",
    "2. doomrc.lua",
    "3. plugins.lua",
  }))
  local open_command = config.doom.new_file_split and "split" or "edit"

  if selected_config == 1 then
    vim.cmd(string.format("%s %s%sdoom_config.lua", open_command, system.doom_root, system.sep))
  elseif selected_config == 2 then
    vim.cmd(string.format("%s %s%sdoomrc.lua", open_command, system.doom_root, system.sep))
  elseif selected_config == 3 then
    vim.cmd(string.format("%s %s%splugins.lua", open_command, system.doom_root, system.sep))
  elseif selected_config ~= 0 then
    log.error("Invalid option selected.")
  end
end

return M
