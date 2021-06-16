"================================================
" health.vim - Doom Nvim Health
" Author: NTBBloodbath
" License: MIT
"================================================

function! health#doom#check() abort
    lua log.info('Checking Doom health ...')
    lua require('doom.health').checkhealth()
endfunction
