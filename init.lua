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
opt.cursorlineopt= "number"
opt.signcolumn = "yes"

vim.g.python_recommended_style = 0
vim.g.is_pythonsense_suppress_object_keymaps = 1

map("v", "<", "<gv")
map("v", ">", ">gv")

map("v", "//", 'y/\\V<c-r>"<cr>')
map("v", "/s", '//<esc>:%s//', {remap = true})

map({"o", "x"}, "ia", 'Ia', {remap = true})

-- used with supasorn/targets.vim to repeat ci" in the next / previous text object in insert mode
map("i", "<c-l>", '<esc>u@r')
map("i", "<c-h>", '<esc>g-i')

map("n", "gD", vim.lsp.buf.definition)
map("n", "gs", vim.lsp.buf.hover)

-- this is used with autocmd InsertLeave, every word under cursor is copy when
-- leaving insert mode and can be pasted with "W
map("n", '"W', '"wsiw', {remap = true}) 
map("n", '"P', 'siw', {remap = true}) 

map ("n", "=<space>", "i <ESC>la <ESC>h") 
-- Swap two words surrouding an operator
map("n", ">W", "WvhdBPli<space><esc>hhvEEldEPxBBB")

vim.cmd [[
augroup CustomHighlight
    autocmd!
    autocmd ColorScheme * highlight IndentBlanklineIndent1 guifg=#707070 gui=nocombine
                      \ | highlight IndentBlanklineIndent2 guifg=#444444 gui=nocombine
augroup END
]]

vim.cmd "source ~/.config/nvim/extra.vim"

vim.cmd [[
:PackerLoad onedark.nvim
colorscheme onedark
]]






