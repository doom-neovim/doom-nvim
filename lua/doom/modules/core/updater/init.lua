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
    commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7",
    module = "plenary",
  },
}

updater.settings = {
  unstable = false,
}

updater._cwd = vim.fn.stdpath("config")

--- Using git and plenary jobs gets a list of all available versions to update to
---@param callback function Handler to receive the list of versions
updater._pull_tags = function(callback)
  local Job = require("plenary.job")
  Job
    :new({
      command = "git",
      args = { "fetch", "--tags", "--all" },
      cwd = updater._cwd,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          callback(nil, "Error pulling tags... \n\n " .. vim.inspect(j.result()))
        end
        callback(j:result())
      end,
    })
    :start()
end

--- Gets the current commit sha or error
---@param callback function(commit_sha, error_string)
updater._get_commit_sha = function(callback)
  local Job = require("plenary.job")

  Job
    :new({
      command = "git",
      args = { "rev-parse", "HEAD" },
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          callback(nil, "Error getting current commit... \n\n" .. vim.inspect(j:result()))
          return
        end
        local result = j:result()
        if #result == 1 then
          callback(result[1])
        else
          callback(nil, "Error getting current commit... No output.")
        end
      end,
    })
    :start()
end

--- Given a version string, checks if it's an alpha/beta version
---@param version string
---@return boolean
local is_version_unstable = function(version)
  return version:match("alpha") ~= nil or version:match("beta") ~= nil
end

--- Gets all version tags as a table of strings
---@param callback function(all_versions, error_string)
updater._get_all_versions = function(callback)
  local Job = require("plenary.job")
  Job
    :new({
      command = "git",
      args = { "tag", "-l", "--sort", "-version:refname" },
      cwd = updater._cwd,
      on_exit = function(j)
        ---@param version string
        local filter_predicate = function(version)
          local is_unsupported = version:match("^1") or version:match("v2") or version:match("v3")
          if is_unsupported or (not updater.settings.unstable and is_version_unstable(version)) then
            return false
          end
          return true
        end
        local result = vim.tbl_filter(filter_predicate, j:result())
        callback(result)
      end,
    })
    :start()
end

--- Using a commit sha, finds the first version tag in commit history
---@param commit_sha string
---@param callback function(version_tag, error_string)
updater._get_last_version_for_commit = function(commit_sha, callback)
  local Job = require("plenary.job")
  Job
    :new({
      command = "git",
      args = { "tag", "-l", "--sort", "-version:refname", "--merged", commit_sha },
      cwd = updater._cwd,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          callback(nil, "Error getting current version... \n\n " .. vim.inspect(j:result()))
          return
        end
        local result = j:result()
        if #result > 0 then
          callback(result[1])
        else
          callback(nil, "Error getting current version... No output.")
        end
      end,
    })
    :start()
end

--- Gets the current version and the latest upstream version
---@param callback function(current_version, latest_version, error_string)
updater._fetch_current_and_latest_version = function(callback)
  updater._pull_tags(function(_, pull_tags_error)
    if pull_tags_error then
      callback(nil, nil, pull_tags_error)
      return
    end
    updater._get_commit_sha(function(commit_sha, commit_sha_error)
      if commit_sha_error then
        callback(nil, nil, commit_sha_error)
        return
      end

      local cur_version, all_versions = nil, nil
      local try_compare_updates = function()
        if cur_version and all_versions then
          -- Find How many versions behind we are
          if #all_versions > 0 then
            callback(cur_version, all_versions[1])
            return
          else
            callback(nil, nil, "Error getting latest version.  The versions list is empty!")
          end
        end
      end

      updater._get_last_version_for_commit(commit_sha, function(version)
        cur_version = version
        try_compare_updates()
      end)

      updater._get_all_versions(function(all)
        all_versions = all
        try_compare_updates()
      end)
    end)
  end)
end

--- Entry point for `:DoomCheckUpdates`, fetches new tags, compares with current version and notifies results
---@param quiet boolean When enabled, disable all but error / needs update messages
updater.check_updates = function(quiet)
  local log = require("doom.utils.logging")
  if not quiet then
    vim.notify("updater: Checking updates...")
  end

  updater._fetch_current_and_latest_version(function(current_version, latest_version, error)
    vim.defer_fn(function()
      if error then
        log.error(("updater: Error checking updates... %s"):format(error))
        return
      end

      if current_version == latest_version then
        if not quiet then
          vim.notify(("updater: You are up to date! (%s)"):format(current_version))
        end
      else
        vim.notify(
          (
            "updater: There is a new version (%s).  You are currently on %s.  Run `:DoomUpdate` to update."
          ):format(latest_version, current_version)
        )
      end
    end, 0)
  end)
end

--- Attempts to merge a version into the current branch, fails if working tree is dirty
---@param target_version string
---@param callback function(error_string)
updater._try_merge_version = function(target_version, callback)
  local Job = require("plenary.job")

  local merge_job = Job:new({
    command = "git",
    args = { "merge", target_version },
    cwd = updater._cwd,
    on_exit = function(j, exit_code)
      if exit_code ~= 0 then
        callback(
          "Error merging "
            .. target_version
            .. ".  You may have to resolve the merge conflict manually... \n\n "
            .. vim.inspect(table.concat(j:result(), "\n"))
        )
        return
      end
      callback(nil)
    end,
  })

  Job
    :new({
      command = "git",
      args = { "diff", "--quiet" },
      cwd = updater._cwd,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          callback(
            (
              "Tried to update to new version %s but could not due to uncommitted changes.  Please commit or stash your changes before trying again."
            ):format(target_version)
          )
        else
          merge_job:start()
        end
      end,
    })
    :start()
end

--- Gets the name of the current working branch
---@param callback function(branch_name, error)
updater._get_branch_name = function(callback)
  local Job = require("plenary.job")
  Job
    :new({
      command = "git",
      args = { "symbolic-ref", "--short", "-q", "HEAD" },
      cwd = updater._cwd,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          callback(nil, "Error getting branch name... \n\n " .. vim.inspect(j:result()))
          return
        end
        local result = j:result()
        if #result > 0 then
          callback(result[1])
        else
          callback(nil, "Error getting branch name... No output.")
        end
      end,
    })
    :start()
end

--- Entry point for `:DoomUpdate`, fetches new tags, compares with current version and attempts to merge new tags into current branch
updater._try_update = function()
  local log = require("doom.utils.logging")
  vim.notify("updater: Attempting to update...")

  updater._get_branch_name(function(branch_name, error)
    -- Ensure user is not in main/next branch
    local error_message = nil
    if error then
      error_message = error
    elseif branch_name == "next" or branch_name == "main" then
      error_message =
        "You cannot use `:DoomUpdate` from within the `main` branch.  Please make a new branch for your custom config (`git checkout -b my-config`)."
    end

    if error_message then
      vim.defer_fn(function()
        log.error(("updater: %s"):format(error_message))
      end, 0)
      return
    end

    updater._fetch_current_and_latest_version(
      function(current_version, latest_version, get_version_error)
        vim.defer_fn(function()
          if get_version_error then
            log.error(("updater: Error checking updates... %s"):format(get_version_error))
            return
          end

          if current_version == latest_version then
            vim.notify(
              ("updater: You are already using the latest version! (%s)"):format(current_version)
            )
          else
            -- Attempt to merge new version into user's custom config branch
            updater._try_merge_version(latest_version, function(merge_error)
              vim.defer_fn(function()
                if merge_error then
                  log.error(("updater: Error updating... %s"):format(merge_error))
                else
                  local message = ("updater: Updated to version %s!"):format(latest_version)
                  -- Only print changelog info if it's a stable release
                  if not is_version_unstable(latest_version) then
                    message = message
                      .. (
                        "  Check the changelog at https://github.com/doom-neovim/doom-nvim/releases/tag/%s"
                      ):format(latest_version)
                  end
                  vim.notify(message)
                end
              end, 0)
            end)
          end
        end, 0)
      end
    )
  end)
end

updater.cmds = {
  {
    "DoomUpdate",
    function()
      updater._try_update()
    end,
  },
  {
    "DoomCheckUpdates",
    function()
      updater.check_updates(false)
    end,
  },
}
return updater
