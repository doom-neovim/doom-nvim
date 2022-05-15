local ui = {}

ui.packages = {
  ["nui.nvim"] = { "MunifTanjim/nui.nvim" },
  -- https://github.com/sidebar-nvim/sidebar.nvim
  -- https://github.com/mvllow/modes.nvim -- mode colors / decorations
}

-- TODO: use `popup.nvim`

ui.cmds = {
  {
    "UIPopup",
    function()
      local Popup = require("nui.popup")
      local event = require("nui.utils.autocmd").event

      local popup = Popup({
        enter = true,
        focusable = true,
        border = {
          style = "rounded",
        },
        position = "50%",
        size = {
          width = "80%",
          height = "60%",
        },
        buf_options = {
          modifiable = true,
          readonly = false,
        },
      })

      -- mount/open the component
      popup:mount()

      -- unmount component when cursor leaves buffer
      popup:on(event.BufLeave, function()
        popup:unmount()
      end)

      -- set content
      vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })
    end,
  },
  {
    "UIInput",
    function()
      local Input = require("nui.input")
      local event = require("nui.utils.autocmd").event

      local input = Input({
        position = "20%",
        size = {
          width = 20,
          height = 2,
        },
        relative = "editor",
        border = {
          style = "single",
          text = {
            top = "How old are you?",
            top_align = "center",
          },
        },
        win_options = {
          winblend = 10,
          winhighlight = "Normal:Normal",
        },
      }, {
        prompt = "> ",
        default_value = "42",
        on_close = function()
          print("Input closed!")
        end,
        on_submit = function(value)
          print("You are " .. value .. " years old")
        end,
      })

      -- mount/open the component
      input:mount()

      -- unmount component when cursor leaves buffer
      input:on(event.BufLeave, function()
        input:unmount()
      end)
    end,
  },
  {
    "UIMenu",
    function()
      local Menu = require("nui.menu")
      local event = require("nui.utils.autocmd").event

      local menu = Menu({
        position = "20%",
        size = {
          width = 20,
          height = 2,
        },
        relative = "editor",
        border = {
          style = "single",
          text = {
            top = "Choose Something",
            top_align = "center",
          },
        },
        win_options = {
          winblend = 10,
          winhighlight = "Normal:Normal",
        },
      }, {
        lines = {
          Menu.item("Item 1"),
          Menu.item("Item 2"),
          Menu.separator("Menu Group", {
            char = "-",
            text_align = "right",
          }),
          Menu.item("Item 3"),
        },
        max_width = 20,
        keymap = {
          focus_next = { "j", "<Down>", "<Tab>" },
          focus_prev = { "k", "<Up>", "<S-Tab>" },
          close = { "<Esc>", "<C-c>" },
          submit = { "<CR>", "<Space>" },
        },
        on_close = function()
          print("CLOSED")
        end,
        on_submit = function(item)
          print("SUBMITTED", vim.inspect(item))
        end,
      })

      -- mount the component
      menu:mount()

      -- close menu when cursor leaves buffer
      menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
    end,
  },
  {
    "UISplit",
    function()
      local Split = require("nui.split")
      local event = require("nui.utils.autocmd").event

      local split = Split({
        relative = "editor",
        position = "bottom",
        size = "20%",
      })

      -- mount/open the component
      split:mount()

      -- unmount component when cursor leaves buffer
      split:on(event.BufLeave, function()
        split:unmount()
      end)
    end,
  },
}

return ui
