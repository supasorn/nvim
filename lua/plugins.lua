return {
  -- ### System's plugin
  { 'navarasu/onedark.nvim', -- Colorscheme
    -- enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      local style = 'cool'
      local util = require("onedark.util")
      local colors = require("onedark.palette")[style]
      require('onedark').setup {
        -- Main options --
        style = style, -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
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
        highlights = {
          ["HopNextKey1"] = {fg = '$yellow'},
          ["HopNextKey2"] = {fg = util.darken(colors.yellow, 0.8)},
        }, -- Override highlight groupscluster pixels into segments

        -- Plugins Config --
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
      vim.cmd [[ colorscheme onedark ]]
    end
  },
  { 'folke/tokyonight.nvim',
    lazy = true,
  },
  { 'kyazdani42/nvim-web-devicons', -- Icons!
    lazy = true
  },
  -- ### Textobjects
  { 'Matt-A-Bennett/vim-surround-funk', -- af, if function objects
    lazy = false,
    init = function()
      vim.g.surround_funk_create_mappings = 0
    end,
    keys = {
      { "af", "<Plug>(SelectWholeFUNCTION)", mode = { "o", "x" } },
      { "iF", "<Plug>(SelectFunctionName)", mode = { "o", "x" } },
      { "if", "<Plug>(SelectFunctionNAME)", mode = { "o", "x" } },
      { "daj", "di(vafp", mode = "n", remap = true },
    },
  },
  { 'PeterRincker/vim-argumentative', -- argument textobject, and swapping
    event = "VeryLazy"
  },
  { 'michaeljsmith/vim-indent-object', -- indent object
    event = "VeryLazy"
  },
  { 'kana/vim-textobj-user', -- Custom textobject. = i=
    event = "VeryLazy",
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
  },
  { 'supasorn/targets.vim', -- Many more textobjects
    event = "VeryLazy"
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', -- for im, am textobject. (Around method's)
    event = "VeryLazy"
  },
  -- ### Text edit / motion
  { 'gbprod/substitute.nvim', -- subversive + exchange: quick substitutions and exchange.
    keys = {
      { "s", "<cmd>lua require('substitute').operator()<cr>" },
      { "ss", "<cmd>lua require('substitute').line()<cr>" },
      { "S", "<cmd>lua require('substitute').eol()<cr>" },
      { "s", "<cmd>lua require('substitute').visual()<cr>", mode = "x" },
      { "sx", "<cmd>lua require('substitute.exchange').operator()<cr>" },
      { "sxx", "<cmd>lua require('substitute.exchange').line()<cr>" },
      { "X", "<cmd>lua require('substitute.exchange').visual()<cr>", mode = "x" },
    },
    opts = {
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
      },
    },
  },
  { 'tpope/vim-repeat', -- expanding dot repeat for more functions
    event = "VeryLazy",
  },
  { "kylechui/nvim-surround", -- Changes surrounding quote, e.g.
    event = "VeryLazy",
    config = true,
  },
  { 'numToStr/Comment.nvim', -- <c-c> to comment line
    dependencies = "nvim-treesitter",
    keys = {
      { "<c-c>", "gccj", remap = true },
      { "<c-c>", "gc", mode = "v", remap = true }
    },
    config = true,
  },
  { 'supasorn/hop.nvim', -- My hop with yank phrase, yank line
    keys = {
      { "<c-j>", mode = { "n", "v" } },
      { "<c-k>", mode = { "n", "v" } },
      { ";", mode = { "n", "v" } },
      { "p", mode = { "o" } },
      { "L", mode = { "o", "v" } },
    },
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'cvbnmtyghqweruiopasldkfj' }
      local map = require("utils").map
      local rwt = require("utils").run_without_TSContext

      map({ "n", "v" }, "<c-j>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.AFTER_CURSOR }))
      map({ "n", "v" }, "<c-k>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.BEFORE_CURSOR }))

      -- map({ "o" }, "p", rwt(require 'hop'.hint_phrase, { ["postcmd"] = "p" }))
      map({ "o" }, "p", rwt(require 'hop'.hint_phrase))
      map({ "o", "v" }, "L", rwt(require 'hop'.hint_2lines))
      map({ "n", "v" }, ";", rwt(require 'hop'.hint_char1))
    end
  },
  { 'ggandor/leap.nvim', -- Experimenting..
    enabled = false,
    keys = {
      { "<space>", ":lua require('leap').leap { target_windows = { vim.fn.win_getid() } }<cr>", mode = { "n", "v" } }
    },
  },
  { 'kevinhwang91/nvim-fFHighlight', -- highlight fF
    enabled = false,
    opts = {
      disable_keymap = false,
      disable_words_hl = false,
      number_hint_threshold = 3,
      prompt_sign_define = { text = '✹' }
    },
    keys = {{'f', mode = {"n", "v"}}, {'f', mode = {"n", "v"}}}
  },
  { 'rhysd/clever-f.vim', -- fFtT with highlight
    keys = { "f", "F", "t", "T" },
    -- enabled = false,
    config = function()
      vim.cmd [[
      let g:clever_f_not_overwrites_standard_mappings = 1
      nmap <expr> f reg_recording() .. reg_executing() == "" ? "<Plug>(clever-f-f)" : "f"
      nmap <expr> F reg_recording() .. reg_executing() == "" ? "<Plug>(clever-f-F)" : "F"
      nmap <expr> t reg_recording() .. reg_executing() == "" ? "<Plug>(clever-f-t)" : "t"
      nmap <expr> T reg_recording() .. reg_executing() == "" ? "<Plug>(clever-f-T)" : "T"
      " map <c-;> ;
      ]]
    end,
  },
  { 'monaqa/dial.nvim', -- enhanced increment/decrement
    keys = {
      { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" } },
      { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" } },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = "v" },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = "v" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new {
            elements = { "and", "or" },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "True", "False" },
            word = true,
            cyclic = true,
          },
        },
      }
    end,
  },
  { 'Wansmer/treesj', -- splitting/joining blocks of code like arrays
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "\\l", ":TSJToggle<cr>" },
    },
    config = true,
  },
  -- ### Yank Paste plugins
  { "AckslD/nvim-neoclip.lua", -- \p shows yank registers with fzf
    event = "VeryLazy",
    dependencies = "fzf-lua",
    keys = { { "\\p", ":lua require('neoclip.fzf')()<cr>" } },
    config = true,
  },
  { 'ojroques/vim-oscyank', -- \c to copy to system's clipboard. works inside tmux inside ssh
    keys = { { "\\c", ":OSCYankVisual<cr>", mode = "v" } }
  },
  { 'svermeulen/vim-yoink', -- <c-p> to cycle through previous yank register
    event = "VeryLazy",
    keys = {
      { "<c-p>", "<plug>(YoinkPostPasteSwapBack)" },
      { "p", "<plug>(YoinkPaste_p)" },
      { "P", "<plug>(YoinkPaste_P)" },
    },
  },
  { 'svban/YankAssassin.vim', -- make the cursor not move when yank
    event = "VeryLazy",
  },
  -- ### Text Interface
  { 'kevinhwang91/nvim-ufo', -- for modern folds
    event = "BufReadPost",
    dependencies = 'kevinhwang91/promise-async',
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
  },
  { 'DarwinSenior/nvim-colorizer.lua', -- Shows color blocks when see hex code
    event = "VeryLazy",
    config = function()
      require 'colorizer'.setup({ 'lua', 'css', 'javascript', 'html' }, {
        mode = "virtualtext"
      })
    end
  },
  { 'uga-rosa/ccc.nvim', -- Color picker
    keys = { { "<c-c>", mode = "i" }, { '\\\\c', ':CccPick<cr>' } },
    cmd = { "CccPick", "CccHighlighterToggle", "CccHighlighterEnable", "CccHighlighterDisable" },
    config = function()
      require('ccc').setup {
        inputs = {
          require('ccc_multiple_color')
        }
      }
      local map = require("utils").map
      map('i', '<c-c>', '<Plug>(ccc-insert)')
    end
  },
  { 'romainl/vim-cool', -- Automatically disable highlights when search
    event = "VeryLazy",
  },
  { 'airblade/vim-current-search-match', -- Highlight current search text differently
    event = "VeryLazy",
    config = function()
      vim.g.current_search_match = 'HighlightCurrentSearch'
    end
  },
  { 'chentoast/marks.nvim', -- show mark column
    event = "VeryLazy",
    opts = {
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
    },
  },
  { 'lukas-reineke/indent-blankline.nvim', -- Indent guideline
    -- event = "BufEnter",
    event = "VeryLazy",
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
          "lazy",
          "NvimTree",
          "Trouble",
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
  },
  { 'nvim-treesitter/nvim-treesitter-context', -- Show context at the top. Cool!
    event = "VeryLazy",
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
            'if',
            -- 'switch',
            -- 'case',
          },
          lua = {
            'table',
          },
          -- Example for a specific filetype.
          -- If a pattern is missing, *open a PR* so everyone can benefit.
          --   rust = {
          --       'impl_item',
          --   },
        },
        exact_patterns = {
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex = 20, -- The Z-index of the context window
        mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- separator = "─",
        -- separator = "-",
      }
    end,
  },
  { 'dstein64/nvim-scrollview', -- Scrollbar
    event = "VeryLazy",
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'nerdtree' },
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
  },
  -- ### UI Interface
  { "SmiteshP/nvim-navic", -- show current code context
    enabled = false,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    lazy = "VeryLazy",
    opts = {
      icons = {
        File          = " ",
        Module        = " ",
        Namespace     = " ",
        Package       = " ",
        Class         = " ",
        Method        = " ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "練",
        Interface     = "練",
        Function      = " ",
        Variable      = " ",
        Constant      = " ",
        String        = " ",
        Number        = " ",
        Boolean       = "◩ ",
        Array         = " ",
        Object        = " ",
        Key           = " ",
        Null          = "ﳠ ",
        EnumMember    = " ",
        Struct        = " ",
        Event         = " ",
        Operator      = " ",
        TypeParameter = " ",
      },
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true
    },
  },
  { 'akinsho/bufferline.nvim', -- Bufferline
    enabled = false,
    config = function()
      local map = require("utils").map
      for i = 1, 9 do
        map("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<cr>", { silent = true })
      end
      local function get_color(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      -- local deffg = '#8a919d'
      -- dark -> bright
      local g0bg = get_color("LineNr", "bg#")
      local g1bg = get_color("StatusLineNc", "bg#")
      local g2bg = get_color("StatusLine", "bg#")
      local deffg = get_color("StatusLine", "fg#")

      local fontcolor = get_color("Function", "fg#")
      local hnormal = {
        -- bg = '#31353f',
        bg = g1bg,
        fg = deffg,
      }
      local hselected = {
        fg = fontcolor,
        bold = false,
        italic = false,
      }
      local hvisible = {
        -- fg = '#7ca8cf',
        fg = get_color("Constant", "fg#"),
        bg = g1bg,
      }
      local separator = {
        fg = g0bg,
        bg = g0bg,
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
            bg = g1bg,
            fg = deffg
          },
          fill = {
            bg = g1bg,
            fg = g1bg
          },

        }
      }
    end
  },
  { 'nvim-lualine/lualine.nvim', -- Statusline
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#98be65',
        orange   = '#FF8800',
        violet   = '#a9a1e1',
        magenta  = '#c678dd',
        blue     = '#51afef',
        red      = '#ec5f67',
      }
      require('lualine').setup {

        options = {
          icons_enabled = true,
          theme = 'onedark',
          -- component_separators = { left = '', right = '' },
          component_separators = { left = '|', right = '|' },
          -- component_separators = { left = '', right = '' },
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
          lualine_a = {
            { function()
              if vim.bo.modified then
                return ' ●'
              end
              return ' '
            end,
            padding = {left = 0, right = 0 }, -- We don't need space before this
            -- separator = { right = ''}
            },
          },
          lualine_b = {
            { 'filename',
              file_status = false,
              symbols = {
                modified = '',    -- Text to show when the file is modified.
                readonly = '[-]',    -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]',   -- Text to show for newly created file before first write
              }
            }
          },
          lualine_c = { 'branch', 'diff' },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ' },
              diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.cyan },
              }
            },
            {
              'lsp_progress',
              display_components = { { 'title', 'percentage', 'message' } },
              spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏', },
            },
            -- { require("lsp-progress").progress, },
            -- { require('lsp_spinner').status },
          },
          lualine_y = {
            {
              function()
                local msg = 'no lsp'
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = ' ',
              -- color = { fg = '#ffffff', gui = 'bold' },
            },
            { 'filetype' } },
          lualine_z = { function()
            local hn = vim.loop.os_gethostname()
            if hn == 'Supasorns-MacBook-Pro.local' then
              return 'MBP'
            elseif hn == 'Supasorns-M2X.local' then
              return 'MBP'
            end
            return hn:gsub("vision", "v")
          end }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { 'filename',
              color = { fg = 'lualine_c_normal' },
            }
          },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },
  { 'rcarriga/nvim-notify', -- Notification window
    event = 'VeryLazy',
    config = function()
      local notify = require("notify")
      notify.setup {
        -- top_down = false,
        -- render = "minimal"
        stages = "static"
      }
      vim.notify = notify
    end
  },
  { 'WhoIsSethDaniel/lualine-lsp-progress.nvim',
    lazy = true,
  },
  -- ### File browser, FZF, Telescope
  { 'kyazdani42/nvim-tree.lua', -- Directory browser
    keys = {
      { "<c-n>", ":NvimTreeToggle %:p:h<cr>" }
    },
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
  },
  { 'junegunn/fzf', -- fzf!
    event = "VeryLazy",
    -- lazy = true,
    build = './install --bin'
  },
  { 'pbogut/fzf-mru.vim', -- F4 fzf MRU
    lazy = false, -- otherwise, it won't remember any files
    dependencies = "fzf",
    cmd = "FZFMru",
    -- keys = { { "<f4>", ":FZFMru --no-sort<CR>" } },
    keys = { { "<space>p", ":FZFMru --no-sort<CR>", mode = "n" } },
  },
  { 'ibhagwan/fzf-lua', -- fzf with native preview, etc
    cmd = { "FzfLua" },
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    keys = {
      { "?", ':lua require("fzf-lua").blines({prompt=" > "})<cr>' },
      { "<s-r>", ':lua require("fzf-lua").command_history({prompt=" > "})<cr>' },
      { "<space>o", ':lua require("fzf-lua").buffers({prompt=" > "})<cr>', mode = "n" },
    },
    opts = {
      winopts = {
        height = 0.25,
        width = 1,
        row = 1,
        border = 'rounded',
        -- hl = { border = 'FloatBorder', }
        preview = {
          -- layout = 'horizontal',
        },
      },
      fzf_opts = {
        ['--layout'] = false,
      },
      buffers = {
        previewer = false,
        fzf_opts = {
          ['--layout'] = 'reverse-list',
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
      grep = {
        rg_opts = "-g '!tags' --column --line-number --no-heading --color=always --smart-case",
      },
    },
    -- " nmap <f4> :lua require('fzf-lua').oldfiles({prompt="> "})<cr>
  },
  { 'nvim-telescope/telescope.nvim', -- Telescope
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      { 'supasorn/telescope-file-browser.nvim' },
      { 'marcuscaisey/olddirs.nvim' },
      { 'junegunn/fzf' },
    },
    cmd = { "Telescope" },
    -- keys = { "<f2>", "gr", "<leader>od" },
    keys = { "<space>i", "gr", "<leader>od" },

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
          -- file_ignore_patterns = { "node_modules" },
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
            },
            olddirs = {
              selected_dir_callback = vim.cmd.lcd,
            }
          },
        },
      })
      require("telescope").load_extension "fzf"
      require("telescope").load_extension "file_browser"
      require("telescope").load_extension "olddirs"

      local map = require("utils").map
      map({ 'n' }, "<space>i",
        function() require "telescope".extensions.file_browser.file_browser({
            path = '%:p:h',
            -- previewer = true,
            hidden = true,
            hide_parent_dir = true, grouped = true
          })
        end)
      map({ 'n' }, "<leader>od", require "telescope".extensions.olddirs.picker)

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
    end
  },
  -- ### LSP, Treesitter, Tags
  { "jose-elias-alvarez/null-ls.nvim", -- For adding format() to lsp, etc
    keys = {
      { "<leader>f", vim.lsp.buf.format, mode = { "n", "v" } }
    },
    config = function()
      -- local map = require("utils").map
      -- map(, "<leader>f", vim.lsp.buf.format)
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.black,
        },
      })
    end
  },
  { 'rmagatti/goto-preview', -- Goto preview with nested!
    keys = {
      { "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>" },
      { "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>" }
    },
    config = true,
  },
  { "williamboman/mason.nvim", -- Lsp Installer
    cmd = { "Mason", "MasonLog", "MasonInstall", "MasonUninstall" },
    config = true,
  },
  { 'williamboman/mason-lspconfig.nvim', -- Mason-Lsp interface
    event = "VeryLazy",
    dependencies = "mason.nvim",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "pyright",
          "html",
          "cssls",
          "tsserver",
          "eslint",
          "lua_ls"
        },
        automatic_installation = true
      })
    end,
  },
  { 'neovim/nvim-lspconfig', -- Lspconfig
    event = "VeryLazy",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup_handlers({
        function(server_name)
          local opts = { capabilities = capabilities }
          if server_name == 'lua_ls' then
            opts.settings = {
              Lua = {
                diagnostics = { globals = { 'vim' }
                }
              }
            }
          end
          -- opts.on_attach = function(client, bufnr)
            -- local navic = require("nvim-navic")
            -- navic.attach(client, bufnr)
          -- end
          require("lspconfig")[server_name].setup(opts)
        end
      })
    end
  },
  { 'majutsushi/tagbar', -- Tagbar! Show code tags
    dependencies = { 'ludovicchabant/vim-gutentags' },
    cmd = "TagbarToggle",
    keys = { { "<f8>", ":TagbarToggle<CR>" } },
  },
  { 'nvim-treesitter/nvim-treesitter', -- Neovim's Treesitter
    event = "VeryLazy",
    build = function() require("nvim-treesitter.install").update { with_sync = true } end,
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        context_commentstring = {
          enable = true
        },
        ensure_installed = { "c", "python", "css", "cpp", "go", "html", "java", "javascript", "json", "lua", "make",
          "php", "vim", "typescript", "vimdoc" },
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
          matchup = {
            enable = true,
          }
        },
      }
    end,
  },
  { 'nvim-treesitter/playground', -- Treesitter playground
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
  },
  { 'folke/trouble.nvim', -- A pretty list for showing diagnostics, refs, quickfix and location lists.
    cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TrobleRefresh" },
    keys = {
      { "<f9>", "<cmd>TroubleToggle document_diagnostics<cr>" }
    },
    config = true,
  },
  -- ### All things cmp-related (autocomplete)
  { "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    lazy = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local luasnip = require("luasnip")
      luasnip.filetype_extend("html", { "javascript" })
      -- vim.keymap.set({ "i", "s" }, "<c-l>", function() require 'luasnip'.jump(1) end, { desc = "LuaSnip forward jump" })
      -- vim.keymap.set({ "i", "s" }, "<c-h>", function() require 'luasnip'.jump(-1) end, { desc = "LuaSnip backward jump" })
    end,
  },
  { "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local has_words_before = function()
        table.unpack = table.unpack or unpack
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require 'cmp'
      cmp.setup({
        formatting = {
          fields = { "kind", "abbr", "menu" }, -- "abbr" is the actual text
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. ""
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
          end,
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,

            -- col_offset = -2,
            -- border = "none",
            -- winhighlight = "Normal:Pmenu",
            -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            -- border = { "", "", "", "│", "╯", "─", "╰", "│" },
          }),
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
        },
        formatting = {
          fields = { "abbr" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline', max_item_count = 10 },
          -- { name = 'path'}
        }),
        formatting = {
          fields = { 'abbr' },
        },
      })


    end,
  },
  -- ### Utilities
  { 'dstein64/vim-startuptime', -- Profiles startup time
    cmd = "StartupTime"
  },
  { 'tpope/vim-eunuch', -- :Rename :Delete :SudoWrite
    cmd = { "Remove", "Delete", "Move", "SudoWrite", "SudoEdit", "Chmod", "Mkdir" }
  },
  { 'wesQ3/vim-windowswap', -- \ww swap two windows
    keys = "<leader>ww"
  },
  { 'tpope/vim-fugitive', -- For git
    keys = {
      { "<leader>gs", ":Git<cr>" },
      { "<leader>gc", ':Git commit -m "auto commit"<cr>' },
      { "<leader>gp", ":Git push<cr>" },
    },
    cmd = { "Git" },
  },
  { 'lewis6991/gitsigns.nvim', -- Show git diff, etc.
    event = "VeryLazy",
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { "<leader>gg", ":Gitsigns toggle_signs<cr>" } },
    cmd = "Gitsigns",
    opts = {
      signcolumn = true,
    },
  },
  { 'sindrets/diffview.nvim',
    cmd = {'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'},

  },
  { 'github/copilot.vim',
    keys = { { "<f10>", "<esc>:Copilot<cr>", mode = { "i" } }, { "<f10>", ":Copilot<cr>", mode = { "n", "v" } } },
    -- enabled = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      -- vim.g.copilot_tab_fallback = ""
      vim.cmd [[
        imap <silent><script><expr> <c-n> copilot#Accept("\<CR>")
      ]]
    end,
  },
}
