local fn = vim.fn
local map = require("utils").map
local opt = vim.opt

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

opt.termguicolors = true
opt.mouse = "a"
opt.eb = false
opt.swapfile = false
opt.smartindent = true
opt.autoindent = true
opt.cindent = true
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.number = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true
opt.wildmenu = true
opt.wildmode = "list:longest,full"
opt.incsearch = true
opt.display = "lastline"
opt.scrolloff = 3
opt.autoread = true
opt.encoding = "utf-8"
opt.laststatus = 2
opt.winblend = 0
opt.cursorline = true
opt.cursorlineopt = "number"
opt.signcolumn = "yes"
vim.g.python_recommended_style = 0
-- vim.g.mapleader = " "

opt.foldcolumn = '0'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- vim.g.is_pythonsense_suppress_object_keymaps = 1

require("lazy").setup("plugins2", {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Disable Diagnostcs globally
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

map("v", "<", "<gv")
map("v", ">", ">gv")

-- vnoremap // y/\V<c-r>=escape(@",'/\')<cr><cr>
map("v", "/s", '//<esc>:%s//', { remap = true })

map({ "o", "x" }, "ia", 'Ia', { remap = true })

-- used with supasorn/targets.vim to repeat ci" in the next / previous text object in insert mode
map("i", "<c-l>", '<esc>u@r')
map("i", "<c-h>", '<esc>g-i')
map("n", "cina", 'cIna', { remap = true })

map("n", "<c-q>", ':q<CR>')

map("n", "gD", vim.lsp.buf.definition)
map("n", "gs", vim.lsp.buf.hover)

-- this is used with autocmd InsertLeave, every word under cursor is copy when
-- leaving insert mode and can be pasted with "W
map("n", '"W', '"wsiw', { remap = true })
map("n", '"P', 'siw', { remap = true })

map("n", "=<space>", "i <ESC>la <ESC>h")
-- Swap two words surrouding an operator
map("n", ">W", "WvhdBPli<space><esc>hhvEEldEPxBBB")

map("n", "\\[", ":cp<cr>")
map("n", "\\]", ":cn<cr>")
map("n", "\\dd", ":lua vim.diagnostic.disable()<cr>")

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.cmd [[
set shm+=I
vnoremap // y/\V<c-r>=escape(@",'/\')<cr><cr>
nnoremap gy /\V<c-r>=escape(@",'/\')<cr><cr>

command! To2spaces %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g
command! To4spaces %s/^\s*/&&/g

let g:fzf_layout = { 'window': {'width': 1, 'height': 0.25, 'yoffset': 1} }
" let $FZF_DEFAULT_OPTS="--layout reverse --info inline"
let $FZF_DEFAULT_OPTS="--info inline"

" Fold all "use { }" in plugins.lua
" au BufReadPost plugins.lua :%g/\(use\_.\{-}\)\@<={/ normal! f{zf%
au BufReadPost plugins2.lua :%g/^  {/ normal! f{zf% 

" " This beauty remembers where you were the last time you edited the file, and returns to the same position.
" au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

function! CustomHighlight()
  " hi clear CursorLineNr
  " hi CursorLineNr guifg=#e5c07b
  hi MatchParen guibg=orange guifg=black
  hi TreesitterContextBottom gui=underline guisp=Grey
  hi HighlightCurrentSearch guibg=#ed6623 guifg=black
endfunction

augroup CustomHighlightGroup
  autocmd!
  autocmd ColorScheme * call CustomHighlight()
augroup END
call CustomHighlight()

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=1000 }
augroup END

]]

vim.cmd "source ~/.config/nvim/extra.vim"
