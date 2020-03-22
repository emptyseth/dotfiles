if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'bling/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'jshint/jshint'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'

call plug#end()

set number
set expandtab
set tabstop=2
set shiftwidth=2
set relativenumber
set signcolumn=yes
syntax on

nmap <C-n> :NERDTreeToggle<CR>

let g:NERDTreeShowHidden=1
let g:NERDTreeGitStatusWithFlags = 1

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

