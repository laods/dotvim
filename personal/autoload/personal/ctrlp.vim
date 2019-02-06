function! personal#ctrlp#disable_matchfunc(cmd) " {{{1
  " Disable pymatcher for e.g. CtrlPMRU
  let g:ctrlp_match_func = {}
  execute a:cmd
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endfunction

" }}}1
