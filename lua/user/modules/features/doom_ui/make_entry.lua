local entry_display = require "telescope.pickers.entry_display"
local utils = require "telescope.utils"
local strings = require "plenary.strings"
local Path = require "plenary.path"

local treesitter_type_highlight = {
  ["associated"] = "TSConstant",
  ["constant"] = "TSConstant",
  ["field"] = "TSField",
  ["function"] = "TSFunction",
  ["method"] = "TSMethod",
  ["parameter"] = "TSParameter",
  ["property"] = "TSProperty",
  ["struct"] = "Struct",
  ["var"] = "TSVariableBuiltin",
}

local lsp_type_highlight = {
  ["Class"] = "TelescopeResultsClass",
  ["Constant"] = "TelescopeResultsConstant",
  ["Field"] = "TelescopeResultsField",
  ["Function"] = "TelescopeResultsFunction",
  ["Method"] = "TelescopeResultsMethod",
  ["Property"] = "TelescopeResultsOperator",
  ["Struct"] = "TelescopeResultsStruct",
  ["Variable"] = "TelescopeResultsVariable",
}

local make_entry = {}

do
  local lookup_keys = {
    display = 1,
    ordinal = 1,
    value = 1,
  }

  local mt_string_entry = {
    __index = function(t, k)
      return rawget(t, rawget(lookup_keys, k))
    end,
  }

  function make_entry.gen_from_string()
    return function(line)
      return setmetatable({
        line,
      }, mt_string_entry)
    end
  end
end

do
  local lookup_keys = {
    ordinal = 1,
    value = 1,
    filename = 1,
    cwd = 2,
  }

  function make_entry.gen_from_file(opts)
    opts = opts or {}

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local disable_devicons = opts.disable_devicons

    local mt_file_entry = {}

    mt_file_entry.cwd = cwd
    mt_file_entry.display = function(entry)
      local hl_group
      local display = utils.transform_path(opts, entry.value)

      display, hl_group = utils.transform_devicons(entry.value, display, disable_devicons)

      if hl_group then
        return display, { { { 1, 3 }, hl_group } }
      else
        return display
      end
    end

    mt_file_entry.__index = function(t, k)
      local raw = rawget(mt_file_entry, k)
      if raw then
        return raw
      end

      if k == "path" then
        local retpath = Path:new({ t.cwd, t.value }):absolute()
        if not vim.loop.fs_access(retpath, "R", nil) then
          retpath = t.value
        end
        return retpath
      end

      return rawget(t, rawget(lookup_keys, k))
    end

    return function(line)
      return setmetatable({ line }, mt_file_entry)
    end
  end
end


function make_entry.gen_from_git_stash(opts)
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      opts.show_branch and { width = 15 } or "",
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value, "TelescopeResultsLineNr" },
      opts.show_branch and { entry.branch_name, "TelescopeResultsIdentifier" } or "",
      entry.commit_info,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local splitted = utils.max_split(entry, ": ", 2)
    local stash_idx = splitted[1]
    local _, branch_name = string.match(splitted[2], "^([WIP on|On]+) (.+)")
    local commit_info = splitted[3]

    return {
      value = stash_idx,
      ordinal = commit_info,
      branch_name = branch_name,
      commit_info = commit_info,
      display = make_display,
    }
  end
end

function make_entry.gen_from_git_commits(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 8 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value, "TelescopeResultsIdentifier" },
      entry.msg,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local sha, msg = string.match(entry, "([^ ]+) (.+)")

    if not msg then
      sha = entry
      msg = "<empty commit message>"
    end

    return {
      value = sha,
      ordinal = sha .. " " .. msg,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }
  end
end

function make_entry.gen_from_quickfix(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 8 },
      { width = 0.45 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

    return displayer {
      line_info,
      entry.text:gsub(".* | ", ""),
      filename,
    }
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

    return {
      valid = true,

      value = entry,
      ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
      display = make_display,

      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

function make_entry.gen_from_buffer(opts)
  opts = opts or {}

  local disable_devicons = opts.disable_devicons

  local icon_width = 0
  if not disable_devicons then
    local icon, _ = utils.get_devicons("fname", disable_devicons)
    icon_width = strings.strdisplaywidth(icon)
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = opts.bufnr_width },
      { width = 4 },
      { width = icon_width },
      { remaining = true },
    },
  }

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

  local make_display = function(entry)
    local display_bufname = utils.transform_path(opts, entry.filename)

    local icon, hl_group = utils.get_devicons(entry.filename, disable_devicons)

    return displayer {
      { entry.bufnr, "TelescopeResultsNumber" },
      { entry.indicator, "TelescopeResultsComment" },
      { icon, hl_group },
      display_bufname .. ":" .. entry.lnum,
    }
  end

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    -- if bufname is inside the cwd, trim that part of the string
    bufname = Path:new(bufname):normalize(cwd)

    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed
    local line_count = vim.api.nvim_buf_line_count(entry.bufnr)

    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. " : " .. bufname,
      display = make_display,

      bufnr = entry.bufnr,
      filename = bufname,
      -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
      lnum = entry.info.lnum ~= 0 and math.max(math.min(entry.info.lnum, line_count), 1) or 1,
      indicator = indicator,
    }
  end
end

function make_entry.gen_from_treesitter(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local display_items = {
    { width = 25 },
    { width = 10 },
    { remaining = true },
  }

  if opts.show_line then
    table.insert(display_items, 2, { width = 6 })
  end

  local displayer = entry_display.create {
    separator = " ",
    items = display_items,
  }

  local type_highlight = opts.symbol_highlights or treesitter_type_highlight

  local make_display = function(entry)
    local msg = vim.api.nvim_buf_get_lines(bufnr, entry.lnum, entry.lnum, false)[1] or ""
    msg = vim.trim(msg)

    local display_columns = {
      entry.text,
      { entry.kind, type_highlight[entry.kind], type_highlight[entry.kind] },
      msg,
    }
    if opts.show_line then
      table.insert(display_columns, 2, { entry.lnum .. ":" .. entry.col, "TelescopeResultsLineNr" })
    end

    return displayer(display_columns)
  end

  return function(entry)
    local ts_utils = require "nvim-treesitter.ts_utils"
    local start_row, start_col, end_row, _ = ts_utils.get_node_range(entry.node)
    local node_text = ts_utils.get_node_text(entry.node)[1]
    return {
      valid = true,

      value = entry.node,
      kind = entry.kind,
      ordinal = node_text .. " " .. (entry.kind or "unknown"),
      display = make_display,

      node_text = node_text,

      filename = vim.api.nvim_buf_get_name(bufnr),
      -- need to add one since the previewer substacts one
      lnum = start_row + 1,
      col = start_col,
      text = node_text,
      start = start_row,
      finish = end_row,
    }
  end
end

function make_entry.gen_from_doom_moduls(opts)
end

function make_entry.gen_from_doom_mappings_table(opts)

end


return make_entry

