---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---

-- If no colorscheme was established then fallback to defauls
if not Is_empty(Doom.colorscheme) then
	Try({
		function()
			vim.opt.background = Doom.colorscheme_bg
			Execute('colorscheme ' .. Doom.colorscheme)
		end,
		Catch({
			function(_)
				Log_message('!', 'Colorscheme not found, falling to doom-one', 1)
				Execute('colorscheme ' .. Doom.colorscheme)
			end,
		}),
	})
else
	Log_message('!', 'Forced default Doom colorscheme', 1)
	Execute('colorscheme doom-one')
end

-- Set colors based on environment (GUI, TUI)
if Doom.enable_guicolors then
	if Fn.exists('+termguicolors') == 1 then
		vim.opt.termguicolors = true
	elseif Fn.exists('+guicolors') == 1 then
		vim.opt.guicolors = true
	end
end
