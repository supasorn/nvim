vim.cmd [[packadd packer.nvim]]

local packer = require('packer')
packer.init {
  -- max_jobs = 10,
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}
return packer.startup(function(use)
  -- ### System's plugin
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim',
    opt = true,
  }
  -- Load plugins faster by caching
  use { 'lewis6991/impatient.nvim'
  }
  -- Colorscheme
  use { 'supasorn/onedark.nvim',
    config = function()
      require('onedark').setup {
        -- Main options --
        style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = "<leader>s", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },

        -- Custom Highlights --
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groupscluster pixels into segments

        -- Plugins Config --
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
      vim.cmd [[ colorscheme onedark ]]
    end
  }
  -- Icons!
  use { 'kyazdani42/nvim-web-devicons' }

  -- ### Textobjects
  -- af, if function objects
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
  -- argument textobject, and swapping
  use { 'PeterRincker/vim-argumentative',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-argumentative"
    end
  }
  -- indent object
  use { 'supasorn/vim-indent-object',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-indent-object"
    end
  }
  -- Custom textobject. = i=
  use { 'kana/vim-textobj-user',
    config = function()
      vim.cmd [[
        function! AfterEquationObject()
          normal! $F=w
          let head_pos = getpos('.')
          normal! $
          let tail_pos = getpos('.')
          echom head_pos
          return ['v', head_pos, tail_pos]
        endfunction 

        function! BeforeEquationObject()
          normal! ^
          let head_pos = getpos('.')
          normal! f=ge
          let tail_pos = getpos('.')
          return ['v', head_pos, tail_pos]
        endfunction 

        call textobj#user#plugin('function', {
        \   'equation': {
        \     'select-i-function': 'AfterEquationObject',
        \     'select-i': '=',
        \     'select-a-function': 'BeforeEquationObject',
        \     'select-a': 'i=',
        \   },
        \ })
      ]]

    end
  }
  -- Many more textobjects
  use { 'supasorn/targets.vim',
  }
  -- for im, am textobject. (Around method's)
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  -- ### Text edit / motion
  -- subversive + exchange: quick substitutions and exchange.
  use { 'gbprod/substitute.nvim',
    -- opt = true,
    -- setup = function()
    -- require("utils").on_file_open "substitute.nvim"
    -- end,
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
  -- expanding dot repeat for more functions
  use { 'tpope/vim-repeat',
    opt = true,
    setup = function()
      require("utils").on_file_open "vim-repeat"
    end
  }
  -- Changes surrounding quote, e.g.
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
  -- <c-c> to comment line
  use { 'numToStr/Comment.nvim',
    opt = true,
    keys = "<c-c>",
    config = function()
      require('Comment').setup()
      vim.cmd [[
      nmap <c-c> gccj
      vmap <c-c> gc
      ]]
    end
  }
  -- My hop with yank phrase, yank line
  use { 'supasorn/hop.nvim',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'cvbnmtyghqweruiopasldkfj' }
      local map = require("utils").map
      local rwt = require("utils").run_without_TSContext

      map({ "n", "v" }, "<c-j>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.AFTER_CURSOR }))
      map({ "n", "v" }, "<c-k>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.BEFORE_CURSOR }))

      map({ "o" }, "p", rwt(require 'hop'.hint_phrase, { ["postcmd"] = "p" }))
      map({ "o", "v" }, "L", rwt(require 'hop'.hint_2lines))
      -- map({ "n", "v" }, "<space>", rwt(require 'hop'.hint_char1))
    end
  }

  use { 'ggandor/leap.nvim',
    config = function()
      local map = require("utils").map
      map({ "n", "v" }, "<space>", ":lua require('leap').leap { target_windows = { vim.fn.win_getid() } }<cr>")
    end
  }

  -- ### Yank Paste plugins
  -- \p shows yank registers with fzf
  use { "AckslD/nvim-neoclip.lua",
    opt = true,
    require = "fzf-lua",
    keys = {{"n", "\\p"}},
    config = function()
      require('neoclip').setup()
      local map = require("utils").map
      map("n", "\\p", require('neoclip.fzf')) -- show yank registers

    end,
  }
  -- \c to copy to system's clipboard. works inside tmux inside ssh
  use { 'ojroques/vim-oscyank',
    opt = true,
    keys = "\\c",
    config = function()
      vim.cmd "vmap \\c :OSCYank<cr>"
    end
  }
  -- <c-p> to cycle through previous yank register
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
  -- make the cursor not move when yank
  use { 'svban/YankAssassin.vim',
    opt = true,
    setup = function()
      require("utils").on_file_open "YankAssassin.vim"
    end,
  }

  -- ### Text Interface
  -- for modern folds
  use { 'kevinhwang91/nvim-ufo',
    opts = true,
    setup = function()
      require("utils").on_file_open "nvim-ufo"
    end,
    requires = 'kevinhwang91/promise-async',
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
        fold_virt_text_handler = handler
      })
      local map = require("utils").map
      map('n', 'zR', require('ufo').openAllFolds)
      map('n', 'zM', require('ufo').closeAllFolds)
    end
  }
  -- Shows color blocks when see hex code
  use { 'DarwinSenior/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup({ 'lua', 'css', 'javascript', 'html' }, {
        mode = "virtualtext"
      })
    end
  }
  -- Automatically disable highlights when search
  use { 'romainl/vim-cool'
  }
  -- Animate search highlight
  use { 'edluffy/specs.nvim',
    config = function()
      require('specs').setup {
        show_jumps       = true,
        min_jump         = 30,
        popup            = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 10, -- time increments used for fade/resize effects
          blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
          width = 8,
          winhl = "Search",
          fader = require('specs').empty_fader,
          resizer = require('specs').shrink_resizer
        },
        ignore_filetypes = {},
        ignore_buftypes  = {
          nofile = true,
        },
      }
      local map = require("utils").map
      map('n', 'n', 'n:lua require("specs").show_specs()<CR>', { silent = true })
      map('n', 'N', 'N:lua require("specs").show_specs()<CR>', { silent = true })
    end
  }
  -- show mark column
  use { 'chentoast/marks.nvim',
    config = function()
      require 'marks'.setup {
        -- whether to map keybinds or not. default true
        default_mappings = true,
        -- which builtin marks to show. default {}
        -- builtin_marks = { ".", "<", ">", "^" },
        builtin_marks = {},
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
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {
          "help",
          "terminal",
          "packer",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "",
          "fzf"
        },
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = {
          sign = "⚑",
          virt_text = "<<<<<<<<",
          -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
          -- defaults to false.
          annotate = false,
        },
        mappings = {}
      }
    end
  }
  -- Indent guideline
  use { 'lukas-reineke/indent-blankline.nvim',
    opt = true,
    setup = function()
      require("utils").on_file_open "indent-blankline.nvim"
    end,
    config = function()
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
      vim.cmd [[
        function! IndentBlanklineColor()
          highlight IndentBlanklineIndent1 guifg=#707070 gui=nocombine
          highlight IndentBlanklineIndent2 guifg=#444444 gui=nocombine
        endfunction

        augroup IndentBlanklineCustomHighlight
          autocmd!
          autocmd ColorScheme * call IndentBlanklineColor()
        augroup END
        call IndentBlanklineColor()
      ]]
    end,
  }
  -- Show context at the top. Cool!
  use { 'nvim-treesitter/nvim-treesitter-context',
    opt = true,
    setup = function()
      require("utils").on_file_open "nvim-treesitter-context"
    end,
    config = function()
      require 'treesitter-context'.setup {
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
            'for', -- These won't appear in the context
            'while',
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
        mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- separator = "─",
        -- separator = "-",
      }
    end,
  }
  -- Scrollbar
  use {'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        excluded_filetypes = {'nerdtree'},
        current_only = true,
        winblend = 90,
        base = 'right',
        column = 1
      })
      vim.cmd [[
        function! ScrollViewColor()
          highlight ScrollView ctermbg=159 guibg=LightCyan
        endfunction

        augroup ScrollViewCustomHighlight
            autocmd!
            autocmd ColorScheme * call ScrollViewColor() 
        augroup END
        call ScrollViewColor() 
      ]]
    end
  }
  --[[
  use {'petertriho/nvim-scrollbar',
    config = function()
      require("scrollbar").setup()
    end,
  }--]]

  -- ### UI Interface
  -- Bufferline
  use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    config = function()
      local map = require("utils").map
      for i = 1, 9 do
        map("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<cr>", { silent = true })
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
        fg = '#7ca8cf',
        bg = '#31353f',
        -- bg = '#21242a',
        -- fg = '#9299a6',
      }
      local redv = {
        bg = 'red',
        fg = 'red'
      }
      local separator = {
        fg = '#21242a',
        bg = '#21242a',
      }
      require("bufferline").setup {
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
            -- icon = ' ',
            style = 'none'
          },
          separator_style = "thin",
          -- separator_style = { "", "" },
        },

        highlights = {
          numbers = hnormal,
          close_button = hnormal,
          duplicate = hnormal,
          modified = hnormal,
          separator = separator,
          buffer_selected = hselected,
          numbers_selected = hselected,
          close_button_selected = hselected,
          duplicate_selected = hselected,
          modified_selected = hselected,
          indicator_selected = hselected,
          separator_selected = separator,
          buffer_visible = hvisible,
          numbers_visible = hvisible,
          close_button_visible = hvisible,
          duplicate_visible = hvisible,
          modified_visible = hvisible,
          indicator_visible = hvisible,
          separator_visible = separator,
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
  -- Statusline
  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {

        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = { left = '', right = '' },
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
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },
          lualine_x = { 'filetype' },
          lualine_y = { 'lsp_progress' },
          --lualine_z = {'location'}
          lualine_z = { 'progress' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
      local map = require("utils").map

      map({ 'n', 'i', 'v' }, "<f2>",
        function() require "telescope".extensions.file_browser.file_browser({
            path = '%:p:h',
            previewer = false,
            hidden = true,
            hide_parent_dir = true, grouped = true
          })
        end)
    end,
  }
  -- Notification window
  use { 'rcarriga/nvim-notify',
    config = function()
      local notify = require("notify")
      notify.setup {
        -- top_down = false,
        -- render = "minimal"
      }
      vim.notify = notify
    end
  }

  -- ### File browser, FZF, Telescope
  -- Directory browser
  use { 'kyazdani42/nvim-tree.lua',
    opt = true,
    setup = function()
      local map = require("utils").map
      map("", "<c-n>", ":NvimTreeToggle %:p:h<cr>")
    end,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require 'nvim-tree'.setup({
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
        actions = {
          open_file = {
            resize_window = false,
          }
        }
      })

      vim.cmd [[
        function! NvimTreeColor()
          highlight NvimTreeIndentMarker guifg=#58606d gui=nocombine
          highlight NvimTreeImageFile guifg=#58606d gui=nocombine
          highlight NvimTreeExecFile guifg=#58606d gui=nocombine
        endfunction

        augroup NvimTreeCustomHighlight
            autocmd!
            autocmd ColorScheme * call NvimTreeColor() 
        augroup END
        call NvimTreeColor() 
      ]]
    end,
  }
  -- fzf!
  use { 'junegunn/fzf',
    run = './install --bin'
  }
  -- F4 fzf MRU
  use { 'pbogut/fzf-mru.vim',
    opt = true,
    cmd = "FZFMru",
    keys = "<f4>",
    config = function()
      vim.cmd [[nmap <F4> :FZFMru --no-sort<CR>]]
    end
  }
  -- fzf with native preview, etc
  use { 'ibhagwan/fzf-lua',
    opt = true,
    cmd = {"FzfLua"},
    keys = { { "n", "<f6>" }, { "n", "?" }, { "n", "<s-r>" }, { "n", "<f3>" }},
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup {
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
        " nmap <f4> :lua require('fzf-lua').oldfiles({prompt="> "})<cr>
      ]]

    end,
  }
  -- Fzf for telescope
  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  -- Telescope's file browser
  use { "supasorn/telescope-file-browser.nvim",
  }
  -- Telescope
  use { 'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },

    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
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
          -- prompt_prefix = "   ",
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
          file_ignore_patterns = { "node_modules" },
          -- file_sorter = require("telescope.sorters").get_fuzzy_file,
          -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,

          mappings = {
            i = { ["<esc>"] = actions.close, },
          },
          extensions = {
            file_browser = {
              theme = "ivy",
              hijack_netrw = false,
            },
            fzf = {
              fuzzy = true, -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true, -- override the file sorter
              case_mode = "smart_case", -- or "ignore_case" or "respect_case"
              -- the default case_mode is "smart_case"
            }
          },
        },
      })
      require("telescope").load_extension "fzf"
      require("telescope").load_extension "file_browser"

      vim.cmd [[

    function! TelescopeColor()
      highlight TelescopeNormal guibg=#202329
      highlight TelescopeResultsBorder guifg=#202329 guibg=#202329 
      highlight TelescopeResultsTitle guifg=#61afef guibg=#202329
      
      highlight TelescopePreviewBorder guifg=#202329 guibg=#202329 
      highlight TelescopePreviewTitle guifg=#181a1f guibg=#e86671
      
      highlight TelescopePromptNormal guibg=#1c1f24
      highlight TelescopePromptBorder guifg=#1c1f24 guibg=#1c1f24 
      highlight TelescopePromptTitle guifg=#1c1f24 guibg=#1c1f24 
    endfunction

    augroup TelescopeCustomHighlight
        autocmd!
        autocmd ColorScheme * call TelescopeColor()
    augroup END
    call TelescopeColor()

    ]]

      -- fg_bg("TelescopeBorder", darker_black, darker_black)
      -- fg_bg("TelescopePromptBorder", black2, black2)

      -- fg_bg("TelescopePromptNormal", white, black2)
      -- fg_bg("TelescopePromptPrefix", red, black2)

      -- bg("TelescopeNormal", darker_black)

      -- fg_bg("TelescopePreviewTitle", black, green)
      -- fg_bg("TelescopePromptTitle", black, red)
      -- fg_bg("TelescopeResultsTitle", darker_black, darker_black)

      -- bg("TelescopeSelection", black2)

    end
  }

  -- ### LSP, Treesitter, Tags
  -- For adding format() to lsp, etc
  use { "jose-elias-alvarez/null-ls.nvim",
    opt = true,
    keys = { { "n", "<leader>f" }, { "v", "<leader>f" } },
    config = function()
      local map = require("utils").map
      map({ "n", "v" }, "<leader>f", vim.lsp.buf.format)

      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.black,
        },
      })
    end
  }
  -- Goto preview with nested!
  use { 'rmagatti/goto-preview',
    opt = true,
    keys = { "gp", "gP", "gr" },
    config = function()
      local map = require("utils").map
      map("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
      map("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")
      map("n", "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")

      require('goto-preview').setup {}
    end
  }
  -- Lsp Installer
  use { "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  }
  -- Mason-Lsp interface
  use { 'williamboman/mason-lspconfig.nvim',
    after = { "mason.nvim", 'cmp-nvim-lsp' },
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
  -- Lspconfig
  use { 'neovim/nvim-lspconfig',
    after = "mason-lspconfig.nvim",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end
      })
    end
  }
  -- Tagbar! Show code tags
  use { 'majutsushi/tagbar',
    opt = true,
    requires = { 'ludovicchabant/vim-gutentags' },
    cmd = "TagbarToggle",
    setup = function()
      vim.cmd [[
      nmap <F8> :TagbarToggle<CR>
      ]]
    end
  }
  -- Neovim's Treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    -- Post-install/update hook with neovim command
    -- setup = function()
    -- require("utils").on_file_open "nvim-treesitter"
    -- end,
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        context_commentstring = {
          enable = true
        },
        ensure_installed = { "c", "python", "css", "cpp", "go", "html", "java", "javascript", "json", "lua", "make",
          "php", "vim", "typescript" },
        ignore_install = { "haskell" }, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = function(lang, bufnr)
            if vim.api.nvim_buf_line_count(0) > 5000 then
              return true
            end
            return false
          end,
          -- disable = {}, -- list of language that will be disabled
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

  -- ### All things cmp-related (autocomplete)
  -- use { "hrsh7th/cmp-nvim-lua" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-cmdline" }
  use { "supasorn/friendly-snippets" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { "L3MON4D3/LuaSnip",
    -- after = {"nvim-cmp", "friendly-snippets"},
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      vim.keymap.set({ "i", "s" }, "<c-n>", function() require 'luasnip'.jump(1) end, { desc = "LuaSnip forward jump" })
      vim.keymap.set({ "i", "s" }, "<c-p>", function() require 'luasnip'.jump(-1) end, { desc = "LuaSnip backward jump" })
    end,
  }
  use { "hrsh7th/nvim-cmp",
    -- after = "friendly-snippets",
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require 'cmp'
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
            -- vim_item.menu = ({
            -- buffer = "[Buffer]",
            -- nvim_lsp = "[LSP]",
            -- luasnip = "[LuaSnip]",
            -- nvim_lua = "[Lua]",
            -- latex_symbols = "[LaTeX]",
            -- })[entry.source.name]
            vim_item.menu = ""
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
          ["<cr>"] = cmp.mapping.confirm({ select = false }),
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
          { name = 'nvim_lsp', max_item_count = 15 },
          { name = 'buffer', max_item_count = 15 },
          { name = 'luasnip' },
          { name = 'path' },
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
          { name = 'buffer', max_item_count = 5 }
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

  -- ### Utilities
  -- Profiles startup time
  use { 'dstein64/vim-startuptime',
    opt = true,
    cmd = "StartupTime"
  }
  -- :Rename :Delete :SudoWrite
  use { 'tpope/vim-eunuch',
  }
  -- \ww swap two windows
  use { 'wesQ3/vim-windowswap',
    opt = true,
    keys = "<leader>ww"
  }
  -- For git
  use { 'tpope/vim-fugitive',
    opt = true,
    setup = function()
      local map = require("utils").map
      map("n", "<leader>gs", ":Git<cr>")
      map("n", "<leader>gc", ':Git commit -m "auto commit"<cr>')
      map("n", "<leader>gp", ":Git push<cr>")
    end,
    cmd = { "Git" },
  }
  -- Show git diff, etc.
  use { 'lewis6991/gitsigns.nvim',
    opt = true,
    requires = { 'nvim-lua/plenary.nvim' },
    setup = function()
      local map = require("utils").map
      map("n", "<leader>gg", ":Gitsigns toggle_signs<cr>")
    end,
    cmd = "Gitsigns",
    config = function()
      require('gitsigns').setup({
        signcolumn = false,
      })
    end
  }

  -- svart!
  -- use { 'http://gitlab.com/madyanov/svart.nvim', }
end)
