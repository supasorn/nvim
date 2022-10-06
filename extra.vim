let g:fzf_layout = { 'window': {'width': 1, 'height': 0.3, 'yoffset': 1} }
let $FZF_DEFAULT_OPTS="--layout reverse"

nnoremap gf :call RgWithMode(expand("<cword>"))<CR>
nnoremap <c-f> :call RgWithMode("")<CR>

nmap <F6> :call FilesAtGitRoot()<cr>
imap <F6> <esc>:call FilesAtGitRoot()<cr>
" nmap <silent> <F7>  :call IterateRgMode()<CR>
" imap <silent> <F7> <esc>:call IterateRgMode()<CR>
nmap <silent> <F7>  :call RgModeFZF()<CR>
imap <silent> <F7> <esc>:call RgModeFZF()<CR>

command! To2spaces %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g
command! To4spaces %s/^\s*/&&/g

" For jumping throu26572gh function arguments
nmap <silent> ( :call JumpThroughParameter(-1)<CR>
nmap <silent> ) :call JumpThroughParameter(1)<CR>

autocmd InsertLeave * call CopyWordUnderCursor()

" hi MatchParen guibg=NONE gui=underline
hi MatchParen guibg=orange guifg=black

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" augroup OpenAllFoldsOnFileOpen
    " autocmd!
    " autocmd BufWinEnter * normal zR
    " echom "yes"
" augroup END



" ----------- Utility functions --------------
function! RgModeFZF()
  let path = system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
  call fzf#run({'source': [
        \"1) Rg current buffer         [" . expand("%:p:h") . "]",
        \"2) Rg current buffer depth 1 [" . expand("%:p:h") . "]",
        \"3) Rg pwd                    [" . getcwd() . "]",
        \"4) Rg git root               [" . path . "]"],
        \'sink':'SetRgModeC', 'window': {'width': 1, 'height': 8, 'yoffset': 1}})
endfunction

function! RgWithMode(query)
  if !exists("g:rgmode")
   let g:rgmode = 4
  endif

  let g:rgmode_query = a:query
  let g:rgmode_rgopt = "-g '!tags' --column --line-number --no-heading --color=always --smart-case"
  if g:rgmode == 0
    let g:rgmode_path = expand("%:p:h")
  elseif g:rgmode == 1
    let g:rgmode_path = expand("%:p:h")
    let g:rgmode_rgopt = g:rgmode_rgopt . " --max-depth=1"
  elseif g:rgmode == 2
    let g:rgmode_path = getcwd()
  else
    let g:rgmode_path = system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
    if g:rgmode_path == ''
      let g:rgmode_path = expand("%:p:h")
    endif
    " call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ''", 1, fzf#vim#with_preview({'dir': system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]}), 0)
  endif
  lua require'fzf-lua'.grep({rg_opts=vim.g.rgmode_rgopt, cwd=vim.g.rgmode_path, search=vim.g.rgmode_query, fzf_cli_args = '--nth 3.. -d :'}) 
  
endfunction


function! FilesAtGitRoot()
  let path = system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
  exec 'FzfLua files cwd=' . path
endfunction


function! JumpThroughParameter(direction)
  let flag = a:direction == 1 ? '' : 'b'
  let s1 = searchpos('\S(\S', 'en' . flag, line('.'))
  let s2 = searchpos(', \S', 'en' . flag, line('.'))
  if s1 != [0, 0] && (s2 == [0, 0] || 
        \ ((flag == '' && s1[1] < s2[1]) || (flag == 'b' && s1[1] > s2[1])) )
    call search('\S(\S', 'e' . flag, line('.'))
  else
    call search(', \S', 'e' . flag, line('.'))
  endif
endfunction

function! CopyWordUnderCursor()
  let @w = expand('<cword>')
endfunction


