"=========  Required Options
" set options required for bundled packages
set nocompatible
filetype plugin indent on

"========= Plugins
" configure plugins first, in case that some settings depend on a loaded plugin

" pathogen
call pathogen#infect()
call pathogen#helptags()

source ~/.vim/vundle

set encoding=utf-8
set laststatus=2

" Enable neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

"========= Keybindings
source /home/evnu/configs/vim/keybindings

source /home/evnu/configs/vim/autocmds

"========= Other configurations
"enable syntax highlighting
syntax on
set nu!

set noswapfile

set undofile
set undodir=/home/evnu/configs/vim/undodir

" Ignore files whose content should be kept private
augroup ignore_undofile
    au!
    au BufReadPre,BufFilePre */private/keys/* setlocal noundofile
augroup end

" relative line numbering
set relativenumber

" for R-vim plugin
let vimrplugin_screenplugin=0
let vimrplugin_tmux=0

"avoid "Hit ENTER to continue". See:
"http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
set cmdheight=1

" configure indent
set expandtab
set shiftwidth=4
set softtabstop=4

"set wildmenu
set wildmenu

"nosol - jump to specific character in a line
set nosol

"short messages
set shm=at

"max text width
set tw=90

set smartindent
set autoindent " manual says that this should be set when smartindent is set

" change to the directory of the file "
set autochdir

" Colorscheme
colorscheme molokai

" fix slight delay after pressing ESC then O
" http://ksjoberg.com/vim-esckeys.html
" set noesckeys
set timeout timeoutlen=1000 ttimeoutlen=100

let c_comment_strings=1 "syntax highlighting in comments

set mouse=a
if has("gui_running")
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
        set guioptions-=e
        set guioptions-=m
        " disable scrollbar "
        set guioptions-=L
        set guioptions-=r
else
	highlight Pmenu ctermbg=238 ctermfg=white gui=bold
endif

"remember position
if has("autocmd")
    augroup remember_pos
        au!
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    augroup END
endif

"= THE BEAUTY: Configure the tabline to remove file extensions
set tabline=%!TabLine()

" adapted from help tabpage

function! TabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " highlight
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set tab page nr for mouse clicks
        let s .= '%' . (i + 1) . 'T'

        " create the label
        let s .= (i + 1) .' %{TabLabel(' . (i + 1) . ')} '
    endfor

    " reset tabe page nr after last TabLinefill
    let s .= '%#TabLineFill#%T'

    return s
endfunction

" remove the file extension from a filename -- :r gets the "root" of a filename
function! TabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return fnamemodify(bufname(buflist[winnr - 1]), ":r")
endfunction
