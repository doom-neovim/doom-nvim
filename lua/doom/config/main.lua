---[[---------------------------------------]]---
--        main.vim - Core of Doom Nvim         --
--            Author: NTBBloodbath             --
--            License: MIT                     --
---[[---------------------------------------]]---
-- If packer.nvim is not installed then install it
local packer_install_path = fn.stdpath('data')
	.. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_install_path)) > 0 then
	execute(
		'silent !git clone https://github.com/wbthomason/packer.nvim '
			.. packer_install_path
	)
	execute('packadd packer.nvim')
end

-- Set some configs on load
if fn.has('vim_starting') == 1 then
	-- Set encoding
	opt('o', 'encoding', 'utf-8')
	-- Required to use some colorschemes and improve colors
	opt('o', 'termguicolors', true)
end

-- Start Doom and run packer.nvim
fn['doom#begin']()
require('plugins')
require('doom.config.load_plugins')
fn['doom#end']()
