local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
  print "Cloning packer .."
  fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

  vim.cmd "packadd packer.nvim"
  require "plugins"
  vim.cmd "PackerSync"
end

require('impatient')

require 'plugins'

vim.cmd "colorscheme onedark"

  -- Disable Diagnostcs globally
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

local opt = vim.opt
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
opt.cursorlineopt= "number"
opt.signcolumn = "yes"

local map = require("utils").map
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.cmd [[
vmap // y/\V<c-r>"<cr>
vmap /s //<esc>:%s//

" targets.vim's argument should really make Ia the default argument
omap ia Ia
xmap ia Ia

" used with supasorn/targets.vim to repeat ci" in the next / previous text object in insert mode
imap <c-l> <esc>u@r
imap <c-h> <esc>g-i

" Swap two words surrouding an operator
nmap >W WvhdBPli<space><esc>hhvEEldEPxBBB
" this is used with autocmd InsertLeave, every word under cursor is copy when
" leaving insert mode and can be pasted with "W
nmap "W "wsiw
nmap "P siw

nnoremap =<SPACE> i <ESC>la <ESC>h

command! To2spaces %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g
command! To4spaces %s/^\s*/&&/g
]]




