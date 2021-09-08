---[[-----------------]]---
--    WhichKey binds     --
---]]-----------------[[---

local utils = require("doom.utils")
local config = require("doom.core.config").config

-- Additional options for mappings
local opts = { silent = true }

-- Set Space key as leader
utils.map("n", "<Space>", "<Nop>", opts, "Editor", "open_whichkey", "Open WhichKey menu")
vim.g.mapleader = " "

if config.doom.new_file_split then
  utils.map(
    "n",
    "<leader>fn",
    ":new<CR>",
    opts,
    "Editor",
    "new_buffer",
    "Open a new unnamed buffer"
  )
else
  utils.map(
    "n",
    "<leader>fn",
    ":enew<CR>",
    opts,
    "Editor",
    "new_buffer_split",
    "Open a new unnamed buffer in a split window"
  )
end

-- Misc
utils.map(
  "n",
  "<leader>`",
  "<cmd>Telescope find_files<CR>",
  opts,
  "Editor",
  "find_files",
  "Find file"
)
utils.map(
  "n",
  "<leader>.",
  "<cmd>Telescope file_browser<CR>",
  opts,
  "Editor",
  "file_browser",
  "Browse files"
)
utils.map(
  "n",
  "<leader>,",
  "<cmd>Telescope buffers show_all_buffers=true<CR>",
  opts,
  "Movement",
  "switch_buffers",
  "Switch buffers"
)
utils.map(
  "n",
  "<leader>/",
  "<cmd>Telescope live_grep<CR>",
  opts,
  "Editor",
  "live_grep",
  "Search a word"
)
utils.map(
  "n",
  "<leader>:",
  "<cmd>Telescope command_history<CR>",
  opts,
  "Editor",
  "command_history",
  "Command history"
)

-- Buffers
utils.map(
  "n",
  "<leader>bc",
  '<cmd>lua require("bufferline").handle_close_buffer(vim.fn.bufnr("%"))<CR>',
  opts,
  "Buffer",
  "close_current_buffer",
  "Close current buffer"
)
utils.map(
  "n",
  "<leader>bb",
  "<cmd>e #<CR>",
  opts,
  "Buffer",
  "switch_buffer",
  "Switch to other buffer"
)
utils.map(
  "n",
  "<leader>b]",
  '<cmd>lua require("bufferline").cycle(1)<CR>',
  opts,
  "Buffer",
  "next_buffer_alt",
  "Goto next buffer"
)
utils.map(
  "n",
  "<leader>bn",
  '<cmd>lua require("bufferline").cycle(1)<CR>',
  opts,
  "Buffer",
  "next_buffer",
  "Goto next buffer"
)
utils.map(
  "n",
  "<leader>bg",
  '<cmd>lua require("bufferline").pick_buffer()<CR>',
  opts,
  "Buffer",
  "goto_buffer",
  "Goto buffer"
)
utils.map(
  "n",
  "<leader>b[",
  '<cmd>lua require("bufferline").cycle(-1)<CR>',
  opts,
  "Buffer",
  "prev_buffer_alt",
  "Goto previous buffer"
)
utils.map(
  "n",
  "<leader>bp",
  '<cmd>lua require("bufferline").cycle(-1)<CR>',
  opts,
  "Buffer",
  "prev_buffer",
  "Goto previous buffer"
)
utils.map(
  "n",
  "<leader>bf",
  "<cmd>FormatWrite<CR>",
  opts,
  "Buffer",
  "format_buffer",
  "Format buffer"
)

-- Doom
utils.map(
  "n",
  "<leader>dc",
  '<cmd>lua require("doom.core.functions").edit_config()<CR>',
  opts,
  "Doom",
  "edit_doom_config",
  "Edit Doom configuration"
)
utils.map(
  "n",
  "<leader>dd",
  "<cmd>lua require('doom.core.functions').open_docs()<CR>",
  opts,
  "Doom",
  "help_doom",
  "Open Doom user manual"
)
utils.map("n", "<leader>du", "<cmd>DoomUpdate<CR>", opts, "Doom", "update_doom", "Update Doom Nvim")
utils.map(
  "n",
  "<leader>dr",
  "<cmd>DoomRollback<CR>",
  opts,
  "Doom",
  "rollback_doom",
  "Rollback Doom Nvim version"
)
utils.map(
  "n",
  "<leader>dR",
  '<cmd>lua require("doom.core.functions").create_report()<CR>',
  opts,
  "Doom",
  "create_crash_report",
  "Create crash report"
)
utils.map(
  "n",
  "<leader>ds",
  "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<CR>",
  opts,
  "Editor",
  "change_colorscheme",
  "Change colorscheme"
)
utils.map(
  "n",
  "<leader>db",
  "<cmd>Telescope mapper<CR>",
  opts,
  "Doom",
  "show_keybindings",
  "Show Doom keybindings"
)
utils.map(
  "n",
  "<leader>dl",
  "<cmd>lua require('doom.core.functions').reload_custom_settings()<CR>",
  opts,
  "Doom",
  "reload_user_settings",
  "Reload user custom settings"
)

-- Plugins
utils.map(
  "n",
  "<leader>ps",
  "<cmd>PackerSync<CR>",
  opts,
  "Plugins",
  "packer_sync",
  "Synchronize your plugins"
)
utils.map(
  "n",
  "<leader>pi",
  "<cmd>PackerInstall<CR>",
  opts,
  "Plugins",
  "packer_install",
  "Install missing plugins"
)
utils.map(
  "n",
  "<leader>pc",
  "<cmd>PackerClean<CR>",
  opts,
  "Plugins",
  "packer_clean",
  "Clean unused plugins"
)
utils.map(
  "n",
  "<leader>pC",
  "<cmd>PackerCompile<CR>",
  opts,
  "Plugins",
  "packer_compile",
  "Compile your plugins changes"
)
utils.map(
  "n",
  "<leader>pS",
  "<cmd>PackerStatus<CR>",
  opts,
  "Plugins",
  "packer_status",
  "Plugins status"
)
utils.map(
  "n",
  "<leader>pp",
  "<cmd>PackerProfile<CR>",
  opts,
  "Plugins",
  "packer_profile",
  "Profile the time taken loading your plugins"
)

-- files
utils.map(
  "n",
  "<leader>fc",
  "<cmd>e $MYVIMRC<CR>",
  opts,
  "Editor",
  "edit_vimrc",
  "Edit your Neovim rc"
)
utils.map(
  "n",
  "<leader>ff",
  "<cmd>Telescope find_files<CR>",
  opts,
  "Editor",
  "find_files_alt",
  "Find files"
)

utils.map(
  "n",
  "<leader>fr",
  "<cmd>Telescope oldfiles<CR>",
  opts,
  "Editor",
  "recent_files",
  "Recently opened files"
)
utils.map(
  "n",
  "<leader>ft",
  "<cmd>Telescope help_tags<CR>",
  opts,
  "Editor",
  "help_tags",
  "Help tags"
)
utils.map(
  "n",
  "<leader>fR",
  "<cmd>SudaRead<CR>",
  opts,
  "Editor",
  "read_sudo",
  "Re-open file with sudo permissions"
)
utils.map(
  "n",
  "<leader>fw",
  "<cmd>SudaWrite<CR>",
  opts,
  "Editor",
  "write_sudo",
  "Write file with sudo permissions"
)

-- search
utils.map(
  "n",
  "<leader>sg",
  "<cmd>Telescope live_grep<CR>",
  opts,
  "Editor",
  "live_grep_alt",
  "Search a word"
)
utils.map(
  "n",
  "<leader>sb",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  opts,
  "Editor",
  "fzf",
  "Search in buffer"
)
utils.map(
  "n",
  "<leader>ss",
  "<cmd>Telescope lsp_document_symbols<CR>",
  opts,
  "LSP",
  "lsp_symbols",
  "Goto symbol"
)
utils.map(
  "n",
  "<leader>sh",
  "<cmd>Telescope command_history<CR>",
  opts,
  "Editor",
  "command_history_alt",
  "Command history"
)
utils.map(
  "n",
  "<leader>sm",
  "<cmd>Telescope marks<CR>",
  opts,
  "Editor",
  "jump_mark",
  "Jump to mark"
)

-- windows
utils.map("n", "<leader>ww", "<C-W>p", opts, "Window", "other_window", "Goto other window")
utils.map("n", "<leader>wd", "<C-W>c", opts, "Window", "close_window", "Close current window")
utils.map("n", "<leader>w-", "<C-W>s", opts, "Window", "split_below", "Split window below")
utils.map("n", "<leader>w|", "<C-W>v", opts, "Window", "split_right", "Split window right")
utils.map("n", "<leader>w2", "<C-W>v", opts, "Window", "double_layout", "Layout double columns")
utils.map("n", "<leader>wh", "<C-W>h", opts, "Window", "window_left", "Window left")
utils.map("n", "<leader>wj", "<C-W>j", opts, "Window", "window_below", "Window below")
utils.map("n", "<leader>wl", "<C-W>l", opts, "Window", "window_right", "Window right")
utils.map("n", "<leader>wk", "<C-W>k", opts, "Window", "window_up", "Window up")
utils.map("n", "<leader>wH", "<C-W>5<", opts, "Window", "expand_window_left", "Expand window left")
utils.map(
  "n",
  "<leader>wJ",
  "<cmd>resize +5<CR>",
  opts,
  "Window",
  "expand_window_below",
  "Expand window below"
)
utils.map(
  "n",
  "<leader>wL",
  "<C-W>5>",
  opts,
  "Window",
  "expand_window_right",
  "Expand window right"
)
utils.map(
  "n",
  "<leader>wK",
  "<cmd>resize -5<CR>",
  opts,
  "Window",
  "expand_window_up",
  "Expand window up"
)
utils.map("n", "<leader>w=", "<C-W>=", opts, "Window", "balance_window", "Balance window")
utils.map("n", "<leader>ws", "<C-W>s", opts, "Window", "split_below_alt", "Split window below")
utils.map("n", "<leader>wv", "<C-W>v", opts, "Window", "split_right_alt", "Split window right")

-- quit / sessions
utils.map(
  "n",
  "<leader>qq",
  '<cmd>lua require("doom.core.functions").quit_doom()<CR>',
  opts,
  "Editor",
  "save_nvim",
  "Exit Neovim"
)
utils.map(
  "n",
  "<leader>qw",
  '<cmd>lua require("doom.core.functions").quit_doom(true, true)<CR>',
  opts,
  "Editor",
  "save_exit_nvim",
  "Save and exit Neovim"
)
utils.map(
  "n",
  "<leader>qr",
  "<cmd>lua require('persistence').load({ last = true })<CR>",
  opts,
  "Editor",
  "restore_session",
  "Restore previously saved session"
)

-- toggle
utils.map(
  "n",
  "<leader>ob",
  "<cmd>lua require('dapui').toggle()<CR>",
  opts,
  "Editor",
  "open_dapui",
  "Open debugging UI"
)
utils.map(
  "n",
  "<leader>od",
  "<cmd>Dashboard<CR>",
  opts,
  "Editor",
  "open_dashboard",
  "Open start screen"
)
utils.map(
  "n",
  "<leader>oe",
  "<cmd>NvimTreeToggle<CR>",
  opts,
  "Editor",
  "open_tree_alt",
  "Toggle file explorer"
)
utils.map(
  "n",
  "<leader>om",
  "<cmd>MinimapToggle<CR>",
  opts,
  "Editor",
  "open_minimap_alt",
  "Toggle code minimap"
)
utils.map(
  "n",
  "<leader>or",
  "<cmd>Ranger<CR>",
  opts,
  "Editor",
  "open_ranger_browser",
  "Toggle Ranger File Browser"
)
utils.map(
  "n",
  "<leader>os",
  "<cmd>SymbolsOutline<CR>",
  opts,
  "Editor",
  "open_symbols_alt",
  "Toggle SymbolsOutline (LSP symbols)"
)
utils.map(
  "n",
  "<leader>ot",
  "<cmd>ToggleTerm<CR>",
  opts,
  "Editor",
  "open_terminal",
  "Toggle terminal"
)

-- git
utils.map("n", "<leader>go", "<cmd>LazyGit<CR>", opts, "Git", "lazygit", "Open LazyGit")
utils.map(
  "n",
  "<leader>gl",
  '<cmd>TermExec cmd="git pull"<CR>',
  opts,
  "Git",
  "git_pull",
  "Pull remote changes"
)
utils.map(
  "n",
  "<leader>gp",
  '<cmd>TermExec cmd="git push"<CR>',
  opts,
  "Git",
  "git_push",
  "Push git changes"
)
utils.map(
  "n",
  "<leader>gs",
  "<cmd>Telescope git_status<CR>",
  opts,
  "Git",
  "git_status",
  "Browse git status"
)
utils.map(
  "n",
  "<leader>gB",
  "<cmd>Telescope git_branches<CR>",
  opts,
  "Git",
  "git_branches",
  "Browse git branches"
)
utils.map(
  "n",
  "<leader>gc",
  "<cmd>Telescope git_commits<CR>",
  opts,
  "Git",
  "git_commits",
  "Browse git commits"
)

-- code
utils.map(
  "n",
  "<leader>ch",
  "<Plug>RestNvim<CR>",
  opts,
  "Editor",
  "exec_http_alt",
  "Execute http client under cursor"
)
utils.map(
  "n",
  "<leader>ci",
  '<cmd>lua require("doom.modules.built-in.runner").start_repl()<CR>',
  opts,
  "Editor",
  "start_repl",
  "Start a REPL"
)
utils.map(
  "n",
  "<leader>cr",
  '<cmd>lua require("doom.modules.built-in.runner").run_code()<CR>',
  opts,
  "Editor",
  "run_file",
  "Run the current file"
)
utils.map(
  "n",
  "<leader>cb",
  '<cmd>lua require("doom.modules.built-in.compiler").compile()<cr>',
  opts,
  "Editor",
  "compile",
  "Compile project"
)
utils.map(
  "n",
  "<leader>cc",
  '<cmd>lua require("doom.modules.built-in.compiler").compile_and_run()<cr>',
  opts,
  "Editor",
  "compile_and_run",
  "Compile and run project"
)

-- debugging
utils.map(
  "n",
  "<leader>cde",
  "<cmd>lua require('dapui').eval()<CR>",
  opts,
  "DAP",
  "dap_eval",
  "Evaluate word under cursor"
)
utils.map(
  "v",
  "<leader>cds",
  "<cmd>lua require('dapui').eval()<CR>",
  opts,
  "DAP",
  "dap_eval_selection",
  "Evaluate selection"
)

-- lsp
utils.map("n", "<leader>cli", "<cmd>LspInfo<CR>", opts, "LSP", "lsp_info", "LSP Information")
utils.map(
  "n",
  "<leader>cla",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  opts,
  "LSP",
  "code_action_alt",
  "Code actions"
)
utils.map(
  "n",
  "<leader>cld",
  "<cmd>lua vim.lsp.buf.type_definition()<CR>",
  opts,
  "LSP",
  "type_definition",
  "Show type definition"
)
utils.map(
  "n",
  "<leader>cll",
  "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
  opts,
  "LSP",
  "line_diagnostic",
  "Show line diagnostics"
)
utils.map(
  "n",
  "<leader>clq",
  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
  opts,
  "LSP",
  "diagnostic_list",
  "Diagnostics into location list"
)

-- jumps
utils.map("n", "<leader>ja", "<C-^>", opts, "Jumps", "jump_alternate_file", "Alternate file")
utils.map("n", "<leader>jj", "<C-o>", opts, "Jumps", "jump_older", "Jump to older pos")
utils.map("n", "<leader>jk", "<C-i>", opts, "Jumps", "jump_newer", "Jump to newer pos")
utils.map("n", "<leader>jp", ":pop<CR>", opts, "Jumps", "jump_pop_tag", "Pop from tag stack")
utils.map(
  "n",
  "<leader>jt",
  ":tag<CR>",
  opts,
  "Jumps",
  "jump_folow_tag",
  "Follow tag / add to stack"
)
-- save
utils.map("n", "<leader>v", "<cmd>w<cr>", opts, "Save", "save_left", "Save v")
utils.map("n", "<leader>m", "<cmd>w<cr>", opts, "Save", "save_right", "Save m")

-- man pages
utils.map("n", "<leader>h", ":Man ", { silent = false }, "Man page", "man_page", "Man page")
