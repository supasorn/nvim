vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim',
    opt = true,
  }
  
  use {'lewis6991/impatient.nvim'
  }

  use { 'junegunn/fzf', 
    run = './install --bin'
  }

  use { 'dstein64/vim-startuptime',
    opt = true,
    cmd = "StartupTime"
  }

  use { 'majutsushi/tagbar',
    requires = {'ludovicchabant/vim-gutentags'},
    opt = true,
    cmd = "TagbarToggle",
    setup = function()
      vim.cmd [[
      nmap <F8> :TagbarToggle<CR>
      ]]
    end
  }

  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() 
      require('fzf-lua').setup{
        winopts = {
          height = 0.25,
          width = 1,
          row = 1,
          border = 'rounded',
        },
        buffers = {
          previewer = false,
          fzf_opts = {
            -- hide tabnr
            -- ['--delimiter'] = ":",
            -- ["--with-nth"]  = '1',
          }
        },
        oldfiles = {
          previewer = false,
        },
        fzf_colors = {
          ["fg"] = { "fg", "Normal" },
          ["bg"] = { "bg", "Normal" },
        },
      }

      vim.cmd [[
        nmap ? :lua require('fzf-lua').blines({prompt="> "})<cr>
        nmap <s-r> :lua require('fzf-lua').command_history({prompt="> "})<cr>
        nmap <f3> :lua require('fzf-lua').buffers({prompt="> "})<cr>
        nmap <f4> :lua require('fzf-lua').oldfiles({prompt="> "})<cr>
      ]]

    end,
  }

  use { 'chentoast/marks.nvim',
    config = function()
      require'marks'.setup {
        -- whether to map keybinds or not. default true
        default_mappings = true,
        -- which builtin marks to show. default {}
        builtin_marks = { ".", "<", ">", "^" },
        -- whether movements cycle back to the beginning/end of buffer. default true
        cyclic = true,
        -- whether the shada file is updated after modifying uppercase marks. default false
        force_write_shada = true,
        -- how often (in ms) to redraw signs/recompute mark positions. 
        -- higher values will have better performance but may cause visual lag, 
        -- while lower values may cause performance penalties. default 150.
        refresh_interval = 250,
        -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
        -- marks, and bookmarks.
        -- can be either a table with all/none of the keys, or a single number, in which case
        -- the priority applies to all marks.
        -- default 10.
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world",
          -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
          -- defaults to false.
          annotate = false,
        },
        mappings = {}
      }
    end
  }


  -- use { 'kshenoy/vim-signature',
  -- }

  use { 'tpope/vim-eunuch',
  }

  use { 'gbprod/substitute.nvim', -- subversive + exchange: quick substitutions and exchange.
    opt = true,
    setup = function()
      require("utils").on_file_open "substitute.nvim"
    end,
    config = function() 
      require("substitute").setup({
        exchange = {
          motion = false,
          use_esc_to_cancel = true,
        },
      })

      local map = require("utils").map
      map("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
      map("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
      map("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
      map("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true }) 

      map("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
      map("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
      map("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
      map("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
    end,
  }

  use { 'wesQ3/vim-windowswap', 
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-windowswap"
    end,
  }

  use { 'ojroques/vim-oscyank', 
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-oscyank"
    end,
    config = function() 
      vim.cmd [[
        vmap \c :OSCYank<cr>
      ]]
    end
  }
  use { 'svermeulen/vim-yoink', 
    -- setup = function()
      -- require("utils").on_file_open "vim-yoink"
    -- end,
    config = function() 
      vim.cmd [[
        nmap <c-p> <plug>(YoinkPostPasteSwapBack)
        "nmap <c-n> <plug>(YoinkPostPasteSwapjorward)
        nmap p <plug>(YoinkPaste_p)
        nmap P <plug>(YoinkPaste_P)
      ]]
    end
  }


  use { 'svban/YankAssassin.vim', 
    opt = true,
    setup = function()
      require("utils").on_file_open "YankAssassin.vim"
    end,
  }

  use { 'Matt-A-Bennett/vim-surround-funk', 
    -- opt = true,
    -- setup = function()
      -- require("utils").on_file_open "vim-surround-funk"
    -- end,
    config = function() 
      vim.cmd [[
        let g:surround_funk_create_mappings = 0
        nmap daj di(vafp 
        xmap <silent> af <Plug>(SelectWholeFUNCTION)
        omap <silent> af <Plug>(SelectWholeFUNCTION)
        xmap <silent> iF <Plug>(SelectFunctionName)
        omap <silent> iF <Plug>(SelectFunctionName)
        xmap <silent> if <Plug>(SelectFunctionNAME)
        omap <silent> if <Plug>(SelectFunctionNAME)
      ]]
    end
  }

  use { 'tpope/vim-repeat',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-repeat"
    end
  }

  use { 'PeterRincker/vim-argumentative', 
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-argumentative"
    end
  }

  use { 'supasorn/vim-indent-object', 
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-indent-object"
    end
  }

  use { 'kana/vim-textobj-user', 
    -- opt = true,
    -- setup = function()
      -- require("utils").on_file_open "vim-textobj-user"
    -- end
  }

  use { 'nvim-treesitter/nvim-treesitter-textobjects', 
    opt = true,
    setup = function()
      require("utils").on_file_open "nvim-treesitter-textobjects"
    end
  }

  use { 'supasorn/targets.vim', 
    opt = true,
    setup = function()
      require("utils").on_file_open "targets.vim"
    end
  }

  use { 'supasorn/vim-pythonsense',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-pythonsense"
    end
  }

  use { "kylechui/nvim-surround",
    opt = true,
    setup = function()
      require("utils").on_file_open "nvim-surround"
    end,
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
      })
    end
  }

  use { 'numToStr/Comment.nvim',
    opt = true,
    setup = function()
      require("utils").on_file_open "Comment.nvim"
    end,
    config = function()
      require('Comment').setup()
      vim.cmd [[
      nmap <c-c> gccj
      vmap <c-c> gc
      ]]
    end
  }

  use {'supasorn/vim-easymotion',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-easymotion"
      vim.g.EasyMotion_leader_key = '<leader>'

      vim.cmd [[
      map <c-j> <leader>j
      vmap <c-j> <leader>j
      map <c-k> <leader>k
      vmap <c-k> <leader>k

      nmap <SPACE> <leader>s
      vmap <SPACE> <leader>s
      ]]
    end
  }

  use { "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
  end,
  }

  use { 'williamboman/mason-lspconfig.nvim',
    after = {"mason.nvim", 'cmp-nvim-lsp'},
    --requires = {'williamboman/mason.nvim'},
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "pyright",
          "html",
          "cssls",
          "tsserver",
          "eslint",
          "sumneko_lua"
        },
        automatic_installation = true
     })
    end,
  }
  use {'neovim/nvim-lspconfig',
    after = "mason-lspconfig.nvim",
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup_handlers({
        function (server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end
      })
    end
  }

  use {"rafamadriz/friendly-snippets"}

  use {"hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require'cmp'
      cmp.setup({
         formatting = {
          format = function(entry, vim_item)
            local kind_icons = {
              Text = "",
              Method = "",
              Function = "",
              Constructor = "",
              Field = "",
              Variable = "",
              Class = "ﴯ",
              Interface = "",
              Module = "",
              Property = "ﰠ",
              Unit = "",
              Value = "",
              Enum = "",
              Keyword = "",
              Snippet = "",
              Color = "",
              File = "",
              Reference = "",
              Folder = "",
              EnumMember = "",
              Constant = "",
              Struct = "",
              Event = "",
              Operator = "",
              TypeParameter = ""
            }
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<cr>"] = cmp.mapping.confirm({select = false}),
          -- ["<s-tab>"] = cmp.mapping.select_prev_item(),
          -- ["<tab>"] = cmp.mapping.select_next_item(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp', max_item_count = 15},
          { name = 'buffer' , max_item_count = 15},
          { name = 'luasnip' },
          { name = 'path'},
        })
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' , max_item_count = 5}
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline', max_item_count = 10 },
          -- { name = 'path'}
        })
      })


    end,
  }

  use {"L3MON4D3/LuaSnip",
    after = {"nvim-cmp", "friendly-snippets"},
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      vim.keymap.set({ "i", "s" }, "<c-n>", function() require'luasnip'.jump(1) end, { desc = "LuaSnip forward jump" })
      vim.keymap.set({ "i", "s" }, "<c-p>", function() require'luasnip'.jump(-1) end, { desc = "LuaSnip backward jump" })
    end,
  }

  use {"saadparwaiz1/cmp_luasnip", after = "LuaSnip" }
  use {"hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" }
  use {"hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" }
  use {"hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" }
  use {"hrsh7th/cmp-path", after = "cmp-buffer" }
  use {"hrsh7th/cmp-cmdline", after = "cmp-path" }

  use 'supasorn/onedark.nvim'
  
  use { 'kyazdani42/nvim-web-devicons' }
  
  use { 'tpope/vim-fugitive',
    opt = true,
    setup = function()
      local map = require("utils").map
      map("n", "<leader>gs", ":Git<cr>")
      map("n", "<leader>gc", ':Git commit -m "auto commit"<cr>')
      map("n", "<leader>gp", ":Git push<cr>")
    end,
    cmd = {"Git"},
  }

  use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    config = function()
      local map = require("utils").map
      for i = 1,9 do
        map("n", "<leader>"..i, ":BufferLineGoToBuffer ".. i .. "<cr>", {silent = true})
      end

      local hnormal = {
        bg = '#31353f',
        fg = '#8a919d'
      }
      local hselected = {
        -- fg = '#b7c0d0',
        -- fg = '#98c379',
        fg = '#73b8f1',
        bold = false,
        italic = false,
      }
      local hvisible = {
        bg = '#31353f',
        fg = '#9299a6',
      }
      require("bufferline").setup{
        options = {
          tab_size = 15,
          color_icons = false,
          show_buffer_icons = false,
          sort_by = "none", 
          -- sort_by = function(buffer_a, buffer_b)
            -- for _, buffer in ipairs(vim.fn.BufMRUList()) do
              -- if buffer == buffer_a.id then
                -- return true
              -- elseif buffer == buffer_b.id then
                -- return false
              -- end
            -- end
            -- return false
          -- end,
          numbers = function(opts)
            return string.format('%s.', opts.ordinal)
          end,
          -- numbers = 'ordinal'
          offsets = {
            {
              -- filetype = "NvimTree",
              -- text = "File Explorer",
              -- text_align = "left",
              separator = false
            }
          },
          indicator = {
            style = 'thin'
          },
          separator_style = "none",
          -- separator_style = {"", ""},
        },


        highlights = {
          numbers = hnormal,
          close_button = hnormal,
          duplicate = hnormal,
          modified = hnormal,
          buffer_selected = hselected,
          numbers_selected = hselected,
          close_button_selected = hselected,
          duplicate_selected = hselected,
          modified_selected = hselected,
          buffer_visible = hvisible,
          numbers_visible = hvisible,
          close_button_visible = hvisible,
          duplicate_visible = hvisible,
          modified_visible = hvisible,
          separator = {
            fg = '#31353f',
            bg = '#31353f'
          },
          background = {
            bg = '#31353f',
            fg = '#8a919d'
          },
          fill = {
            bg = '#31353f',
            fg = '#31353f'
          },

        }
      }
    end
  }

  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {

      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = { left = '', right = ''},
        --section_separators = { left = '', right = ''},
        section_separators = { left = '', right = '' },
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
        lualine_y = {'lsp_progress'},
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

  use { 'lukas-reineke/indent-blankline.nvim',
    opt = true,
    setup = function()
      require("utils").on_file_open "indent-blankline.nvim"
    end,
    config = function()
      vim.cmd "highlight IndentBlanklineIndent1 guifg=#707070 gui=nocombine"
      vim.cmd "highlight IndentBlanklineIndent2 guifg=#444444 gui=nocombine"
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

  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0',
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

  
  
  use { 'nvim-treesitter/nvim-treesitter-context',
    opt = true,
    setup = function()
      require("utils").on_file_open "nvim-treesitter-context"
    end,
    
    config = function()
      require'treesitter-context'.setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                'class',
                'function',
                'method',
                -- 'for', -- These won't appear in the context
                -- 'while',
                -- 'if',
                -- 'switch',
                -- 'case',
            },
            -- Example for a specific filetype.
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            --   rust = {
            --       'impl_item',
            --   },
        },
        exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex = 20, -- The Z-index of the context window
        mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = "─",
      }
    end,
  }

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    setup = function()
      require("utils").on_file_open "nvim-treesitter"
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
          --[[ This doesn't support dot repeat yet as of Sept 2022
          swap = {
            enable = true,
            swap_next = {
              [">,"] = "@parameter.inner",
            },
            swap_previous = {
              ["<,"] = "@parameter.inner",
            },
          },
          --]]
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
  use { 'lewis6991/gitsigns.nvim', 
    opt = true,
    requires = { 'nvim-lua/plenary.nvim' },
    cmd = "Gitsigns",
    config = function()
      require('gitsigns').setup({
        signcolumn = false,
      })
    end
  }

  use { 'kyazdani42/nvim-tree.lua',
    opt = true,
    setup = function()
      local map = require("utils").map
      map("", "<c-n>", ":NvimTreeToggle %:p:h<cr>")
    end,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require'nvim-tree'.setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = false,
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
            },
          },
        },
        renderer = {
          group_empty = true,
          indent_markers = {
            enable = true
          },
          icons = {
            git_placement = "after",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              git = {
                untracked = "-",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  }

end)
