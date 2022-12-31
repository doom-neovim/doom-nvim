local largefile = {}

largefile.settings = {
  max_line_count = 10000,
}

largefile.packages = {
  ["LargeFile"] = {
    "vim-scripts/LargeFile",
    commit = "3941a37b2b0288524300348a39521a46539bf9f6",
    setup = function()
      vim.g.LargeFile = 1 -- 1 MiB
    end,
  },
}

largefile.should_disable = function(_lang, bufnr)
  -- need to check file size too:
  -- on initial open the buffer would be unloaded and report line count as 0
  -- and we'd trigger an initial parsing of the large file which could be
  -- a delay of seconds
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if string.len(fname) > 0 then
    local fsize = vim.fn.getfsize(fname)
    if fsize > vim.g.LargeFile * 1024 * 1024 then
      -- flag for debugging
      vim.b.LargeFile_treesitter_mode_fsize = true
      return true
    end
  end
  if vim.api.nvim_buf_line_count(bufnr) > doom.features.largefile.settings.max_line_count then
    -- flag for debugging
    vim.b.LargeFile_treesitter_mode_linecount = true
    return true
  end
  return false
end

largefile.update_treesitter = function(settings)
  for _, feature in pairs(settings) do
    -- keep enable as is, but add a function that runs on buffer open
    -- to determine whether to disable the feature for that buffer
    feature.disable = largefile.should_disable
  end
  return settings
end

return largefile
