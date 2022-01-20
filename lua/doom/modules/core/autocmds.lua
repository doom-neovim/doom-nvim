local is_plugin_disabled = require("doom.utils").is_plugin_disabled

local autocmds = {
  { "BufWritePost", "*/doom/**/*.lua", function() require("doom.utils.reloader").full_reload() end },
  {
    "BufWritePost",
    "*/doom-nvim/modules.lua,*/doom-nvim/config.lua",
    function() require("doom.utils.reloader").full_reload() end,
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
    require("doom.core.netrw").set_maps,
  })
  table.insert(autocmds, {
    "FileType",
    "netrw",
    require("doom.core.netrw").draw_icons,
  })
  table.insert(autocmds, {
    "TextChanged",
    "*",
    require("doom.core.netrw").draw_icons,
  })
end

return autocmds
