"{{{ Initialization
runtime bundle/vim-pathogen.git/autoload/pathogen.vim

" pathogen and vundle
call pathogen#infect()
call pathogen#helptags()

" set options required for bundled packages
set nocompatible
filetype plugin indent on
set syntax=on

filetype off " from vundle readme
runtime vundle
filetype on

"}}}

"{{{Main options
syntax on "enable syntax highlighting

" enable hybrid relativenumber-number
set relativenumber
set number

set encoding=utf-8
set laststatus=2

set noswapfile " do not use swapfiles..
set undofile " but persistent undo is nice.. (see autocommands for ignored paths!)
set undodir=~/.vim/undodir

set noautochdir

" don't track changes
set nobackup
set noswapfile

"{{{ highlight whitespace
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

augroup whitespace
    au!
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
augroup END
"}}}

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

"{{{ Overlong columns

" mark overlong columns
set cc=90

" linebreak
set tw=100

" }}}

"{{{Hit enter less often
"short messages - less hit-enter prompts
set shortmess=at
"avoid "Hit ENTER to continue". See:
"http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
set cmdheight=1
"}}}

" fix slight delay after pressing ESC then O
" http://ksjoberg.com/vim-esckeys.html
" See also: `:help noesckeys`
set timeout timeoutlen=1000 ttimeoutlen=100

" {{{ Menu
set wildmenu
"" 1st and 2nd tab act differently
set wildmode=list:longest,full
" }}}

"}}}

" {{{ Searching Stuff
" From http://robots.thoughtbot.com/faster-grepping-in-vim
" Use silver-searcher
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
endif
" }}}

"{{{Style
" Colorscheme
colorscheme molokai

if has("gui_running")
    set guifont=Terminus\ 12
    " guioptions: autoselect, grey menu items, vim icon, tear-off menu items
    set guioptions=agit

    " set color of popup menu
    highlight Pmenu guibg=black guifg=white gui=bold
    set background=dark
else
    highlight Pmenu ctermbg=238 ctermfg=white gui=bold
    " allow using the mouse in a terminal
    set mouse=a
    " colors
    set background=dark
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
    au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
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

"{{{ mail file settings
augroup filetype_mail
    au!
    au FileType mail setlocal textwidth=0 linebreak
augroup END
" }}}

"{{{ Manage undo files
" Ignore files whose content should be kept private
augroup undofile
    au!
    au BufReadPre,BufFilePre */private/keys/* setlocal noundofile
augroup end
"}}}

"{{{ Vimperator
augroup vimperator
    au!
    autocmd BufWinEnter vimperator-* call VimperatorSettings()
augroup END
function! VimperatorSettings()
    set wrap
    set linebreak
    set nolist  " list disables linebreak
    set textwidth=0
    set wrapmargin=0
endfunction
"}}}

" {{{ Trac
augroup trac
    au!
    au BufNew,BufRead *trac.* :set ft=tracwiki
    au BufNew,BufRead *trac.* :set tw=0
augroup END
" }}}
"}}}

" {{{ Keybindings

" ignore Ctrl+C
nnoremap <C-c> :echom "<C-c> ignored"<cr>

" edit/source vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" edit custom snippets for the current filetype
" See :help c_CTRL-R for the expression register '='
nnoremap <leader>se :split <c-r>=g:neosnippet#snippets_directory."/".&ft.".snip"<cr><cr>

" Some simple keymappings
map <F3> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

" for vim undo tree
nnoremap <F6> :GundoToggle<CR>

" toggle syntastic
nnoremap <F9> :SyntasticToggleMode<CR>

" remove whitespace at the end of a line
nnoremap <leader>dws :%s/\s\+$//ge<CR>

" neosnippets; see https://github.com/Shougo/neosnippet.vim
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" }}}
