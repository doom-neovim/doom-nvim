return function()
    local bo = vim.bo
    local gl = require('galaxyline')
    local buffer = require('galaxyline.provider_buffer')
    local condition = require('galaxyline.condition')

    local gls = gl.section

    gl.short_line_list = { 'NvimTree', 'packer', 'minimap', 'Outline' }

    local colors = {
        bg = '#282c34',
        fg = '#bbc2cf',
        section_bg = '#3E4556',
        yellow = '#ECBE7B',
        cyan = '#46D9FF',
        green = '#98be65',
        orange = '#da8548',
        magenta = '#c678dd',
        blue = '#51afef',
        red = '#ff6c6b',
    }

    -- TODO: merge dashboard functions to get only one function for both cases

    -- If current buffer is not a dashboard
    local function is_not_dashboard()
        local buftype = buffer.get_buffer_filetype()
        if buftype == 'DASHBOARD' then
            return false
        else
            return true
        end
    end

    -- If current buffer is a dashboard
    local function is_dashboard()
        local buftype = buffer.get_buffer_filetype()
        if buftype == 'DASHBOARD' then
            return true
        else
            return false
        end
    end

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
                Execute(
                    'hi GalaxyViMode guifg=' .. mode_color[Fn.mode()]
                )
                return ' Doom '
            end,
            highlight = { colors.red, colors.bg, 'bold' },
        },
    }
    gls.left[3] = {
        Separator = {
            provider = function()
                return ' '
            end,
            condition = condition.buffer_not_empty and is_not_dashboard,
            highlight = { colors.bg, colors.section_bg },
        },
    }
    gls.left[4] = {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty and is_not_dashboard,
            highlight = {
                require('galaxyline.provider_fileinfo').get_file_icon_color,
                colors.section_bg,
            },
        },
    }
    gls.left[5] = {
        FileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty and is_not_dashboard,
            highlight = { colors.fg, colors.section_bg },
            separator = '',
            separator_highlight = { colors.section_bg, colors.bg },
        },
    }
    gls.left[6] = {
        GitIcon = {
            provider = function()
                return '  '
            end,
            condition = condition.check_git_workspace and is_not_dashboard,
            highlight = { colors.red, colors.bg },
        },
    }
    gls.left[7] = {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace and is_not_dashboard,
            highlight = { colors.fg, colors.bg },
            separator = ' ',
            separator_highlight = { colors.section_bg, colors.bg },
        },
    }
    gls.left[8] = {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width and is_not_dashboard,
            icon = ' ',
            highlight = { colors.green, colors.bg },
        },
    }
    gls.left[9] = {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width and is_not_dashboard,
            icon = ' ',
            highlight = { colors.orange, colors.bg },
        },
    }
    gls.left[10] = {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width and is_not_dashboard,
            icon = ' ',
            highlight = { colors.red, colors.bg },
        },
    }
    gls.left[11] = {
        LeftEnd = {
            provider = function()
                return ''
            end,
            condition = is_not_dashboard,
            highlight = { colors.section_bg, colors.bg },
        },
    }
    gls.left[12] = {
        DiagnosticError = {
            provider = 'DiagnosticError',
            condition = is_not_dashboard,
            icon = '   ',
            highlight = { colors.red, colors.section_bg },
        },
    }
    gls.left[13] = {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            condition = is_not_dashboard,
            icon = '   ',
            highlight = { colors.orange, colors.section_bg },
        },
    }
    gls.left[14] = {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            condition = is_not_dashboard,
            icon = '   ',
            highlight = { colors.blue, colors.section_bg },
            separator = '',
            separator_highlight = { colors.section_bg, colors.bg },
        },
    }

    -- Right side
    -- alternate separator colors if the current buffer is a dashboard
    gls.right[1] = {
        RightStart = {
            provider = function()
                return ''
            end,
            condition = is_not_dashboard,
            highlight = { colors.section_bg, colors.bg },
        },
    }
    gls.right[2] = {
        FileFormat = {
            provider = function()
                return bo.filetype
            end,
            condition = is_not_dashboard,
            highlight = { colors.fg, colors.section_bg },
            separator = ' ',
            separator_highlight = { colors.bg, colors.section_bg },
        },
    }
    gls.right[3] = {
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
    gls.right[4] = {
        FileEncode = {
            provider = 'FileEncode',
            condition = condition.hide_in_width and is_not_dashboard,
            highlight = { colors.fg, colors.section_bg },
            separator = ' |',
            separator_highlight = { colors.bg, colors.section_bg },
        },
    }
    gls.right[5] = {
        LineInfo = {
            provider = 'LineColumn',
            condition = is_not_dashboard,
            highlight = { colors.fg, colors.section_bg },
            separator = ' | ',
            separator_highlight = { colors.bg, colors.section_bg },
        },
    }
    -- If the current buffer is the dashboard then show Doom Nvim version
    if is_dashboard then
        gls.right[6] = {
            DoomVersion = {
                provider = function()
                    return 'DOOM v' .. Doom_version
                end,
                condition = is_dashboard,
                highlight = { colors.blue, colors.bg, 'bold' },
                separator = ' ',
                separator_highlight = { colors.section_bg, colors.bg },
            },
        }
        gls.right[7] = {
            Space = {
                provider = function()
                    return ' '
                end,
                condition = is_dashboard,
                highlight = { colors.section_bg, colors.bg },
            },
        }
    end
    gls.right[8] = {
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
            condition = is_not_dashboard,
            highlight = { colors.fg, colors.section_bg },
            separator = '',
            separator_highlight = { colors.section_bg, colors.bg },
        },
    }

    gls.short_line_right[1] = {
        BufferIcon = {
            provider = 'BufferIcon',
            condition = is_not_dashboard,
            highlight = { colors.yellow, colors.section_bg },
            separator = '',
            separator_highlight = { colors.section_bg, colors.bg },
        },
    }
end
