local log = require("doom.extras.logging")
local term

if packer_plugins and packer_plugins["toggleterm.nvim"] then
  term = require("toggleterm.terminal").Terminal
else
  log.error(
    "Doom compiler needs toggleterm plugin, please uncomment the 'terminal' entry in your doom_modules.lua"
  )
end

local M = {}

-- Currently supported languages,
-- filetype → binary to execute
local languages = {
  rust = "rust",
  go = "go",
}

-- compile will compile the project in the current working directory
M.compile = function()
  local filetype = vim.bo.filetype
  local lang_bin = languages[filetype]

  local compiled_code, err = xpcall(function()
    if lang_bin then
      -- Set the properly builder command for the project
      local compiler_cmd
      if lang_bin == "rust" then
        compiler_cmd = "cargo build"
      elseif lang_bin == "go" then
        -- NOTE: Untested because I am not using Go anymore, this
        -- command should look for a main program in the cwd
        compiler_cmd = "go build ."
      end
      local compiler = term:new({ cmd = compiler_cmd, hidden = true, close_on_exit = false })
      compiler:open()
    else
      log.error("The filetype " .. filetype .. " is not yet supported in the Doom compiler plugin")
    end
  end, debug.traceback)

  if not compiled_code then
    log.error("Error while trying to compile the project. Traceback:\n" .. err)
  end
end

-- compile_and_run compiles the project and then runs it
M.compile_and_run = function()
  local filetype = vim.bo.filetype
  local lang_bin = languages[filetype]

  local compiled_code, err = xpcall(function()
    if lang_bin then
      -- Set the properly builder command for the project
      local compiler_cmd
      if lang_bin == "rust" then
        compiler_cmd = "cargo run"
      elseif lang_bin == "go" then
        -- NOTE: Untested because I am not using Go anymore
        -- TODO: Maybe try to find other way for this if not everyone
        --       uses a main.go file as their entry points?
        compiler_cmd = "go run main.go"
      end
      local compiler_and_runner = term:new({
        cmd = compiler_cmd,
        hidden = true,
        close_on_exit = false,
      })
      compiler_and_runner:open()
    else
      log.error("The filetype " .. filetype .. " is not yet supported in the Doom compiler plugin")
    end
  end, debug.traceback)

  if not compiled_code then
    log.error("Error while trying to compile and run the project. Traceback:\n" .. err)
  end
end

return M
