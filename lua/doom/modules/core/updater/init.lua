--[[
--  Doom updater
--
--  Update your doom nvim config using the :DoomUpdate command.
--  Currently disabled (not imported) because I'm not sure how nicely this will play
--  with user's own changes to config.lua/modules.lua.  May re-enable in future once
--  we land on a strategy to solve this.
--
--  One solution could be automatically creating a `user-config` branch on first load
--  and automatically pulling from tags into the `user-config` branch.
--
--  Works by fetching tags from origin, comparing semantic versions and checking out
--  the tag with the greatest semantic version.
--
--]]
local updater = {}

--- @class DoomVersion
--- @field message string
--- @field major number
--- @field minor number
--- @field patch number

updater.packages = {
  ["plenary.nvim"] = {
    "nvim-lua/plenary.nvim",
    commit = "9069d14a120cadb4f6825f76821533f2babcab92",
    module = "plenary",
  },
}

updater._cwd = vim.fn.stdpath("config")

--- Using git and plenary jobs gets a list of all available versions to update to
---@param callback function Handler to receive the list of versions
updater._fetch_versions = function(callback)
  local versions = {}
  local Job = require("plenary.job")
  local job = Job:new({
    command = "git",
    args = { "fetch", "--tags", "--all" },
    cwd = updater._cwd,
  })

  job:and_then(Job:new({
    command = "git",
    args = { "log", "--no-walk", "--tags", '--pretty="%d %s"' },
    cwd = updater._cwd,
    on_exit = function(j, err_code)
      if err_code ~= 0 then
        callback(nil, "Git error when fetching tags" .. j:result())
        return
      end

      local result = ""
      for _, l in ipairs(j:result()) do
        result = result .. l .. "\n"
        local tag = l:match("%((.-)[%),]")
        local v = tag:gsub("%a", ""):gsub("[:%c%s]", "")
        local major, minor, patch = unpack(vim.split(v, "%."))

        table.insert(versions, {
          message = l,
          major = tonumber(major),
          minor = tonumber(minor),
          patch = tonumber(patch),
        })
      end
      callback(versions)
    end,
  }))
  job:start()
end

--- Gets the latest version from a list of versions
---@param  versions DoomVersion[] List of versions from _fetch_versions
---@return DoomVersion the latest version from the list
updater._get_latest_from_versions = function(versions)
  local latest = nil
  for _, v in ipairs(versions) do
    if latest == nil then
      latest = v
    elseif updater._is_version_newer(latest, v) then
      latest = v
    end
  end
  return latest
end

--- Check if alternate version is newer than another version
---@param curr DoomVersion The base/current version
---@param alternate DoomVersion The alternate version to compare
---@return boolean True if alternate is newer than curr
updater._is_version_newer = function(curr, alternate)
  return curr.major < alternate.major
    or (curr.major == alternate.major and curr.minor < alternate.minor)
    or (curr.major == alternate.major and curr.minor == alternate.minor and curr.patch < alternate.patch)
end

--- Checks for updates and notifys user if a new version is available
updater._check_updates = function()
  print("Check updates")
  updater._fetch_versions(function(versions, err)
    print(vim.inspect(versions))
    local log = require("doom.utils.logging")
    print("Handling check updates with versions")
    if err then
      log.error(("reloader: Failed to check for updates: %s."):format(err))
      return
    end
    local utils = require("doom.utils")
    local latest = updater._get_latest_from_versions(versions)
    if updater._is_version_newer(utils.version, latest) then
      local s = (
        "updater: New version of doom-nvim available(v%d.%d.%d).  Run `:DoomUpdate` to update."
      ):format(latest.major, latest.minor, latest.patch)
      log.warn(s)
    else
      log.warn("updater: No new version detected, up to date.")
    end
  end)
end

--- Checks for updates and updates if a new version is available.
updater._update = function()
  updater._fetch_versions(function(versions, err)
    if err then
      local log = require("doom.utils.logging")
      log.error(("reloader: Failed to check for updates: %s."):format(err))
      return
    end
    local utils = require("doom.utils")
    local latest = updater._get_latest_from_versions(versions)
    if updater._is_version_newer(utils.version, latest) then
      updater._checkout_version(latest)
    end
  end)
end

--- Checks out doom-nvim to a specific version, used by update but can also be used to rollback.
---@param version DoomVersion
updater._checkout_version = function(version)
  local version_string = ("%d.%d.%d"):format(version.major, version.minor, version.patch)
  local tag_string = "tags/v" .. version_string

  local log = require("doom.utils.logging")
  log.info("Attempting to checkout " .. tag_string)

  local Job = require("plenary.job")
  Job:new({
    command = "git",
    args = { "merge", tag_string },
    cwd = updater._cwd,
    on_exit = function(j, return_val)
      print(vim.inspect(j:result()) .. vim.inspect(return_val))
      log.info(( "updater: Updated to v%s."):format(version_string))
    end,
  }):start()
end

-- recursive check that user settings mirror `core/doom_global.lua`
-- with the new defaults. don't modify any user settings. only
-- add.
updater.sync_user_settings = function()
end


updater.cmds = {
  -- {
  --   "DoomUpdate",
  --   function()
  --     updater._update()
  --   end,
  -- },
  -- {
  --   "DoomCheckUpdates",
  --   function()
  --     updater._check_updates()
  --   end,
  -- },
}
return updater
