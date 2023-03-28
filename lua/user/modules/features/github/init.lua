-- NeoRoot
-- ThePrimeagen/refactoring.nvim
-- ray-x/lsp_signature.nvim
-- ray-x/lsp_signature.nvim
-- rcarriga/nvim-dap-ui
-- theHamsta/nvim-dap-virtual-text
-- nvim-telescope/telescope-dap.nvim
-- gcmt/taboo.vim
-- pretty-fold
-- fold-preview
-- preservim/vim-markdown
-- godlygeek/tabular
-- iamcco/markdown-preview.nvim
-- SidOfc/mkdx
-- nvim-orgmode/orgmode
-- -- ekickx/clipboard-image.nvim
-- local key_mappings = {
--     issue = {
--       close_issue = { lhs = "<space>ic", desc = "close issue" },
--       reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
--       list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
--       -- list_issues = { lhs = "<space>iL", desc = "list open issues on same repo" },
--       reload = { lhs = "<C-r>", desc = "reload issue" },
--       open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
--       copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
--       add_assignee = { lhs = "<space>aa", desc = "add assignee" },
--       remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
--       create_label = { lhs = "<space>lc", desc = "create label" },
--       add_label = { lhs = "<space>la", desc = "add label" },
--       remove_label = { lhs = "<space>ld", desc = "remove label" },
--       goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
--       add_comment = { lhs = "<space>ca", desc = "add comment" },
--       delete_comment = { lhs = "<space>cd", desc = "delete comment" },
--       next_comment = { lhs = "]c", desc = "go to next comment" },
--       prev_comment = { lhs = "[c", desc = "go to previous comment" },
--       react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
--       react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
--       react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
--       react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
--       react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
--       react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
--       react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
--       react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
--     },
--     pull_request = {
--       checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
--       merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
--       squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
--       list_commits = { lhs = "<space>pc", desc = "list PR commits" },
--       list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
--       show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
--       add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
--       remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
--       close_issue = { lhs = "<space>ic", desc = "close PR" },
--       reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
--       list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
--       reload = { lhs = "<C-r>", desc = "reload PR" },
--       open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
--       copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
--       goto_file = { lhs = "gf", desc = "go to file" },
--       add_assignee = { lhs = "<space>aa", desc = "add assignee" },
--       remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
--       create_label = { lhs = "<space>lc", desc = "create label" },
--       add_label = { lhs = "<space>la", desc = "add label" },
--       remove_label = { lhs = "<space>ld", desc = "remove label" },
--       goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
--       add_comment = { lhs = "<space>ca", desc = "add comment" },
--       delete_comment = { lhs = "<space>cd", desc = "delete comment" },
--       next_comment = { lhs = "]c", desc = "go to next comment" },
--       prev_comment = { lhs = "[c", desc = "go to previous comment" },
--       react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
--       react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
--       react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
--       react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
--       react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
--       react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
--       react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
--       react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
--     },
--     review_thread = {
--       goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
--       add_comment = { lhs = "<space>ca", desc = "add comment" },
--       add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
--       delete_comment = { lhs = "<space>cd", desc = "delete comment" },
--       next_comment = { lhs = "]c", desc = "go to next comment" },
--       prev_comment = { lhs = "[c", desc = "go to previous comment" },
--       select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
--       select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
--       close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
--       react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
--       react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
--       react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
--       react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
--       react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
--       react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
--       react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
--       react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
--     },
--     submit_win = {
--       approve_review = { lhs = "<C-a>", desc = "approve review" },
--       comment_review = { lhs = "<C-m>", desc = "comment review" },
--       request_changes = { lhs = "<C-r>", desc = "request changes review" },
--       close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
--     },
--     review_diff = {
--       add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
--       add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
--       focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
--       toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
--       next_thread = { lhs = "]t", desc = "move to next thread" },
--       prev_thread = { lhs = "[t", desc = "move to previous thread" },
--       select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
--       select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
--       close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
--       toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
--     },
--     file_panel = {
--       next_entry = { lhs = "j", desc = "move to next changed file" },
--       prev_entry = { lhs = "k", desc = "move to previous changed file" },
--       select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
--       refresh_files = { lhs = "R", desc = "refresh changed files panel" },
--       focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
--       toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
--       select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
--       select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
--       close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
--       toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
--     }
--   }
local M = {}

M.settings = {}

M.packages = {

  ["octo.nvim"] = {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}
-- local function getMappings1()
--   return key_mappings;
-- end

M.configs = {
  ["octo.nvim"] = function()
    require("octo").setup({
      default_remote = { "origin", "upstream" },
      -- mappings = getMappings1()
    })
  end,
}

M.autocmds = {}

M.cmds = {}
-- M.requires_modules = { "features.auto_install" }
M.binds = {
  {
    "<leader>go",
    [[<cmd>Octo actions<CR>]],
    name = "Octo menu",
    mode = "nv",
  },
}

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps

return M
