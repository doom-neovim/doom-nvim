local buf = {}

--
-- create intuitive super easy to use helpers
-- that allow code to be super readable.
--
-- nvim buf api is great but it is impossible to understand
-- what happens quickly sometimes, so these will make it super obvious
-- what you are doing.

buf.replace_lines = function(buf, line, value)
  if type(value) == "string" then
    -- replace single line
  elseif type(value) == "table" then
    -- replace mult lines
  end
end

buf.replace_text = function() end
buf.delete_lines = function(buf, start, end_)
  if end_ then
  else
    -- delete line start.
  end
end

buf.insert_lines = function(buf, line, value)
  -- before/after
  --
  -- string or #table == 1 / else loop mult lines
end

buf.set_lines = function(buf, line, start, end_, value) end

buf.insert_line = function(buf, line, value)
  vim.api.nvim_buf_set_lines(buf, line, line, true, { value })
end

-- local function replace_line(buf, line, value) end

buf.set_text = function(buf, range, value)
  vim.api.nvim_buf_set_text(buf, range[1], range[2], range[3], range[4], { value })
end

buf.insert_text_at = function(buf, row, col, value)
  vim.api.nvim_buf_set_text(buf, row, col, row, col, { value })
end

buf.set_cursor_to_buf = function(buf, range, win)
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.cursor(range[1] + 1, range[2])
end

return buf
