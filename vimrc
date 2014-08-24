"{{{ Initialization
" set options required for bundled packages
set nocompatible
filetype plugin indent on

" pathogen and vundle
call pathogen#infect()
call pathogen#helptags()

source ~/.vim/vundle

"}}}

"{{{ Source files
source ~/.vim/keybindings
"}}}

"{{{Main options
syntax on "enable syntax highlighting
set relativenumber " relative line numbering

set encoding=utf-8
set laststatus=2

set noswapfile " do not use swapfiles..
set undofile " but persistent undo is nice.. (see autocommands for ignored paths!)
set undodir=~/.vim/undodir

"{{{indent, tabwidth, shiftwidth and NO TABS!
set expandtab
set shiftwidth=4
set softtabstop=4
"max text width
set tw=90

" Note (from :help smartindent):
" When typing '#' as the first character in a new line, the indent for that line is
" removed, the '#' is put in the first column.  The indent is restored for the next line.
" If you don't want this, use this mapping: ":inoremap # X^H#", where ^H is entered with
" CTRL-V CTRL-H.
set smartindent
inoremap # X#

set autoindent " manual says that this should be set when smartindent is set
"}}}

"set wildmenu
set wildmenu

"nosol - jump to first non-blank character in a line
set nosol

"{{{Hit enter less often
"short messages - less hit-enter prompts
set shortmess=at
"avoid "Hit ENTER to continue". See:
"http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
set cmdheight=1
"}}}

" Colorscheme
colorscheme molokai

" fix slight delay after pressing ESC then O
" http://ksjoberg.com/vim-esckeys.html
" See also: `:help noesckeys`
set timeout timeoutlen=1000 ttimeoutlen=100
"}}}

"{{{Style
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
"}}}

"{{{Tabline
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
"}}}

"{{{Autocommands

"{{{Cursor positioning
augroup remember_pos
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END
"}}}

"{{{ Vimscript file settings
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal foldlevelstart=0
augroup END
"}}}

"{{{ Erlang file settings
augroup filetype_erlang
    au!
    au FileType erlang setlocal comments=:%%%,:%%,:%
    " wrap text and code, add comment leader after newline and o
    au FileType erlang setlocal formatoptions=tcqor
augroup END
" }}}

"{{{ Manage undo files
" Ignore files whose content should be kept private
augroup undofile
    au!
    au BufReadPre,BufFilePre */private/keys/* setlocal noundofile
augroup end
"}}}
"}}}
