execute pathogen#infect()

filetype plugin indent on

"Syntax hilighting
let python_highlight_all=1
syntax on

"Set swap file
set swapfile
set dir=~/.vimswap

"set split location
set splitbelow
set splitright

"Enable folding
set foldmethod=indent
set foldlevel=99

"Set tabs/indents/width on opening python files
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
"    \ set textwidth=79 |

"Set tabs/indents/width on other files
au BufNewFile,BufRead *.js,*.html,*.css,*.sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

"Set tabs/indent/width for json files
au BufNewFile,BufRead *.json
    \ set autoindent |
    \ set textwidth=78 |
    \ set shiftwidth=2 |
    \ set softtabstop=2 |
    \ set tabstop=8 |
    \ set expandtab |
    \ set foldmethod=syntax |

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

"Set char wrap to 72 for gitcommit
au FileType gitcommit set tw=72

"Flag bad whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Set json filetypes explicitly for syntastic
au BufRead,BufNewFile *.json set filetype=json

"Set TeX to compile with XeLaTeX
let g:Tex_CompileRule_pdf='xelatex --interaction=nonstopmode $*'

"UTF-8 support
set encoding=utf-8

"Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "type": "style" }

"NERDTree 
autocmd vimenter * NERDTree

"Visual settings
let base16colorspace=256
set background=dark
colorscheme base16-eighties
set number
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_eighties'

"Key mappings

"Remove hardmap to line feed for CTRL-j
let g:BASH_Ctrl_j = 'off'

"Map CTRL-n to open/close NERDTree
map <C-n> :NERDTreeToggle<CR>

"Enable folding with the spacebar
nnoremap <space> za

"Shortcut window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
