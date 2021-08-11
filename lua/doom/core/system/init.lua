---[[---------------------------------------]]---
--    system - Doom Nvim system integration    --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local M = {}

-- get_config_dir will get the config path based in the current system, e.g.
-- 'C:\Users\JohnDoe\AppData\Local' for windows and '~/.config' for *nix
-- @return string
local function get_config_dir()
  if string.find(vim.loop.os_uname().sysname, "Windows") then
    return os.getenv("USERPROFILE") .. "\\AppData\\Local\\"
  end

  return (os.getenv("XDG_CONFIG_HOME") and os.getenv("XDG_CONFIG_HOME"))
    or (os.getenv("HOME") .. "/.config")
end

-- get_separator will return the system paths separator, e.g. \ for Windows and / for *nix
-- @return string
local function get_separator()
  if vim.loop.os_uname().sysname == "Windows" then
    return "\\"
  end

  return "/"
end

M.config_dir = get_config_dir()

M.sep = get_separator()

-- The doom-nvim root directory, works as a fallback for looking Doom Nvim configurations
-- in case that doom_configs_root directory does not exists.
M.doom_root = string.format("%s%snvim", M.config_dir, M.sep)
-- The doom-nvim configurations root directory
M.doom_configs_root = string.format("%s%sdoom-nvim", M.config_dir, M.sep)
-- The doom-nvim logs file path
M.doom_logs = vim.fn.stdpath("data") .. string.format("%sdoom.log", M.sep)
-- The doom-nvim bug report file path
M.doom_report = vim.fn.stdpath("data") .. string.format("%sdoom_report.md", M.sep)
-- The git workspace for doom-nvim, e.g. 'git -C /home/JohnDoe/.config/nvim'
M.git_workspace = string.format("git -C %s ", M.doom_root)

return M
