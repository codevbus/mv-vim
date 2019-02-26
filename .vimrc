" Section: Vim options {{{1
"--------------------------------------------------------------------------

set autoindent              " Carry over indenting from previous line
set autoread                " Don't bother me hen a file changes
set autowrite               " Write on :next/:prev/^Z
set backspace=indent,eol,start
                            " Allow backspace beyond insertion point
set cindent                 " Automatic program indenting
set cinkeys-=0#             " Comments don't fiddle with indenting
set cino=                   " See :h cinoptions-values
set commentstring=\ \ #%s   " When folds are created, add them to this\
set complete+=k             " Enable dictionary completion
set copyindent              " Make autoindent use the same chars as prev line
set directory-=.            " Don't store temp files in cwd
set encoding=utf8           " UTF-8 by default
set expandtab               " No tabs
set fileformats=unix,dos,mac  " Prefer Unix
set fillchars=vert:\ ,stl:\ ,stlnc:\ ,fold:-,diff:┄
                            " Unicode chars for diffs/folds, and rely on
                            " Colors for window borders
silent! set foldmethod=marker " Use braces by default
set formatoptions=tcqn1     " t - autowrap normal text
                            " c - autowrap comments
                            " q - gq formats comments
                            " n - autowrap lists
                            " 1 - break _before_ single-letter words
                            " 2 - use indenting from 2nd line of para
set hidden                  " Don't prompt to save hidden windows until exit
set history=200             " How many lines of history to save
set hlsearch                " Hilight searching
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set infercase               " Completion recognizes capitalization
set laststatus=2            " Always show the status bar
set linebreak               " Break long lines by word, not char
set list                    " Show whitespace as special chars - see listchars
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:· " Unicode characters for various things
set matchtime=2             " Tenths of second to hilight matching paren
set modelines=5             " How many lines of head & tail to look for ml's
" silent! set mouse=nvc       " Use the mouse, but not in insert mode
set nobackup                " No backups left after done editing
set nu                      " Set line numbers to start
set visualbell t_vb=        " No flashing or beeping at all
set nowritebackup           " No backups made while editing
set printoptions=paper:letter " US paper
set ruler                   " Show row/col and percentage
set scroll=4                " Number of lines to scroll with ^U/^D
set scrolloff=15            " Keep cursor away from this many chars top/bot
set sessionoptions-=options " Don't save runtimepath in Vim session (see tpope/vim-pathogen docs)
set shiftwidth=2            " Number of spaces to shift for autoindent or >,<
set shortmess+=A            " Don't bother me when a swapfile exists
set showbreak=              " Show for lines that have been wrapped, like Emacs
set showmatch               " Hilight matching braces/parens/etc.
set showtabline=2           " Show tab bar
set sidescrolloff=3         " Keep cursor away from this many chars left/right
set smartcase               " Lets you search for ALL CAPS
set softtabstop=2           " Spaces 'feel' like tabs
set suffixes+=.pyc          " Ignore these files when tab-completing
set tabstop=2               " The One True Tab
set textwidth=100           " 100 is the new 80
set thesaurus+=~/.vim/mthes10/mthesaur.txt
set notitle                 " Don't set the title of the Vim window
set wildmenu                " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,*.pyc,.git,node_modules  " Ignore certain files in tab-completion

" Section: Commands & Functions {{{1
"--------------------------------------------------------------------------

"Define function to strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
  " Save last search and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  " strip trailing whitespace
  %s/\s\+$//e
  " restore previous search and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

"Automatically strip trailing whitespace before buffer write
au BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()

" trim spaces at EOL
command! TEOL %s/\s\+$//
command! CLEAN retab | TEOL

" http://stackoverflow.com/questions/1005/getting-root-permissions-on-a-file-inside-of-vi
cmap w!! w !sudo tee >/dev/null %

"Flag bad whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Rename.vim  -  Rename a buffer within Vim and on the disk
" Copyright June 2007 by Christian J. Robinson <infynity@onewest.net>
" Distributed under the terms of the Vim license.  See ":help license".
" http://www.infynity.spodzone.com/vim/Rename.vim
" Usage: :Rename[!] {newname}
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
function! Rename(name, bang)
    let l:curfile = expand("%:p")
    let v:errmsg = ""
    silent! exe "saveas" . a:bang . " " . a:name
    if v:errmsg =~# '^$\|^E329'
        if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
            silent exe "bwipe! " . l:curfile
            if delete(l:curfile)
                echoerr "Could not delete " . l:curfile
            endif
        endif
    else
        echoerr v:errmsg
    endif
endfunction1

" Section: Plugin settings {{{1
"--------------------------------------------------------------------------

" A new Vim package system
source ~/.config/vim/bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect('~/.config/vim/bundle/{}')
call pathogen#helptags()

" for any plugins that use this, make their keymappings use comma
let mapleader = ","
let maplocalleader = ","

" Explore.vim (comes with Vim 6)
let explVertical = 1
let explSplitRight = 1
let explWinSize = 30
let explHideFiles = '^\.,\.(class|swp|pyc|pyo)$,^CVS$'
let explDirsFirst = -1

" vimspell.vim
let spell_auto_type = ""

" NERD_tree.vim
let NERDTreeIgnore = ['\~$', '\.pyc$']
autocmd vimenter * NERDTree

" FZF (replaces Ctrl-P, FuzzyFinder and Command-T)
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Ag<CR>

" ack -> ag
let g:ackprg = 'ag --vimgrep'

" fugitive
autocmd QuickFixCmdPost *grep* cwindow

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" supertab
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1

" Zenburn
let g:zenburn_high_Contrast = 1

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" markdown.vim
let g:vim_markdown_frontmatter = 1

" enable filetype plugins -- e.g., ftplugin/xml.vim
filetype plugin indent on

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK',
\   'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'buffers': 'tabsel'
\ },
\ 'tabline': {
\   'left': [['buffers']], 'right': [['close']]
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

"vim-go settings
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"tagbar settings
let g:tagbar_compact = 1

let g:tagbar_type_terraform = {
\ 'ctagstype' : 'terraform',
    \ 'kinds' : [
    \ 'r:resources',
    \ 'm:modules',
    \ 'o:outputs',
    \ 'v:variables',
    \ 'f:tfvars'
    \ ],
    \ 'sort' : 0
    \ }

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
    \ 'h:Heading_L1',
    \ 'i:Heading_L2',
    \ 'k:Heading_L3'
    \ ]
    \ }

"Disable LaTex Box in vim-polyglot for VimTeX
let g:polyglot_disabled = ['latex']

" Section: Color and syntax {{{1
"--------------------------------------------------------------------------

" Make sure colored syntax mode is on, and make it Just Work with newer 256
" color terminals like iTerm2.
set background=dark
let base16colorspace=256 " Access colors present in 256 colorspace
set termguicolors
colorscheme base16-materia
syntax on
let &t_ut=''

" window splits & ruler were too bright - change to white on grey
" (shouldn't change GUI or non-color term appearance)
highlight StatusLine   cterm=NONE ctermbg=blue ctermfg=white
highlight StatusLineNC cterm=NONE ctermbg=black ctermfg=white
highlight VertSplit    cterm=NONE ctermbg=black ctermfg=white

" unfortunately, taglist.vim's filenames is linked to LineNr, which sucks
highlight def link MyTagListFileName Statement
highlight def link MyTagListTagName Question

" turn off coloring for CDATA
highlight def link xmlCdata NONE

" custom incorrect spelling colors
highlight SpellBad     term=underline cterm=underline ctermbg=NONE ctermfg=205
highlight SpellCap     term=underline cterm=underline ctermbg=NONE ctermfg=33
highlight SpellRare    term=underline cterm=underline ctermbg=NONE ctermfg=217
highlight SpellLocal   term=underline cterm=underline ctermbg=NONE ctermfg=72

" ignore should be... ignored
"silent! highlight Ignore cterm=bold ctermfg=black ctermbg=bg
"highlight clear FoldColumn
"highlight def link FoldColumn Ignore
highlight clear Folded
highlight link Folded Ignore
"highlight clear LineNr
"highlight! def link LineNr Ignore

" nice-looking hilight if I remember to set my terminal colors
highlight clear Search
highlight Search term=NONE cterm=NONE ctermfg=white ctermbg=black

" make hilighted matching parents less offensive
highlight clear MatchParen
highlight link MatchParen Search

" colors for NERD_tree
highlight def link NERDTreeRO NERDTreeFile

" make trailing spaces visible
highlight SpecialKey ctermbg=Yellow guibg=Yellow

" make menu selections visible
highlight PmenuSel ctermfg=black ctermbg=magenta

" the sign column slows down remote terminals
highlight clear SignColumn
highlight link SignColumn Ignore

" Markdown could be more fruit salady.
highlight link markdownH1 PreProc
highlight link markdownH2 PreProc
highlight link markdownLink Character
highlight link markdownBold String
highlight link markdownItalic Statement
highlight link markdownCode Delimiter
highlight link markdownCodeBlock Delimiter
highlight link markdownListMarker TodojA

" Folding highlight
highlight Folded ctermbg=235 ctermfg=255

" Section: Key mappings {{{1
"--------------------------------------------------------------------------

"Macros
nmap \A :set formatoptions+=a<CR>:echo "autowrap enabled"<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \R :NERDTreeFind<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \a :set formatoptions-=a<CR>:echo "autowrap disabled"<CR>
nmap \b :set nocin tw=80<CR>:set formatoptions+=a<CR>
nmap \c :call TmuxPaneClear()<CR>
nmap \e :NERDTreeToggle<CR>
nmap \g :Gstatus<CR>
nmap \h :call ToggleHex()<CR>
nmap \i vip:sort<CR>
nmap \l :setlocal number!<CR>:setlocal number?<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nmap \o :set paste!<CR>:set paste?<CR>
nmap \q :nohlsearch<CR>
nmap \r :call TmuxPaneRepeat()<CR>
nmap \s :setlocal invspell<CR>
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \u :setlocal list!<CR>:setlocal list?<CR>
nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>
nmap \x :cclose<CR>
nmap \z :w<CR>:!open %<CR><CR>

"Remove hardmap to line feed for CTRL-j
let g:BASH_Ctrl_j = 'off'

"Enable folding with the spacebar
nnoremap <space> za
vnoremap <space> zf

"Shortcut window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move between open buffers.
map <C-n> :bnext<CR>
map <C-p> :bprev<CR>

"incsearch bindings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Alt-W to delete a buffer and remove it from the list but keep the window
" (courtesy bufkill.vim)
nmap <Esc>w :BD<CR>
nmap ∑ :BD<CR>

" Open vimrc for editing in a new buffer
map <leader>vm :e $MYVIMRC<CR>

" Source vimrc
map <leader>sv :source $MYVIMRC<CR>

" Section: File types {{{1
" "--------------------------------------------------------------------------

" Remove ALL autocommands for the current group.
augroup vimrc
autocmd!

" File types that get huge and slow
au FileType json setlocal conceallevel=0 foldmethod=syntax foldlevel=999

au FileType gitcommit setlocal textwidth=80

" Python file indentation
au FileType py setlocal tabstop=4  softtabstop=4  shiftwidth=4  textwidth=79  expandtab  fileformat=unix

"Remove wrap for markdown files
au FileType md setlocal textwidth=0

"Set tab settings on Golang files for gofmt compatibility
au FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nolist

"Set autocomplete dictionary for files based on extension
au FileType * execute 'setlocal dict+=~/.vim/dict/'.&filetype.'.txt'

"Auto open tagbar if file is supported
autocmd FileType * nested :call tagbar#autoopen(0)

augroup END
