"{{{ Initialization
runtime bundle/vim-pathogen/autoload/pathogen.vim

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
set incsearch
set hlsearch
" }}}

"{{{Style

" Colorscheme
if has("gui_running")
    set guifont=Terminus\ 10
    " guioptions: autoselect, grey menu items, vim icon, tear-off menu items
    set guioptions=agit

    colorscheme molokai
else
    " colors
    set background=dark

    colorscheme molokai
    highlight Pmenu ctermbg=238 ctermfg=white gui=bold
    " allow using the mouse in a terminal
    set mouse=a
endif

" colorize the cursor and ignore the color scheme for this
" NOTE: in a terminal emulator (e.g. rxvt), the color must probably be defined in ~/.Xresources
highlight Cursor guifg=white guibg=red

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

"{{{ Shell file settings
augroup filetype_sh
    autocmd!
    au FileType sh setlocal formatoptions=tcqor
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
let s:wranglerp = '~/.vim/wrangler/lib/erlang/lib/wrangler-1.1.01'
if ! empty(finddir(s:wranglerp))
    let g:erlangWranglerPath = s:wranglerp
endif

function! s:ErlangHighlight()
    syn keyword erlangTodo contained NOTE
endfunction

function! s:ErlangSettings()
    let g:erlang_shift_trailing_match=1
    au FileType erlang setlocal comments=:%%%,:%%,:%
    " wrap text and code, add comment leader after newline and o
    au FileType erlang setlocal formatoptions=tcqorj
    au FileType erlang setlocal textwidth=80

    autocmd FileType erlang vnoremap <leader>e :WranglerExtractFunction<ENTER>
    autocmd FileType erlang noremap  <leader>m :WranglerRenameModule<ENTER>
    autocmd FileType erlang noremap  <leader>f :WranglerRenameFunction<ENTER>
    autocmd FileType erlang noremap  <leader>v :WranglerRenameVariable<ENTER>
    autocmd FileType erlang noremap  <leader>p :WranglerRenameProcess<ENTER>
    autocmd FileType erlang noremap  <leader>u :WranglerUndo<ENTER>

    call <SID>ErlangHighlight()
endfunction

augroup filetype_erlang
    au!
    au BufNew,BufRead *.appup setlocal ft=erlang
    call <SID>ErlangSettings()
augroup END

augroup filetype_escript
    au!
    au BufRead,BufWrite *.escript setlocal filetype=erlang
    call <SID>ErlangSettings()
augroup END
" }}}

"{{{ Python file settings
augroup filetype_python
    au FileType python setlocal formatoptions=tcqor
augroup END
"}}}

"{{{ mail file settings
augroup filetype_mail
    au!
    au FileType mail setlocal textwidth=90 linebreak noundofile
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
    autocmd BufWinEnter vimperator-* call <SID>VimperatorSettings()
augroup END
function! s:VimperatorSettings()
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

" nohls after searching
nnoremap <esc><esc> :<c-u>nohlsearch<cr>

" cnext/cprevious
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>

" edit/source vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" source the current file
nnoremap <leader>sf :source %<cr>

" edit custom snippets for the current filetype
" See :help c_CTRL-R for the expression register '='
nnoremap <leader>se :split <c-r>=g:neosnippet#snippets_directory."/".&ft.".snip"<cr><cr>

" Some simple keymappings
map <F3> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

" for vim undo tree
nnoremap <F6> :UndotreeToggle<CR>

" toggle syntastic
nnoremap <F9> :SyntasticToggleMode<CR>

" Grep for todos and open search results using :lopen
function! GrepTodos()
    let s:file = expand('%:p')
    exec "lvimgrep /\\vTODO|XXX|FIXME/ " . s:file
endfunction

nnoremap <F4> :silent call GrepTodos()<cr>

" remove whitespace at the end of a line
" NOTE: uses the register A for storing the previous position.
function! s:RemoveTrailingWhitespace()
    let l:save_reg = @a
    normal! ma
    %s/\s\+$//ge
    normal! `a
    let @a = l:save_reg
endfunction
nnoremap <leader>dws :call <SID>RemoveTrailingWhitespace()<cr>

" neosnippets; see https://github.com/Shougo/neosnippet.vim
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" }}}
