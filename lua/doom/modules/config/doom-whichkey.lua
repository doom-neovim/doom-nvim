return function()
    local wk = require('which-key')
    local utils = require('doom.utils')

    ----- WhichKey setup ------------------------
    ---------------------------------------------
	wk.setup({
		plugins = {
			marks = false,
			registers = false,
			presets = {
				operators = false,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		operators = {
			d = 'Delete',
			c = 'Change',
			y = 'Yank (copy)',
			['g~'] = 'Toggle case',
			['gu'] = 'Lowercase',
			['gU'] = 'Uppercase',
			['>'] = 'Indent right',
			['<lt>'] = 'Indent left',
			['zf'] = 'Create fold',
			['!'] = 'Filter though external program',
			-- ['v'] = 'Visual Character Mode',
			gc = 'Comments',
		},
		icons = {
			breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
			separator = '➜', -- symbol used between a key and it's label
			group = '+', -- symbol prepended to a group
		},
		window = {
			padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
		},
		layout = {
			height = { min = 1, max = 10 }, -- min and max height of the columns
		},
		hidden = { '<silent>', '^:', '^ ' }, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
		triggers = { '<leader>' }, -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specifiy a list manually
	})

    ----- WhichKey binds ------------------------
    ---------------------------------------------
    -- Buffers
    wk.register({
        ['<leader>'] = {
            b = {
                name = '+buffer',
                ['1'] = {
                    ':lua require("bufferline").go_to_buffer(1)<CR>',
                    'Buffer 1',
                },
                ['2'] = {
                    ':lua require("bufferline").go_to_buffer(2)<CR>',
                    'Buffer 2',
                },
                ['3'] = {
                    ':lua require("bufferline").go_to_buffer(3)<CR>',
                    'Buffer 3',
                },
                ['4'] = {
                    ':lua require("bufferline").go_to_buffer(4)<CR>',
                    'Buffer 4',
                },
                ['5'] = {
                    ':lua require("bufferline").go_to_buffer(5)<CR>',
                    'Buffer 5',
                },
                ['6'] = {
                    ':lua require("bufferline").go_to_buffer(6)<CR>',
                    'Buffer 6',
                },
                ['7'] = {
                    ':lua require("bufferline").go_to_buffer(7)<CR>',
                    'Buffer 7',
                },
                ['8'] = {
                    ':lua require("bufferline").go_to_buffer(8)<CR>',
                    'Buffer 8',
                },
                ['9'] = {
                    ':lua require("bufferline").go_to_buffer(9)<CR>',
                    'Buffer 9',
                },
                c = {
                    ':lua require("bufferline").handle_close_buffer(vim.fn.bufnr("%"))<CR>',
                    'Close current buffer',
                },
                f = {
                    -- This is equal to :FormatWrite
                    ':lua require("format").format("!", true, 1, vim.fn.line("$"))<CR>',
                    'Format buffer',
                },
                n = { ':lua require("bufferline").cycle(1)<CR>', 'Next buffer' },
                P = {
                    ':lua require("bufferline").pick_buffer()<CR>',
                    'Pick buffer',
                },
                p = {
                    ':lua require("bufferline").cycle(-1)<CR>',
                    'Previous buffer',
                },
            },
        },
    })

    -- Plugins
    wk.register({
        ['<leader>'] = {
            p = {
                name = '+plugins',
                c = {
                    ':lua require("packer").clean()<CR>',
                    'Clean disabled or unused plugins',
                },
                i = {
                    ':lua require("packer").install()<CR>',
                    'Install missing plugins',
                },
                p = {
                    ':lua require("packer").profile_output()<CR>',
                    'Profile the time taken loading your plugins',
                },
                s = {
                    ':lua require("packer").sync()<CR>',
                    'Performs PackerClean and then PackerUpdate',
                },
                u = {
                    ':lua require("packer").update()<CR>',
                    'Update your plugins',
                },
            },
        },
    })

    -- Order
    wk.register({
        ['<leader>'] = {
            o = {
                name = '+order',
                d = {
                    ':lua require("bufferline").sort_buffers_by("directory")<CR>',
                    'Sort by directory',
                },
                l = {
                    ':lua require("bufferline").sort_buffers_by("extension")<CR>',
                    'Sort by language',
                },
                n = {
                    ':lua require("bufferline").move(1)<CR>',
                    'Re-order buffer to next',
                },
                p = {
                    ':lua require("bufferline").move(-1)<CR>',
                    'Re-order buffer to previous',
                },
            },
        },
    })

    -- File
    wk.register({
        ['<leader>'] = {
            f = {
                name = '+file',
                c = { ':e $MYVIMRC<CR>', 'Edit Neovim configuration' },
                n = { 'Create a new unnamed buffer' },
                f = { ':Telescope find_files<CR>', 'Find files' },
                b = { ':Telescope marks<CR>', 'Bookmarks' },
                W = { ':Telescope live_grep<CR>', 'Find word' },
                t = { ':Telescope help_tags<CR>', 'Help tags' },
                h = { ':Telescope oldfiles<CR>', 'Recently opened files' },
                w = { ':SudaWrite<CR>', 'Write file with sudo permissions' },
                r = { ':SudaRead<CR>', 'Re-open file with sudo permissions' },
            },
        },
    })

    -- Window
    wk.register({
        ['<leader>'] = {
            w = {
                name = '+window',
                C = { ':only<CR>', 'Close all other windows' },
                c = { ':close<CR>', 'Close current window' },
                h = { ':split<CR>', 'Split horizontally' },
                v = { ':vsplit<CR>', 'Split vertically' },
            },
        },
    })

    -- Sessions
    wk.register({
        ['<leader>'] = {
            s = {
                name = '+sessions',
                s = { ':SaveSession<CR>', 'Save current session' },
                r = { ':RestoreSession<CR>', 'Restore previously saved session' },
                l = {
                    ':Telescope session-lens search_session<CR>',
                    'Session switcher',
                },
            },
        },
    })

    -- Doom Menu
    wk.register({
        ['<leader>'] = {
            d = {
                name = '+doom',
                c = {
                    ':e ~/.config/doom-nvim/doomrc<CR>',
                    'Edit your Doom Nvim configuration',
                },
                d = { ':help doom_nvim<CR>', 'Open Doom Nvim documentation' },
                u = { ':DoomUpdate<CR>', 'Check Doom Nvim udpates' },
                r = {
                    ':lua require("doom.core.functions").create_report()<CR>',
                    'Create crash report',
                },
            },
        },
    })

    -- Toggler
    wk.register({
        ['<leader>'] = {
            t = {
                name = '+toggle',
                s = { ':Dashboard<CR>', 'Open start screen' },
                c = { ':DashboardChangeColorscheme<CR>', 'Change colorscheme' },
                e = { ':NvimTreeToggle<CR>', 'Toggle Tree Explorer' },
                m = { ':MinimapToggle<CR>', 'Toggle Minimap' },
                S = { ':SymbolsOutline<CR>', 'Toggle Symbols view' },
                t = { ':ToggleTerm<CR>', 'Toggle terminal' },
            },
        },
    })

    -- If web is enabled and restclient is enabled too
    if
        not utils.has_value(Doom.disabled_modules, 'web')
        and (not utils.has_value(Doom.disabled_plugins, 'restclient'))
    then
        wk.register({
            ['<leader>'] = {
                r = {
                    name = '+runner',
                    r = {
                        ':DotHttp<CR>',
                        'Run restclient on the line that the cursor is currently on',
                    },
                },
            },
        })
    end

    -- If LSP is enabled
    if
        not utils.has_value(Doom.disabled_modules, 'lsp')
        and (not utils.has_value(Doom.disabled_plugins, 'compe'))
    then
        wk.register({
            ['<leader>'] = {
                l = {
                    name = '+lsp',
                    d = {
                        '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                        'Show type definition',
                    },
                    l = {
                        '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                        'Show line diagnostics',
                    },
                    L = {
                        '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
                        'Diagnostics into location list',
                    },
                },
            },
        })
    end

    -- If Git is enabled
    if not utils.has_value(Doom.disabled_modules, 'git') then
        wk.register({
            ['<leader>'] = {
                g = {
                    name = '+git',
                    o = { ':LazyGit<CR>', 'Open LazyGit' },
                    P = { ':TermExec cmd="git pull"<CR>', 'Pull' },
                    p = { ':TermExec cmd="git push"<CR>', 'Push' },
                    S = { 'Stage hunk' },
                    s = { ':TermExec cmd="git status"<CR>', 'Status' },
                    u = { 'Undo stage hunk' },
                    R = { 'Reset buffer' },
                    r = { 'Reset hunk' },
                    h = { 'Preview hunk' },
                    b = { 'Blame line' },
                },
            },
        })
    end
end
