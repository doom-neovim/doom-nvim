-- This file only has side-effects.

-- Doom Nvim commands.

-- Set a custom command to open Doom Nvim user manual can be called by using
-- :DoomManual.
vim.cmd([[command! DoomManual lua require("doom.core.functions").open_docs()]])
-- Set a custom command to create a crash report can be called by using
-- :DoomReport.
vim.cmd([[command! DoomReport lua require("doom.core.functions").create_report(]])

vim.cmd([[command! -nargs=* DoomNuke lua require("doom.core.functions").nuke(<f-args>)]])
