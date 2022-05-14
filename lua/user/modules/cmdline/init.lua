local cmdline = {}

-- WOULD IT BE POSSIBLE TO PUT DEFAULT COMMANDLINE AT TOP OF WINDOW INSTEAD OF AT THE ABSOLUTE BOTTOM?

-- it would be cool to have telescope also follow the cursor so that you don't have to jump up and down all the time.
-- depending on what quadrant you are in telescope will open its window so that you type where your eyes wer so that
-- things become super smooth from an ergonomic perspective.

cmdline.packages = {
  ["fine-cmdline.nvim"] = { "VonHeikemen/fine-cmdline.nvim" }, -- :h fine-cmdline
  -- git@github.com:VonHeikemen/searchbox.nvim.git
}

cmdline.configs = {}
cmdline.configs["fine-cmdline.nvim"] = function()
  require("fine-cmdline").setup({
    cmdline = {
      enable_keymaps = true,
      smart_history = true,
      prompt = ": ",
    },
    popup = {
      position = {
        row = "10%",
        col = "50%",
      },
      size = {
        width = "60%",
      },
      border = {
        style = "rounded",
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    hooks = {
      before_mount = function(input)
        -- code
      end,
      after_mount = function(input)
        -- code
      end,
      set_keymaps = function(imap, feedkeys) -- https://github.com/VonHeikemen/fine-cmdline.nvim#setting-keymaps
        -- code
      end,
    },
  })
end

-- cmdline.configs["searchbox.nvim"] = function()
--   require("searchbox").setup({
--     popup = {
--       relative = "win",
--       position = {
--         row = "5%",
--         col = "95%",
--       },
--       size = 30,
--       border = {
--         style = "rounded",
--         highlight = "FloatBorder",
--         text = {
--           top = " Search ",
--           top_align = "left",
--         },
--       },
--       win_options = {
--         winhighlight = "Normal:Normal",
--       },
--     },
--     hooks = {
--       before_mount = function(input)
--         -- code
--       end,
--       after_mount = function(input)
--         -- code
--       end,
--       on_done = function(value, search_type)
--         -- code
--       end,
--     },
--   })
-- end

-- cmdline.binds = {}
-- leader > colon > float cmdline.

-- There is also the possibility to setup a default value before it shows up. Say you want to create a keybinding to use vimgrep.
-- <cmd>FineCmdline vimgrep <CR>
-- Open from lua
-- FineCmdline is an alias for the .open() function in the fine-cmdline module. So you could also use this.

-- <cmd>lua require("fine-cmdline").open({default_value = ""})<CR>

return cmdline
