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

-- map("n", "<f4>", ":Telescope oldfiles<cr>")
map("", "<c-n>", ":NvimTreeToggle %:p:h<cr>")

map("n", "<leader>gs", ":Git<cr>")
map("n", "<leader>gc", ':Git commit -m "auto commit"<cr>')
map("n", "<leader>gp", ":Git push<cr>")

for i = 1,9 do
  map("n", "<leader>"..i, ":BufferLineGoToBuffer ".. i .. "<cr>", {silent = true})
end

