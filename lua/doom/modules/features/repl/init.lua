local repl = {}

repl.settings = {
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        command = { "zsh" },
      },
    },
    position = "right",
    size = 20,
  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "<space>rc",
    visual_send = "<space>rc",
    send_file = "<space>rf",
    send_line = "<space>rl",
    -- send_mark = "<space>sm",
    -- mark_motion = "<space>mc",
    -- mark_visual = "<space>mc",
    -- remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true,
  },
}

repl.packages = {
  ["iron.nvim"] = {
    "hkupty/iron.nvim",
    commit = "f4131638454aeb96cbd92652dd8c396e48eb4118",
    cmd = "IronRepl",
  },
}

repl.configs = {
  ["iron.nvim"] = function()
    local iron = require("iron.core")

    local settings = vim.tbl_deep_extend("force", {}, doom.features.repl.settings)

    settings.config.repl_open_command = require("iron.view")[settings.config.position](
      settings.config.size
    )

    iron.setup(settings)
  end,
}
repl.binds = {
  {
    "<leader>r",
    name = "+repl",
    {
      { "r", "<cmd>IronRepl<CR>", name = "Repl" },
      { "f", "<NOP>", name = "Send file" },
      { "s", "<NOP>", name = "Send line" },
      { "c", "<NOP>", name = "Send visual / motion" },
      { "i", "<NOP>", name = "Interupt repl" },
      { "<cr>", "<NOP>", name = "Enter" },
      { "C", "<NOP>", name = "Clear" },
    },
  },
  {
    "<C-e>",
    function()
      local iron = require("iron.core")
      iron.send_line()
    end,
    name = "Repl send line",
    mode = "n",
  },
  {
    "<C-e>",
    function()
      local iron = require("iron.core")
      iron.visual_send()
    end,
    name = "Repl visual send",
    mode = "v",
  },
}

return repl
