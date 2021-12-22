local autocmds = {}

if doom.formatter.on_save then
  table.insert(autocmds, {
    "BufWritePre",
    "*",
    "FormatWrite",
  })
end

return autocmds
