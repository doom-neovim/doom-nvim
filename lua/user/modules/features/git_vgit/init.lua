local vgit = {}

vgit.packages = {
  ["vgit.nvim"] = { "tanvirtin/vgit.nvim" },
}

-- return function()
--   require('vgit').setup({
--   })
-- end

--       -- ['n <C-k>'] = 'hunk_up',
--       -- ['n <C-j>'] = 'hunk_down',

vgit.binds = {
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "g",
        name = "+git",
        {
          {
            "v",
            name = "+vgit",
            {
              { "s", ":lua require('vgit').buffer_hunk_stage()<cr>", name = "stage hunk" },
              { "r", ":lua require('vgit').buffer_hunk_reset()<cr>", name = "reset hunk" },
              { "p", ":lua require('vgit').buffer_hunk_preview()<cr>", name = "preview hunk" },
              { "b", ":lua require('vgit').buffer_blame_preview()<cr>", name = "blame preview" },
              { "f", ":lua require('vgit').buffer_diff_preview()<cr>", name = "diff preview" },
              { "h", ":lua require('vgit').buffer_history_preview()<cr>", name = "hist preview" },
              { "u", ":lua require('vgit').buffer_reset()<cr>", name = "buf reset" },
              {
                "g",
                ":lua require('vgit').buffer_gutter_blame_preview()<cr>",
                name = "gutter bl preview",
              },
              {
                "x",
                ":lua require('vgit').toggle_diff_preference()<cr>",
                name = "toggle diff pref",
              },
              {
                "P",
                name = "+project",
                {
                  { "s", ":lua require('vgit').project_stage_all()<cr>", name = "stage all" },
                  { "X", ":lua require('vgit').project_reset_all()<cr>", name = "discard all!staged" },
                  { "u", ":lua require('vgit').project_unstage_all()<cr>", name = "unstage all" },
                  {
                    "l",
                    ":lua require('vgit').project_hunks_preview()<cr>",
                    name = "proj hunks preview",
                  },
                  {
                    "d",
                    ":lua require('vgit').project_diff_preview()<cr>",
                    name = "proj diff preview",
                  },
                  { "q", ":lua require('vgit').project_hunks_qf()<cr>", name = "proj hunks qt" },
                },
              },
            },
          },
        },
      },
    },
  },
}

return vgit

-- buffer_hunk_preview()                              *vgit.buffer_hunk_preview()*
--                 Opens a diff preview showing the diff of the current buffer
--                 in comparison to that found in index. This preview will open up in
--                 a smaller window relative to where your cursor is. If the
--                 command is called while being on a hunk, the window will open
--                 focused on the diff of that hunk.
--
-- buffer_diff_preview()                               *vgit.buffer_diff_preview()*
--                 Opens a diff preview showing the diff of the current buffer in
--                 comparison to that found in index. If the command is called
--                 while being on a hunk, the window will open focused on the
--                 diff of that hunk.
--
-- buffer_history_preview()                         *vgit.buffer_history_preview()*
--                 Opens a diff preview along with a table of logs, enabling
--                 users to see different iterations of the file through it's
--                 lifecycle in git.
--
-- buffer_blame_preview()                             *vgit.buffer_blame_preview()*
--                 Opens a preview detailing the blame of the line that
--                 based on the cursor position within the buffer.
--
-- buffer_gutter_blame_preview()                *vgit.buffer_gutter_blame_preview()*
--                 Opens a preview which shows all the blames related to the
--                 lines of the buffer.
--
-- buffer_diff_staged_preview()                  *vgit.buffer_staged_diff_preview()*
--                 Opens a diff preview showing the diff of the staged changes in
--                 the current buffer.
--
-- buffer_hunk_staged_preview()                  *vgit.buffer_staged_hunk_preview()*
--                 Opens a diff preview showing the diff of the staged changes in
--                 the current buffer. This preview will open up in a smaller
--                 window relative to where your cursor is.
--
-- buffer_hunk_stage()                                    *vgit.buffer_hunk_stage()*
--                 Stages a hunk, if a cursor is on the hunk.
--
-- buffer_hunk_reset({target}, {opts})                    *vgit.buffer_hunk_reset()*
--                 Removes all changes made in the buffer on the hunk the cursor
--                 is currently on to what exists in HEAD.
--
-- buffer_stage()                                              *vgit.buffer_stage()*
--                 Stages all changes in the current buffer.
--
-- buffer_unstage()                                          *vgit.buffer_unstage()*
--                 Unstages all changes in the current buffer.
--
-- buffer_reset()                                              *vgit.buffer_reset()*
--                 Removes all current changes in the buffer and resets it to the
--                 version in HEAD.
--
-- project_stage_all()                                    *vgit.project_stage_all()*
--                 Stages all file changes in your project.
--
--
--
-- project_diff_preview()                            *vgit.project_diff_preview()*
--                 Opens a diff preview along with a table of all the files that
--                 have been changed, enabling users to see all the files that
--                 were changed in the current project. Users can use this view
--                 to stage and unstage all files using stage_all and
--                 unstage_all. Users can also trigger changes on individual
--                 files using |buffer_stage|, |buffer_unstage| and
--                 |buffer_reset| while being on the cursor that corresponds to
--                 the file.
--
-- project_commits_preview()                       *vgit.project_commits_preview()*
--                 Opens a diff preview along with a list of all the commits that
--                 are taken as argument params.
--
--
-- project_staged_hunks_preview()           *vgit.project_hunks_staged_preview()*
--                 Opens a diff preview along with a foldable list of all the
--                 current staged hunks in the project. Users can use this
--                 preview to cycle through all the hunks. Pressing enter on a
--                 hunk will open the file and focus on the hunk.
--
-- project_debug_preview()                               *vgit.project_debug_preview()*
--                 Opens a VGit view showing logs of a pariticular kind traced within
--                 the application.
--
-- hunk_up()                                                        *vgit.hunk_up()*
--                 Moves the cursor to the hunk above the current cursor
--                 position.
--
-- hunk_down()                                                    *vgit.hunk_down()*
--                 Moves the cursor to the hunk below the current cursor
--                 position.
--
-- toggle_diff_preference()                          *vgit.toggle_diff_preference()*
--                 Used to switch between "split" and "unified" diff.
--
-- toggle_live_gutter()                                  *vgit.toggle_live_gutter()*
--                 Enables/disables git gutter signs.
--
-- toggle_live_blame()                                    *vgit.toggle_live_blame()*
--                 Enables/disables current line blame functionality that is seen
--                 in the form of virtual texts.
--
-- toggle_authorship_code_lens()                *vgit.toggle_authorship_code_lens()*
--                 Enables/disables authorship code lens that can be found on top
--                 of the file.
--
-- toggle_tracing()                                          *vgit.toggle_tracing()*
--                 Enables/disables debug logs that are used internally by VGit to make
--                 suppressed logs visible.
