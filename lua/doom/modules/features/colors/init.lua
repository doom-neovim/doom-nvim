local colorpicker = {}

-- TODO: rename into something more useful



-- norcalli/nvim-colorizer.lua - A high-performance color highlighter for Neovim which has no external dependencies!.
-- sunjon/Shade.nvim - Shade is a Neovim plugin that dims your inactive windows, making it easier to see the active window at a glance.
-- winston0410/range-highlight.nvim - An extremely lightweight plugin (~ 120loc) that highlights ranges you have entered in commandline.
-- xiyaowong/nvim-transparent - Make your Neovim transparent.
-- folke/twilight.nvim - Dim inactive portions of the code you're editing using TreeSitter.

colorpicker.settings = {}

colorpicker.packages = {
  -- https://github.com/max397574/colortils.nvim -- <<<<<< this one!!!
  ["vCoolor.vim"] = { "KabbAmine/vCoolor.vim" }, -- open color picker / requires mouse to select color
  -- https://github.com/folke/lsp-colors.nvim
}

return colorpicker
