" vi: foldmethod=marker
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc configuration file
" https://github.com/danmichaelo/dotfiles/blob/master/vimrc
"
" Some sources of inspiration: 
"     http://www.vi-improved.org/vimrc.php
"     http://ciaranm.wordpress.com/2008/05/15/my-vimrc/
"     http://amix.dk/blog/post/19486
"     https://github.com/nvie/vimrc/blob/master/vimrc
"
" Some useful mappings:
"  ,l               Toggle TagList
"  ,t               Command-T
"  <S-left>         NerdTree
"  ,b               FufBuffer
"  ,.               Close current buffer
"  ,r               TeX forward-search with Skim
"  ,ss              Toggle spell checking
"  ,c               Insert timestamp
"  <left>, <right>  Previous / next tab
"  <S-j>, <S-k>     Move a line of text
"  <space>          toggle fold
"  æ/å              <C-d>/<C-u> (move down/up)
"  ø                :nohls 
"  :CD              cd to current dir
"  :w!!             sudo write
"  (DISABLED) <M-tab>          Tex_Completion
"  <C-b>/<C-k>      \langle / \rangle (bra-ket)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove all auto-commands to avoid having the autocommands twice if
" the vimrc file is re-sourced.
autocmd!

set nocompatible         " be iMproved, required
filetype off             " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Keep Plugin commands between vundle#begin/end.

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" From github:
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'vim-scripts/taglist.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-latex/vim-latex'
Plugin 'scrooloose/nerdcommenter'
Plugin 'aquach/vim-mediawiki-editor'
"Plugin 'lervag/vim-latex'
"Plugin 'tomtom/tbibtools'

" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Testing tab-behaviour in MacVim/Terminal Vim (not all keys are picked up...)
"map <special> <Tab> :echo "Got Tab"<CR>
"map <special> <C-Tab> :echo "Got Control-Tab"<CR>
"map <special> <S-Tab> :echo "Got Shift-Tab"<CR>
"map <special> <M-Tab> :echo "Got Alt-Tab"<CR>
" Directory for swap files
set directory=~/tmp,/var/tmp,/tmp,.

" Change mapleader (this has to be done before setting any mappings!)
let mapleader = "," 
let maplocalleader = "," 

" Use neocomplete
let g:neocomplete#enable_at_startup = 1

" Basics {{{
    set encoding=utf-8
    if (!has("gui_running"))
        syntax on 
    endif
    set modeline                " to allow for in-file directives
    set modelines=5             " from the first five lines of a file
    "set wildmode=longest:full  " completes less :)
    set wildmenu                " press ^-D after :e to file surf
    set wildchar=<Tab>          " e.g. :b <tab> to show buffers, :e <Tab> to show files
    set wildmode=full
    if (has("gui_running")) 
      "set lines=46 columns=80   " resize window
    endif
    set nostartofline           " preserve cursor position on e.g. buffer change
" }}}

" Editing {{{
    if has("gui_macvim")    
        "set macmeta            " Interpret Alt-key as meta-key in MacVim
    endif
    set backspace=indent,eol,start " Allow backspace to delete line
    set tabstop=4               " four-space tab indent
    set shiftwidth=4            " allows use of <,> to block (un)indent lines
    set expandtab               " more portable to use spaces for indenting
    set softtabstop=4           " makes backspace delete 4 spaces at once
    set autoindent              " indent at the same level of the previous line
    set smartindent             " do we need it?
    "set textwidth=77           " hard wrap at this column
    set ignorecase              " needed for smartcase
    set smartcase               " ignore case unless upper-case letters entered
    set incsearch               " incremental searching (I love-hate this..)
    set hls                     " Highlight search results
    set pastetoggle=<C-l>p      " Toggles paste mode
    nnoremap <Leader>p :set invpaste<CR>
    set formatprg=par           " http://vimcasts.org/episodes/formatting-text-with-par/

" }}}

" Vim UI {{{
    if (has("gui_running"))
      " set showtabline=0       " hide tab line
      set winaltkeys=no         " prevent Alt key from focusing menu (Windows) 
    endif
    set hidden                  " keep changes to buffer without writing them to file upon buffer change
    if (has("gui_running"))
      set cursorline              " indicate the cursor line
    endif
    set number                  " show linenumber
    "set lazyredraw             " faster macros
    set shortmess+=a            " abbrev. of messages (avoids 'hit enter')
    set showcmd                 " display incomplete commands 
    set guioptions-=T           " Remove toolbar
    set guioptions-=L           " Remove left scrollbar (unwanted win resize)
    set browsedir=buffer        " Maki GUI File Open use current directory
    " set ruler                 " show the cursor position all the time
    set laststatus=2            " show status line even if only one window
    "set scroll=10               " scroll only 10 lines at a time with C-d and C-u
    set lcs=tab:>-,eol:<,nbsp:% " set hidden characters to show upon :set list
" }}}

" Colors, ... {{{
    if (!has("gui_running"))
      colorscheme desert   " looks OK with 16 colors
      "colorscheme Tomorrow
      set bg=dark
    endif
    highlight clear Search
    highlight Search term=underline cterm=underline guibg=Grey40 ctermfg=1 guifg=Red
"" }}}

" Statusline {{{
    " %t: filename (without path)
    " %m modified flag, [+] if modified
    " %r%h%w: readonly,help,preview flags
    set statusline=%2*%-3.3n%0*   " window number
    set statusline+=%t%m%r%h%w\ 

    " %Y: type of file in buffer (h:fileformat)
    " ff: fileformat (unix,mac,dos)
    set statusline+=(%Y,%{&ff},%{&fenc}): 

    " display current tag/function using ctags / taglist:
    set statusline+=\ %{Tlist_Get_Tagname_By_Line()}()

    " %=: Separation point between left and right aligned items
    set statusline+=%=

    " %v: virtual column number
    " %l: line number
    " %p: Percentage through file in lines as in CTRL-G
    " %P: Percentage through file of displayed window.
    set statusline+=%=[POS=%04l,%04v][%P,\ LEN=%L,%{&tw}] 
   
   
    " Special statusbar for special windows
    if has("autocmd")
        au FileType qf
                    \ if &buftype == "quickfix" |
                    \     setlocal statusline=%2*%-3.3n%0* |
                    \     setlocal statusline+=\ \[Compiler\ Messages\] |
                    \     setlocal statusline+=%=%2*\ %<%P |
                    \ endif
   
        "au BufEnter -MiniBufExplorer- setlocal statusline=%f 
    
        fun! <SID>FixMiniBufExplorerTitle()
            if "-MiniBufExplorer-" == bufname("%")
                setlocal statusline=%2*%-3.3n\ %0*\[MiniBufExplorer\]
            elseif "__Tag_List__" == bufname("%")
                setlocal statusline=%2*%-3.3n%0*
                setlocal statusline+=\[TagList\]
                setlocal statusline+=%=\ %<%P
            endif
        endfun
   
        au BufWinEnter *
            \ let oldwinnr=winnr() |
            \ windo call <SID>FixMiniBufExplorerTitle() |
            \ exec oldwinnr . " wincmd w"
    endif
   
    " %0*     Restore normal highlight
    " %2*     Switch to User2 highlight
    " %-3.3n  Buffer number
    " %P      Percentage through the file
    " set statusline"
    " Horizontal scrollbar
    " https://groups.google.com/forum/?fromgroups=#!msg/vim_use/6bO-QKWj9_4/2cdqygSqcMgJ
    " https://github.com/goerz/vimrc/blob/master/vimrc
    function ShowFileFormatFlag(var)
      if ( a:var == 'dos' )
        return ' [dos]'
      elseif ( a:var == 'mac' )
        return ' [mac]'
      else
        return ''
      endif
    endfunction
    if has("gui_running")
        " In gvim, we can do with a fairly simple status line
        set stl=%f\ [%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%M%R%H%W]\ %y\ [%l/%L,%v]\ [%p%%]
    else
        " In a regular console, I want to emulate a scroll bar
        "func! STL()
        "    let stl_encodinginfo = '%{(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"")}'
        "    let stl = '%f ['.stl_encodinginfo.'%M%R%H%W]%{ShowFileFormatFlag(&fileformat)} %y [%4l/%4L,%2.v]'
        "    let takenwidth = len(bufname(winbufnr(winnr()))) + len(&filetype) + 3 * &readonly
        "                \ + len((&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":""))
        "                \ + len(ShowFileFormatFlag(&fileformat))
        "                \ + 2 * ((&modified) || (!&modifiable)) + 2*len(line('$')) + 20
        "                \ + g:stl_extraspace
        "    let barWidth = &columns - takenwidth
        "    let barWidth = barWidth < 3 ? 3 : barWidth

        "    if line('$') > 1
        "        "let progress = (line('.')-1) * (barWidth-1) / (line('$')-1)
        "        " more like a normal progressbar: but this will only be
        "        " approximate with line break enabled, due to different
        "        " counting between line() and winheight()
        "        let progress = (line('w0')-1) * (barWidth-6) / ((line('$')-1) - winheight(0))
        "    else
        "        let progress = barWidth/2
        "    endif

        "    if barWidth <=12
        "        let bar = '[%p%%]'
        "    else
        "        let bar = ' [%0*%'.barWidth.'.'.barWidth.'('.repeat('-',progress ).'%2*      %0*'.repeat('-',barWidth - progress - 6).'%0*%)%<]'
        "    endif

        "    return stl.bar
        "endfun
        "hi def link User1 Grey40
        "hi def link User2 Red
        "highlight User2 ctermbg=Black

        "let stl_extraspace = 0 " You can set this global variable in order to limit the
        " space of the statusline. This is useful in case you
        " have several windows open with vertical splits

        "set stl=%!STL()       " (when starting in console mode)
    endif
    " I also want special formatting of the scroll bar
    set highlight+=sr
    set highlight+=Sr
    set laststatus=2
    
" }}}

" General Mappings {{{
    " < See h:map-modes > "
   
    " Remap 'go to file' to open in new tab
    " nnoremap gf <C-W>g
    "
    " The <Esc> key... <S-Tab> works quite well, but collides
    " with SnipMate, which I would prefer to avoid modifying.
    " <C-Tab>, <M-Tab> doesn't work in all terminals. Neither
    " does <S-Space>. Well, there is <Caps Lock>, the large and
    " tempting key just laying there unused... too bad it's not 
    " mappable in Vim...
    " Ideally, I would like to avoid computer-specific solutions, since
    " that makes life hard when using different computers, but since
    " 99 % of my Vim usage is on my own machine (or through SSH), 
    " I decided to go for a system-wide remapping of <Caps Lock> to 
    " <Esc>  using the PCKeyboardHack pref pane. Doing the same on
    " linux terminals is simple with xmodmap, and on windows it can be
    " done with regedit.

    " Alternatives to <esc>... I used to have <s-tab>, but that was taken by
    " snipmate, so now I'm testing <s-space>.
    "imap <S-tab> <esc>
    "imap <S-space> <esc>
   
    " space -> toggle fold in normal mode
    nnoremap <silent> <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>
   
    " Shift-left -> toggle NERD Tree:
    " (key combo not catched in Mac Terminal Vim!)
    nmap <S-left> :NERDTreeToggle<RETURN>
  
    " Move a line of text using SHIFT+[jk] 
    " Idea: http://vim.wiki.ifi.uio.no/Runarfu.vimrc
    nmap <S-j> mz:m+<cr>`z
    nmap <S-k> mz:m-2<cr>`z
    vmap <S-j> :m'>+<cr>`<my`>mzgv`yo`z
    vmap <S-k> :m'<-2<cr>`>my`<mzgv`yo`z

    " å -> move up, æ -> move down
    nmap æ <C-d>
    nmap å <C-u>

    " ø -> hide search highlightning
    nmap ø :set nohls<cr>
   
    " ,b -> Browse buffers with FuzzyFinder:
    map <leader>b :FufBuffer<cr>

    " ,tt -> Toggle Tag List:
    nmap <leader>m :TlistToggle<cr>

    " ,. -> Close buffer:
    nmap <leader>. :bd<cr>

    " :CD -> Switch to current dir
    command! CD cd %:p:h

    " :w!! -> sudo-write
    cmap w!! w !sudo tee % > /dev/null
   
    " F2 -> show full path
    nnoremap <F2> :echo expand("%:p")<cr>

    " - to comment, _ to uncomment
    nmap - <Plug>NERDCommenterAlignLeft
    vmap - <Plug>NERDCommenterAlignLeft
    nmap _ <Plug>NERDCommenterUncomment
    vmap _ <Plug>NERDCommenterUncomment

    " Map Ctrl-å to Ctrl-] (command for following links), since Ctrl-] doesn't
    " work with Norwegian keyboard layout (on Macs at least)
    map <C-å> <C-]>
   
    " Maps for switching buffers. Note that both Alt-Tab and Ctrl-tab can be 
    " mapped in MacVim, but neither in Terminal Vim, so we need alternatives...
    nnoremap <Right> :bnext<CR>
    "nnoremap <Tab> :bnext<CR>
    nnoremap <Left> :bprevious<CR>

    " Sessions:
    " CTRL+Q for saving, CTRL+S for reloading 
    set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
    map <c-q> :mksession! ~/.vim/.session <cr>
    map <c-s> :source ~/.vim/.session <cr>

    " Automaticly save current viewpoint for tex files:
    " disabled because: resets the cursor, and closes folds.
    " may work better without Vim-LaTeX
    "set viewoptions=folds,cursor
    "au BufWinLeave *.tex mkview
    "au BufWinEnter *.tex silent loadview
    
    "au BufUnload *.tex mkview
    "au BufEnter *.tex silent loadview <CR><SPACE>
    "au BufWinLeave * mkview
    "au BufWinEnter * silent! loadview

    " Reeeally geeky: map arrow keys into something useful :) 
    " Comment: No, I can't handle it!
    "map <up> <c-b>
    "map <down> <c-f>
    "map <left> <ESC>:NERDTreeToggle<RETURN>
    "map <right> <ESC>:Tlist<RETURN>
    
    " Append modeline after last line in buffer.
    " Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
    " files.
    function! AppendModeline()
       let l:modeline = "{# -*- coding: utf-8; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim: set fenc=utf-8 et sw=4 ts=4 sts=4: #}"
       "let l:modeline = substitute(&commentstring, "%s", l:modeline,
                "")
       call append(line("$"), l:modeline)
    endfunction
    nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
   
" }}}

" Tex Mappings {{{
   
    " ,r: Forward-search with Skim    
    map <leader>r :w<CR>:silent !/Applications/Skim.app/Contents/SharedSupport/displayline <C-r>=line('.')<CR> %<.pdf %<CR>
   
    " Shortcuts for bras and kets (Dirac notation)
    imap <C-B> \langle
    imap <C-K> \rangle
    imap <C-v> qw<tab>
    " defined in snippets

    " Map \lz to write-compile-view
    " nmap <buffer><leader>lz :w<cr><leader>ll<leader>lv<cr>
   
    " When compiling the file, the cursor doesn't stay where it was, but
    " jumps to the beginnig of line. Pressing `` will move the cursor back.
    " Let's map \la to save, compile with \ll and return the cursor with ``:
    " nmap <buffer><leader>la :w<cr><leader>ll``

    " Map Alt-Tab to Vim-Latex autocomplete cite/ref (former <F9>):
    " autocmd FileType tex imap <buffer> <M-TAB> <Plug>Tex_Completion

"}}}

" Automation: {{{

    " Test of session saving:
    "au BufWinLeave runcalc mkview
    "au BufWinEnter runcalc silent loadview

    " Use .as for ActionScript files, not Atlas files.
    au BufNewFile,BufRead *.as set filetype=actionscript

    " Load wikimedia markup for .wiki files
    autocmd BufRead,BufNewFile *.wiki            setfiletype Wikipedia
    autocmd BufRead,BufNewFile *.wikipedia.org*  setfiletype Wikipedia
    

    " Load the closetag plugin for HTML files:
    "au Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim 
   
"}}}

" Spell checking: {{{

    " Pressing ,ss will toggle and untoggle spell checking
    map <leader>ss :setlocal spell!<cr>

    " Define a new function to both set spelling language and
    " update the spellingfile variable. 
    " Usage: SetLang no
    " http://vimdoc.sourceforge.net/htmldoc/usr_41.html#41.7
    function! dm:SetLang(newlang)
        " The special prefix 'a:' tells Vim that the variable is a function argument.
        let &spell = 1
        let &spl = a:newlang
        let spellf = $DROPBOXDIR."/spell/".&spl.".".&enc.".add"
        let &spellfile = spellf
        "echo "Using: " . &spf
    endfunction

    command! -nargs=1 SetLang call dm:SetLang("<args>")

"}}}

" Templates: {{{
    " Every time you open a new file Vim checks ~/.vim/skel/ for a file whose name
    " starts with tmpl. and ends with the extension of the file you're creating. It
    " then reads the template file into your new file's buffer. 
    " Invoke Vim with gvim lalala.html
    function! LoadTemplate()
      silent! 0r ~/.vim/templates/tmpl.%:e
      " Highlight %VAR% placeholders with the Todo colour group
      " match Todo /%.*%/
    endfunction
    autocmd! BufNewFile * call LoadTemplate()
    "Jump between %VAR% placeholders in Normal mode with <Ctrl-p>
    "nnoremap <c-p> /%\u.\{-1,}%<cr>c/%/e<cr>
    "Jump between %VAR% placeholders in Insert mode with <Ctrl-p>
    "inoremap <c-p> <ESC>/%\u.\{-1,}%<cr>c/%/e<cr>
"}}}

" Plugin Settings {{{

    " Vim-Latex {{{
        let g:latex_view_general_viewer = 'skim-displayline'
        let g:latex_view_general_options = '1'
    "}}}

    " Automatic LaTex Plugin {{{
        "let g:atp_status_notification = 1
        "let g:atp_ProgressBar = 1
        "let g:atp_statusNotif = 1
        "let g:atp_updatetime_insert = 2000                         
        "let g:atp_updatetime_normal = 1000
        "au BufReadPre *.tex let b:atp_TexCompiler="pdflatex"
    " }}}

    " SnipMate {{{
        let g:snips_author = 'Dan Michael O. Heggø'
    "}}}

    " TagList Settings {{{
        "let Tlist_Ctags_Cmd = "/opt/local/bin/ctags"

        let Tlist_GainFocus_On_ToggleOpen = 1
       
        " close window when only TagList open
        let Tlist_Exit_OnlyWindow = 1
   
        " don't show variables in php
        let tlist_php_settings = 'php;c:class;d:constant;f:function' 

        " When you edit files of filetype 'tex' in Vim, the taglist plugin will
        " invoke the exuberant ctags tool passing the 'latex' filetype and the
        " flags b, c and l to generate the tags. The text heading 'bibitem',
        " 'command' and 'label' will be used in the taglist window for the tags
        " which are generated for the flags b, c and l respectively.
        "let tlist_tex_settings = 'latex;b:bibitem;c:command;l:label'
       
        " Tex language:
        " Defined in ~/.vim/bundle/vim-latex/ftplugin/latex-suite/main.vim on line 885

    "}}}

   
    " Vim-Latex {{{
   
        " IMPORTANT: grep will sometimes skip displaying the file name if you
        " search in a singe file. This will confuse Latex-Suite. Set your grep
        " program to always generate a file-name.
        set grepprg=grep\ -nH\ $*

        " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files
        " defaults to 'plaintex' instead of 'tex', which results in vim-latex
        " not being loaded.  The following changes the default filetype back to
        " 'tex':
        let g:tex_flavor='latex'

        " Vim-LaTex settings
        let g:Tex_Leader = '@'
        let g:Tex_SmartKeyQuote = 1
        "
        " let g:Tex_GotoError=0 " don't go automaticly to first error
        " Note: latex/suitecompiler.vim, at line 605, calls 'cfile', which will
        "       cause the insertion point to jump to the beginning of the line.
        "       I've changed this to call 'cgetfile' instead.
        "
        let g:Tex_DefaultTargetFormat = 'pdf' 
        let g:Tex_MultipleCompileFormats = 'pdf'
        let g:Tex_PromptedEnvironments = 'equation,equation*,align,align*,figure,figure*,subfigure'
       
        if has("unix") && match(system("uname"),'Darwin') != -1
            " Debug: echo "Mac!"
            let g:Tex_ViewRule_pdf = 'open -a Skim.app' 
            "let g:Tex_CompileRule_pdf = 'pdflatex -file-line-error -interaction nonstopmode $* -synctex=1'
            let g:Tex_CompileRule_pdf = 'latexmk -pdf -silent $*'
        else
            " Debug: echo "Not a Mac!"
        endif

        "let g:Tex_ViewRule_pdf = 'kpdf'
            "
        "set errorformat=%f:%l:\ %m
        let g:Tex_CompileRule_bib = '/opt/local/bin/biber $'
        "let g:Tex_CompileRule_pdf = 'rubber $*'
           
        " Vim-Latex Custom Macros (http://tiny.cc/7Pbwu) {
        " lets latex-suite compile the file automatically when the buffer is saved 
        " au BufWritePost *.tex call Tex_RunLaTeX()

        if exists('*IMAP')
            augroup MyIMAPs
              au!
              au VimEnter * call IMAP('veps', "\\varepsilon",'tex')
              au VimEnter * call IMAP('CRE', "\hat{a}_{<++>}^{\\dagger}",'tex')
              au VimEnter * call IMAP('ANI', "\hat{a}_{<++>}",'tex')

              au VimEnter * call IMAP('EAL', "\\begin{align}\<CR><++>\<CR>\\end{align}<++>",'tex')

              au VimEnter * call IMAP('EFE', "\\begin{figure}\<CR><++>\<CR>\\end{figure}<++>", 'tex')
              au VimEnter * call IMAP('MAT', "\\begin{bmatrix}<++>\\end{bmatrix}<++>", 'tex')
              au VimEnter * call IMAP('DET', "\\begin{vmatrix}<++>\\end{vmatrix}<++>", 'tex')
              au VimEnter * call IMAP('SUBFI', "\\begin{figure}[htbp]\<CR>\\centering\<CR>\\subfigure[<+Title 1+>]{\<CR>\\includegraphics[width=7cm]{<+File 1+>}\<CR>\\label{fig:<+Label 1+>}\<CR>}\<CR>\\subfigure[<+Title 2+>]{\<CR>\\includegraphics[width=7cm]{<+File 2+>}\<CR>\\label{fig:<+Label 2+>}\<CR>}\<CR>\\caption{<+Main caption+>}\<CR>\\label{fig:<+Label+>}\<CR>\\end{figure}\<CR><++>", 'tex')

            augroup END
        endif
        " }
       
    "}}}
   
" }}}

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.  Only define it when not
" defined already.
if !exists(":DiffOrig") 
    command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis \ | wincmd p | diffthis 
endif

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowritefile (is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 50
  let g:loaded_LargeFile = 0
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | let g:loaded_LargeFile = 1 | set eventignore+=FileType | setlocal noswapfile bufhidden=unload undolevels=-1 | else | set eventignore-=FileType | endif
  augroup END
endif

" XML {{{

  " Auto-fold if file is not large:
  au BufNewFile,BufRead *.xml if !g:loaded_LargeFile | set ts=2 sts=2 sw=2 foldmethod=indent | endif

" }}}

" Python {{{
    autocmd BufNewFile,BufRead *.py inoremap <F12> <ESC>:w<CR>:!python % 
    autocmd BufNewFile,BufRead *.py nnoremap <F12> :w<CR>:!python % 
   
    nnoremap <leader>c "=strftime("%b %d, %Y %X")<CR>P

    " If buffer modified, update any 'Last modified: ' in the first 20 lines.
    " 'Last modified: ' can have up to 10 characters before (they are retained).
    " Restores cursor and window position using save_cursor variable.
    function! LastModified()
    if &modified
    let save_cursor = getpos(".")
    let n = min([20, line("$")])
    exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
          \ strftime('%b %d, %Y %X') . '#e'
    call setpos('.', save_cursor)
    endif
    endfun
    autocmd BufWritePre * call LastModified()

    " Space: Select all lines with the current indent level:
    autocmd BufNewFile,BufRead *.py nmap <Space> :call SelectIndent()<CR>
    function! SelectIndent ()
        let temp_var=indent(line("."))
        while indent(line(".")-1) >= temp_var
            exe "normal k"
        endwhile
        exe "normal V"
        while indent(line(".")+1) >= temp_var
            exe "normal j"
        endwhile
    endfun

" }}}

command! -nargs=* Hardcopy call DoMyPrint('<args>')
function DoMyPrint(args)
  let colorsave=g:colors_name
  color print
  exec 'hardcopy '.a:args
  exec 'color '.colorsave
endfunction
