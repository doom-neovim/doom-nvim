local is_plugin_disabled = require("doom.utils").is_plugin_disabled

local autocmds = {
  { "BufWritePost", "*/doom/**/*.lua", require("doom.utils.reloader").full_reload },
  {
    "BufWritePost",
    "*/doom-nvim/modules.lua,*/doom-nvim/config.lua",
    require("doom.utils.reloader").full_reload,
  },
}

if doom.autosave then
  table.insert(autocmds, { "TextChanged,InsertLeave", "<buffer>", "silent! write" })
end

if doom.highlight_yank then
  table.insert(autocmds, {
    "TextYankPost",
    "*",
    function()
      require("vim.highlight").on_yank({ higroup = "Search", timeout = 200 })
    end,
  })
end

if doom.preserve_edit_pos then
  table.insert(autocmds, {
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
  })
end

if is_plugin_disabled("explorer") then
  table.insert(autocmds, {
    "FileType",
    "netrw",
    require("doom.core.settings.netrw").set_maps,
  })
  table.insert(autocmds, {
    "FileType",
    "netrw",
    require("doom.core.settings.netrw").draw_icons(),
  })
  table.insert(autocmds, {
    "TextChanged",
    "*",
    require("doom.core.settings.netrw").draw_icons(),
  })
end

return autocmds
