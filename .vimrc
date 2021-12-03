set termguicolors

if has('nvim') && empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
   silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !has('nvim') && empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"Oliver's plugins

" Used to quickly surround visual selections with html tags or quotes
Plug 'tpope/vim-surround'

" Multi-selection using Ctrl + N
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Color pallete selector
Plug 'KabbAmine/vCoolor.vim'

" Need to install ripgrep for this to work: `brew install ripgrep`
" Fzf has an integration with ripgrep to search git files using command :Rg
Plug 'jremmen/vim-ripgrep'

" Global find and replace 
Plug 'brooth/far.vim'

"Oliver's: Tsx/Jsx related
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

" ========================================
Plug 'christoomey/vim-tmux-navigator'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"Plug 'dense-analysis/ale'
" Plug 'elixir-editors/vim-elixir'
" Plug 'gleam-lang/gleam.vim'
" Plug 'preservim/nerdtree'
Plug 'preservim/vimux'
Plug 'tpope/vim-fugitive'

" Plug 'tpope/vim-abolish'

" ==== Coc plugs ==== 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/coc-diagnostic', {'do': 'npm install --force'}
Plug 'elixir-lsp/coc-elixir', {'do': 'npm install && npm run prepack'}
Plug 'neoclide/coc-git', {'do': 'npm install --force'}
Plug 'fannheyward/coc-marketplace', {'do': 'npm install --force'}
Plug 'neoclide/coc-eslint', {'do': 'npm install --force'}
Plug 'neoclide/coc-tsserver', {'do': 'npm install --force'}
Plug 'neoclide/coc-prettier', {'do': 'npm install --force'}
Plug 'iamcco/coc-tailwindcss',  {'do': 'npm install --frozen-lockfile && npm run build'}
" Plug 'neoclide/coc-highlight', {'do': 'npm install --force'}
" Plug 'neoclide/coc-lists', {'do': 'npm install --force'}
" Plug 'neoclide/coc-yank', {'do': 'npm install --force'}

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'

" Helps with directory navigation using - to go up and enter to go down
Plug 'tpope/vim-vinegar'

Plug 'tpope/vim-commentary'
Plug 'chriskempson/base16-vim'
" Plug 'itchyny/lightline.vim'
" Plug 'tpope/vim-unimpaired'
Plug 'vim-test/vim-test'

call plug#end()

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
   incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF
set nocompatible
set shiftwidth=2
set tabstop=2
set expandtab
set smartindent
set ignorecase
set smartcase
set autoindent
set hlsearch
set incsearch
set laststatus=2
set ruler
set textwidth=80
set colorcolumn=+1
set number
set undodir=~/.vim/undodir
set undofile

colorscheme base16-gruvbox-dark-medium
nnoremap <C-p> :Files<Cr>

"nmap <C-p> :Files<Cr>

" enable folding by indent, but don't fold everything whenever you open a file
set foldmethod=indent
set nofoldenable

"Incremental selection with treesitter
nmap <S-Up> gnn
vmap <S-Up> grn
vmap <S-Down> grm

map 0 ^

"nmap <C-p> :GFiles<cr>
nnoremap <silent> gst :GFiles?<CR>

let mapleader=","
nmap <leader>l :so $MYVIMRC<cr>

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" vimux 'slime'
function! VimuxSlime()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

 " If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <C-c><C-c> "vy :call VimuxSlime()<CR>
 " Select current paragraph and send it to tmux
nmap <C-c><C-c> vip<C-c><C-c>

nmap <C-c><C-l> :wa <bar> VimuxRunLastCommand<CR>
nmap <silent> <C-c><C-f> :wa <bar> VimuxRunCommand "mix surface.format"<CR>

" Test mappings
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> <C-t><C-n> :wa <bar> TestNearest<CR>
nmap <silent> <C-t><C-f> :wa <bar> TestFile<CR>
nmap <silent> <C-t><C-s> :wa <bar> TestSuite<CR>
nmap <silent> <C-t><C-l> :wa <bar> TestLast<CR>
nmap <silent> <C-t><C-g> :wa <bar> TestVisit<CR>
let test#strategy = 'vimux'
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

" let test#strategy = 'dispatch'
" let test#strategy = 'make'
" let test#strategy = 'terminal' " run in mac terminal application terminal
" let test#strategy = 'iterm' " run in mac terminal application iterm
" let test#strategy = 'basic' " run test commands with :!
" let test#strategy = 'neovim' " use neovim :terminal
" let test#strategy = 'vimterminal' " vim 8 trminal
let test#filename_modifier = ':.'
" let test#filename_modifier = ':.' " test/models/user_test.rb (default)
" let test#filename_modifier = ':p' " /User/janko/Code/my_project/test/models/user_test.rb
" let test#filename_modifier = ':~' " ~/Code/my_project/test/models/user_test.rb

" Jump to next error
" Use `[d` and `]d` to navigate diagnostics (`e` jumps directly to errors)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> <leader>e <Plug>(coc-diagnostic-info)
nnoremap <silent> <leader>d  :<C-u>CocList -A --normal diagnostics<cr>

" Remap saving files
nmap <silent> <leader>w :w<CR>
nmap <silent> <leader>q :q<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

nmap <leader><cr> :nohlsearch <cr>

" git mappings
nnoremap <silent> <leader>gi :CocCommand git.chunkInfo<CR>
nnoremap <silent> <leader>gu :CocCommand git.chunkUndo<CR>
nnoremap <silent> <leader>ga :CocCommand git.chunkStage<CR>

" navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

nmap cp :VCoolor <cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nmap <silent> <leader>f :CocAction<cr>

function! GetRegisters()
    redir => cout
    silent registers
    redir END
    return split(cout, "\n")[1:]
endfunction
function! UseRegister(line)
    let var_a = getreg(a:line[1], 1, 1)
    " let var_amode = getregtype(a:line[1])
    " call setreg('"', var_a, var_amode)
    exe 'normal! o'.var_a[0]
endfunction
command! Registers call fzf#run(fzf#wrap({
            \ 'source': GetRegisters(),
            \ 'sink': function('UseRegister')}))


function! RandomColorScheme()
  let mycolors = split(globpath(&rtp,"colors/*.vim"),"\n")

  let components = split(reltimestr(reltime()), '\.')
  let microseconds = components[-1] + 0

  let mycol = mycolors[microseconds % len(mycolors)]
  let mycol = split(mycol, '/')[-1]
  let mycol = substitute(mycol, '\.vim', '', '')

  exec "colorscheme " . mycol
  " display it
  exec "colorscheme"

  unlet mycolors
  unlet mycol
endfunction

:command! NewColor call RandomColorScheme()
