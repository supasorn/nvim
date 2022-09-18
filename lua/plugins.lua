vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = true }

  use 'navarasu/onedark.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() 
      local actions = require("telescope.actions")
      require("telescope").setup(
      { 
        defaults = {
          mappings = { i = { ["<esc>"] = actions.close, }, }, }, }
      )
    end
  }

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  use {'kyazdani42/nvim-tree.lua',
    opt = true,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require'nvim-tree'.setup()
    end,
  }

end)
