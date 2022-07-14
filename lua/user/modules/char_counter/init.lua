local char_counter = {}

char_counter.settings = {
  popup = {
    position = "50%",
    size = {
      width = 80,
      height = 40,
    },
    border = {
      padding = {
        top = 2,
        bottom = 2,
        left = 3,
        right = 3,
      },
    },
    style = "rounded",
    enter = true,
    buf_options = {
      modifiable = true,
      readonly = true,
    },
  },
}

char_counter.packages = {
  ["nui.nvim"] = {
    "MunifTanjim/nui.nvim",
    cmd = { "CountPrint" },
  },
}

char_counter.configs = {
  ["nui.nvim"] = function()
    vim.notify("char_counter: nui.nvim loaded", "info")
  end,
}

char_counter._insert_enter_char_count = nil
char_counter._accumulated_difference = 0
char_counter._get_current_buffer_char_count = function()
  local lines = vim.api.nvim_buf_line_count(0)
  local chars = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, lines, false)) do
    chars = chars + #line
  end
  return chars
end

char_counter.autocmds = {
  {
    "InsertEnter",
    "*",
    function()
      -- Only operate on normal file buffers
      print(("buftype: %s"):format(vim.bo.buftype))
      if vim.bo.buftype == "" then
        -- Store current char count
        char_counter._insert_enter_char_count = char_counter._get_current_buffer_char_count()
      end
    end,
  },
  {
    "InsertLeave",
    "*",
    function()
      -- Only operate on normal file buffers
      if vim.bo.buftype == "" and char_counter._insert_enter_char_count then
        -- Find the amount of chars added or removed
        local new_count = char_counter._get_current_buffer_char_count()
        local diff = new_count - char_counter._insert_enter_char_count
        print(new_count, diff)
        -- Add the difference to the accumulated total
        char_counter._accumulated_difference = char_counter._accumulated_difference + diff
        print(("Accumulated difference %s"):format(char_counter._accumulated_difference))
      end
    end,
  },
}

char_counter.cmds = {
  {
    "CountPrint",
    function()
      local Popup = require("nui.popup")
      local popup = Popup(char_counter.settings.popup)
      popup:mount()
      popup:map("n", "<esc>", function()
        popup:unmount()
      end)

      local msg = ("char_counter: You have typed %s characters since I started counting."):format(
        char_counter._accumulated_difference
      )
      vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { msg })
    end,
  },
  {
    "CountReset",
    function()
      char_counter._accumulated_difference = 0
      vim.notify("char_counter: Reset count!", "info")
    end,
  },
}

char_counter.binds = {
  {
    "<leader>i",
    name = "+info",
    { -- Adds a new `whichkey` folder called `+info`
      { "c", "<cmd>:CountPrint<CR>", name = "Print new chars" }, -- Binds `:CountPrint` to `<leader>ic`
      { "r", "<cmd>:CountReset<CR>", name = "Reset char count" }, -- Binds `:CountPrint` to `<leader>ic`
    },
  },
}

return char_counter
