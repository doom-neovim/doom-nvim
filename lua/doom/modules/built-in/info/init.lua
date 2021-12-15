local utils = require("doom.utils")
local system = require("doom.core.system")

--- @class Info
local info = {}

--- Info buffer namespace
local info_ns = vim.api.nvim_create_namespace("doom_info_ns")
--- Info buffer ID
local info_buffer
--- Current buffer ID, meant to be used for getting buffer information like treesitter parser
local curr_buffer = vim.api.nvim_win_get_buf(0)

--- Doom Nvim banner
local doom_banner = {
  "                                                                               ",
  "=================     ===============     ===============   ========  ========",
  "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //",
  "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
  "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
  "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
  "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
  "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
  "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
  "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
  "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
  "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
  "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
  "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
  "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
  "||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
  "||.=='    _-'                                                     `' |  /==.||",
  "=='    _-'                        N E O V I M                         \\/   `==",
  "\\   _-'                                                                `-_   /",
  " `''                                                                      ``'  ",
  "                                                                               ",
}

--- System-wide commands required by Doom (some of them are optional)
local additional_executables = { "rg", "fd", "git", "npm", "node", "tree-sitter" }

--- Gets padding with N length
--- @param n number
--- @return string
local function get_padding(n)
  return (" "):rep(n)
end

--- Padding levels
local padding_level = {
  get_padding(2),
  get_padding(4),
  get_padding(6),
  get_padding(10),
}

--- Aligns text to center
--- @param text_lines table
--- @param align_mode string
--- @return table
local function align_text(text_lines, align_mode)
  local aligned_text = {}
  local padding_amount
  local window_width = vim.api.nvim_win_get_width(0)

  for _, line in ipairs(text_lines) do
    if align_mode == "left" then
      padding_amount = 2
    elseif align_mode == "center" then
      padding_amount = math.floor(window_width / 2) - math.floor(line:len() / 2)
    end
    local padding = get_padding(padding_amount)
    table.insert(aligned_text, padding .. line)
  end

  return aligned_text
end

--- Checks if a system command exists
--- @param command string
--- @return boolean
local function command_exists(command)
  return vim.fn.executable(command) == 1
end

--- Extract the basename of given filepath, suffix is not trimed.
local function basename(path)
  return string.match(path, string.format(".*%s(.*)", system.sep))
end

--- Get the active language servers, extracted from my galaxyline fork
--- @return string
local get_lsp_clients = function(bufnr)
  local msg = "No Active Lsp"
  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return msg
  end

  local client_names = ""
  for _, client in pairs(clients) do
    if string.len(client_names) < 1 then
      client_names = client_names .. client.name
    else
      client_names = client_names .. ", " .. client.name
    end
  end
  return string.len(client_names) > 0 and client_names or msg
end

local function get_doom_info()
  local doom_info = {}

  ----- DOOM INFORMATION ------------------------
  -----------------------------------------------
  -- Doom version
  local doom_version = utils.doom_version
  -- Doom branch
  local doom_branch = utils.get_git_output("branch --show-current", true)
  -- Configurations path
  local config_path = require("doom.core.config").source
  local modules_path = require("doom.core.config.modules").source
  local userplugins_path = require("doom.core.config.userplugins").source

  ----- NVIM INFORMATION ------------------------
  -----------------------------------------------
  local nvim_dev_version = false
  -- Neovim version
  local version = vim.version()
  if version.minor == 7 then
    nvim_dev_version = true
  end
  local nvim_version = string.format(
    "%s.%s.%s %s",
    version.major,
    version.minor,
    version.patch,
    nvim_dev_version and "(prerelease)" or ""
  )

  -- Local commit and last update date
  local current_commit = utils.get_git_output("rev-parse HEAD", true)
  local last_update_date = utils.get_git_output("show -s --format=%cD " .. current_commit, true)

  vim.list_extend(doom_info, {
    "Doom Nvim Information",
    string.format("%s• Neovim version: %s%s", padding_level[1], padding_level[1], nvim_version),
    string.format(
      "%s• Doom version: %s%s (%s branch)",
      padding_level[1],
      padding_level[2],
      doom_version,
      doom_branch
    ),
    string.format(
      "%s• Doom root:%s%s",
      padding_level[1],
      padding_level[2]:rep(2),
      system.doom_root
    ),
    string.format("%s• Last update date: %s", padding_level[1], last_update_date),
  })
  if doom_branch == "develop" then
    -- Current commit relevant information
    local current_commit_author = utils.get_git_output(
      'show -s --format="%cN <%cE>" ' .. current_commit,
      true
    )
    local current_commit_message = utils.get_git_output(
      "show -s --format=%s " .. current_commit,
      true
    )
    local current_commit_body = utils.get_git_output(
      "show -s --format=%b " .. current_commit,
      false
    )

    vim.list_extend(doom_info, {
      "",
      string.format("%s▶ Doom current commit", padding_level[1]),
      string.format("%s• Commit short hash: %s", padding_level[2], current_commit:sub(1, 7)),
      string.format(
        "%s• Commit author: %s%s",
        padding_level[2],
        padding_level[2],
        current_commit_author
      ),
      string.format(
        "%s• Commit subject:%s%s",
        padding_level[2],
        padding_level[2],
        current_commit_message
      ),
    })
    -- Check if the commit body is empty before trying to add it
    if current_commit_body:gsub("[\r\n]", ""):len() > 0 then
      vim.list_extend(doom_info, {
        "",
        string.format("%s○ Commit body", padding_level[2]),
      })
      -- Add each line separately because Neovim does not like newlines
      for _, body_part in ipairs(vim.split(current_commit_body, "\n")) do
        if body_part:len() > 0 then
          vim.list_extend(doom_info, {
            string.format(
              "%s",
              body_part
                :gsub("^", string.format("%s", padding_level[3]))
                :gsub("^%s+", string.format("%s", padding_level[3]))
                :gsub("^%s+%-", string.format("%s-", padding_level[3]))
            ),
          })
        end
      end
    end
  end
  vim.list_extend(doom_info, {
    "",
    string.format("%s▶ Doom configurations paths", padding_level[1]),
    string.format("%s- %s", padding_level[2], config_path),
    string.format("%s- %s", padding_level[2], modules_path),
    string.format("%s- %s", padding_level[2], userplugins_path),
  })

  ----- TREESITTER INFORMATION ------------------
  -----------------------------------------------
  vim.list_extend(doom_info, {
    "",
    string.format("%s▶ Installed treesitter parsers", padding_level[1]),
  })
  for _, parser in ipairs(require("nvim-treesitter.info").installed_parsers()) do
    table.insert(doom_info, string.format("%s- %s", padding_level[2], parser))
  end

  ----- LSP INFORMATION -------------------------
  -----------------------------------------------
  if not require("doom.utils").is_plugin_disabled("lsp") and packer_plugins["nvim-lspinstall"] then
    vim.list_extend(doom_info, {
      "",
      string.format("%s▶ Installed language servers", padding_level[1]),
    })
    for _, server in ipairs(require("lspinstall").installed_servers()) do
      -- Get the real name for the language server because lspinstall names them like the filetype
      local server_path = require("lspconfig")[server].cmd[1]
      local real_server_name = basename(server_path)
      if not real_server_name then
        -- If we were unable to get the server executable name then fallback to default server name (filetype)
        real_server_name = server
      else
        -- Fix some server names that are "incorrect"
        real_server_name = real_server_name
          :gsub("%-language%-server", "")
          :gsub("%-langserver", "")
          :gsub("typescript", "tsserver")
          :gsub("sumneko%-lua", "sumneko_lua")
      end
      table.insert(doom_info, string.format("%s- %s", padding_level[2], real_server_name))
    end
  end
  return doom_info
end

local function get_buffer_info()
  local buffer_info = {}
  local buffer_ft = vim.api.nvim_buf_get_option(curr_buffer, "filetype")

  vim.list_extend(buffer_info, {
    "Buffer Information",
    string.format(
      "%s• %s%s%s",
      padding_level[1],
      "Is read-only?",
      padding_level[3],
      vim.api.nvim_buf_get_option(curr_buffer, "readonly") and "yes" or "no"
    ),
    string.format("%s• %s: %s", padding_level[1], "Detected filetype", buffer_ft),
    "",
    string.format("%s▶ Settings", padding_level[1]),
    string.format(
      "%s• %s: %s%s",
      padding_level[2],
      "File format",
      padding_level[3],
      vim.api.nvim_buf_get_option(curr_buffer, "fileformat"):upper()
    ),
  })
  if vim.api.nvim_buf_get_option(curr_buffer, "fileencoding"):len() > 0 then
    vim.list_extend(buffer_info, {
      string.format(
        "%s• %s: %s%s",
        padding_level[2],
        "File encoding",
        padding_level[2],
        vim.api.nvim_buf_get_option(curr_buffer, "fileencoding"):upper()
      ),
    })
  end
  vim.list_extend(buffer_info, {
    string.format(
      "%s• %s: %s",
      padding_level[2],
      "Indentation width",
      vim.api.nvim_buf_get_option(curr_buffer, "tabstop")
    ),
    string.format(
      "%s• %s: %s",
      padding_level[2],
      "Indentation style",
      vim.api.nvim_buf_get_option(curr_buffer, "expandtab") and "Tabs" or "Spaces"
    ),
    "",
    ----- TREESITTER INFORMATION ------------------
    -----------------------------------------------
    string.format("%s▶ TreeSitter", padding_level[1]),
    string.format(
      "%s• %s%s",
      padding_level[2],
      "Is parser installed?" .. padding_level[2]:rep(3),
      utils.has_value(require("nvim-treesitter.info").installed_parsers(), buffer_ft) and "yes"
        or "no"
    ),
    string.format(
      "%s• %s %s",
      padding_level[2],
      "Is indentation enabled?" .. padding_level[2]:rep(2),
      require("nvim-treesitter.configs").is_enabled("indent", buffer_ft) and "yes" or "no"
    ),
    string.format(
      "%s• %s %s",
      padding_level[2],
      "Is syntax highlighting enabled?",
      require("nvim-treesitter.configs").is_enabled("highlight", buffer_ft) and "yes" or "no"
    ),
  })

  ----- LSP INFORMATION -------------------------
  -----------------------------------------------
  if not require("doom.utils").is_plugin_disabled("lsp") and packer_plugins["nvim-lspinstall"] then
    vim.list_extend(buffer_info, {
      "",
      string.format("%s▶ Language Servers", padding_level[1]),
      string.format(
        "%s• %s %s",
        padding_level[2],
        "Is language server installed?",
        utils.has_value(require("lspinstall").installed_servers(), buffer_ft) and "yes" or "no"
      ),
      string.format(
        "%s• %s:%s%s",
        padding_level[2],
        "Active language servers",
        padding_level[3],
        get_lsp_clients(curr_buffer)
      ),
    })
  end

  return buffer_info
end

local function get_system_info()
  local sys_info = {}

  ----- OS --------------------------------------
  -----------------------------------------------
  -- Get the current OS and if the user is running Linux then get also the
  -- distribution name, e.g. Manjaro
  local sysname = vim.loop.os_uname().sysname
  local distro_name
  -- If the user is running Linux then get the distribution name
  if sysname == "Linux" then
    distro_name = vim.trim(
      -- PRETTY_NAME="Distribution (Additional info)", e.g.
      --   PRETTY_NAME="Fedora 34 (KDE Plasma)"
      vim.fn.system(
        'cat /etc/os-release | grep "^PRETTY_NAME" | sed '
          .. "'s/^PRETTY_NAME=\"//' | sed "
          .. "'s/\"//'"
      )
    )
  end
  vim.list_extend(sys_info, {
    "System Information",
    string.format("%s• %s: %s%s", padding_level[1], "OS", padding_level[4], sysname),
  })
  if distro_name then
    vim.list_extend(sys_info, {
      string.format("%s• %s: %s%s", padding_level[1], "Distro", padding_level[3], distro_name),
    })
  end
  vim.list_extend(sys_info, {
    string.format("%s• %s: %s", padding_level[1], "Architecture", vim.loop.os_uname().machine),
  })

  ----- PROGRAMS --------------------------------
  -----------------------------------------------
  vim.list_extend(sys_info, {
    "",
    string.format("%s▶ Programs", padding_level[1]),
  })
  for _, program in ipairs(additional_executables) do
    local opt_message, extra_padding = "", ""

    -- We add an extra whitespace to 'no' so we can have an uniform format
    local is_installed = command_exists(program) and "yes" or "no"
    if (program == "node" or program == "npm") and (not command_exists(program)) then
      opt_message = "(Optional, required by some language servers)"
    elseif program == "fd" and (not command_exists(program)) then
      opt_message = "(Optional, improves performance for many file indexing commands)"
    elseif program == "rg" and (not command_exists(program)) then
      opt_message = "(Optional, improves performance for many file indexing commands)"
    elseif program == "tree-sitter" and (not command_exists(program)) then
      opt_message = "(Optional, only needed for :TSInstallFromGrammar, not required for :TSInstall)"
    end

    -- Add padding after the question, e.g. Found fd?   yes/no
    --                                               ^^
    --                                             padding
    if program:len() ~= 11 then
      extra_padding = get_padding(11 - program:len())
    end
    table.insert(
      sys_info,
      string.format(
        "%s• Found `%s`? %s%s%s",
        padding_level[2],
        program,
        extra_padding,
        -- Add extra whitespace to "no"
        is_installed == "yes" and is_installed or is_installed .. " ",
        opt_message:len() < 1 and opt_message or " " .. opt_message
      )
    )
  end

  return sys_info
end

--- Set buffer contents
--- @param buffer_id number
local function set_buffer_content(buffer_id)
  local content = {}

  -- Doom banner
  for _, banner_line in ipairs(align_text(doom_banner, "center")) do
    table.insert(content, banner_line)
  end

  -- Doom Nvim information
  local doom_info = get_doom_info()
  local buffer_info = get_buffer_info()
  local system_info = get_system_info()

  for _, info_section in ipairs({ doom_info, { "", "" }, buffer_info, { "", "" }, system_info }) do
    local aligned_info = align_text(info_section, "left")
    vim.list_extend(content, aligned_info)
  end
  vim.api.nvim_buf_set_lines(buffer_id, 0, info_ns, false, content)
end

local function set_syntax_highlighting(buffer_id)
  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(buffer_id, 0, vim.fn.line("$"), true)) do
    if lnum < #doom_banner then
      vim.api.nvim_buf_add_highlight(buffer_id, -1, "Comment", lnum, 0, -1)
    else
      local hl = "NONE"
      local endl = -1
      if line:find("Information") then
        -- Information headers
        hl = "Title" -- "Structure"
      elseif line:find("▶") then
        -- Information subheaders (level 2)
        hl = "VariableBuiltin"
      elseif line:find("○") then
        -- Information subheaders (level 3)
        hl = "FunctionBuiltin"
      elseif line:find(": ") or line:find("? ") then
        -- Information fields
        hl = "Bold"
        if #vim.split(line, "?") < 2 then
          -- Highlight only the field name, e.g. 'Version'
          endl = vim.split(line, ":")[1]:len()
        else
          -- Highlight only the field name
          endl = vim.split(line, "?")[1]:len()
        end
      end
      vim.api.nvim_buf_add_highlight(buffer_id, -1, hl, lnum - 1, 0, endl)
    end
  end

  -- Extra highlights that we can't manually set with nvim_buf_add_highlight
  -- NOTE: these extra newlines are for improving code readability, don't remove!
  vim.cmd([[
    " True / False
    " NOTE: Use String and ErrorMsg as a fallback if TextXBold does not exists in the current colorscheme
    call matchadd(match(execute("hi TextSuccessBold"), "cleared") =~ -1  ? "TextSuccessBold" : "String", "yes")
    call matchadd(match(execute("hi TextErrorBold"), "cleared") =~ -1  ? "TextErrorBold" : "ErrorMsg", '\(no\s\)\|\(no$\)\|\(No Active Lsp\)')

    " Commit author email
    call matchadd("Bold", '\([-a-zA-Z0-9_]\+@[-a-zA-Z0-9_]\+\.\w\+\)')

    " Commit SHA
    call matchadd("Constant", '\(\s[a-f0-9]\{7}$\)')

    " Commits scopes
    call matchadd("Msg", '\(hotfix\)\|\(fix\)')
    call matchadd("MoreMsg", "feat")
    call matchadd("WarningMsg", "refact")
    call matchadd("ErrorMsg", '\(refact\!\)\|\(BREAKING CHANGE\)')
    call matchadd("SpecialComment", "docs")
    call matchadd("Comment", "chore")
    call matchadd("Constant", "release")
    call matchadd("SpecialComment", '\(([-a-zA-Z0-9_]\+):\)\@>')

    " Release type and branches
    call matchadd("Bold", '\(prerelease\)\|\(develop\|main\)\sbranch')

    " Strings
    call matchadd("String", '".*"')

    " Numbers
    call matchadd("Number", '\s[0-9]\+$')

    " Fields
    call matchadd("String", "•")

    " Lists and delimiters
    call matchadd("Operator", '\(\s\+-\s\)\|:\s\+\|<\|>\|@\|(\|)')

    " Neovim commands
    " NOTE: Use Comment as a fallback if CommentBold does not exists in the current colorscheme
    call matchadd(match(execute("hi CommentBold"), "cleared") =~ -1 ? "CommentBold" : "Comment", '\(:[A-Za-z]\+\)')

    " Inline code like markdown
    call matchadd(match(execute("hi CommentBold"), "cleared") =~ -1 ? "CommentBold" : "Comment", '\(`[-a-zA-Z0-9_,\.\<\>@\$#+\!]\+`\)')
    " Conceal start `
    call matchadd("Conceal", '\(`[-a-zA-Z0-9_,\.\<\>@\$#+\!]\+`\)\@=', 10, -1, {"conceal": ""})
    " Conceal ending `
    call matchadd("Conceal", '\(\(`?\)\|\(`$\)\|\(`\s\)\|\(`,\s\)\)\@=', 10, -1, {"conceal": ""})
  ]])
end

--- Open Doom information floating window
info.open = function()
  -- Create a new scratch buffer
  info_buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(info_buffer, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(info_buffer, "filetype", "DoomInfo")

  -- Get terminal dimensions
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  -- Floating window dimensions and start position
  local win_height = math.ceil(height * 0.9 - 2)
  local win_width = math.ceil(width * 0.9)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)
  -- Set our floating window options
  local win_opts = {
    style = "minimal", -- Disable most UI options
    border = "single", -- Single whitespace padding
    relative = "editor", -- Relative to global editor grid
    width = win_width, -- Width
    height = win_height, -- Height
    row = row, -- Row position
    col = col, -- Column position
  }

  -- Create our window with attached buffer
  vim.api.nvim_open_win(info_buffer, true, win_opts)

  -- Set the buffer contents
  set_buffer_content(info_buffer)

  -- Set the buffer options
  vim.api.nvim_buf_set_option(info_buffer, "modifiable", false)
  -- Concealing for inline code
  vim.opt_local.conceallevel = 2
  vim.opt_local.concealcursor = "nc"
  -- Folding
  vim.opt_local.foldtext =
    [[substitute(substitute(substitute(getline(v:foldstart), '?\s\+', '? ', 'g'), ':\s\+', ': ', 'g'), '\\t', repeat('\ ',&tabstop), 'g') . ' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' fields)']]
  vim.opt_local.shiftwidth = 6
  vim.opt_local.foldignore = [[=\\\|]]
  vim.opt_local.foldmethod = "indent"
  vim.opt_local.fillchars = {
    eob = " ", -- suppress ~ at EndOfBuffer
    fold = " ", -- supress dots between folds info
  }

  -- Set the buffer keybinds
  vim.api.nvim_buf_set_keymap(
    info_buffer,
    "n",
    "q",
    "<cmd>bdelete<CR>",
    { noremap = true, silent = true }
  )

  -- Set the buffer syntax
  set_syntax_highlighting(info_buffer)
end

info.close = function()
  vim.api.nvim_buf_delete(info_buffer, {})
end

info.toggle = function()
  if info_buffer and vim.fn.bufexists(info_buffer) == 1 then
    info.close()
  else
    info.open()
  end
end

return info
