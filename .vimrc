set termguicolors

" Checks for nvim being installed...
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

"BEGIN: ============== Oliver's plugins =========

" Used to quickly surround visual selections with html tags or quotes
Plug 'tpope/vim-surround'

" " Helpful auto-completion of common language-specific things
Plug 'honza/vim-snippets'

" Multi-selection using Ctrl + N
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Color pallete selector
Plug 'KabbAmine/vCoolor.vim'

" Need to install ripgrep for this to work: `brew install ripgrep`
" Fzf has an integration with ripgrep to search git files using command :Rg
Plug 'jremmen/vim-ripgrep'

" Global find and replace 
Plug 'brooth/far.vim'

" vim-dadbod adds support for querying databases from Vim. 
"
" Run :DB <db_url> <sql query>
"
" NOTES:
"   * vim-elixir works with this by running :DB MyApp.Repo <sql query>. However,
"   it does not work if your app is running inside of docker
"   * vim-dotenv allows you to call :DB $DATABASE_URL if DATABASE_URL is set in
"   your .env file
Plug 'tpope/vim-dadbod'

"
Plug 'tpope/vim-dotenv'

"Oliver's: Tsx/Jsx related
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

" END: =================Oliver's plugins ==========

" Use to help navigate between vim/tmux panes seamlessly with ctrl + hjkl
Plug 'christoomey/vim-tmux-navigator'

" Excellent library for searching across your project (among other things)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Plug 'elixir-editors/vim-elixir'

" Plug 'gleam-lang/gleam.vim'
" Plug 'preservim/nerdtree'
Plug 'preservim/vimux'
Plug 'tpope/vim-fugitive'

"Most recently used... open with :MRU

Plug 'yegappan/mru'
Plug 'tpope/vim-abolish'

" Following three plugins are for quick navigation between elixir test and src
" files. See https://github.com/andyl/vim-projectionist-elixir. Tag: go to test
Plug 'tpope/vim-projectionist'
Plug 'c-brenn/fuzzy-projectionist.vim'
Plug 'andyl/vim-projectionist-elixir'

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

" ==== BEGIN: Oliver's coc plugs ====

Plug 'neoclide/coc-snippets', { 'do': 'npm install --force'}
Plug 'neoclide/coc-pairs', {'do': 'npm install --force'}

" ==== END: Oliver's coc plugs ====


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
set undodir=~/.vim/undodir "persist undo's per-file across vim sessions to not lose undo history
set undofile "enable the above
set foldmethod=indent "enable folding by indent
set nofoldenable "but don't fold everything whenever you open a file

colorscheme base16-gruvbox-dark-medium

" Vim leader is ","
let mapleader=","

" To resource `~/.vimrc`
nmap <leader>l :so $MYVIMRC<cr>

" == bare Vim remappings ==
"
" Remap saving files
nmap <silent> <leader>w :w<CR>
nmap <silent> <leader>q :q<CR>

" , + enter removes yellow highlights after searching
nmap <leader><cr> :nohlsearch <cr>

" Some magic to make tabbing through autocompletion popups from CoC work.
"
" Hit tab to navigate through popups
" Hit enter while in popup to select currently highlighted thing
"
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" ====

" == from: tpope/vim-dadbod / tpope/vim-dotenv ==
nnoremap <C-d><C-d> :DB $DATABASE_URL
" ====

" == from junegunn/fzf ==: 
"
" Search all files tracked by git
nnoremap <C-p> :GFiles<Cr>

" Search all files that are currently modified / staged with git
nnoremap <silent> gst :GFiles?<CR>

" Search for file across all files including those not tracked by Git
"   NOTE: This is not the default behaviour of :Files from fzf...
"   we override the default :Files command to do so via the FZF_DEFAULT_COMMAND
"   env var set in ~/.zshrc. This command uses ripgrep (rg) with the needed flags
"   to do this
nnoremap <C-f> :Files<Cr>
"
" ====

" == from nvim-treesitter/nvim-treesitter: (see ~/.config/nvim/init.vim for
"treesitter config) ==: 
"
"Incremental selection with treesitter. Search for gnn/grn/grm in the above
"specified file path to see the treesitter config related to this in this file
nmap <S-Up> gnn
vmap <S-Up> grn
vmap <S-Down> grm
" ====

map 0 ^

" == from yegappan/mru: shows recently open files == 
nnoremap <leader>ru :MRU<CR>

" == from coc-nvim == 
"
" Defines `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" ====

" == from: vim-projectionist / 'c-brenn/fuzzy-projectionist.vim' / 'andyl/vim-projectionist-elixir'
"
" NOTE: Technically the below commands also toggle between other types of
" associated file types than test and source files. They may work on toggling
" between controllers & views, or LiveViews and Views... however my
" main use case for it is to toggle between tests and src code.
"
" Toggle between test and src files for current buffer
nnoremap <Leader>gt :A<CR>

" Open associated test/src file for current file in new vertical split buffer
nnoremap <Leader>gv :AV<CR>
" ==== 

" == from: 'preservim/vimux'
"
" Define a function that sends highlighted text to Vimux (tmux) buffer
function! VimuxSlime()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

 " If text is already selected, save it in the v buffer and send that buffer to tmux
vmap <C-c><C-c> "vy :call VimuxSlime()<CR>
 " Select current paragraph that your cursor is over and send it to tmux
nmap <C-c><C-c> vip<C-c><C-c>

" Run the last command you sent to tmux
nmap <C-c><C-l> :wa <bar> VimuxRunLastCommand<CR>

" Specifically to run mix surface.format
nmap <silent> <C-c><C-f> :wa <bar> VimuxRunCommand "mix surface.format"<CR>
" ====

" == from: 'vim-test/vim-test'
"
" Test mappings
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> <C-t><C-n> :wa <bar> TestNearest<CR>
nmap <silent> <C-t><C-f> :wa <bar> TestFile<CR>
nmap <silent> <C-t><C-s> :wa <bar> TestSuite<CR>
nmap <silent> <C-t><C-l> :wa <bar> TestLast<CR>
nmap <silent> <C-t><C-g> :wa <bar> TestVisit<CR>
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

" Other options for where to run tests are below. Keep them around in case you
" wish to switch from using vimux to something else
"
let test#strategy = 'vimux'
" let test#strategy = 'dispatch'
" let test#strategy = 'make'
" let test#strategy = 'terminal' " run in mac terminal application terminal
" let test#strategy = 'iterm' " run in mac terminal application iterm
" let test#strategy = 'basic' " run test commands with :!
" let test#strategy = 'neovim' " use neovim :terminal
" let test#strategy = 'vimterminal' " vim 8 trminal

" Different ways of specifying what file path to feed to the test runner
"
let test#filename_modifier = ':.'
" let test#filename_modifier = ':.' " test/models/user_test.rb (default)
" let test#filename_modifier = ':p' " /User/janko/Code/my_project/test/models/user_test.rb
" let test#filename_modifier = ':~' " ~/Code/my_project/test/models/user_test.rb
"
" ====

" == from: neoclide/coc-snippets and honza/vim-snippets
"
" Instructions for use of snippets:
"   * Begin typing snippet name hit enter when you find correct snippet in
"   coc dropdown
"   * Type anything to replace visually selected text (do not esc or hit i as
"   this will remove you from the autofill mode that snippets uses)
"   * Once done filling out the first snippet field, hit <C-j> to jump to the next
"   snippet field
"   * Keep doing this until you have filled all the snippet fields out
nmap <C-s><C-s> :CocList snippets<cr>
" ====


" == from: iamcco/coc-diagnostic
"
" Jump to next error
" Use `[d` and `]d` to navigate diagnostics (`e` jumps directly to errors only)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" , + e shows diagnostic info across entire project
nmap <silent> <leader>e <Plug>(coc-diagnostic-info)

" , + d shows error info across entire project
nnoremap <silent> <leader>d  :<C-u>CocList -A --normal diagnostics<cr>
" ==== 

" == from: coc-* ==  
"
" Coc jump to mappings:
"
" current symbol = thing your cursor is over
"
"  gd: Jump to definition(s) of current symbol by invoke
nmap <silent> gd <Plug>(coc-definition)
"  gy: Jump to type definition(s) of current symbol by invoke
nmap <silent> gy <Plug>(coc-type-definition)
"  gi: Jump to implementation(s) of current symbol by invoke
nmap <silent> gi <Plug>(coc-implementation)
"  gr: Jump to reference(s) of the current symbol by invoke
nmap <silent> gr <Plug>(coc-references)

" Show coc hover docs
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  " If inside of a vim doc or help, don't use CoC hover docs
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Coc git mappings
"
" Show git information under your cursor (will show git diff associated with git
" gutter bar)
nnoremap <silent> <leader>gi :CocCommand git.chunkInfo<CR>

" Undo change associated with git gutter bar
nnoremap <silent> <leader>gu :CocCommand git.chunkUndo<CR>

" Stages change from git gutter bar
nnoremap <silent> <leader>ga :CocCommand git.chunkStage<CR>

" Navigate git chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)
" ==== 

" == from KabbAmine/vCoolor.vim ==
"
" Opens a color palette selector and inserts a hex / rgb value of whatever you
" choose
nmap cp :VCoolor <cr>
" ==== 

" This doesn't appear to do anything? Keeping around until I discover what it
" does
nmap <silent> <leader>f :CocAction<cr>


" == Use fzf to help search through Registers with custom :Registers command
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
" ==== 

" == Get a new RandomColorScheme when you invoke the :NewColor command.
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
" ====
