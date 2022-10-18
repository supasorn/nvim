let g:fzf_layout = { 'window': {'width': 1, 'height': 0.3, 'yoffset': 1} }
let $FZF_DEFAULT_OPTS="--layout reverse"

nnoremap gf :call RgWithPath(expand("<cword>"))<CR>
nnoremap <c-f> :call RgWithPath("")<CR>

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

function! GetParents(dir)
  let dir = fnamemodify(a:dir, ':p:h')
  let arr = [dir]
  while 1
    let par = fnamemodify(dir, ':h')
    if par == dir
      break
    endif
    let arr =  arr + [par]
    let dir = par
  endwhile
  return arr
endfunction

function! SetRgPath(...)
  let st = substitute(a:1, "'", '', 'g')
  let path = matchstr(st, '\v\[([^]]*)')
  let g:rgmode_path = path[1:]
  call RgWithPath("")
endfunction
command! -nargs=* SetRgPathC call SetRgPath(shellescape(<q-args>))

function! RgModeFZF()
  let gitpath = system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
  let file = expand("%")

  let folders = GetParents(file)

  " let list = [" 0:a) git [" . gitpath . "]"]
  let list = []
  let counter = 1
  for i in folders
    let ts = string(counter)
    if counter < 10
      let ts = ' ' . ts
    endif
    let alias =  '     '
    if i == gitpath
      let alias = 'git  '
    elseif i == expand('~')
      let alias = 'home '
    endif


    let list = list + [ts . ':'. nr2char(char2nr('a') + counter - 1) . ') ' . alias . ' [' . i . ']']
    let counter += 1
  endfor

  call fzf#run({'source': list,
        \'sink':'SetRgPathC', 'window': {'width': 1, 'height': counter + 3, 'yoffset': 1}, 'options': "--query \"':\" --no-sort"})
endfunction

" ----------- Utility functions --------------
function! RgWithPath(query)
  let g:rgmode_query = a:query
  let g:rgmode_rgopt = "-g '!tags' --column --line-number --no-heading --color=always --smart-case"

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


