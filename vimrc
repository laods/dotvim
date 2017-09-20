" Use space as leader key
nnoremap <space> <nop>
let mapleader = "\<space>"

" {{{1 Load plugins

if !filereadable(resolve(expand('~/.vim/autoload/plug.vim')))
  let s:stop = 1
  execute 'silent !~/.vim/init.sh'
  autocmd VimEnter * PlugInstall --sync | quitall
endif

silent! if plug#begin('~/.vim/bundle')

" Load local plugin files
Plug '~/.vim/personal'

" Plugin manager
Plug 'junegunn/vim-plug', { 'on' : [] }

" Git plugins
Plug 'gregsexton/gitv', { 'on' : 'Gitv' }
Plug 'tpope/vim-fugitive'

" Compatibility layer between neovim and Vim
Plug 'roxma/vim-hug-neovim-rpc', !has('nvim') ? {} : { 'on' : [] }

" Completion
Plug 'roxma/nvim-completion-manager'

" Automatic linting
if has('nvim') || v:version >= 800
  Plug 'w0rp/ale'
endif

" Miscellaneous
Plug 'lervag/vimtex'            " LaTeX plugin
Plug 'dyng/ctrlsf.vim'          " A very nice search and replace plugin
Plug 'tpope/vim-repeat'         " Allow . to repeat more actions
Plug 'Konfekt/FastFold'         " Make folding work faster
Plug 'luochen1990/rainbow'      " Rainbow parantheses (looks good)
Plug 'ctrlpvim/ctrlp.vim'       " Fuzzy file finder
Plug 'junegunn/vim-slash'       " For improved search highlighting
Plug 'davidhalter/jedi-vim'     " Python plugin (e.g. completion)
Plug 'vim-python/python-syntax' " Python syntax plugin
Plug 'tmhedberg/SimpylFold'     " Python fold plugin

call plug#end() | endif

if exists('s:stop')
  finish
endif

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window
  autocmd WinEnter,FocusGained * setlocal cursorline
  autocmd WinLeave,FocusLost   * setlocal nocursorline

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line('$') |
        \   execute 'normal! g`"' |
        \ endif

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q <c-c><c-c>

  " Close preview after complete
  autocmd CompleteDone * pclose
augroup END

" {{{1 Options

" Vim specific options
if !has('nvim')
  set history=10000
  set nrformats-=octal
  if has('patch-7.4.399')
    set cryptmethod=blowfish2
  else
    set cryptmethod=blowfish
  endif
  set autoread
  set backspace=indent,eol,start
  set wildmenu
  set laststatus=2
  set smarttab
  set autoindent
  set incsearch
endif

" Basic
set cpoptions+=J
set tags=tags;~,.tags;~
set path=.,**
set fileformat=unix
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=filler,foldcolumn:0,context:4
if has('gui_running')
  set diffopt+=vertical
else
  set diffopt+=horizontal
endif

" Backup, swap and undofile
set directory=~/.vim/swap
set backup
set backupdir=~/.vim/backup
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.vim/undofiles

if !isdirectory(&directory)
  call mkdir(&directory)
endif
if !isdirectory(&backupdir)
  call mkdir(&backupdir)
endif
if !isdirectory(&undodir)
  call mkdir(&undodir)
endif

" Behaviour
set lazyredraw
set confirm
set hidden
set shortmess=aoOtT
silent! set shortmess+=cI
silent! set shortmess+=F
set textwidth=79
set nowrap
set linebreak
set comments=n:>
set nojoinspaces
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set winaltkeys=no
set mouse=
set gdefault

" Completion
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,d,]
set completeopt=longest,menu,preview

" Presentation
set list
set listchars=tab:▸\ ,nbsp:%,trail:\ ,extends:,precedes:
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
set cursorline
set scrolloff=10
set splitbelow
set splitright
set previewheight=20
set noshowmode

if !has('gui_running')
  set visualbell
  set t_vb=
endif

" Folding
if &foldmethod ==# ''
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set foldtext=TxtFoldText()

function! TxtFoldText()
  let level = repeat('-', min([v:foldlevel-1,3])) . '+'
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')
  return printf('%-4s %-s', level, title)
endfunction

" Indentation
set softtabstop=-1
set shiftwidth=2
set expandtab
set copyindent
set preserveindent
silent! set breakindent

" Searching and movement
set nostartofline
set ignorecase
set smartcase
set infercase
set showmatch

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" {{{1 Appearance and UI

set background=light

if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
endif

" Set colorscheme and custom colors
silent! colorscheme my_solarized

" Initialize statusline and tabline
call statusline#init()
call statusline#init_tabline()

" {{{1 Mappings

" Disable some mappings
noremap  <f1>   <nop>
inoremap <f1>   <nop>
inoremap <esc>  <nop>
nnoremap Q      <nop>

" Some general/standard remappings
inoremap jk     <esc>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap '      `
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Utility maps for repeatable quickly change current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN

" Navigate folds
nnoremap          zf zMzvzz
nnoremap <silent> zj :silent! normal! zc<cr>zjzvzz
nnoremap <silent> zk :silent! normal! zc<cr>zkzvzz[z

" Shortcuts for opening and sourcing vimrc file
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>xv :source $MYVIMRC<cr>

" {{{1 Configure plugins

" {{{2 internal

" Enable internal matchit plugin
runtime macros/matchit.vim

" Disable a lot of unnecessary internal plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" }}}2

" {{{2 feature: git

let g:Gitv_WipeAllOnClose = 1
let g:Gitv_DoNotMapCtrlKey = 1

nnoremap <leader>gl :Gitv --all<cr>
nnoremap <leader>gL :Gitv! --all<cr>
xnoremap <leader>gl :Gitv! --all<cr>

nmap     <leader>gs :Gstatus<cr>gg<c-n>
nnoremap <leader>gd :Gdiff<cr>

command! Gtogglestatus :call Gtogglestatus()

function! Gtogglestatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    Gstatus
  endif
endfunction

augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete
  autocmd FileType git setlocal foldlevel=1
augroup END

" }}}2
" {{{2 feature: completion

let g:cm_sources_override = {
      \ 'cm-bufkeyword' : {'abbreviation' : 'key'},
      \}
let g:cm_completeopt = 'menu,menuone,noinsert,noselect,preview'

inoremap <expr> <cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

augroup my_cm_setup
  autocmd!
  autocmd User CmSetup call cm#register_source({
        \ 'name' : 'vimtex',
        \ 'priority': 8,
        \ 'scoping': 1,
        \ 'scopes': ['tex'],
        \ 'abbreviation': 'tex',
        \ 'cm_refresh_patterns': g:vimtex#re#ncm,
        \ 'cm_refresh': {'omnifunc': 'vimtex#complete#omnifunc'},
        \ })
augroup END

" }}}2

" {{{2 plugin: ale

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': ['pylint'],
      \}

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)

highlight link ALEErrorLine ErrorMsg
highlight link ALEWarningLine WarningMsg
highlight link ALEInfoLine ModeMsg

" }}}2
" {{{2 plugin: CtrlFS

let g:ctrlsf_indent = 2
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_context = '-B 2'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_populate_qflist = 1
if executable('rg')
  let g:ctrlsf_ackprg = 'rg'
endif

nnoremap         <leader>ff :CtrlSF 
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" }}}2
" {{{2 plugin: CtrlP

let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

if executable('rg')
  let g:ctrlp_user_command += ['rg %s --files --color=never --glob ""']
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_tilde_homedir = 1
let g:ctrlp_match_window = 'top,order:ttb,min:30,max:30'
let g:ctrlp_status_func = {
      \ 'main' : 'statusline#ctrlp',
      \ 'prog' : 'statusline#ctrlp',
      \}
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_mruf_exclude = '\v' . join([
      \ '\/\.%(git|hg)\/',
      \ '\.wiki$',
      \ '\.snip$',
      \ '\.vim\/vimrc$',
      \ '\/vim\/.*\/doc\/.*txt$',
      \ '_%(LOCAL|REMOTE)_',
      \ '\~record$',
      \ '^\/tmp\/',
      \ '^man:\/\/',
      \], '|')

" Mappings
nnoremap <silent> <leader>oo :CtrlP<cr>
nnoremap <silent> <leader>ov :CtrlP ~/.vim<cr>
nnoremap <silent> <leader>ob :CtrlPBuffer<cr>

" }}}2
" {{{2 plugin: FastFold

nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  ['x','X']
let g:fastfold_fold_movement_commands = []

" }}}2
" {{{2 plugin: rainbow

let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['#f92672', '#00afff', '#268bd2', '#93a1a1', '#dc322f',
      \   '#6c71c4', '#b58900', '#657b83', '#d33682', '#719e07', '#2aa198'],
      \ 'ctermfgs': ['9', '127', '4', '1', '3', '12', '5', '2', '6', '33',
      \   '104', '124', '7', '39'],
      \ 'separately' : {
      \   'gitconfig' : 0,
      \   'wiki' : 0,
      \   'md' : 0,
      \   'help' : 0,
      \   'fortran' : {},
      \ }
      \}

" }}}2
" {{{2 plugin: vim-plug

let g:plug_window = 'tab new'

nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>

" }}}2
" {{{2 plugin: vim-slash

noremap <plug>(slash-after) zz

" }}}2

" {{{2 filetype: python

" Note: Remember to install python[23]-jedi!
" Note: See ~/.vim/personal/ftplugin/python.vim for more settings

" I prefer to map jedi.vim features manually
let g:jedi#auto_initialization = 0

" Syntax
let g:python_highlight_all = 1

" Folding
let g:SimpylFold_docstring_preview = 1

" }}}2
" {{{2 filetype: tex

"
" NOTE: See also ~/.vim/personal/ftplugin/tex.vim
"

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_toc_hotkeys = {'enabled' : 1}
let g:vimtex_view_general_viewer = 'evince'

" }}}2

" }}}1

" vim: fdm=marker
