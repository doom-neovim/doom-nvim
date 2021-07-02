return function()
	local utils = require('doom.utils')

	local bo = vim.bo
	local gl = require('galaxyline')
	local lsp = require('galaxyline.provider_lsp')
	local file_info = require('galaxyline.provider_fileinfo')
	local buffer = require('galaxyline.provider_buffer')
	local condition = require('galaxyline.condition')

	local gls = gl.section

	gl.short_line_list = {
		'NvimTree',
		'packer',
		'minimap',
		'Outline',
		'toggleterm',
	}

	-- Dynamically change statusline colors,
	-- defaults to doom-one dark variant colors.
	--
	-- @tparam string name The color name to be returned
	-- @return string
	local function get_color(name)
		return function()
			local colors = {
				bg = '#23272e',
				fg = '#bbc2cf',
				section_bg = '#5B6268',
				yellow = '#ECBE7B',
				cyan = '#46D9FF',
				green = '#98be65',
				orange = '#da8548',
				magenta = '#c678dd',
				blue = '#51afef',
				red = '#ff6c6b',
			}

			if
				vim.g.colors_name == 'doom-one'
				and vim.opt.background:get() == 'light'
			then
				colors = {
					bg = '#c6c7c7',
					fg = '#383a42',
					fg_alt = '#9ca0a4',
					yellow = '#986801',
					cyan = '#0184bc',
					green = '#50a14f',
					orange = '#da8548',
					magenta = '#a626a4',
					blue = '#4078f2',
					red = '#e45649',
				}
			end
			return colors[name]
		end
	end

	local function is_dashboard()
		local buftype = buffer.get_buffer_filetype()
		if buftype == 'DASHBOARD' then
			return true
		end
	end

	local function is_not_dashboard()
		local buftype = buffer.get_buffer_filetype()
		if buftype ~= 'DASHBOARD' then
			return true
		end
	end

	-- Left side
	gls.left[1] = {
		RainbowLeft = {
			provider = function()
				return '▊ '
			end,
			highlight = { get_color('blue'), get_color('bg') },
		},
	}
	gls.left[2] = {
		ViMode = {
			provider = function()
				-- auto change color according the vim mode
				-- TODO: find a less dirty way to set ViMode colors
				local mode_color = {
					n = get_color('red')(),
					i = get_color('green')(),
					v = get_color('blue')(),
					[''] = get_color('blue')(),
					V = get_color('blue')(),
					c = get_color('magenta')(),
					no = get_color('red')(),
					s = get_color('orange')(),
					S = get_color('orange')(),
					[''] = get_color('orange')(),
					ic = get_color('yellow')(),
					R = get_color('magenta')(),
					Rv = get_color('magenta')(),
					cv = get_color('red')(),
					ce = get_color('red')(),
					r = get_color('cyan')(),
					rm = get_color('cyan')(),
					['r?'] = get_color('cyan')(),
					['!'] = get_color('red')(),
					t = get_color('red')(),
				}
				vim.api.nvim_command(
					'hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()]
				)
				return '  '
			end,
			highlight = { get_color('red'), get_color('bg'), 'bold' },
		},
	}
	gls.left[3] = {
		FileSize = {
			provider = 'FileSize',
			condition = condition.buffer_not_empty and is_not_dashboard,
			highlight = {
				get_color('fg'),
				get_color('bg'),
			},
			separator = ' ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.left[4] = {
		FileIcon = {
			provider = 'FileIcon',
			condition = condition.buffer_not_empty and is_not_dashboard,
			highlight = {
				require('galaxyline.provider_fileinfo').get_file_icon_color,
				get_color('bg'),
			},
		},
	}
	gls.left[5] = {
		FileName = {
			provider = 'FileName',
			condition = condition.buffer_not_empty and is_not_dashboard,
			highlight = { get_color('fg'), get_color('bg'), 'bold' },
			separator = ' ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.left[6] = {
		LineInfo = {
			provider = function()
				local line = vim.fn.line('.')
				local column = vim.fn.col('.')
				return string.format('%3d : %2d  ', line, column)
			end,
			condition = is_not_dashboard,
			highlight = { get_color('fg_alt'), get_color('bg') },
		},
	}
	gls.left[7] = {
		LinePercent = {
			provider = 'LinePercent',
			condition = is_not_dashboard,
			highlight = { get_color('fg_alt'), get_color('bg') },
			separator = '  ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.left[8] = {
		DiagnosticError = {
			provider = 'DiagnosticError',
			condition = is_not_dashboard,
			icon = '   ',
			highlight = { get_color('red'), get_color('bg') },
		},
	}
	gls.left[9] = {
		DiagnosticWarn = {
			provider = 'DiagnosticWarn',
			condition = is_not_dashboard,
			icon = '   ',
			highlight = { get_color('orange'), get_color('bg') },
		},
	}
	gls.left[10] = {
		DiagnosticInfo = {
			provider = 'DiagnosticInfo',
			condition = is_not_dashboard,
			icon = '   ',
			highlight = { get_color('blue'), get_color('bg') },
		},
	}

	-- Right side
	-- alternate separator colors if the current buffer is a dashboard
	gls.right[1] = {
		FileFormat = {
			provider = 'FileFormat',
			condition = condition.hide_in_width and is_not_dashboard,
			highlight = { get_color('fg'), get_color('bg') },
			separator = '  ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.right[2] = {
		FileEncode = {
			provider = 'FileEncode',
			condition = condition.hide_in_width and is_not_dashboard,
			highlight = { get_color('fg'), get_color('bg') },
			separator = ' ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.right[3] = {
		ShowLspClientOrFileType = {
			provider = function()
				-- Check if there's a LSP client running to avoid redundant
				-- statusline elements
				if lsp.get_lsp_client() ~= 'No Active Lsp' then
					return ' ' .. lsp.get_lsp_client():gsub(
						'^%l',
						string.upper
					)
				else
					-- Use the filetype instead and capitalize it
					return ' ' .. (vim.bo.filetype:gsub('^%l', string.upper))
				end
			end,
			condition = function()
				local tbl = { ['dashboard'] = true, [''] = true }
				if tbl[bo.filetype] then
					return false
				end
				return true
			end,
			highlight = { get_color('blue'), get_color('bg') },
			separator = '  ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.right[4] = {
		GitIcon = {
			provider = function()
				return '  '
			end,
			condition = condition.check_git_workspace,
			highlight = { get_color('red'), get_color('bg') },
			separator = ' ',
			separator_highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.right[5] = {
		GitBranch = {
			provider = 'GitBranch',
			condition = condition.check_git_workspace,
			highlight = { get_color('green'), get_color('bg'), 'bold' },
		},
	}
	gls.right[6] = {
		DiffSeparator = {
			provider = function()
				return '   '
			end,
			condition = is_not_dashboard,
			highlight = { get_color('bg'), get_color('bg') },
		},
	}
	gls.right[7] = {
		DiffAdd = {
			provider = 'DiffAdd',
			condition = condition.hide_in_width and is_not_dashboard,
			icon = ' ',
			highlight = { get_color('green'), get_color('bg') },
		},
	}
	gls.right[8] = {
		DiffModified = {
			provider = 'DiffModified',
			condition = condition.hide_in_width and is_not_dashboard,
			icon = ' ',
			highlight = { get_color('orange'), get_color('bg') },
		},
	}
	gls.right[9] = {
		DiffRemove = {
			provider = 'DiffRemove',
			condition = condition.hide_in_width and is_not_dashboard,
			icon = ' ',
			highlight = { get_color('red'), get_color('bg') },
		},
	}

	-- If the current buffer is the dashboard then show Doom Nvim version
	if is_dashboard then
		gls.right[10] = {
			DoomVersion = {
				provider = function()
					return 'DOOM v' .. utils.doom_version .. ' '
				end,
				condition = is_dashboard,
				highlight = { get_color('blue'), get_color('bg'), 'bold' },
				separator = '  ',
				separator_highlight = {
					get_color('bg'),
					get_color('bg'),
				},
			},
		}
	end
	gls.right[11] = {
		RainbowRight = {
			provider = function()
				return ' ▊'
			end,
			highlight = { get_color('blue'), get_color('bg') },
		},
	}

	-- Short status line
	gls.short_line_left[1] = {
		ShortRainbowLeft = {
			provider = function()
				return '▊ '
			end,
			highlight = { get_color('blue'), get_color('bg') },
		},
	}
	gls.short_line_left[2] = {
		BufferType = {
			provider = 'FileTypeName',
			condition = is_not_dashboard,
			highlight = { get_color('fg'), get_color('bg') },
		},
	}

	gls.short_line_right[1] = {
		BufferIcon = {
			provider = 'BufferIcon',
			condition = is_not_dashboard,
			highlight = { get_color('yellow'), get_color('bg') },
		},
	}
	gls.short_line_right[2] = {
		ShortRainbowRight = {
			provider = function()
				return ' ▊'
			end,
			highlight = { get_color('blue'), get_color('bg') },
		},
	}
end
