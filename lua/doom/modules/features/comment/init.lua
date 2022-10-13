local comment = {}

comment.settings = {
  --- Add a space b/w comment and the line
  --- @type boolean
  padding = true,

  --- Whether the cursor should stay at its position
  --- NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
  --- @type boolean
  sticky = true,

  --- Lines to be ignored while comment/uncomment.
  --- Could be a regex string or a function that returns a regex string.
  --- Example: Use '^$' to ignore empty lines
  --- @type string|fun():string
  ignore = nil,

  --- Passes to ts-context-commentstring to get commentstring in JSX
  pre_hook = function(ctx)
    -- Only calculate commentstring for tsx filetypes
    if vim.bo.filetype == "typescriptreact" then
      local comment_utils = require("Comment.utils")

      -- Detemine whether to use linewise or blockwise commentstring
      local type = ctx.ctype == comment_utils.ctype.line and "__default" or "__multiline"

      -- Determine the location where to calculate commentstring from
      local location = nil
      if ctx.ctype == comment_utils.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == comment_utils.cmotion.v or ctx.cmotion == comment_utils.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = type,
        location = location,
      })
    end
  end,
}

comment.packages = {
  ["Comment.nvim"] = {
    "numToStr/Comment.nvim",
    commit = "98c81efa6ac1946b63eef685c27f8da928d9f4e7",
    module = "Comment",
  },
}

comment.configs = {}
comment.configs["Comment.nvim"] = function()
  local config = vim.tbl_extend("force", doom.features.comment.settings, {
    -- Disable mappings as we'll handle it in binds.lua
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  require("Comment").setup(config)
end

comment.binds = {
  {
    "gc",
    [[<cmd>lua require("Comment.api").call('toggle.linewise', '@g')<CR>]],
    name = "Comment motion",
  },
  {
    "gc",
    [[<Esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>]],
    name = "Comment line",
    mode = "v",
  },
  {
    "gb",
    [[<Esc><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>]],
    name = "Comment block",
    mode = "v",
  },
  {
    "gcc",
    [[<cmd>lua require("Comment.api").toggle.linewise.current()<CR>]],
    name = "Comment line",
  },
  {
    "gcA",
    [[<cmd>lua require("Comment.api").insert.linewise.eol()<CR>]],
    name = "Comment end of line",
  },
}

return comment
