" Options

" Start with some decent defaults.
" This has to be before almost anything else because setting it resets a bunch of options.
set nocompatible

" Can backspace over newlines
set backspace=2

" Read modelines.
" (Gentoo disables this by default.)
set modeline

" Enable syntax highlighting.
syntax on

" Tabs and spaces
set tabstop=8           " Hard tabs are displayed as 8 spaces.
set expandtab           " Tab key inserts spaces.
set shiftwidth=4        " Shifting indents 4 spaces.
set shiftround          " Shifting aligns to a multiple of shiftwidth.
set smarttab " Tab key at the beginning of a line inserts shiftwidth spaces.

" Always show the status line.
set laststatus=2

" Show current position in status line.
set ruler

" Show a line at the 80-character mark
set colorcolumn=80

" Make tabs and non-breaking spaces visible.
" Tabs will appear as »-------.
" Non-breaking spaces will appear as a middle dot.
set list listchars=tab:»-,nbsp:·

" Options for automatic formatting.
" tc: wrap text and comments at textwidth
" l: don't break lines that are already past textwidth
" r: enter key inside comment inserts comment character
" j: remove comment character when joining lines
" q: let gq format comments
set formatoptions=tcrqlj

" Insert one space after a period when joining lines.
set nojoinspaces

" Recognize C-style and Python-style line comments, and bulleted lists.
" Don't recognize multi-line C comments.
set comments=://,b:#,fb:-

" Disable C indenting. Should be disabled by nocompatible.
set nocindent

" Copy indent from previous line.
set autoindent

" Searching
set incsearch   " Search while typing.
set hlsearch    " Highlight matches.

" Backup / undo
set nobackup    " Don't write backup~ files; I have real backups.
set writebackup " But keep a copy during writes.

set undofile    " Save undo history.

" Titles
set title
set titleold=

" Easy toggle for paste mode
set pastetoggle=<F2>


""""""""
" Mappings

" Select all
noremap <C-a> :GVgg

" Perform a write if I didn't open in sudo mode
cmap w!! w !sudo tee > /dev/null %

" Make navigating tabs easier.
" ^P and ^N scroll through tabs.
noremap <C-p> :tabprev<cr>
noremap <C-n> :tabnext<cr>

" Make Y yank to the end of the line,
" for consistency with C and D.
noremap Y y$

" Get rid of Q, which enters ex mode,
" something i've never done on purpose
nnoremap Q <Nop>
nnoremap gQ gq

" Make :W an alias for :w
" and :Q an alias for :q
" Common typo.
command W write
command Q quit

" Map ctrlp to ^T
let g:ctrlp_map = '<C-t>'

" Make <F5> toggle the background
function ToggleBackground()
    let &background = ( &background == "dark"? "light" : "dark" )
    if exists("g:colors_name")
        exe "colorscheme " . g:colors_name
    endif
endfunction

noremap <F5> :call ToggleBackground()<CR>
inoremap <F5> <C-\><C-O>:call ToggleBackground()<CR>
vnoremap <F5> <ESC>:call ToggleBackground()<CR>gv

" :Trim strips trailing whitespace from all lines
command Trim %substitute/\s\+$//

""""""""
" Filetypes

" Enable filetype detection.
filetype on

" Enable :Man
runtime ftplugin/man.vim

" Disable modelines in git commit messages.
" Limit width to 72 charaters.
autocmd BufRead COMMIT_EDITMSG setlocal nomodeline textwidth=72

" Use hard tabs in C-based languages
" and Makefiles
autocmd filetype c setlocal noexpandtab shiftwidth=8
autocmd filetype cpp setlocal noexpandtab shiftwidth=8
autocmd filetype go setlocal noexpandtab shiftwidth=8
autocmd filetype javascript setlocal noexpandtab shiftwidth=8
autocmd filetype make setlocal noexpandtab shiftwidth=8


""""""""
" Colors

highlight link pythonImport Keyword
highlight link pythonFunction Normal
highlight link pythonDecorator Normal
highlight link pythonDottedName Normal

" make color column stand out less
highlight ColorColumn ctermbg=darkgrey guibg=darkgrey

" In HTML, don't stylize the contents of <em> and <a> and the like.
let g:html_no_rendering = 1

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

if has('gui_running')
    " better font and color choices
    set guifont=Go\ Mono\ 10
    colorscheme solarized

    " no toolbar
    set toolbar=
end



