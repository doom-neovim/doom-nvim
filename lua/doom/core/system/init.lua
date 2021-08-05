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
  if (jit and jit.os == "Windows") or (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) then
    return os.getenv("USERPROFILE") .. "\\AppData\\Local\\"
  end

  return (os.getenv("XDG_CONFIG_HOME") and os.getenv("XDG_CONFIG_HOME"))
    or (os.getenv("HOME") .. "/.config")
end

-- get_separator will return the system paths separator, e.g. \ for Windows and / for *nix
-- @return string
local function get_separator()
  if (jit and jit.os == "Windows") or (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) then
    return "\\"
  end

  return "/"
end

M.config_dir = get_config_dir()

M.sep = get_separator()

return M
