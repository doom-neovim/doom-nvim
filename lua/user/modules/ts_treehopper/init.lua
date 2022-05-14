-- https://github.com/mfussenegger/nvim-treehopper
local ts_hop = {}

local api = vim.api
local M = {}
local ns = api.nvim_create_namespace("me.tsnode")

M.config = { hint_keys = {} }

local function keys_iter()
  local i = 0
  local len = #M.config.hint_keys
  return function()
    -- This won't work if there are too many nodes
    while true do
      i = i + 1
      if i <= len then
        return M.config.hint_keys[i]
      elseif (i - len) <= 26 then
        local c = string.char(i + 96)

        local k = true
        -- Skip already used hint_keys
        for _, v in ipairs(M.config.hint_keys) do
          if v == c then
            k = false
            break
          end
        end

        if k then
          return c
        end
      else
        local c = string.char(i + 65 - 27)

        local k = true
        -- Skip already used hint_keys
        for _, v in ipairs(M.config.hint_keys) do
          if v == c then
            k = false
            break
          end
        end

        if k then
          return c
        end
      end
    end
  end
end

function M.nodes()
  api.nvim_buf_clear_namespace(0, ns, 0, -1)
  local ts = vim.treesitter

  -- copy this into ts monitor
  local get_query = require("vim.treesitter.query").get_query
  local get_parser = require("vim.treesitter").get_parser
  local query = get_query(get_parser(0)._lang, "locals")
  if not query then
    print("No locals query for language", vim.bo.filetype)
    return
  end

  local parser = ts.get_parser(0)
  local trees = parser:parse()
  local root = trees[1]:root()
  local lnum, col = unpack(api.nvim_win_get_cursor(0))
  lnum = lnum - 1

  local cursor_node = root:descendant_for_range(lnum, col, lnum, col)
  local iter = keys_iter()
  local hints = {}

  local win_info = vim.fn.getwininfo(api.nvim_get_current_win())[1]
  for i = win_info.topline, win_info.botline do
    api.nvim_buf_add_highlight(0, ns, "TSNodeUnmatched", i - 1, 0, -1)
  end

  local function register_node(node)
    local key = iter()
    local start_row, start_col, end_row, end_col = node:range() -- very interesting that you can get range like this.
    api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
      virt_text = { { key, "TSNodeKey" } },
      virt_text_pos = "overlay",
    })
    api.nvim_buf_set_extmark(0, ns, end_row, end_col, {
      virt_text = { { key, "TSNodeKey" } },
      virt_text_pos = "overlay",
    })
    hints[key] = node
  end

  register_node(cursor_node)
  local parent = cursor_node:parent()
  while parent do
    register_node(parent)
    parent = parent:parent()
  end

  vim.cmd("redraw")

  while true do
    local ok, keynum = pcall(vim.fn.getchar)
    if not ok then
      api.nvim_buf_clear_namespace(0, ns, 0, -1)
      break
    end
    if type(keynum) == "number" then
      local key = string.char(keynum)
      local node = hints[key]
      if node then
        local start_row, start_col, end_row, end_col = node:range()
        api.nvim_win_set_cursor(0, { start_row + 1, start_col })
        vim.cmd("normal! v")
        local max_row = api.nvim_buf_line_count(0)
        if max_row == end_row then
          end_row = end_row - 1
          end_col = #api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1]
        elseif end_col == 0 then
          -- If the end points to the start of the next line, move it to the
          -- end of the previous line.
          -- Otherwise operations include the first character of the next line
          local end_line = api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]
          end_row = end_row - 1
          end_col = #end_line
        end
        api.nvim_win_set_cursor(0, { end_row + 1, math.max(0, end_col - 1) })
        api.nvim_buf_clear_namespace(0, ns, 0, -1)
        break
      else
        vim.api.nvim_feedkeys(key, "", true)
        api.nvim_buf_clear_namespace(0, ns, 0, -1)
        break
      end
    end -- if number
  end -- while true
end

ts_hop.binds = {}

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(ts_hop.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "n",
--         name = "+nav",
--         {
--           "t",
--           name = "+treesitter",
--           {
--             { "h", , name = "ts hop"}
--           },
--         },
--       },
--     },
--   })
-- end

return ts_hop
