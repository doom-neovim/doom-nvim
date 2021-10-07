vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g["colors_name"] = "doom-one"

package.loaded["colors.doom-one"] = nil
require("colors.doom-one").load_colorscheme()
