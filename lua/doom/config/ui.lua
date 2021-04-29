---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---
-- If no colorscheme was established then fallback to defauls
if not is_empty(g.doom_colorscheme) then
    try {
        function()
            execute('set background=' .. g.doom_colorscheme_bg)
            execute('colorscheme ' .. g.doom_colorscheme)
        end, catch {
            function(_)
                fn['doom#logging#message']('!', 'Colorscheme not found', 1)
                execute('colorscheme ' .. g.doom_colorscheme)
            end
        }
    }
else
    fn['doom#logging#message']('!', 'Forced default Doom colorscheme', 1)
    execute('colorscheme doom-one')
end

-- If guicolors are enabled
if g.doom_enable_guicolors == 1 then
    if fn.exists('+termguicolors') then
        opt('o', 'termguicolors', true)
    elseif fn.exists('+guicolors') then
        opt('o', 'guicolors', true)
    end
end
