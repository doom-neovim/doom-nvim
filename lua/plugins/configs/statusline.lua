local bo = vim.bo
local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section

gl.short_line_list = { 'NvimTree', 'packer', 'minimap', 'Outline' }

local colors = {
	bg = '#282c34',
	fg = '#c8ccd4',
	section_bg = '#373d48',
	yellow = '#e5c07b',
	cyan = '#56b6c2',
	green = '#98c379',
	orange = '#ffb86c',
	magenta = '#c678dd',
	blue = '#61afef',
	red = '#e06c75',
}

-- Left side
gls.left[1] = {
	RainbowRed = {
		provider = function()
			return '▊ '
		end,
		highlight = { colors.blue, colors.bg },
	},
}
gls.left[2] = {
	ViMode = {
		provider = function()
			-- auto change color according the vim mode
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				[''] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[''] = colors.orange,
				ic = colors.yellow,
				R = colors.magenta,
				Rv = colors.magenta,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				['r?'] = colors.cyan,
				['!'] = colors.red,
				t = colors.red,
			}
			api.nvim_command(
				'hi GalaxyViMode guifg=' .. mode_color[fn.mode()]
			)
			return ' Doom '
		end,
		highlight = { colors.red, colors.bg, 'bold' },
		separator = ' ',
		separator_highlight = { colors.bg, colors.section_bg },
	},
}

gls.left[3] = {
	FileIcon = {
		provider = 'FileIcon',
		condition = condition.buffer_not_empty,
		highlight = {
			require('galaxyline.provider_fileinfo').get_file_icon_color,
			colors.section_bg,
		},
	},
}
gls.left[4] = {
	FileName = {
		provider = 'FileName',
		highlight = { colors.fg, colors.section_bg },
		separator = '',
		separator_highlight = { colors.section_bg, colors.bg },
	},
}
gls.left[5] = {
	GitIcon = {
		provider = function()
			return '  '
		end,
		condition = condition.check_git_workspace,
		highlight = { colors.red, colors.bg },
	},
}
gls.left[6] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = condition.check_git_workspace,
		highlight = { colors.fg, colors.bg },
		separator = ' ',
	},
}
gls.left[7] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = condition.hide_in_width,
		icon = ' ',
		highlight = { colors.green, colors.bg },
	},
}
gls.left[8] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = condition.hide_in_width,
		icon = ' ',
		highlight = { colors.orange, colors.bg },
	},
}
gls.left[9] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = condition.hide_in_width,
		icon = ' ',
		highlight = { colors.red, colors.bg },
	},
}
gls.left[10] = {
	LeftEnd = {
		provider = function()
			return ''
		end,
		highlight = { colors.section_bg, colors.bg },
	},
}
gls.left[11] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = { colors.red, colors.section_bg },
	},
}
gls.left[12] = {
	Space = {
		provider = function()
			return ' '
		end,
		highlight = { colors.section_bg, colors.section_bg },
	},
}
gls.left[13] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = { colors.orange, colors.section_bg },
	},
}
gls.left[14] = {
	Space = {
		provider = function()
			return ' '
		end,
		highlight = { colors.section_bg, colors.section_bg },
	},
}
gls.left[15] = {
	DiagnosticInfo = {
		provider = 'DiagnosticInfo',
		icon = '  ',
		highlight = { colors.blue, colors.section_bg },
		separator = ' ',
		separator_highlight = { colors.section_bg, colors.bg },
	},
}

-- Right side
gls.right[1] = {
	FileFormat = {
		provider = function()
			return bo.filetype
		end,
		icon = ' ', -- add extra space between separator and text
		highlight = { colors.fg, colors.section_bg },
		separator = '',
		separator_highlight = { colors.section_bg, colors.bg },
	},
}
gls.right[2] = {
	ShowLspClient = {
		provider = 'GetLspClient',
		condition = function()
			local tbl = { ['dashboard'] = true, [''] = true }
			if tbl[bo.filetype] then
				return false
			end
			return true
		end,
		icon = 'LSP: ',
		highlight = { colors.fg, colors.section_bg },
		separator = ' | ',
		separator_highlight = { colors.bg, colors.section_bg },
	},
}
gls.right[3] = {
	FileEncode = {
		provider = 'FileEncode',
		condition = condition.hide_in_width,
		highlight = { colors.fg, colors.section_bg },
		separator = ' |',
		separator_highlight = { colors.bg, colors.section_bg },
	},
}
gls.right[4] = {
	LineInfo = {
		provider = 'LineColumn',
		highlight = { colors.fg, colors.section_bg },
		separator = ' | ',
		separator_highlight = { colors.bg, colors.section_bg },
	},
}
gls.right[5] = {
	RainbowBlue = {
		provider = function()
			return ' ▊'
		end,
		highlight = { colors.blue, colors.bg },
	},
}

-- Short status line
gls.short_line_left[1] = {
	BufferType = {
		provider = 'FileTypeName',
		highlight = { colors.fg, colors.section_bg },
		separator = ' ',
		separator_highlight = { colors.section_bg, colors.bg },
	},
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider = 'BufferIcon',
		highlight = { colors.yellow, colors.section_bg },
		separator = '',
		separator_highlight = { colors.section_bg, colors.bg },
	},
}
