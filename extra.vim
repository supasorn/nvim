" Rule: tmux send -t 2 ls Enter
" Rule: tmux send -t 2 '!!' Enter Enter
"
nnoremap gf :call RgCwd(expand("<cword>"))<CR>
" nnoremap <space>/ :call RgCwd("")<CR>
" nnoremap <space>f :call FilesWithPath()<cr>

" nmap <F6> :call FilesAtGitRoot()<cr>
" imap <F6> <esc>:call FilesAtGitRoot()<cr>

" nmap <F5> :FzfLua grep<cr>
" imap <F5> <esc>:FzfLua grep<cr>


" nmap <F7> :call RgModeFZF()<CR>
" imap <F7> <esc>:call RgModeFZF()<CR>

nmap <silent> ( :call JumpThroughParameter(-1)<CR>
nmap <silent> ) :call JumpThroughParameter(1)<CR>

nnoremap \m :call FirstLineCompile()<CR>

autocmd InsertLeave * call CopyWordUnderCursor()

" augroup OpenAllFoldsOnFileOpen
    " autocmd!
    " autocmd BufWinEnter * normal zR
    " echom "yes"
" augroup END
"
function! FirstLineCompile() 
  if !empty(matchstr(getline(1), ':'))
    let l:s = split(getline(1) , ':')
  else
    let l:s = ''
  endif
  " echom l:s
  if !empty(matchstr(l:s[0], 'Rule'))
    let l:command = l:s[1]
    let l:out = system(l:command)
    try
      cexpr l:out 
    catch
      "echo l:out
    endtry
    botright cwindow 8
    echo l:out
  endif
endfunction 

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
  exe 'cd' g:rgmode_path 
  echom 'Set cwd to ' . g:rgmode_path
  lua vim.notify(' ' .. vim.g.rgmode_path, vim.log.levels.INFO, {title="Find Path Cwd"})
  " call RgWithPath("")
endfunction

command! -nargs=* SetRgPathC call SetRgPath(shellescape(<q-args>))

function! RgModeFZF()
  let gitpath = system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
  let file = expand("%")

  let folders = GetParents(file)

  let list = [" 0:G) git   [" . gitpath . "]"]
  " let list = []
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
function! FilesWithPath()
  lua require'fzf-lua'.files({cwd=vim.g.rgmode_path}) 
endfunction

function! FilesCwd()
  lua require'fzf-lua'.files({cwd=vim.fn.getcwd()}) 
endfunction

function! RgWithPath(query)
  let g:rgmode_query = a:query
  let g:rgmode_rgopt = "-g '!tags' --column --line-number --no-heading --color=always --smart-case"

  lua require'fzf-lua'.grep({rg_opts=vim.g.rgmode_rgopt, cwd=vim.g.rgmode_path, search=vim.g.rgmode_query, fzf_cli_args = '--nth 3.. -d :'}) 
endfunction

function! RgCwd(query)
  let g:rgmode_query = a:query
  let g:rgmode_rgopt = "-g '!tags' --column --line-number --no-heading --color=always --smart-case"

  lua require'fzf-lua'.grep({rg_opts=vim.g.rgmode_rgopt, cwd=vim.fn.getcwd(), search=vim.g.rgmode_query, fzf_cli_args = '--nth 3.. -d :'}) 
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


