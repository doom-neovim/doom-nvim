---[[---------------------------------------]]---
--    system - Doom Nvim system integration    --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local system = {}
local stdpath = vim.fn.stdpath
local config_dir = stdpath("config"):match(".*[/\\]"):sub(1, -2)

system.sep = package.config:sub(1, 1)

-- The doom-nvim root directory, works as a fallback for looking Doom Nvim configurations
-- in case that doom_configs_root directory does not exists.
system.doom_root = stdpath("config")

-- The doom-nvim configurations root directory
system.doom_configs_root = table.concat({ config_dir, "doom-nvim" }, system.sep)

local testdir = vim.loop.fs_opendir(system.doom_configs_root)
if testdir then
  vim.loop.fs_closedir(testdir)
else
  system.doom_configs_root = stdpath("config")
end

-- The doom-nvim logs file path
system.doom_logs = table.concat({ stdpath("data"), "doom.log" }, system.sep)

-- The doom-nvim bug report file path
system.doom_report = table.concat({ stdpath("data"), "doom_report.md" }, system.sep)

-- The git workspace for doom-nvim, e.g. 'git -C /home/JohnDoe/.config/nvim'
system.git_workspace = string.format("git -C %s ", stdpath("config"))

return system
