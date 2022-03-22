-- NOTE: Can't require "doom.utils.logging" in the top level, because `doom`
-- may not exist here.
local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")
local async = require("doom.utils.async")
local is_module_enabled = utils.is_module_enabled

local functions = {}

-- Quit Neovim and dump all messages to doom.log file.
-- @tparam bool dont_write If doom shouldn't save before exiting
-- @tparam bool force If doom should force the exiting
functions.quit_doom = function(dont_write, force)
  local quit_cmd = ""
  if not dont_write then
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
  local log = require("doom.utils.logging")
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
  local log = require("doom.utils.logging")
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
  local log = require("doom.utils.logging")
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
-- TODO: Port to module architecture
functions.update_doom = function()
  local log = require("doom.utils.logging")
  save_backup_hashes()

  log.info("Pulling Doom remote changes ...")

  local updater = async:new({
    cmd = "git pull",
    cwd = system.doom_root,
    on_stdout = function(_, data)
      if data then
        log.info("Successfully updated Doom!")
        --- Completely reload Doom Nvim
        require("doom.utils.reloader").full_reload()
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
-- TODO: Port to module architecture
functions.rollback_doom = function()
  local log = require("doom.utils.logging")
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

local function bool2str(bool)
  return bool and "on" or "off"
end

-- Toggle background="dark"|"light"
functions.toggle_background = function()
  local background = vim.go.background
  if background == "light" then
    vim.go.background = "dark"
  else
    vim.go.background = "light"
  end
  -- XXX: Should we "just print"? Maybe and info log?
  print(string.format("background=%s", vim.go.background))
end

-- Only define if lsp enabled, it only makes sense there.
if is_module_enabled("lsp") then
  -- Toggle completion (by running cmp setup again).
  functions.toggle_completion = function()
    _doom.cmp_enable = not _doom.cmp_enable
    print(string.format("completion=%s", bool2str(_doom.cmp_enable)))
  end
end

-- Toggle signcolumn="auto"|"no"
functions.toggle_signcolumn = function()
  local signcolumn = vim.o.signcolumn
  if signcolumn == "no" then
    vim.opt.signcolumn = "auto"
  else
    vim.opt.signcolumn = "no"
  end
  print(string.format("signcolumn=%s", vim.opt.signcolumn))
end

-- Set the indent and tab related numbers.
-- Negative numbers mean tabstop -- Really though? Tabs?
functions.set_indent = function()
  local indent = tonumber(
    vim.fn.input("Set indent (>0 uses spaces, <0 uses tabs, 0 uses vim defaults): ")
  )
  if not indent then
    indent = -8
  end
  vim.opt.expandtab = indent > 0
  indent = math.abs(indent)
  vim.opt.tabstop = indent
  vim.opt.softtabstop = indent
  vim.opt.shiftwidth = indent
  print(string.format("indent=%d %s", indent, vim.opt.expandtab and "spaces" or "tabs"))
end

-- Change the number display modes.
functions.change_number = function()
  local number = vim.opt.number
  local relativenumber = vim.opt.relativenumber
  if (number == false) and (relativenumber == false) then
    vim.opt.number = true
    vim.opt.relativenumber = false
  elseif (number == true) and (relativenumber == false) then
    vim.opt.number = false
    vim.opt.relativenumber = true
  elseif (number == false) and (relativenumber == true) then
    vim.opt.number = true
    vim.opt.relativenumber = true
  else -- (number == true) and (relativenumber == true) then
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
  print("number=%s, relativenumber=%s", bool2str(vim.opt.number), bool2str(vim.opt.relativenumber))
end

-- Toggle autopairs.
if is_module_enabled("autopairs") then
  functions.toggle_autopairs = function()
    local autopairs = require("nvim-autopairs")
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
  end
end

-- Toggle spell.
functions.toggle_spell = function()
  vim.opt.spell = not vim.opt.spell
  print(string.format("spell=%s", bool2str(vim.opt.spell)))
end

-- Toggle syntax/treesitter
functions.change_syntax = function()
  local parsers = require("nvim-treesitter.parsers")
  if parsers.has_parser() then
    if vim.opt.syntax then
      vim.cmd("TSBufDisable highlight")
      vim.cmd("syntax off")
    else
      vim.cmd("TSBufEnable highlight")
      vim.cmd("syntax on")
    end
    local state = bool2str(vim.opt.syntax)
    print(string.format("syntax=%s, treesitter=%s", state, state))
  else
    if vim.o.syntax then
      vim.cmd("syntax off")
    else
      vim.cmd("syntax on")
    end
    local state = bool2str(vim.opt.syntax)
    print(string.format("syntax=%s", state))
  end
end

-- Better folding function.
functions.sugar_folds = function()
  local start_line = vim.fn.getline(vim.v.foldstart):gsub("\t", ("\t"):rep(vim.opt.tabstop:get()))
  return string.format("%s ... (%d lines)", start_line, vim.v.foldend - vim.v.foldstart + 1)
end

return functions
