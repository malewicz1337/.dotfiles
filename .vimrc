syntax on
set relativenumber
set number
set autoindent
set smartindent
colorscheme slate

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

let g:netrw_localrmdir = 'rm -r'
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_localmkdir = 'mkdir'
let g:netrw_localmvdir = 'mv'

set rtp+=/opt/homebrew/opt/fzf


if exists("g:loaded_hjkl_remap") || &cp || v:version < 700
  finish
endif
let g:loaded_hjkl_remap = 1

noremap <silent> l gk
noremap <silent> k gj
noremap <silent> j <Left>
noremap <silent> ; <Right>

noremap <C-w>k <C-w>j
noremap <C-w><C-k> <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w><C-l> <C-w>k
noremap <C-w>j <C-w>h
noremap <C-w><C-j> <C-w>h

noremap <C-w>; <C-w>l
noremap <C-w><C-semicolon> <C-w>l

noremap ' ;

set rtp+=/opt/homebrew/opt/fzf

