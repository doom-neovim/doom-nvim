local user_utils = require("user.utils")

local binds_mini_syntax = {}

-- NOTE: for each binds, use ts to auto generate a `cmd` for it so that we call the command instead of
-- calling the function in the bind. since there currently is problems with binds reloading. therefore
-- auto map it to a cmd.

-- lsp.binds = {
-- }

-- CMD: rename leader branch / leaf across files.
--    so that we can easilly update the mappings tree even though you assing binds to same branch in multiple
--    modules.

-- todo: put mapping before name >> (mode mapping name command options)
--
-- TODO: check out the connor/nest.nvim branch
-- so that I understand how nest works and if I can take some inspiration
-- from there.

-- how to handle the case where you want to assign mode to just a subtable
-- >> maybe add a cascading options key branch ["mode nv"]??
local t_mini_syntax_test = {
  [[ n  fast_exit                ZZ      require("doom.core.functions").quit_doom ]],
  [[ n  remove_search_hl         <ESC>   :noh<CR>  ]],
  [[ n  jump_to_next_buf         <Tab>   :bnext<CR> ]],
  [[ n  jump_to_prev_buf         <S-Tab> :bprevious<CR> ]],
  [[ n  show_hover_doc           K       vim.lsp.buf.hover ]],
  [[ n  jump_to_prev_diagnostic  [d      vim.diagnostic.goto_prev ]],
  [" n  jump_to_next_diagnostic  ]d "] = vim.diagnostic.goto_next,
  [[ n  command_one       s B sf ]],
  [[ n  second_command    <c-z> :sus s ]],
  [[ n  this_is_the_third <c-z> :sus sn ]],
  [[ x  and_the_fourth    <c-z> :DoomReload sn ]],
  [[ x  and_the_fourth <c-z> :DoomReload ]],

  [[ v what_is_this p "_dP ]],
  [[ v suspend_vim <c-z> <Esc><cmd>suspend<CR> ]],
  [[ v inspect_selection <C-l>v "zy:lua doom.moll.funcs.inspect(<c-r>z)<Left> ]],
  [[ v print_visual_sel <C-l>i :lua doom.moll.funcs.inspect(loadstring(doom.moll.funcs.get_visual_selection()))<CR> ]],

  [" x the_name <c-z> sn "] = function()
    print("hello")
  end,
  [" x the_name <c-z> "] = function()
    print("hello")
  end,

  ["<C-"] = {
    [[ h> <C-w>h "Jump window left"   ]],
    [[ j> <C-w>j "Jump window down"   ]],
    [[ k> <C-w>k "Jump window up"     ]],
    [" l>  jump_xxx  "] = function()
      print("something")
    end,
    ["..nv"] = { -- this is a pretty nice syntax.
      [[ "Left>", ":vertical resize -2<CR>", name = "Resize window left" ]],
      [[ "Down>", ":resize -2<CR>", name = "Resize window down" ]],
      [[ "Up>", ":resize +2<CR>", name = "Resize window up" ]],
      [[ "Right>", ":vertical resize +2<CR>", name = "Resize window right" ]],
    },
  },

  --   {
  --     "<leader>cf",
  --     function()
  --       vim.lsp.buf.formatting_sync()
  --     end,
  --     name = "Format/Fix",
  --   },
  -- }

  -- leader
  ["c +code"] = {
    [[ r  rename                  vim.lsp.buf.rename ]],
    [[ a  do_action               vim.lsp.buf.code_action ]],
    [[ t  jump_to_type            vim.lsp.buf.type_definition ]],
    [[ D  jump_to_declaration     vim.lsp.buf.declaration ]],
    [[ d  jump_to_definition      vim.lsp.buf.definition, ]],
    [[ R  jump_to_references      vim.lsp.buf.references, ]],
    [[ i  jump_to_implementation  vim.lsp.buf.implementation, ]],
    ["l +lsp"] = {
      [[ i inform     <cmd>LspInfo<CR> ]],
      [[ r restart    <cmd>LspRestart<CR> ]],
      [[ s start      <cmd>LspStart<CR> ]],
      [[ d disconnect <cmd>LspStop<CR> ]],
    },
    ["d +diagnostics"] = {
      -- { "[", vim.diagnostic.goto_prev, name = "Jump to prev" },
      -- { "]", vim.diagnostic.goto_next, name = "Jump to next" },
      -- { "p", vim.diagnostic.goto_prev, name = "Jump to prev" },
      -- { "n", vim.diagnostic.goto_next, name = "Jump to next" },
      -- {
      --   "L",
      --   function()
      --     vim.diagnostic.open_float(0, {
      --       focusable = false,
      --       border = doom.border_style,
      --     })
      --   end,
      --   name = "Line",
      -- },
      -- { "l", vim.lsp.diagnostic.set_loclist, name = "Loclist" },
    },
  },
  --       {
  --         "c",
  --         name = "+code",
  --       },
  --       {
  --         "t",
  --         name = "+tweak",
  --         {
  --           { "c", function() require("doom.core.functions").toggle_completion() end, name = "Toggle completion" },
  --         },
  --       },
}

binds_mini_syntax.settings = {
  input = {
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

binds_mini_syntax.cmds = {
  {
    "MiniSyntaxTest",
    function()
      user_utils.mappings_parse_mini_syntax(t_mini_syntax_test)
    end,
  },
  {
    "BindsCreateGetInput",
    function()
      local Input = require("nui.input")
      local event = require("nui.utils.autocmd").event

      local popup_options = {
        relative = "cursor",
        position = {
          row = 1,
          col = 0,
        },
        size = 20,
        border = {
          style = "rounded",
          text = {
            top = "[Input]",
            top_align = "left",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal",
        },
      }

      local input = Input(popup_options, {
        prompt = "> ",
        default_value = "42",
        on_close = function()
          print("Input closed!")
        end,
        on_submit = function(value)
          -- print("Value submitted: ", value)
          user_utils.parse_mappings_str_syntax(value)
        end,
        on_change = function(value)
          print("Value changed: ", value)
        end,
      })
      -- mount/open the component
      input:mount()

      -- unmount component when cursor leaves buffer
      input:on(event.BufLeave, function()
        input:unmount()
      end)
      -- pass string through parser
      -- print result
    end,
  }, -- BindsCreateGetInput
  {
    "CreateBindsAddLevelToLeaf",
    function()
      -- use treesitter to modify lines
    end,
  },
}

if require("doom.utils").is_module_enabled("whichkey") then
  binds_mini_syntax.binds = {
    {
      "<leader>M",
      name = "+moll",
      {
        { "i", "<cmd>:BindsCreateGetInput<CR>", name = "creab binds test input" },
        { "I", "<cmd>:MiniSyntaxTest<CR>", name = "create binds syntax test" },
      },
    },
  }
end

return binds_mini_syntax
