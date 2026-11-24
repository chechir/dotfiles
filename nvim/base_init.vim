"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Functionality                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" Share the system clipboard
set clipboard=unnamed
set clipboard+=unnamedplus

" Four-space indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

set mouse=r
set number
set colorcolumn=90
set so=7
imap kk <Esc>:w<CR>

" Case-insensitive search unless there is a capital letter
set ignorecase
set smartcase

" Keep visual selection while indenting
vnoremap < <gv
vnoremap > >gv

" Clear search highlight
nnoremap ff :nohlsearch <CR>

nnoremap <Leader>e :q<CR>

nnoremap <C-s> :update<CR>
inoremap <C-s> <C-c>:update<CR>

nnoremap <silent> <Leader>w :keeppatterns %s/\s\+$//<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Movement                                   "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ( :tabprevious<CR>
nnoremap ) :tabnext<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Python                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap db Obreakpoint()<CR>
nnoremap mm Oif __name__ == '__main__':<CR>

" Pretty-print the buffer as JSON
nnoremap ^ :%!python3 -m json.tool<CR>
