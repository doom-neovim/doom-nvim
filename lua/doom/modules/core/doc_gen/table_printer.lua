--- This helps rpint tables for the doc_gen module
local table_printer = {}

--- Returns a table of max length for each column
--- @param rows list<number, number>
table_printer._get_max_lengths = function(rows)
  local max_lengths = {}
  for _, _ in ipairs(rows[1]) do
    table.insert(max_lengths, 0)
  end

  for _, row in ipairs(rows) do
    for index, cell in ipairs(row) do
      local md_visible_str = string.match(cell, "%[(.*)%]"):gsub('`', '')
      max_lengths[index] = math.max(max_lengths[index], string.len(md_visible_str or cell))
    end
  end
  print(vim.inspect(max_lengths))
  return max_lengths
end

table_printer.pad_left = function(string, length, char)
  local c = char or " "
  local current_length = string.len(string)
  local difference = length - current_length
  if difference > 0 then
    string = string.rep(c, difference) .. string
  end
  return string
end

--- Prints a table from a set of data and some provided keys
---@param data table[] The data to format into a table
---@param keys string[] Keys to extract data from
---@param titles string[]|nil Optional titles for `keys` parameter
---@return string The formatted table
table_printer.print = function(data, keys, titles)
  -- Extract the desired keys from the table data
  local rows = {
    titles,
  }
  for _, row in ipairs(data) do
    local row_out = {}
    for i, k in ipairs(keys) do
      table.insert(row_out, row[k])
    end
    table.insert(rows, row_out)
  end

  local max_lengths = table_printer._get_max_lengths(rows)

  local pad_left = table_printer.pad_left
  local result = {}
  for row_index, row in ipairs(rows) do
    if row_index == 1 then
      local header_line = "|"
      local divider_line = "|"
      for index, cell in ipairs(keys) do
        local title = (titles and titles[index] ~= nil) and titles[index] or cell
        header_line = header_line .. string.format(" %s |", pad_left(title, max_lengths[index]))
        divider_line = divider_line .. string.format(" %s |", pad_left("", max_lengths[index], "-"))
      end
      table.insert(result, header_line)
      table.insert(result, divider_line)
    else
      local line = "|"
      for index, cell in ipairs(row) do
        line = line .. string.format(" %s |", pad_left(cell, max_lengths[index]))
      end
      table.insert(result, line)
    end
  end

  return table.concat(result, "\n")
end

return table_printer
