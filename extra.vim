if filereadable(expand("~/.vim/vimrc.functions"))
  source ~/.vim/vimrc.functions
endif

let g:fzf_layout = { 'window': {'width': 1, 'height': 0.3, 'yoffset': 1} }
let $FZF_DEFAULT_OPTS="--layout reverse"
" Swap two words surrouding an operator
nmap >W WvhdBPli<space><esc>hhvEEldEPxBBB
" this is used with autocmd InsertLeave, every word under cursor is copy when
" leaving insert mode and can be pasted with "W
nmap "W "wsiw
nmap "P siw
nnoremap =<SPACE> i <ESC>la <ESC>h

nnoremap gr :call RgWithMode(expand("<cword>"))<CR>
nnoremap <c-f> :call RgWithMode("")<CR>

nnoremap \m :w<CR>:execute "cd %:p:h \| try \| cd bin \| catch \| try \| cd ../bin \| catch \| endtry \| endtry"<CR>:make %:t:r<CR>
nnoremap \[ :cp<Cr>
nnoremap \] :cn<Cr>

noremap -= =a}``

nmap <F6> :call FilesAtGitRoot()<cr>
imap <F6> <esc>:call FilesAtGitRoot()<cr>
" nmap <silent> <F7>  :call IterateRgMode()<CR>
" imap <silent> <F7> <esc>:call IterateRgMode()<CR>
nmap <silent> <F7>  :call RgModeFZF()<CR>
imap <silent> <F7> <esc>:call RgModeFZF()<CR>

command! To2spaces %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g
command! To4spaces %s/^\s*/&&/g

" For jumping through function arguments
nmap <silent> ( :call JumpThroughParameter(-1)<CR>
nmap <silent> ) :call JumpThroughParameter(1)<CR>

autocmd InsertLeave * call CopyWordUnderCursor()

" hi MatchParen guibg=NONE gui=underline
hi MatchParen guibg=orange guifg=black

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
autocmd BufWritePost *.cpp,*.h,*.c,*.cc call UpdateTags()

augroup OpenAllFoldsOnFileOpen
    autocmd!
    autocmd BufRead * normal zR
augroup END


" function Func()
" :TSContextDisable
" lua require'hop'.hint_char1()
" :TSContextEnable
" endfunction
