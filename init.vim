:filetype indent on

set tabstop=8 softtabstop=0 expandtab shiftwidth=3 smarttab

:set foldmethod=marker

au BufNewFile *.vhd 0r ~/.vim/template.vhd | let IndentStyle = "vhd"
au BufNewFile *_tb.vhd 0r ~/.vim/tb_template.vhd | let IndentStyle = "vhd"
"find the last signal and mark it with 's'
au BufNewFile,BufRead *.vhd :normal G?signalmsgg

"let g:solarized_termcolors=256
"set background=dark
colorscheme desert
" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

" include fzf
set rtp+=~/.config/nvim/bundle/fzf/bin/
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'w0rp/ale'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets.git'
Plugin 'Shougo/deoplete.nvim'
Plugin 'junegunn/fzf'

"
" " All of your Plugins must be added before the following line
call vundle#end()

let g:deoplete#enable_at_startup = 1

let g:ale_fixers = {'c': ['clang-format']}
" Enable completion where available.
let g:ale_completion_enabled = 1

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
"inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))


iab slv std_logic_vector(
iab sl std_logic
iab sig signal
iab var variable

syntax on
filetype plugin indent on

"set colorcolumn=110                                                                                           
"highlight ColorColumn ctermbg=darkgray

function! Sm1()
   r~/.vim/sm1.vhd
   normal G
endfunction

function! Sm2()
   r~/.vim/sm2.vhd
endfunction

function! Tb(path)
   if filereadable(a:path)
      "python import vim                                                                                         
      "python import sys                                                                                         
      "python string = vim.eval("a:path")
      "python sys.argv = [string]                                                                                
      "pyfile ~/.vim/fileparse.py
      execute '!python2.7 ~/.vim/fileparse.py' a:path "null"
      r~/.vim/tb_template_1.vhd
      normal G
      r./sigs.vhd                                                                                             
      normal G
      r~/.vim/tb_template_2.vhd
      normal G
      r./inst.vhd 
      normal G	
      r~/.vim/tb_template_3.vhd
      normal G
   else
      r~/.vim/tb_template.vhd
   endif

endfunction

function! Inst(path)                                                                                          
   "python import vim  
   "python import sys   
   "python string = vim.eval("a:path")                                                                        
   "python sys.argv = [string]                                                                                
   "pyfile ~/.vim/fileparse.py
   execute '!python2.7 ~/.vim/fileparse.py' a:path "null"
   r./inst.vhd                                                                                             
endfunction 

function! Inst_sigs(path)                                                                                          
   execute '!python2.7 ~/.vim/fileparse.py' a:path "null"
   r./sigs.vhd                                                                                             
endfunction 

"Syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_vhdl_checkers = ['ghdl']
" End syntastic settings

:set rnu

let mapleader="\<Space>"
nnoremap <leader>c :!ctags -R $TCL_SVN
nnoremap <leader>v :vsplit
nnoremap <leader>t :Tab /
nnoremap <leader>j Lzz
nnoremap <leader>k Hzz
nnoremap <leader>i i_<esc>r
"m doesnt work
nnoremap <leader>I :call Inst("
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>n :NERDTree<cr>
"noremap! Q q
inoremap jj <ESC>
inoremap <esc> <nop>
noremap <UP> <NOP>
noremap <DOWN> <NOP>
noremap <RIGHT> <NOP>
noremap <LEFT> <NOP>
tnoremap <Esc> <C-\><C-n>
"==================================================================
"Macros
"set the last signal as marker 's'
let @i = "G?signalms<c-o>"
"make word under cursor a signal
let @s = "yiw'sosignal jjpa : std_logicjjms"
"==================================================================

"==================================================================
"Functions
"==================================================================
"=================================================
" Maperator  - This function modifies an entity block into a port
"               map instantiation.
"to use this function, copy and paste the entity that you want to
"instantiate into the file first. put your cursor in the pasted
"entity section and press <leader>m 
" Maperator Macros
let @p = "0fnwyiw0Pa: jj0/entitywiwork.jjweld$/portea mapjj"
let @l = '/:byiwf:c2w=> jj"0pa, --jj'
" Macro takes the word under the cursor and makes it a signal
" and then returns to location.  Use this after the maperator()
" function.
let @o = 'mm"zyiwf-wy$''sosignal jj"zpa : jjpms`m'
"
nnoremap <leader>m :call Maperator()<cr>
vnoremap <leader>m :<c-u>call Maperator()<cr>

function! Maperator()

   " Move to end of line (this solves corner case of cursor at '0')
   silent exe '$'
   "Find the most previous 'entity'
   silent exe '?entity'
   " mark with M
   normal mm
   silent exe '/end'
   let endmark = line('.')
   normal d$
   silent exe '?:'
   let lastport = line('.')
   normal `m
   normal @p
   
   while line('.') < lastport
      normal @l
   endwhile
   
endfunction
"=================================================

nnoremap <leader>g :set operatorfunc=<SID>Grepperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>Grepperator(visualmode())<cr>

function! s:Grepperator(type)
   let saved_unnamed_register = @@

   if a:type ==# 'v'
      normal! `<v`>y
   elseif a:type ==# 'char'
      normal! `<v`>y
   else
      return
   endif

   :call UnixGrep(@@, '.')
   copen

   let @@ = saved_unnamed_register
endfunction

nnoremap <leader>p :set operatorfunc=<SID>PortmapUpdate<cr>g@
vnoremap <leader>p :<c-u>call <SID>PortmapUpdate(visualmode())<cr>

function! s:PortmapUpdate(type)
   let saved_unnamed_register = @@

   if a:type ==# 'v'
      normal! `<v`>"ay?entityw"byiw
   elseif a:type ==# 'char'
      normal! `<v`>"ay?entityw"byiw
   else
      return
   endif

   :call UnixGrep(@b, './*.vhd')
   let myList = getqflist()
   let FileName = @%
   call filter(myList, 'bufname(v:val.bufnr) !~ FileName')
   call setqflist(myList)
   copen

   let @@ = saved_unnamed_register
endfunction

function! UnixGrep(string, dir)
   silent execute "grep! -R " . shellescape(a:string) . " " . a:dir
"   copen
endfunction

function! UnixFind(string)
   :args `find . -type f -iname "*.vhd"`
endfunction

function! Count( word )
   redir => cnt
   silent exe '%s/' . a:word . '//gn'
   redir END

   let res = strpart(cnt, 0, stridx(cnt, " "))
   return res
endfunction

function! VisualCount( word )
   let start = line("'<")
   let end = line("'>")
   redir => cnt
   silent execute start . ',' . end . '%s/' . a:word . '//gn'
   "silent execute "'<,'>%s/" . a:word . "//gn"
   "silent exe '%s/' . a:word . '//gn'
   redir END

   let res = strpart(cnt, 0, stridx(cnt, " "))
   return res
endfunction
