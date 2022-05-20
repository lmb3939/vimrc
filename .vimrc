" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 :
"
"    This is the personal .vimrc file of lmb.
"    Copyright 2022 lmb.
" }

" plugin manager {

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" }

" Environment {

    " Basics {
    set nocompatible
    filetype plugin indent on  " enable filetype dectection and ft specific plugin/indent
    syntax on                  " enable syntax hightlight and completion
    set encoding=utf-8         " Necessary to show Unicode glyphs
    set fileencoding=utf-8
    set hidden
    let $LANG='en'             " Avoid garbled characters in Chinese language windows OS
    source $VIMRUNTIME/delmenu.vim
    " }

" }

" Vim UI {

    " Basics {
    set fillchars=vert:\ ,stl:\ ,stlnc:\
    set showmode                    " Display the current mode
    " highlight current line
    au Winleave * set nocursorline nocursorcolumn
    au Winleave * set cursorline cursorcolumn
    set cursorline cursorcolumn
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LinerNr         " current line number row will have same background color in relative mode
    set laststatus=2
    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set relativenumber
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    " }

    " Theme, fonts , etc {
    set bg=light
    "set bg=dark

    "color space-vim-dark
    "color dracula
    "color gruvbox
    "color papercolor
    "color Atelier_SulphurpoolDark
    "color Atelier_SulphurpoolLight
    color inkstained
    "color zephyr

    hi Cursor guifg=#000000 guibg=#FE8019
    hi comment gui=none guifg=#008C8C
    set guifont=UbuntuMono\ Nerd\ Font:h14
    " }

" }

" Formatting {

    set foldcolumn=1                     " add a bit extra margin to the left
    set nowrap                           " Do not wrap long lines
    set autoindent                       " Indent at the same level of the previous line
    set smartindent                      " si
    set shiftwidth=4                     " Use indents of 4 spaces
    set smarttab                         " Be smart when using tabs ;)
    set expandtab                        " Tabs are spaces, not tabs
    set tabstop=4                        " An indentation every four columns
    set softtabstop=4                    " Let backspace delete indent
    set nojoinspaces                     " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                       " Puts new vsplit windows to the right of the current
    set splitbelow                       " Puts new split windows to the bottom of the current
    au FileType c,cpp,java, set mps+==:; " Match, to be used with %

    " set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    "highlight OverLength ctermbg=red ctermfg=white guibg=#ff6600
    "au BufRead,BufNewFile *.v,*.c match OverLength /\%80v.*/
" }

" Edit {

    " Super VIM {
    let mapleader = "\<Space>"

    " Quickly edit/reload the vimrc file
    nmap <silent> <leader>ev :e $MYVIMRC<CR>
    nmap <silent> <leader>sv :so $MYVIMRC<CR>

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
                \ if ! exists("g:leave_my_cursor_position_alone") |
                \     if line("'\"") > 0 && line ("'\"") <= line("$") |
                \         exe "normal g'\"" |
                \     endif |
                \ endif

    " Make VIM remember position in file after reopen
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    nnoremap ; :
    nnoremap <ESC> :nohl<CR>
    imap jj <ESC>

    " Shift+*: do not goto next match
    nnoremap <silent><expr> * v:count ? '*'
                \ : ':execute "keepjumps normal! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'
    nnoremap <silent><expr> g* v:count ? 'g*'
                \ : ':execute "keepjumps normal! g*" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'

    " Make a simple "search" text object.
    vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
                \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv

    " insert date e.g. 31Jan11
    :inoremap \zd <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
    " insert filename
    :inoremap \zf <C-R>=expand("%")<CR>

    au FocusLost * silent! wa
    " fold all but the matched area
    nnoremap zpr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>

    " Delete trailing, ^m, etc.. {
    " Delete trailing spaces at line ending
    nnoremap <C-S-S> :%s/\s\+;/;/g<CR>
    nnoremap <C-S-C> :%s/\s\+,/,/g<CR>
    " Delete ^m
    nnoremap <leader>dm : %s/\r//g<CR>
    " Change tabs to spaces
    nnoremap <leader>tt : %s/\t/    /g<CR>
    " Delete trailing
    nnoremap <leader>ts : %s/\s\+$//<CR>
    " Delete blank line
    nnoremap <leader>dl :g/^\s*$/d<CR>
    " Delete trailing white space on save, useful for Python ;)
    autocmd BufWrite *.*  : call DeleteTrailingWS()
    " }

    " Buffer, Tabs {
    map <leader>l :bnext<cr>
    map <leader>h :bprevious<cr>

    " }

    " Navigation {

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " easier navigation between split windows
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-h> <c-w>h
    nnoremap <c-l> <c-w>l
    " }

    " }

    " Basic Edit {
    set nomore
    set novb
    set noeb
    set t_vb=
    set history=10
    set lazyredraw       " Don't redraw while executing macros (good performance config)
    set magic            " For regular expression turn magic on
    set autoread         " auto reload when file was changed by other editor
    set autowrite
    set confirm
    set nobackup         " Turn backup off, since most stuff is in SVN, git et.c anyway...
    set nowb
    set noswapfile
    set confirm          " prompt when existing from an unsaved file
    set t_Co=256         " Explicitly tell vim that the terminal has 256 colors
    set mouse=a          " Automatically enable mouse usage
    set gcr:a:blinkon0   " No blink
    set mousehide        " Hide the mouse cursor while typing
    set report=0         " always report number of lines changed
    set matchtime=2      " show matching bracket for 0.2 seconds
    set matchpairs+=<:>  " specially for html
    set nojoinspaces     " Prevents inserting two spaces after punctuation on a join (J)
    set tabpagemax=15    " Only show 15 tabs
    "set scrolljump=5     " Lines to scroll when cursor leaves screen
    "set scrolloff=3      " Minimum lines to keep above and below cursor
    set foldenable        " Auto fold code
    set foldmethod=marker
    set foldmarker={{{,}}}
    " }

    " }

" Plugin {

    " auto-pairs{
    let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"'}
    " }

    " Coc{
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/coc.nvim"))
        inoremap <silent><expr> <c-space> coc#refresh()
        :nnoremap <space>e :CocCommand explorer<CR>
    endif
    " }

    " fzf {
    nnoremap <silent> <Leader>f :Files<CR>
    nnoremap <silent> <Leader>b :Buffers<CR>
    " }

    " vim-tex{
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vimtex"))
        autocmd TextChanged,TextChangedI <buffer> silent write
        let g:tex_flavor = 'latex'
        "let g:vimtex_view_method='mupdf'
        let g:vimtex_view_general_viewer = 'SumatraPDF'
        let g:vimtex_view_general_options
                    \ = '-reuse-instance -forward-search @tex @line @pdf'
        let g:vimtex_view_general_options_latexmk = '-reuse-instance'
        let g:vimtex_quickfix_mode=0
        set conceallevel=1
        let g:tex_conceal='abdmg'
    endif
    " }

    " rainbow_paraentheses {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/rainbow_parentheses.vim"))
        let g:rbpt_colorpairs = [
                    \ ['brown',       'RoyalBlue3'],
                    \ ['Darkblue',    'SeaGreen3'],
                    \ ['darkgray',    'DarkOrchid3'],
                    \ ['darkgreen',   'firebrick3'],
                    \ ['darkcyan',    'RoyalBlue3'],
                    \ ['darkred',     'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['gray',        'RoyalBlue3'],
                    \ ['black',       'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['Darkblue',    'firebrick3'],
                    \ ['darkgreen',   'RoyalBlue3'],
                    \ ['darkcyan',    'SeaGreen3'],
                    \ ['darkred',     'DarkOrchid3'],
                    \ ['red',         'firebrick3'],
                    \ ]
        let g:rbpt_max = 16
        let g:rbpt_loadcmd_toggle = 0
        au VimEnter * RainbowParenthesesToggle
        au Syntax   * RainbowParenthesesLoadRound
        au Syntax   * RainbowParenthesesLoadSquare
        au Syntax   * RainbowParenthesesLoadBraces
        au Syntax   * RainbowParenthesesLoadChevrons
    endif
    " }

    " airline {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-airline"))
        let g:airline#_powerline_fonts = 1
        if !exists ('g:airline_symbols')
            let g:airline_symbols = {}
        endif
        let g:airline_theme = 'papercolor'

        " tabline
        "let g:airline#extensions#tabline#enabled = 1
        "let g:airline#extensions#tabline#buffer_nr_show = 1
        "let g:airline#extensions#tabline#left_sep = ''
        "let g:airline#extensions#tabline#left_alt_sep = ''
        "let g:airline#extensions#tabline#right_sep = ''
        "let g:airline#extensions#tabline#right_alt_sep = ''

        " statusline
        let g:airline_left_sep = ''
        let g:airline_left_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_right_alt_sep = ''
        let g:airline_symbols.branch = ''
        let g:airline_symbols.readonly = ''
        let g:airline_symbols.linenr = ' :'
        let g:airline_symbols.maxlinenr = ''
        "let g:airline_symbols.linenr = '¶'
        "let g:airline_symbols.linenr = '☰'
        let g:airline_symbols.dirty='⚡'
    endif

    " }

    " easy align{
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-easy-align"))
        nmap ga :EasyAlign<CR>
        xmap ga :EasyAlign<CR>
    endif
    "}

    " Easy Grep {
    let g:EasyGrepWindowPosition=""
    let g:EasyGrepRecursive=1
    let g:EasyGrepWindow=1
    let g:EasyGrepIngoreCase=1
    let g:EasyGrepHidden=1
    " }

    " expand region {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-expand-region"))
        "vmap v <Plug>(expand_region_expand)
        "vmap <C-v> <Plug>(expand_region_shrink)
        map K <Plug>(expand_region_expand)
        "map J <Plug>(expand_region_shrink)
    endif
    " }

    " vim-indent-guides {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-indent-guides/"))
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
    endif
    " }

    " vim supertab {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/supertab"))
        let g:SuperTabDefaultCompletionType = "context"
        let g:SuperTabRetainCompletionType=2
        let g:SuperTabDefaultCompletionType="<c-n>"
    endif
    " }

    "signify {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-signify"))
        let g:signify_vcs_list=['git']
        highlight DiffAdd cterm=bold ctermbg=none ctermfg=119
        highlight SignifySignAdd cterm=bold ctermbg=237 ctermfg=119
    endif
    "}

    " WhichKey {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-which-key"))
        nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
        nnoremap <silent> <localleader> :WhichKey ','<CR>
        set timeoutlen=500
        call which_key#register('<Space>', "g:which_key_map")

        nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
        vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

        let g:which_key_map =  {}
        let g:which_key_map.f = { 'name' : '+file' }

        nnoremap <silent> <leader>fs :w<CR>
        let g:which_key_map.f.s = 'save-file'

        let g:which_key_map['w'] = {
                    \ 'name' : '+windows' ,
                    \ 'w' : ['<C-W>w'     , 'other-window']          ,
                    \ 'd' : ['<C-W>c'     , 'delete-window']         ,
                    \ '-' : ['<C-W>s'     , 'split-window-below']    ,
                    \ '|' : ['<C-W>v'     , 'split-window-right']    ,
                    \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
                    \ 'h' : ['<C-W>h'     , 'window-left']           ,
                    \ 'j' : ['<C-W>j'     , 'window-below']          ,
                    \ 'l' : ['<C-W>l'     , 'window-right']          ,
                    \ 'k' : ['<C-W>k'     , 'window-up']             ,
                    \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
                    \ 'J' : ['resize +5'  , 'expand-window-below']   ,
                    \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
                    \ 'K' : ['resize -5'  , 'expand-window-up']      ,
                    \ '=' : ['<C-W>='     , 'balance-window']        ,
                    \ 's' : ['<C-W>s'     , 'split-window-below']    ,
                    \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
                    \ '?' : ['Windows'    , 'fzf-window']            ,
                    \ }

        let g:which_key_map.b = {
                    \ 'name' : '+buffer' ,
                    \ '1' : ['b1'        , 'buffer 1']        ,
                    \ '2' : ['b2'        , 'buffer 2']        ,
                    \ 'd' : ['bd'        , 'delete-buffer']   ,
                    \ 'f' : ['bfirst'    , 'first-buffer']    ,
                    \ 'h' : ['Startify'  , 'home-buffer']     ,
                    \ 'l' : ['blast'     , 'last-buffer']     ,
                    \ 'n' : ['bnext'     , 'next-buffer']     ,
                    \ 'p' : ['bprevious' , 'previous-buffer'] ,
                    \ '?' : ['Buffers'   , 'fzf-buffer']      ,
                    \ }

        let g:which_key_map.v = {
                    \ 'name' : '+Vimtex' ,
                    \ '1' : ['VimtexClean', 'VimtexClean'],
                    \ '2' : ['VimtexCompile', 'VimtexCompile'],
                    \ '3' : ['VimtexCountWords', 'VimtexCountWords'],
                    \ '4' : ['VimtexView', 'VimtexView'],
                    \ '5' : ['VimtexErrors', 'VimtexErrors'],
                    \ '6' : ['VimtexStatus', 'VimtexStatus'],
                    \}

    endif
    "}

    " quickui {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-quickui"))
        call quickmenu#reset()

        "let g:quickmenu_options = "HL"
        "noremap <silent><F12> :call quickmenu#toggle(0)
        "call quickmenu#append("# Debug", '')
        noremap <silent><F12> :call quickui#menu#open()<cr>
        call quickui#menu#install('&File', [
                    \ [ "&New File\tCtrl+n", 'echo 0' ],
                    \ [ "&Open File\t(F3)", 'echo 1' ],
                    \ [ "&Close", 'echo 2' ],
                    \ [ "--", '' ],
                    \ [ "&Save\tCtrl+s", 'echo 3'],
                    \ [ "Save &As", 'echo 4' ],
                    \ [ "Save All", 'echo 5' ],
                    \ [ "--", '' ],
                    \ [ "E&xit\tAlt+x", 'echo 6' ],
                    \ ])
    endif
    " }

    " After
    " NeatStatusLine {
    if isdirectory(expand("~/.vimrc_neovim/.vim/bundle/vim-neatstatus"))
        let g:NeatStatusLine_color_insert = 'guifg=#ffffff guibg=#ff0000 gui=bold ctermfg=15 ctermbg=9 cterm=bold'
    endif
    " }
    " }

" Functions {

    " DeleteTrailingWS
    func! DeleteTrailingWS()
        exe "normal mz"
        %s/\s\+$//ge
        exe "normal `z"
    endfunc

    "autocmd BufWritePre,FileWritePre *.v ks|call LastModified()|'s
    "function! LastModified()
    "    let l = line("$")
    "    exe "1," . l . "s/[L]astModified : .*/LastModified :" .
    "                \ strftime(" %Y %b %d %X")
    "endfunction

    if has("autocmd")
        " Highlight TODO, FIXME, NOTE, etc.
        if v:version > 701
            autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\|HACK\)')
            autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
        endif
    endif

" }

" TODO {
        " >>> Easier formatting
        "nnoremap <silent> <leader>q gwip

        "nmap <silent> * :let @/='\<'.expand('<cword>').'\>'<CR>
" }

" Have a nice day!
