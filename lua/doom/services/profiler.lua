local hrtime = vim.loop.hrtime

local profiler = {}

profiler.all_start = hrtime()
profiler.chunks = {}

profiler._right_pad = function(str, length, char)
  local res = str .. string.rep(char or " ", length - #str)

  return res, res ~= str
end
profiler._left_pad = function(str, length, char)
  local res = string.rep(char or " ", length - #str) .. str

  return res, res ~= str
end

profiler.start = function(chunk)
  profiler.chunks[chunk] = { start = hrtime() }
end

profiler.stop = function(chunk)
  profiler.chunks[chunk].stop = hrtime()
end

--- Logs the current state of the profiler
---@param opts nil|table
profiler.log = function(options)
  local opts = options or {}

  local show_async = opts.show_async or false
  -- Convert chunks into a list, ordered by start time
  local chunks = vim.tbl_map(function(key)
    return vim.tbl_extend("force", {
      key = key,
    }, profiler.chunks[key])
  end, vim.tbl_keys(profiler.chunks))

  table.sort(chunks, function(a, b)
    return a.start < b.start
  end)

  for _, parent in ipairs(chunks) do
    local children = vim.tbl_filter(function(child)
      if child.stop and parent.stop then
        return parent.start < child.start and parent.stop > child.stop
      end
      return false
    end, chunks)
    if #children > 0 then
      parent.has_children = true
    end
    vim.tbl_map(function(child)
      child.depth = child.depth ~= nil and child.depth + 1 or 1
    end, children)
  end

  vim.api.nvim_echo({{profiler._right_pad("Category", 12), "Int"}, {profiler._right_pad("Task", 48), "Int"}, {"Duration(ms)", "Int"}, {"\tStart/End Time", "Int"}}, false, {})

  -- Print them one by one
  for _, entry in ipairs(chunks) do
    local depth = entry.depth or 0
    local echo_tbl = {}

    local name_or_category, name_or_nil = unpack(vim.split(entry.key, "|", {}))
    local is_async = string.find(name_or_category, "async") ~= nil
    if not is_async or (show_async and is_async) then
      if name_or_category and name_or_nil then
        table.insert(echo_tbl, { profiler._right_pad(name_or_category, 12, " "), "Comment" })
        table.insert(
          echo_tbl,
          { string.rep(" |", depth) .. (entry.has_children and " + " or " - "), "Comment" }
        )
        table.insert(echo_tbl, { profiler._right_pad(name_or_nil, 48 - depth * 2, " "), "Normal" })
      else
        table.insert(echo_tbl, { string.rep(" |", depth), "Comment" })
        table.insert(echo_tbl, {
          profiler._right_pad(name_or_category, 60 - depth * 2, " "),
          "Normal",
        })
      end

      if entry.stop then
        local duration = (entry.stop - entry.start) / 1e6
        table.insert(echo_tbl, { ("%.03f"):format(duration), "Class" })
      else
        table.insert(echo_tbl, { "N/A", "Class" })
      end

      local start_time = (entry.start - profiler.all_start) / 1e6
      local stop_time = entry.stop and ("%.03f"):format((entry.stop - profiler.all_start) / 1e6)
        or "Hasn't stopped yet"

      table.insert(echo_tbl, { ("\t\t%.03f -> %s"):format(start_time, stop_time), "Comment" })

      vim.api.nvim_echo(echo_tbl, false, {})
    end
  end
end

profiler.reset = function()
  profiler.chunks = {}
end

return profiler
