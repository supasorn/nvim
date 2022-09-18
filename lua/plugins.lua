vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = true }

  use 'navarasu/onedark.nvim'

  use { 
    'tpope/vim-fugitive',
    opt = true,
    cmd = {"Git"},
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {

      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'filetype'},
        lualine_y = {''},
        --lualine_z = {'location'}
        lualine_z = {'progress'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
    end,
}

  use {
    'lukas-reineke/indent-blankline.nvim',
    opt = true,
    setup = function()
      require("core.utils").on_file_open "indent-blankline.nvim"
    end,
    config = function()
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#707070 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#444444 gui=nocombine]]
      require('indent_blankline').setup({
        filetype_exclude = {
          "help",
          "terminal",
          "packer",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "",
        },
        buftype_exclude = { "terminal" },
        show_current_context = true,
        show_current_context_start = true,
        space_char_blankline = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
      })
    end,
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() 
      local actions = require("telescope.actions")
      --require("base46").load_highlight"telescope"
      require("telescope").setup(
      { 
          defaults = {
          vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
           i = { ["<esc>"] = actions.close, }, 
        },
      },

      extensions_list = { "themes", "terms" },
    })
    end
  }

  -- Post-install/update hook with neovim command
  use { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate',
    setup = function()
      require("core.utils").on_file_open "nvim-treesitter"
    end,
    cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo"},
    run = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        context_commentstring = {
          enable = true
        },
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = {"haskell"}, -- List of parsers to ignore installing
        highlight = {
          enable = true,              -- false will disable the whole extension
          disable = { },  -- list of language that will be disabled
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            -- init_selection = "gnn",
            -- node_incremental = "grn",
            -- scope_incremental = "grc",
            -- node_decremental = "grm",
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<tab>",
            node_decremental = "<BS>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim 
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["am"] = "@function.outer",
              ["im"] = "@function.inner",
              -- ["ac"] = "@class.outer",
              -- ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]]"] = "@function.outer",
              ["]m"] = "@class.outer",
            },
            goto_next_end = {
              ["]["] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[]"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
        },
      }
    end,
  }

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
