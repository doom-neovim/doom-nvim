local gitsigns = {}

-- doom.modules.git.settings.gitsigns
gitsigns.settings = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "│",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "│",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ["n ]c"] = {
      expr = true,
      "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
    },
    ["n [c"] = {
      expr = true,
      "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
    },
  },
  watch_gitdir = { interval = 1000, follow_files = true },
  current_line_blame_opts = {
    delay = 1000,
    position = "eol",
  },
  sign_priority = 6,
  update_debounce = 100,
  diff_opts = {
    internal = true, -- If luajit is present
  },
}

gitsigns.packages = {
  ["gitsigns.nvim"] = {
    "lewis6991/gitsigns.nvim",
    commit = "3791dfa1ee356a3250e0b74f63bad90e27455f60",
  },
}

gitsigns.configs = {}
gitsigns.configs["gitsigns.nvim"] = function()
  require("gitsigns").setup(doom.modules.gitsigns.settings)
end

gitsigns.binds = {
  { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "o" },
  { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "x" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "g",
        name = "+git",
        {
          {
            "z",
            name = "+gitsigns",
            {
              { "S", '<cmd>lua require"gitsigns".stage_hunk()<CR>', name = "stage hunk" },
              { "u", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', name = "undo hunk" },
              { "r", '<cmd>lua require"gitsigns".reset_hunk()<CR>', name = "reset hunk" },
              { "R", '<cmd>lua require"gitsigns".reset_buffer()<CR>', name = "reset buffer" },
              { "h", '<cmd>lua require"gitsigns".preview_hunk()<CR>', name = "preview hunk" },
              { "b", '<cmd>lua require"gitsigns".blame_line()<CR>', name = "blame line" },
            },
          },
        },
      },
    },
  },
}

return gitsigns



-- ==============================================================================
-- FUNCTIONS                                                 *gitsigns-functions*
--
-- Note functions with the {async} attribute are run asynchronously and are
-- non-blocking (return immediately).
--
--
-- setup({cfg})                                                *gitsigns.setup()*
--                 Setup and start Gitsigns.
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters: ~
--                     {cfg} Table object containing configuration for
--                     Gitsigns. See |gitsigns-usage| for more details.
--
-- attach({bufnr})                                            *gitsigns.attach()*
--                 Attach Gitsigns to the buffer.
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters: ~
--                     {bufnr}  (number): Buffer number
--
-- detach({bufnr})                                            *gitsigns.detach()*
--                 Detach Gitsigns from the buffer {bufnr}. If {bufnr} is not
--                 provided then the current buffer is used.
--
--                 Parameters: ~
--                     {bufnr}  (number): Buffer number
--
-- detach_all()                                           *gitsigns.detach_all()*
--                 Detach Gitsigns from all buffers it is attached to.
--
-- refresh()                                                 *gitsigns.refresh()*
--                 Refresh all buffers.
--
--                 Attributes: ~
--                     {async}
--
-- get_actions()                                         *gitsigns.get_actions()*
--                 Get all the available line specific actions for the current
--                 buffer at the cursor position.
--
--                 Return: ~
--                     Dictionary of action name to function which when called
--                     performs action.
--
-- setloclist({nr}, {target})                             *gitsigns.setloclist()*
--                 Populate the location list with hunks. Automatically opens the
--                 location list window.
--
--                 Alias for: `setqflist({target}, { use_location_list = true, nr = {nr} }`
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters: ~
--                     {nr}     (integer): Window number or the |window-ID|.
--                              `0` for the current window (default).
--                     {target} (integer or string): See |gitsigns.setqflist()|.
--
-- setqflist({target}, {opts})                             *gitsigns.setqflist()*
--                 Populate the quickfix list with hunks. Automatically opens the
--                 quickfix window.
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters: ~
--                     {target} (integer or string):
--                              Specifies which files hunks are collected from.
--                              Possible values.
--                              • [integer]: The buffer with the matching buffer
--                                number. `0` for current buffer (default).
--                              • `"attached"`: All attached buffers.
--                              • `"all"`: All modified files for each git
--                                directory of all attached buffers in addition
--                                to the current working directory.
--                     {opts}   (table|nil):
--                              Additional options:
--                              • {use_location_list}: (boolean)
--                                Populate the location list instead of the
--                                quickfix list. Default to `false`.
--                              • {nr}: (integer)
--                                Window number or ID when using location list.
--                                Expand folds when navigating to a hunk which is
--                                inside a fold. Defaults to `0`.
--                              • {open}: (boolean)
--                                Open the quickfix/location list viewer.
--                                Defaults to `true`.
--
-- diffthis({base})                                         *gitsigns.diffthis()*
--                 Perform a |vimdiff| on the given file with {base} if it is
--                 given, or with the currently set base (index by default).
--
--                 Examples: >
--                   " Diff against the index
--                   :Gitsigns diffthis
--
--                   " Diff against the last commit
--                   :Gitsigns diffthis ~1
-- <
--
--                 For a more complete list of ways to specify bases, see
--                 |gitsigns-revision|.
--
--                 Attributes: ~
--                     {async}
--
-- reset_base({global})                                   *gitsigns.reset_base()*
--                 Reset the base revision to diff against back to the
--                 index.
--
--                 Alias for `change_base(nil, {global})` .
--
-- change_base({base}, {global})                         *gitsigns.change_base()*
--                 Change the base revision to diff against. If {base} is not
--                 given, then the original base is used. If {global} is given
--                 and true, then change the base revision of all buffers,
--                 including any new buffers.
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters:~
--                     {base} string|nil The object/revision to diff against.
--                     {global} boolean|nil Change the base of all buffers.
--
--                 Examples: >
--                   " Change base to 1 commit behind head
--                   :lua require('gitsigns').change_base('HEAD~1')
--
--                   " Also works using the Gitsigns command
--                   :Gitsigns change_base HEAD~1
--
--                   " Other variations
--                   :Gitsigns change_base ~1
--                   :Gitsigns change_base ~
--                   :Gitsigns change_base ^
--
--                   " Commits work too
--                   :Gitsigns change_base 92eb3dd
--
--                   " Revert to original base
--                   :Gitsigns change_base
-- <
--
--                 For a more complete list of ways to specify bases, see
--                 |gitsigns-revision|.
--
-- blame_line({opts})                                     *gitsigns.blame_line()*
--                 Run git blame on the current line and show the results in a
--                 floating window.
--
--                 Parameters: ~
--                     {opts}   (table|nil):
--                              Additional options:
--                              • {full}: (boolean)
--                                Display full commit message
--                              • {ignore_whitespace}: (boolean)
--                                Ignore whitespace when running blame.
--
--                 Attributes: ~
--                     {async}
--
-- get_hunks({bufnr})                                      *gitsigns.get_hunks()*
--                 Get hunk array for specified buffer.
--
--                 Parameters: ~
--                     {bufnr} integer: Buffer number, if not provided (or 0)
--                             will use current buffer.
--
--                 Return: ~
--                    Array of hunk objects. Each hunk object has keys:
--                      • `"type"`: String with possible values: "add", "change",
--                        "delete"
--                      • `"head"`: Header that appears in the unified diff
--                        output.
--                      • `"lines"`: Line contents of the hunks prefixed with
--                        either `"-"` or `"+"`.
--                      • `"removed"`: Sub-table with fields:
--                        • `"start"`: Line number (1-based)
--                        • `"count"`: Line count
--                      • `"added"`: Sub-table with fields:
--                        • `"start"`: Line number (1-based)
--                        • `"count"`: Line count
--
-- select_hunk()                                         *gitsigns.select_hunk()*
--                 Select the hunk under the cursor.
--
-- preview_hunk()                                       *gitsigns.preview_hunk()*
--                 Preview the hunk at the cursor position in a floating
--                 window.
--
-- prev_hunk({opts})                                       *gitsigns.prev_hunk()*
--                 Jump to the previous hunk in the current buffer.
--
--                 Parameters: ~
--                     See |gitsigns.next_hunk()|.
--
-- next_hunk({opts})                                       *gitsigns.next_hunk()*
--                 Jump to the next hunk in the current buffer.
--
--                 Parameters: ~
--                     {opts}  table|nil Configuration table. Keys:
--                             • {wrap}: (boolean)
--                               Whether to loop around file or not. Defaults
--                               to the value 'wrapscan'
--                             • {navigation_message}: (boolean)
--                               Whether to show navigation messages or not.
--                               Looks at 'shortmess' for default behaviour.
--                             • {foldopen}: (boolean)
--                               Expand folds when navigating to a hunk which is
--                               inside a fold. Defaults to `true` if 'foldopen'
--                               contains `search`.
--
-- reset_buffer_index()                           *gitsigns.reset_buffer_index()*
--                 Unstage all hunks for current buffer in the index. Note:
--                 Unlike |gitsigns.undo_stage_hunk()| this doesn't simply undo
--                 stages, this runs an `git reset` on current buffers file.
--
--                 Attributes: ~
--                     {async}
--
-- stage_buffer()                                       *gitsigns.stage_buffer()*
--                 Stage all hunks in current buffer.
--
--                 Attributes: ~
--                     {async}
--
-- undo_stage_hunk()                                 *gitsigns.undo_stage_hunk()*
--                 Undo the last call of stage_hunk().
--
--                 Note: only the calls to stage_hunk() performed in the current
--                 session can be undone.
--
--                 Attributes: ~
--                     {async}
--
-- reset_buffer()                                       *gitsigns.reset_buffer()*
--                 Reset the lines of all hunks in the buffer.
--
-- reset_hunk({range})                                    *gitsigns.reset_hunk()*
--                 Reset the lines of the hunk at the cursor position, or all
--                 lines in the given range. If {range} is provided, all lines in
--                 the given range are reset. This supports partial-hunks,
--                 meaning if a range only includes a portion of a particular
--                 hunk, only the lines within the range will be reset.
--
--                 Parameters:~
--                     {range} table|nil List-like table of two integers making
--                     up the line range from which you want to reset the hunks.
--
-- stage_hunk({range})                                    *gitsigns.stage_hunk()*
--                 Stage the hunk at the cursor position, or all lines in the
--                 given range. If {range} is provided, all lines in the given
--                 range are staged. This supports partial-hunks, meaning if a
--                 range only includes a portion of a particular hunk, only the
--                 lines within the range will be staged.
--
--                 Attributes: ~
--                     {async}
--
--                 Parameters:~
--                     {range} table|nil List-like table of two integers making
--                     up the line range from which you want to stage the hunks.
--
-- toggle_deleted()                                   *gitsigns.toggle_deleted()*
--                 Toggle |gitsigns-config-show_deleted|
--
-- toggle_current_line_blame()             *gitsigns.toggle_current_line_blame()*
--                 Toggle |gitsigns-config-current_line_blame|
--
-- toggle_word_diff()                               *gitsigns.toggle_word_diff()*
--                 Toggle |gitsigns-config-word_diff|
--
-- toggle_linehl()                                     *gitsigns.toggle_linehl()*
--                 Toggle |gitsigns-config-linehl|
--
-- toggle_numhl()                                       *gitsigns.toggle_numhl()*
--                 Toggle |gitsigns-config-numhl|
--
-- toggle_signs()                                       *gitsigns.toggle_signs()*
--                 Toggle |gitsigns-config-signcolumn|
