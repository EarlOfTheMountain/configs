" Need to install vim-plug from vimplug.com, can use the curl command bellow
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Need to install language engines clangd, basedpiright
" Example with Debian:
" sudo apt install clangd pipx fzf ripgrep
" pipx ensurepath
" pipx install basedpyright

" Keep Vim's standard defaults (filetype detection, syntax, etc.)
source $VIMRUNTIME/defaults.vim

" Leader keys
let mapleader = " "
let maplocalleader = "\\"

" Editing
set hidden
set backspace=indent,eol,start
set undofile
set undolevels=1000
set history=1000
set autoread
set confirm

" Display
set number
set relativenumber
set ruler
set mouse=a
set signcolumn=yes
set cursorline
set scrolloff=5
set sidescrolloff=5
set laststatus=2
set wildmenu
set showcmd
set showmode

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Indentation, baseline for most code; filetype rules can override it
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround

" Splits
set splitbelow
set splitright

" Convenient mappings
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>h :nohlsearch<CR>

call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'


call plug#end()

" Register the engines for LSP
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

if executable('basedpyright-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'basedpyright',
        \ 'cmd': {server_info->['basedpyright-langserver', '--stdio']},
        \ 'allowlist': ['python'],
        \ })
endif

" LSP navigation and info
nnoremap <silent> K          :LspHover<CR>
nnoremap <silent> gd         :LspDefinition<CR>
nnoremap <silent> gr         :LspReferences<CR>
nnoremap <silent> gi         :LspImplementation<CR>
nnoremap <silent> <leader>rn :LspRename<CR>
nnoremap <silent> <leader>ca :LspCodeAction<CR>
nnoremap <silent> [d         :LspPreviousDiagnostic<CR>
nnoremap <silent> ]d         :LspNextDiagnostic<CR>

" clang-format - 

function! FormatWithClangFormat() range
    let l:input = getline(a:firstline, a:lastline)
    let l:output = system('clang-format', join(l:input, "\n") . "\n")
    if v:shell_error
        echoerr 'clang-format failed: ' . l:output
        return
    endif
    call setline(a:firstline, split(l:output, "\n"))
endfunction

nnoremap <silent> <leader>f :%call FormatWithClangFormat()<CR>
xnoremap <silent> <leader>f :call FormatWithClangFormat()<CR>

" fzf.vim
nnoremap <silent> <leader>p :Files<CR>
nnoremap <silent> <leader>/ :Rg<CR>
let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "./.git/*"'
