return function()
  require("dapui").setup({
    icons = {
      expanded = "▾",
      collapsed = "▸",
    },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
    },
    sidebar = {
      open_on_start = true,
      elements = {
        -- You can change the order of elements in the sidebar
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left", -- Can be "left" or "right"
    },
    tray = {
      open_on_start = true,
      elements = {
        "repl",
      },
      size = 10,
      position = "bottom", -- Can be "bottom" or "top"
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
    },
  })
end
