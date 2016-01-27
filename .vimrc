execute pathogen#infect()

filetype plugin indent on

"Syntax hilighting
let python_highlight_all=1
syntax on


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
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

"Set tabs/indents/width on other files
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

"Flag bad whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

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
set number
let g:airline_powerline_fonts = 1
let g:airline_theme = 'murmur'

"Key mappings
map <C-n> :NERDTreeToggle<CR>

"Enable folding with the spacebar
nnoremap <space> za

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
