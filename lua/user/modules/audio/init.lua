local audio = {}

-- https://github.com/johnnovak/vim-walter

audio.settings = {}

-- https://github.com/davidgranstrom?tab=repositories
-- https://github.com/madskjeldgaard?tab=repositories

audio.packages = {
  ["nvim-spotify"] = {"KadoBOT/nvim-spotify"},
  ["music.nvim"] = {"max-0406/music.nvim "},
  ["osc.nvim"] = { "davidgranstrom/osc.nvim.git " },
  ["nvim-supercollider-piano"] = { "madskjeldgaard/nvim-supercollider-piano" },
  -- https://github.com/davidgranstrom/telescope-scdoc.nvim -- <<<< EXTENSION
  ["scnvim"] = {
    "davidgranstrom/scnvim",
    run = ":call scnvim#install()",
  },
  ["vim-tidal"] = {"tidalcycles/vim-tidal"},
  ["reaper-nvim"] = {"madskjeldgaard/reaper-nvim"},
  -- https://github.com/karstm/chuck.vim
  -- https://github.com/vim-scripts/ck.vim
}

audio.packages["scnvim"] = function()
  local sclang = require("scnvim/sclang")
  local api = vim.api
  local M = {}

  api.nvim_command([[
  autocmd FileType supercollider lua require'dkg/supercollider'.set_mappings()
  ]])

  local Window = {}

  function Window:new(tbl)
    tbl = tbl or {}
    setmetatable(tbl, self)
    self.__index = self
    self.bufnr = api.nvim_create_buf(true, true)
    self.border_bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(self.bufnr, "filetype", "scnvim")
    api.nvim_buf_set_name(self.bufnr, "[sclang]")
    return tbl
  end

  function Window:is_open()
    return self:is_valid() and vim.fn.bufwinnr(self.bufnr) > 0
  end

  function Window:is_valid()
    return self.bufnr and api.nvim_buf_is_loaded(self.bufnr) or false
  end

  function Window:set_lines(data)
    if self:is_valid() then
      api.nvim_buf_set_lines(self.bufnr, -1, -1, true, { data })
      if self:is_open() then
        local num_lines = api.nvim_buf_line_count(self.bufnr)
        api.nvim_win_set_cursor(self.winnr, { num_lines, 0 })
      end
    end
  end

  function Window:create_border(options, margin)
    vim.validate({
      options = { options, "table" },
    })
    margin = margin or 2
    local opts = {
      width = options.width + margin,
      height = options.height + margin,
      col = options.col - (margin / 2),
      row = options.row - (margin / 2),
      focusable = false,
    }
    local border = {}
    local top = "╭" .. string.rep("─", opts.width - margin) .. "╮"
    local mid = "│" .. string.rep(" ", opts.width - margin) .. "│"
    local bot = "╰" .. string.rep("─", opts.width - margin) .. "╯"
    table.insert(border, top)
    for i = 1, opts.height - margin do
      table.insert(border, mid)
    end
    table.insert(border, bot)
    api.nvim_buf_set_lines(self.border_bufnr, 0, -1, true, border)
    return vim.tbl_extend("keep", opts, options)
  end

  function Window:open()
    local term_height = api.nvim_get_option("lines")
    local term_width = api.nvim_get_option("columns")
    local opts = {
      relative = "editor",
      width = 80,
      height = 20,
      col = term_width - 81,
      row = term_height - 23,
      anchor = "NW",
      style = "minimal",
    }
    local border_options = self:create_border(opts)
    self.winnr = api.nvim_open_win(self.bufnr, false, opts)
    self.border_winnr = api.nvim_open_win(self.border_bufnr, false, border_options)
    api.nvim_win_set_option(self.border_winnr, "winhl", "Normal:Floating")
    api.nvim_win_set_option(self.border_winnr, "winblend", 30)
    api.nvim_win_set_option(self.winnr, "winhl", "Normal:Floating")
    api.nvim_win_set_option(self.winnr, "winblend", 30)
  end

  function Window:clear()
    if self:is_valid() then
      api.nvim_buf_set_lines(self.bufnr, 0, -1, true, {})
    end
  end

  function Window:close()
    api.nvim_win_close(self.winnr, true)
    api.nvim_win_close(self.border_winnr, true)
  end

  function Window:destroy()
    api.nvim_buf_delete(self.bufnr, { force = true })
    api.nvim_buf_delete(self.border_bufnr, { force = true })
  end

  function M.clear()
    M.window:clear()
  end

  function M.toggle()
    if M.window:is_open() then
      M.window:close()
    else
      M.window:open()
    end
  end

  function M.set_mappings()
    local options = { noremap = true, nowait = true, silent = true }
    api.nvim_buf_set_keymap(
      0,
      "n",
      "<M-L>",
      '<cmd> lua require"dkg/supercollider".clear()<cr>',
      options
    )
    api.nvim_buf_set_keymap(
      0,
      "n",
      "<Enter>",
      '<cmd> lua require"dkg/supercollider".toggle()<cr>',
      options
    )
  end

  sclang.on_start = function()
    M.window = Window:new()
    M.window:open()
  end

  sclang.on_read = function(data)
    M.window:set_lines(data)
  end

  sclang.on_exit = function(code, signal)
    if M.window:is_open() then
      M.window:close()
    end
    M.window:destroy()
  end

  return M
end

audio.binds = {}

return audio
