-- This file only has side-effects.

-- Doom Nvim commands.

-- Set a custom command to update Doom Nvim can be called by using :DoomUpdate.
vim.cmd([[command! DoomUpdate lua require("doom.core.functions").update_doom()]])
-- Set a custom command to rollback Doom Nvim version can be called by using
-- :DoomRollback.
vim.cmd([[command! DoomRollback lua require("doom.core.functions").rollback_doom()]])
-- Set a custom command to open Doom Nvim user manual can be called by using
-- :DoomManual.
vim.cmd([[command! DoomManual lua require("doom.core.functions").open_docs()]])
-- Set a custom command to fully reload Doom Nvim and simulate a new Neovim run
-- can be called by using :DoomReload.
vim.cmd([[command! DoomReload lua require("doom.modules.built-in.reloader").full_reload()]])
-- Set a custom command to create a crash report can be called by using
-- :DoomReport.
vim.cmd([[command! DoomReport lua require("doom.core.functions").create_report(]])
