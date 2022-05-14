local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")
local user_paths = require("user.utils.path")
local tsq = require("vim.treesitter.query")
local api = vim.api
local cmd = api.nvim_command

local M = {}

-- create helper functions that can be nice and useful.
-- ALSO ANNOTATE IF THE FUNCTION ALREADY EXISTS IN A PLUGIN
-- such as nvim-treesitter.ts_utils.
--

-- ts.remove_unused_locals(bufnr)

-- ts.get_parsed_query()
-- ts.return_captures_from_parsed_query(qp, { list of capture names you want to return })
-- ts.prepend_line_of_node_with(node,"-- ",offset)
-- ts.append_line_of_node_with(node,"-- ",offset)
-- ts.insert_text_before_node(node,"-- ", offset)
-- ts.insert_text_after_node(node,"-- ", offset)
-- ts.surround_node_with_text(node,"-- ", offset)
--

M.get_query_file = function(lang, query_name)
  return fs.read_file(string.format("%s/queries/%s/%s.scm", system.doom_root, lang, query_name))
end

-- get_query_on_buf
M.get_query = function(query_str, bufnr)
  if bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end
  local language_tree = vim.treesitter.get_parser(bufnr)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local q = vim.treesitter.parse_query("lua", query_str)
  return bufnr, root, q
end

M.get_query_on_file = function(lang, query_name, path_target)
  local query_str = M.get_query_file(lang, query_name)
  local source_str = fs.read_file(path_target)
  local language_tree_parser_str = vim.treesitter.get_string_parser(source_str, lang)
  local syntax_tree = language_tree_parser_str:parse()
  local root = syntax_tree[1]:root()
  local q = vim.treesitter.parse_query(lang, query_str)
  return source_str, root, q
end

M.run_query_on_buf = function(lang, query_name, buf)
  print("buf: ", buf)
  local query_str = M.get_query_file(lang, query_name)
  local language_tree = vim.treesitter.get_parser(buf, lang)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local q = vim.treesitter.parse_query(lang, query_str)
  return buf, root, q
end

-- M.get

M.log_captures = function(root, bufnr, q)
  if q ~= nil then
    local id_done = {}
    local iterated_captures = {}
    for id, node, metadata in q:iter_captures(root, bufnr, root:start(), root:end_()) do
      local name = q.captures[id]
      local nt = tsq.get_node_text(node, bufnr)
      -- if not vim.tbl_contains(id_done, id) then
      --   table.insert(id_done, id)
      -- table.insert(iterated_captures, { id = id, node = node, metadata = metadata })
      -- end
      print(string.format([[ %s: (%s) -> `%s` ]], id, name, nt))
    end

    print("::: log captures :::::::::::::::::::::::::::::::::::::::::::::::")

    -- for _, c in ipairs(iterated_captures) do
    --   local name = q.captures[c.id]
    --   local nt = tsq.get_node_text(c.node, bufnr)
    --   local sr, sc, er, ec = c.node:range()
    --   print(
    --     string.format([[ %s: (%s) -> `%s`  [%s %s, %s %s] ]], c.id, name, nt, sr + 1, sc, er + 1, ec)
    --   )
    -- end
  end
end

M.get_unique_captures = function() end

M.get_captures = function(root, bufnr, q, capture_name)
  local capture_name_matches = {}
  if q ~= nil then
    for id, node, metadata in q:iter_captures(root, bufnr, root:start(), root:end_()) do
      local name = q.captures[id] -- name of the capture in the query

      -- refactor into function get_capture from query
      if name == capture_name then
        table.insert(capture_name_matches, node)
      end
    end
  end
  return capture_name_matches
end

M.get_captures_from_multiple_files_with_STRING_PARSER = function()
  local mult_file_captures = {
    filepath = "",
    node = nil,
  }
  local umps = user_paths.get_user_mod_paths()
  -- for each path
  -- ts parse for package_string captures
  -- store in table

  return mult_file_captures
end

M.ts_single_node_prepend_text = function(node, bufnr, prepend_text)
  local type = node:type() -- type of the captured node
  local nt = tsq.get_node_text(node, bufnr)
  local sr, sc, er, ec = node:range()
  print(string.format("type: %s, text: %s, [%s %s, %s %s]", type, nt, sr + 1, sc, er + 1, ec))
  api.nvim_buf_set_text(bufnr, sr, sc, sr, sc, { prepend_text })
  return bufnr
end

M.ts_single_node_append_text = function(node, bufnr, prepend_text)
  local type = node:type() -- type of the captured node
  local nt = tsq.get_node_text(node, bufnr)
  local sr, sc, er, ec = node:range()
  print(string.format("type: %s, text: %s, [%s %s, %s %s]", type, nt, sr + 1, sc, er + 1, ec))
  api.nvim_buf_set_text(bufnr, er, ec, er, ec, { prepend_text })
end

M.single_node_inner_text_transform = function(node, source, mode)

  -- 1 replace from beginning "L"
  -- 2 replace from end "R"
  -- 3 replace from both both "B"
  -- 4 full swap inner text with repl "F"
end

-- @param table
-- loop and apply
M.ts_nodes_prepend_text = function(nodes, bufnr, prepend_text)
  for i, v in ipairs(nodes) do
    M.ts_single_node_prepend_text(v, bufnr, prepend_text)
  end
end

M.ts_nodes_append_text = function(nodes, bufnr, prepend_text)
  for i, v in ipairs(nodes) do
    M.ts_single_node_append_text(v, bufnr, prepend_text)
  end
end
-- M.ts_node_append_text = function(node) end
-- M.ts_node_surround_text = function(node) end

return M
