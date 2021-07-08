---[[---------------------------------------]]---
--     doomrc.lua - Load Doom Nvim doomrc      --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

function Check_BFC()
	-- /home/user/.config/doom-nvim/doomrc
	if Fn.filereadable(Doom_root .. '/doomrc') then
		Doom_bfc = true
	else
		Doom_bfc = false
	end
end

local function default_BFC_values()
    Doom = {
        -- Autosave
        -- false : Disable autosave
        -- true  : Enable autosave
        -- @default = false
        autosave = false,

        -- Format on save
        -- false : Disable format on save
        -- true  : Enable format on save
        -- @default = false
        fmt_on_save = false,

        -- Autosave sessions
        -- false : Disable session autosave
        -- true  : Enable session autosave
        -- @default = false
        autosave_sessions = false,

        -- Autoload sessions
        -- false : Disable session autoload
        -- true  : Enable session autosave
        -- @default = false
        autoload_last_session = false,

        -- Preserve last editing position
        -- false : Disable preservation of last editing position
        -- true  : Enable preservation of last editing position
        -- @default = false
        preserve_edit_pos = false,

        -- Default indent size
        -- @default = 4
        indent = 4,

        -- Show indent lines
        -- @default = true
        show_indent = true,

        -- Expand tabs
        -- Specifies if spaces or tabs must be used
        -- false : spaces
        -- true  : tabs
        -- @default = true
        expand_tabs = true,

        -- Set numbering
        -- false : Shows absolute number lines
        -- true  : Shows relative number lines
        -- @default = true
        relative_num = true,

        -- Set max cols
        -- Defines the column to show a vertical marker
        -- @default = 80
        max_columns = 80,

        -- Enable guicolors
        -- Enables gui colors on GUI versions of Neovim
        -- @default = true
        enable_guicolors = true,

        -- Sidebar sizing
        -- Specifies the default width of Tree Explorer and Tagbar
        -- @default = 25
        sidebar_width = 25,

        -- Tagbar left
        -- Sets Tagbar buffer to the left when enabled
        -- @default = true
        tagbar_left = true,

        -- Show hidden files
        -- @default = true
        show_hidden = true,

        -- Default colorscheme
        -- @default = doom-one
        colorscheme = 'doom-one',

        -- Background color
        -- @default = dark
        colorscheme_bg = 'dark',

        -- Checkupdates on start
        -- @default = false
        check_updates = false,

        -- Disabled plugins
        -- @default = {'lazygit', 'minimap', 'restclient'}
        -- example:
        --   disabled_plugins = {'emmet-vim'}
        disabled_plugins = { 'lazygit', 'minimap', 'restclient' },

        -- Disabled plugins modules
        -- @default = {'git', 'lsp', 'web'}
        -- example:
        --   disabled_modules = {'web'}
        disabled_modules = { 'git', 'lsp', 'web' },

        -- Install custom plugins
        -- @default = {}
        -- examples:
        --   plugins without options:
        --       custom_plugins = {'andweeb/presence.nvim'}
        --   plugins with options:
        --       custom_plugins = {
        --           {
        --              'repo': 'andweeb/presence.nvim',
        --              'enabled': true,
        --           }
        --       }
        custom_plugins = {},

        -- Set the parsers for TreeSitter
        -- @default = {}
        -- example:
        --   ts_parsers = {'python', 'javascript'}
        ts_parsers = {},

        -- Set the Terminal direction
        -- Available directions:
        --   - vertical
        --   - horizontal
        --   - window
        --   - float
        -- @default = 'horizontal'
        terminal_direction = 'horizontal',

        -- Set the Terminal width
        -- Applies only to float direction
        -- @default = 70
        terminal_width = 70,

        -- Set the Terminal height
        -- Applies to all directions except window
        -- @default = 20
        terminal_height = 20,

        -- Conceal level
        -- Set Neovim conceal level
        -- 0 : Disable indentline and show all
        -- 1 : Conceal some functions and show indentlines
        -- 2 : Concealed text is completely hidden unless it has a custom replacement
        --     character defined
        -- 3 : Concealed text is completely hidden
        conceallevel = 0,

        -- Logging level
        -- 0 : No logging
        -- 1 : All errors, no echo (default)
        -- 2 : All errors and messages, no echo
        -- 3 : All errors and messages, echo
        -- @default = 1
        logging = 3,
    }
end

function Load_BFC()
	-- /home/user/.config/doom-nvim/doomrc
	if Fn.filereadable(Doom_root .. '/doomrc') then
		Try({
			function()
				Cmd('luafile ' .. Doom_root .. '/doomrc')
				Log_message('+', 'Loading the BFC ...', 2)
			end,
			Catch({
				function(_)
					Log_message('!', 'Error while loading the BFC', 1)
				end,
			}),
		})
	else
		Log_message('+', 'No BFC file found, falling to defaults', 2)
        default_BFC_values()
	end
end
