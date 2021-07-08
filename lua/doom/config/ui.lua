---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: GPLv2                    --
---[[---------------------------------------]]---

-- If no colorscheme was established then fallback to defauls
if not Is_empty(Doom.colorscheme) then
	Try({
		function()
			Execute('set background=' .. Doom.colorscheme_bg)
			Execute('colorscheme ' .. Doom.colorscheme)
		end,
		Catch({
			function(_)
				Log_message('!', 'Colorscheme not found', 1)
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
	if Fn.exists('+termguicolors') then
		Opt('o', 'termguicolors', true)
	elseif Fn.exists('+guicolors') then
		Opt('o', 'guicolors', true)
	end
end
