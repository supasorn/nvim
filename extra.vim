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
nnoremap \r :call FirstLineCompile(2)<CR>

autocmd InsertLeave * call CopyWordUnderCursor()

" augroup OpenAllFoldsOnFileOpen
    " autocmd!
    " autocmd BufWinEnter * normal zR
    " echom "yes"
" augroup END

function! s:AfterDap(timer) abort
  execute 'DapViewOpen'
  execute 'DapContinue'
endfunction

function! s:OnCompileExit(command, output, job_id, exit_code, event) abort
  call setqflist([], 'r')
  call setqflist(a:output, 'a')

  let l:qf = getqflist()

  let b:building = v:false
  let b:build_ok = (a:exit_code == 0)
  lua require('spinner').stop()
  redrawstatus

  if a:exit_code == 0 && empty(l:qf)
    echohl DiagnosticOk
    echom '✔ Build succeeded'
    echohl None
  else
    botright cwindow 8
  endif

  if a:command =~ 'dpython'
    call timer_start(500, function('s:AfterDap'))
  endif
endfunction

function! FirstLineCompile(...) 
  let l:line = a:0 > 0 ? a:1 : 1
  let l:text = getline(l:line)

  if l:text !~ ':'
    return
  endif

  let l:s = split(l:text, ':', 1)

  if l:s[0] !~ 'Rule'
    return
  endif

  let b:building = 1
  let b:build_ok = v:null
  redrawstatus
  lua require('spinner').start()

  let l:command = trim(l:s[1])

  " clear quickfix
  call setqflist([], 'r')

  let l:output = []

  let l:job = jobstart(l:command, {
        \ 'stdout_buffered': v:true,
        \ 'stderr_buffered': v:true,
        \ 'on_stdout': {j,d,e -> extend(l:output, d)},
        \ 'on_stderr': {j,d,e -> extend(l:output, d)},
        \ 'on_exit': function('s:OnCompileExit', [l:command, l:output]),
        \ })

  if l:job <= 0
    echoerr 'Failed to start job'
  endif

  " let l:out = system(l:command)
  " try
    " cexpr l:out 
  " catch
    "echo l:out
  " endtry

  " if l:command =~ 'dpython'
    " call timer_start(500, {-> [execute('DapViewOpen'), execute('DapContinue')]})
  " endif
  " botright cwindow 8
  " echo l:out

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


