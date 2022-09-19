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
require 'plugins'

vim.cmd "colorscheme onedark"

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

local map = require("utils").map
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<f4>", ":Telescope oldfiles<cr>")
map("", "<c-n>", ":NvimTreeToggle %:p:h<cr>")

map("n", "<leader>gs", ":Git<cr>")
map("n", "<leader>gc", ':Git commit -m "auto commit"<cr>')
map("n", "<leader>gp", ":Git push<cr>")

--[[
local function myfunc()
  vim.opt.showtabline = 2
  vim.opt.tabline = "%!v:lua.require('bufline').run()"
end
myfunc()
--]]
