"================================================
" health.vim - Doom Nvim Health
" Author: NTBBloodbath
" License: MIT
"================================================

function! health#doom#check() abort
    lua require('doom.core.logging').info('Checking Doom health ...')
    lua require('doom.core.health').checkhealth()
endfunction
