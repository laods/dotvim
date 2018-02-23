function! personal#init#go_to_last_known_position() abort " {{{1
  if line("'\"") < 0 || line("'\"") > line('$')
    return
  endif

  normal! g`"
  normal! zMzvzz
endfunction

" }}}1
function! personal#init#custom_colors() abort " {{{1
  " Purpose: Define custom colors for various things that are loaded through an
  "          autocmd after the ColorScheme event.

  " Plugins
  " ---------------------------------------------------------------------------

  highlight ctrlsfSelectedLine    cterm=bold           gui=bold           ctermfg=39  guifg=#00afff

  highlight link ALEErrorLine ErrorMsg
  highlight link ALEWarningLine WarningMsg
  highlight link ALEInfoLine ModeMsg
endfunction

" }}}1
