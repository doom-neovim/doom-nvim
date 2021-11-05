---[[-----------------]]---
--    WhichKey binds     --
---]]-----------------[[---

local mappings = require("doom.utils.mappings")
local config = require("doom.core.config").config
local is_plugin_disabled = require("doom.utils").is_plugin_disabled

-- Additional options for mappings
local opts = { silent = true }

-- Set Space key as leader
if is_plugin_disabled("which-key") then
  mappings.map("n", "<Space>", "<Nop>", opts, "Editor", "open_whichkey", "Open WhichKey menu")
end
vim.g.mapleader = " "

if config.doom.new_file_split then
  if config.doom.vertical_split then
    mappings.map(
      "n",
      "<Leader>fn",
      ":vert new<CR>",
      opts,
      "Editor",
      "new_buffer_split_vertical",
      "Open a new unnamed buffer in a vertical split window"
    )
  else
    mappings.map(
      "n",
      "<Leader>fn",
      ":new<CR>",
      opts,
      "Editor",
      "new_buffer_split",
      "Open a new unnamed buffer in a split window"
    )
  end
else
  mappings.map(
    "n",
    "<leader>fn",
    ":enew<CR>",
    opts,
    "Editor",
    "new_buffer",
    "Open a new unnamed buffer"
  )
end

-- Misc
mappings.map(
  "n",
  "<leader>`",
  "<cmd>lua require('telescope.builtin').find_files({cwd=vim.fn.expand('%:p:h')})<CR>",
  opts,
  "Editor",
  "cwd_file_browser",
  "Find file from CWD of current file"
)
mappings.map(
  "n",
  "<leader>.",
  "<cmd>Telescope file_browser<CR>",
  opts,
  "Editor",
  "file_browser",
  "Browse files"
)
mappings.map(
  "n",
  "<leader>,",
  "<cmd>Telescope buffers show_all_buffers=true<CR>",
  opts,
  "Movement",
  "switch_buffers",
  "Switch buffers"
)
mappings.map(
  "n",
  "<leader>/",
  "<cmd>Telescope live_grep<CR>",
  opts,
  "Editor",
  "live_grep",
  "Search a word"
)
mappings.map(
  "n",
  "<leader>:",
  "<cmd>Telescope command_history<CR>",
  opts,
  "Editor",
  "command_history",
  "Command history"
)

-- buffers
mappings.map(
  "n",
  "<leader>bc",
  '<cmd>lua require("bufferline").handle_close_buffer(vim.fn.bufnr("%"))<CR>',
  opts,
  "Buffer",
  "close_current_buffer",
  "Close current buffer"
)
mappings.map(
  "n",
  "<leader>bb",
  "<cmd>e #<CR>",
  opts,
  "Buffer",
  "switch_buffer",
  "Switch to other buffer"
)
mappings.map(
  "n",
  "<leader>b]",
  '<cmd>lua require("bufferline").cycle(1)<CR>',
  opts,
  "Buffer",
  "next_buffer_alt",
  "Goto next buffer"
)
mappings.map(
  "n",
  "<leader>bn",
  '<cmd>lua require("bufferline").cycle(1)<CR>',
  opts,
  "Buffer",
  "next_buffer",
  "Goto next buffer"
)
mappings.map(
  "n",
  "<leader>bg",
  '<cmd>lua require("bufferline").pick_buffer()<CR>',
  opts,
  "Buffer",
  "goto_buffer",
  "Goto buffer"
)
mappings.map(
  "n",
  "<leader>b[",
  '<cmd>lua require("bufferline").cycle(-1)<CR>',
  opts,
  "Buffer",
  "prev_buffer_alt",
  "Goto previous buffer"
)
mappings.map(
  "n",
  "<leader>bp",
  '<cmd>lua require("bufferline").cycle(-1)<CR>',
  opts,
  "Buffer",
  "prev_buffer",
  "Goto previous buffer"
)
mappings.map(
  "n",
  "<leader>bf",
  "<cmd>FormatWrite<CR>",
  opts,
  "Buffer",
  "format_buffer",
  "Format buffer"
)

-- doom
mappings.map(
  "n",
  "<leader>dc",
  "<cmd>DoomConfigs<CR>",
  opts,
  "Doom",
  "edit_doom_config",
  "Edit Doom configuration"
)
mappings.map(
  "n",
  "<leader>dd",
  "<cmd>DoomManual<CR>",
  opts,
  "Doom",
  "help_doom",
  "Open Doom user manual"
)
mappings.map(
  "n",
  "<leader>du",
  "<cmd>DoomUpdate<CR>",
  opts,
  "Doom",
  "update_doom",
  "Update Doom Nvim"
)
mappings.map(
  "n",
  "<leader>dr",
  "<cmd>DoomRollback<CR>",
  opts,
  "Doom",
  "rollback_doom",
  "Rollback Doom Nvim version"
)
mappings.map(
  "n",
  "<leader>dR",
  "<cmd>DoomReport<CR>",
  opts,
  "Doom",
  "create_crash_report",
  "Create crash report"
)
mappings.map(
  "n",
  "<leader>ds",
  "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<CR>",
  opts,
  "Editor",
  "change_colorscheme",
  "Change colorscheme"
)
mappings.map(
  "n",
  "<leader>db",
  "<cmd>Telescope mapper<CR>",
  opts,
  "Doom",
  "show_keybindings",
  "Show Doom keybindings"
)
mappings.map(
  "n",
  "<leader>dl",
  "<cmd>DoomConfigsReload<CR>",
  opts,
  "Doom",
  "reload_user_settings",
  "Reload user custom settings"
)
mappings.map(
  "n",
  "<leader>di",
  "<cmd>DoomInfo<CR>",
  opts,
  "Doom",
  "display_info_dashboard",
  "Display information dashboard"
)

-- plugins
mappings.map(
  "n",
  "<leader>ps",
  "<cmd>PackerSync<CR>",
  opts,
  "Plugins",
  "packer_sync",
  "Synchronize your plugins"
)
mappings.map(
  "n",
  "<leader>pi",
  "<cmd>PackerInstall<CR>",
  opts,
  "Plugins",
  "packer_install",
  "Install missing plugins"
)
mappings.map(
  "n",
  "<leader>pc",
  "<cmd>PackerClean<CR>",
  opts,
  "Plugins",
  "packer_clean",
  "Clean unused plugins"
)
mappings.map(
  "n",
  "<leader>pC",
  "<cmd>PackerCompile<CR>",
  opts,
  "Plugins",
  "packer_compile",
  "Compile your plugins changes"
)
mappings.map(
  "n",
  "<leader>pS",
  "<cmd>PackerStatus<CR>",
  opts,
  "Plugins",
  "packer_status",
  "Plugins status"
)
mappings.map(
  "n",
  "<leader>pp",
  "<cmd>PackerProfile<CR>",
  opts,
  "Plugins",
  "packer_profile",
  "Profile the time taken loading your plugins"
)

-- files
mappings.map(
  "n",
  "<leader>fc",
  "<cmd>e $MYVIMRC<CR>",
  opts,
  "Editor",
  "edit_vimrc",
  "Edit your Neovim rc"
)
mappings.map(
  "n",
  "<leader>ff",
  "<cmd>Telescope find_files<CR>",
  opts,
  "Editor",
  "find_files_alt",
  "Find files"
)

mappings.map(
  "n",
  "<leader>fr",
  "<cmd>Telescope oldfiles<CR>",
  opts,
  "Editor",
  "recent_files",
  "Recently opened files"
)
mappings.map(
  "n",
  "<leader>ft",
  "<cmd>Telescope help_tags<CR>",
  opts,
  "Editor",
  "help_tags",
  "Help tags"
)
mappings.map(
  "n",
  "<leader>fR",
  "<cmd>SudaRead<CR>",
  opts,
  "Editor",
  "read_sudo",
  "Re-open file with sudo permissions"
)
mappings.map(
  "n",
  "<leader>fw",
  "<cmd>SudaWrite<CR>",
  opts,
  "Editor",
  "write_sudo",
  "Write file with sudo permissions"
)

-- search
mappings.map(
  "n",
  "<leader>sg",
  "<cmd>Telescope live_grep<CR>",
  opts,
  "Editor",
  "live_grep_alt",
  "Search a word"
)
mappings.map(
  "n",
  "<leader>sb",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  opts,
  "Editor",
  "fzf",
  "Search in buffer"
)
mappings.map(
  "n",
  "<leader>ss",
  "<cmd>Telescope lsp_document_symbols<CR>",
  opts,
  "LSP",
  "lsp_symbols",
  "Goto symbol"
)
mappings.map(
  "n",
  "<leader>sh",
  "<cmd>Telescope command_history<CR>",
  opts,
  "Editor",
  "command_history_alt",
  "Command history"
)
mappings.map(
  "n",
  "<leader>sm",
  "<cmd>Telescope marks<CR>",
  opts,
  "Editor",
  "jump_mark",
  "Jump to mark"
)

-- tweak
mappings.map(
  "n",
  "<leader>tb",
  '<cmd>lua require("doom.core.functions").toggle_background()<CR>',
  opts,
  "Tweak",
  "toggle_background",
  "Toggle background"
)
mappings.map(
  "n",
  "<leader>tc",
  '<cmd>lua require("doom.core.functions").toggle_completion()<CR>',
  opts,
  "Tweak",
  "toggle_completion",
  "Toggle completion"
)
-- "g" as gutter, git, ... (but this tweak is applicable for linter like ALE, too)
mappings.map(
  "n",
  "<leader>tg",
  '<cmd>lua require("doom.core.functions").toggle_signcolumn()<CR>',
  opts,
  "Tweak",
  "toggle_signcolumn",
  "Toggle signcolumn"
)
mappings.map(
  "n",
  "<leader>ti",
  '<cmd>lua require("doom.core.functions").set_indent()<CR>',
  opts,
  "Tweak",
  "set_indent",
  "Set tab and indent"
)
mappings.map(
  "n",
  "<leader>tn",
  '<cmd>lua require("doom.core.functions").change_number()<CR>',
  opts,
  "Tweak",
  "change_number",
  "Change number"
)
if not is_plugin_disabled("autopairs") then
  mappings.map(
    "n",
    "<leader>tp",
    '<cmd>lua require("doom.core.functions").toggle_autopairs()<CR>',
    opts,
    "Tweak",
    "toggle_autopairs",
    "Toggle autopairs"
  )
end
mappings.map(
  "n",
  "<leader>ts",
  '<cmd>lua require("doom.core.functions").toggle_spell()<CR>',
  opts,
  "Tweak",
  "toggle_spell",
  "Toggle spell"
)
mappings.map(
  "n",
  "<leader>tx",
  '<cmd>lua require("doom.core.functions").change_syntax()<CR>',
  opts,
  "Tweak",
  "change_syntax",
  "Change syntax"
)

-- windows
mappings.map("n", "<leader>ww", "<C-W>p", opts, "Window", "other_window", "Goto other window")
mappings.map("n", "<leader>wd", "<C-W>c", opts, "Window", "close_window", "Close current window")
mappings.map("n", "<leader>w-", "<C-W>s", opts, "Window", "split_below", "Split window below")
mappings.map("n", "<leader>w|", "<C-W>v", opts, "Window", "split_right", "Split window right")
mappings.map("n", "<leader>w2", "<C-W>v", opts, "Window", "double_layout", "Layout double columns")
mappings.map("n", "<leader>wh", "<C-W>h", opts, "Window", "window_left", "Window left")
mappings.map("n", "<leader>wj", "<C-W>j", opts, "Window", "window_below", "Window below")
mappings.map("n", "<leader>wl", "<C-W>l", opts, "Window", "window_right", "Window right")
mappings.map("n", "<leader>wk", "<C-W>k", opts, "Window", "window_up", "Window up")
mappings.map(
  "n",
  "<leader>wH",
  "<C-W>5<",
  opts,
  "Window",
  "expand_window_left",
  "Expand window left"
)
mappings.map(
  "n",
  "<leader>wJ",
  "<cmd>resize +5<CR>",
  opts,
  "Window",
  "expand_window_below",
  "Expand window below"
)
mappings.map(
  "n",
  "<leader>wL",
  "<C-W>5>",
  opts,
  "Window",
  "expand_window_right",
  "Expand window right"
)
mappings.map(
  "n",
  "<leader>wK",
  "<cmd>resize -5<CR>",
  opts,
  "Window",
  "expand_window_up",
  "Expand window up"
)
mappings.map("n", "<leader>w=", "<C-W>=", opts, "Window", "balance_window", "Balance window")
mappings.map("n", "<leader>ws", "<C-W>s", opts, "Window", "split_below_alt", "Split window below")
mappings.map("n", "<leader>wv", "<C-W>v", opts, "Window", "split_right_alt", "Split window right")

-- quit / sessions
mappings.map(
  "n",
  "<leader>qq",
  '<cmd>lua require("doom.core.functions").quit_doom()<CR>',
  opts,
  "Editor",
  "save_nvim",
  "Exit Neovim"
)
mappings.map(
  "n",
  "<leader>qw",
  '<cmd>lua require("doom.core.functions").quit_doom(true, true)<CR>',
  opts,
  "Editor",
  "save_exit_nvim",
  "Save and exit Neovim"
)
mappings.map(
  "n",
  "<leader>qr",
  "<cmd>lua require('persistence').load({ last = true })<CR>",
  opts,
  "Editor",
  "restore_session",
  "Restore previously saved session"
)

-- open
mappings.map(
  "n",
  "<leader>ob",
  "<cmd>lua require('dapui').toggle()<CR>",
  opts,
  "Editor",
  "open_dapui",
  "Open debugging UI"
)
mappings.map(
  "n",
  "<leader>od",
  "<cmd>Dashboard<CR>",
  opts,
  "Editor",
  "open_dashboard",
  "Open start screen"
)
if not config.doom.use_netrw then
  mappings.map(
    "n",
    "<leader>oe",
    "<cmd>NvimTreeToggle<CR>",
    opts,
    "Editor",
    "open_tree_alt",
    "Toggle file explorer"
  )
else
  mappings.map(
    "n",
    "<leader>oe",
    string.format("<cmd>Lexplore%s<CR>", config.doom.explorer_right and "!" or ""),
    opts,
    "Editor",
    "open_tree_alt",
    "Toggle file explorer"
  )
end
mappings.map(
  "n",
  "<leader>om",
  "<cmd>MinimapToggle<CR>",
  opts,
  "Editor",
  "open_minimap_alt",
  "Toggle code minimap"
)
mappings.map(
  "n",
  "<leader>or",
  "<cmd>Ranger<CR>",
  opts,
  "Editor",
  "open_ranger_browser",
  "Toggle Ranger File Browser"
)
mappings.map(
  "n",
  "<leader>os",
  "<cmd>SymbolsOutline<CR>",
  opts,
  "Editor",
  "open_symbols_alt",
  "Toggle SymbolsOutline (LSP symbols)"
)
mappings.map(
  "n",
  "<leader>ot",
  "<cmd>ToggleTerm<CR>",
  opts,
  "Editor",
  "open_terminal",
  "Toggle terminal"
)

-- git
mappings.map("n", "<leader>go", "<cmd>LazyGit<CR>", opts, "Git", "lazygit", "Open LazyGit")
mappings.map(
  "n",
  "<leader>gl",
  '<cmd>TermExec cmd="git pull"<CR>',
  opts,
  "Git",
  "git_pull",
  "Pull remote changes"
)
mappings.map(
  "n",
  "<leader>gp",
  '<cmd>TermExec cmd="git push"<CR>',
  opts,
  "Git",
  "git_push",
  "Push git changes"
)
mappings.map(
  "n",
  "<leader>gs",
  "<cmd>Telescope git_status<CR>",
  opts,
  "Git",
  "git_status",
  "Browse git status"
)
mappings.map(
  "n",
  "<leader>gB",
  "<cmd>Telescope git_branches<CR>",
  opts,
  "Git",
  "git_branches",
  "Browse git branches"
)
mappings.map(
  "n",
  "<leader>gc",
  "<cmd>Telescope git_commits<CR>",
  opts,
  "Git",
  "git_commits",
  "Browse git commits"
)

-- code
mappings.map(
  "n",
  "<leader>ch",
  "<Plug>RestNvim<CR>",
  opts,
  "Editor",
  "exec_http_alt",
  "Execute http client under cursor"
)
mappings.map(
  "n",
  "<leader>ci",
  '<cmd>lua require("doom.modules.built-in.runner").start_repl()<CR>',
  opts,
  "Editor",
  "start_repl",
  "Start a REPL"
)
mappings.map(
  "n",
  "<leader>cr",
  '<cmd>lua require("doom.modules.built-in.runner").run_code()<CR>',
  opts,
  "Editor",
  "run_file",
  "Run the current file"
)
mappings.map(
  "n",
  "<leader>cb",
  '<cmd>lua require("doom.modules.built-in.compiler").compile()<cr>',
  opts,
  "Editor",
  "compile",
  "Compile project"
)
mappings.map(
  "n",
  "<leader>cc",
  '<cmd>lua require("doom.modules.built-in.compiler").compile_and_run()<cr>',
  opts,
  "Editor",
  "compile_and_run",
  "Compile and run project"
)

-- debugging
mappings.map(
  "n",
  "<leader>cdb",
  "<cmd>lua require('dap').toggle_breakpoint()<CR>",
  opts,
  "DAP",
  "dap_toggle_brkpt",
  "Toggle breakpoint on current line"
)
mappings.map(
  "n",
  "<leader>cdc",
  "<cmd>lua require('dap').continue()<CR>",
  opts,
  "DAP",
  "dap_continue",
  "Start (or continue) a debug session"
)
mappings.map(
  "n",
  "<leader>cdd",
  "<cmd>lua require('dap').disconnect()",
  opts,
  "DAP",
  "dap_disconnect",
  "End debugging session"
)
mappings.map(
  "n",
  "<leader>cde",
  "<cmd>lua require('dapui').eval()<CR>",
  opts,
  "DAP",
  "dap_eval",
  "Evaluate word under cursor"
)
mappings.map(
  "v",
  "<leader>cds",
  "<cmd>lua require('dapui').eval()<CR>",
  opts,
  "DAP",
  "dap_eval_selection",
  "Evaluate selection"
)

-- lsp
mappings.map("n", "<leader>cli", "<cmd>LspInfo<CR>", opts, "LSP", "lsp_info", "LSP Information")
mappings.map(
  "n",
  "<leader>cla",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  opts,
  "LSP",
  "code_action_alt",
  "Code actions"
)
mappings.map(
  "n",
  "<leader>cld",
  "<cmd>lua vim.lsp.buf.type_definition()<CR>",
  opts,
  "LSP",
  "type_definition",
  "Show type definition"
)
mappings.map(
  "n",
  "<leader>cll",
  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, border = "single" })<CR>',
  opts,
  "LSP",
  "line_diagnostic",
  "Show line diagnostics"
)
mappings.map(
  "n",
  "<leader>clq",
  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
  opts,
  "LSP",
  "diagnostic_list",
  "Diagnostics into location list"
)
mappings.map(
  "n",
  "<leader>clr",
  "<cmd>lua vim.lsp.buf.rename()<CR>",
  opts,
  "LSP",
  "rename_reference",
  "Rename the reference under cursor"
)

-- jumps
mappings.map("n", "<leader>ja", "<C-^>", opts, "Jumps", "jump_alternate_file", "Alternate file")
mappings.map("n", "<leader>jj", "<C-o>", opts, "Jumps", "jump_older", "Jump to older pos")
mappings.map("n", "<leader>jk", "<C-i>", opts, "Jumps", "jump_newer", "Jump to newer pos")
mappings.map("n", "<leader>jp", ":pop<CR>", opts, "Jumps", "jump_pop_tag", "Pop from tag stack")
mappings.map(
  "n",
  "<leader>jt",
  ":tag<CR>",
  opts,
  "Jumps",
  "jump_folow_tag",
  "Follow tag / add to stack"
)
-- save
mappings.map("n", "<leader>v", "<cmd>w<cr>", opts, "Save", "save_left", "Save v")
mappings.map("n", "<leader>m", "<cmd>w<cr>", opts, "Save", "save_right", "Save m")

-- man pages
mappings.map("n", "<leader>h", ":Man ", { silent = false }, "Man page", "man_page", "Man page")
