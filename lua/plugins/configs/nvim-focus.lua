local focus = require('focus')

-- Enable focus
focus.enable = true
-- Adjust according to the size of your screen!
focus.width = 60
focus.height = 20
-- Set which filetypes focus will not resize
focus.excluded_filetypes = { 'NvimTree', 'Vista', 'Minimap', 'terminal' }
