local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
local map = require("utils").map
local opt = vim.opt

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
  print "Cloning packer .."
  fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

  vim.cmd "packadd packer.nvim"
  require "plugins"
  vim.cmd "PackerSync"
end

pcall(require, 'impatient')

require 'plugins'


-- Disable Diagnostcs globally
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

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

opt.foldcolumn = '0'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldlevel=20

-- vim.g.is_pythonsense_suppress_object_keymaps = 1

map("v", "<", "<gv")
map("v", ">", ">gv")

map("v", "//", 'y/\\V<c-r>"<cr>')
map("v", "/s", '//<esc>:%s//', { remap = true })

map({ "o", "x" }, "ia", 'Ia', { remap = true })

-- used with supasorn/targets.vim to repeat ci" in the next / previous text object in insert mode
map("i", "<c-l>", '<esc>u@r')
map("i", "<c-h>", '<esc>g-i')

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


vim.cmd [[
hi MatchParen guibg=orange guifg=black

command! To2spaces %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g
command! To4spaces %s/^\s*/&&/g

let g:fzf_layout = { 'window': {'width': 1, 'height': 0.3, 'yoffset': 1} }
let $FZF_DEFAULT_OPTS="--layout reverse"

" Fold all "use { }" in plugins.lua
au BufReadPost plugins.lua :%g/\(use\_.\{-}\)\@<={/ normal! f{zf%
" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

function! CustomHighlight()
  " hi clear CursorLineNr
  " hi CursorLineNr guifg=#e5c07b
endfunction

augroup CustomHighlightGroup
  autocmd!
  autocmd ColorScheme * call CustomHighlight()
augroup END
call CustomHighlight()
]]

vim.cmd "source ~/.config/nvim/extra.vim"
