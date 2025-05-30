local utils = require("utils")
local map = utils.map
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
          ["IndentBlanklineContextChar"] = { fg = '$purple' },
          ["IndentBlanklineContextStart"] = { fmt = 'underline' },
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
  { 'catppuccin/nvim',
    lazy = true,
  },
  { 'folke/tokyonight.nvim',
    lazy = true,
  },
  { 'nvim-tree/nvim-web-devicons', -- Icons!
    lazy = true
  },
  -- ### Textobjects
  { 'Matt-A-Bennett/vim-surround-funk', -- af, if function objects
    lazy = false,
    init = function()
      vim.g.surround_funk_create_mappings = 0
    end,
    keys = {
      { "af",  "<Plug>(SelectWholeFUNCTION)", mode = { "o", "x" } },
      { "iF",  "<Plug>(SelectFunctionName)",  mode = { "o", "x" } },
      { "if",  "<Plug>(SelectFunctionNAME)",  mode = { "o", "x" } },
      { "daj", "di(vafp",                     mode = "n",         remap = true },
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
      on_substitute = function()
        vim.cmd("call yoink#startUndoRepeatSwap()")
      end,
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
      -- { ";", mode = { "n", "v" } },
      { "<space>", mode = { "n", "v" }, desc="hop" },
      -- { "<cr>", mode = { "n", "v" }, desc="hop" },
      { "p", mode = { "o" } },
      { "L", mode = { "o", "v" } },
    },
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'cvbnmtyghqweruiopasldkfj' }
      local rwt = require("utils").run_without_TSContext

      map({ "n", "v" }, "<c-j>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.AFTER_CURSOR }))
      map({ "n", "v" }, "<c-k>",
        rwt(require 'hop'.hint_lines_skip_whitespace, { direction = require 'hop.hint'.HintDirection.BEFORE_CURSOR }))

      -- map({ "o" }, "p", rwt(require 'hop'.hint_phrase, { ["postcmd"] = "p" }))
      map({ "o" }, "p", rwt(require 'hop'.hint_phrase))
      map({ "o", "v" }, "L", rwt(require 'hop'.hint_2lines))

      -- map({ "n", "v" }, ";", rwt(require 'hop'.hint_char1))
      map({ "n", "v" }, "<space>", rwt(require 'hop'.hint_char1))
      -- map({ "n", "v" }, "<cr>", rwt(require 'hop'.hint_char1))
    end
  },
  { 'kevinhwang91/nvim-fFHighlight', -- highlight fF
    -- enabled = false,
    opts = {
      disable_keymap = false,
      disable_words_hl = false,
      number_hint_threshold = 3,
      prompt_sign_define = { text = '✹' }
    },
    keys = {{'f', mode = {"n", "v"}}, {'f', mode = {"n", "v"}}}
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
      { "\\l", ":TSJToggle<cr>", desc="list to single/multiple lines"},
    },
    config = true,
  },
  -- ### Yank Paste plugins
  { "AckslD/nvim-neoclip.lua", -- \p shows yank registers with fzf
    event = "VeryLazy",
    dependencies = "fzf-lua",
    keys = { { "\\p", ":lua require('neoclip.fzf')()<cr>", desc="show yank list"} },
    config = true,
  },
  { 'ojroques/vim-oscyank', -- \c to copy to system's clipboard. works inside tmux inside ssh
    keys = { { "\\c", ":OSCYankVisual<cr>", mode = "v", desc="yank to system's clipboard" } }
  },
  { 'svermeulen/vim-yoink', -- <c-p> to cycle through previous yank register
    event = "VeryLazy",
    keys = {
      { "<c-p>", "<plug>(YoinkPostPasteSwapBack)" },
      { "<c-n>", "<plug>(YoinkPostPasteSwapForward)" },
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
    enabled = true,
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
        annotate = true,
      },
      mappings = {}
    },
  },
  { "LintaoAmons/bookmarks.nvim",
    event = "VeryLazy",
    keys = {
      {"mm", "<cmd>BookmarksMark<cr>", mode = {"n", "v"}},
      {"'o", "<cmd>BookmarksGoto<cr>", mode = {"n", "v"}},
      {"'t", "<cmd>BookmarksTree<cr>", mode = {"n", "v"}}
    },
    dependencies = {
      {"supasorn/sqlite.lua"},
      {"nvim-telescope/telescope.nvim"},
      {"stevearc/dressing.nvim"} -- optional: better UI
    },
    config = function()
      require('bookmarks').setup {
        keymap = {
          delete = {"dd"}
        }
      }
      vim.cmd [[
        function! BookmarkColor()
          hi BookmarksNvimLine guibg=NONE
        endfunction

        augroup BookmarkCustomHighlight
          autocmd!
          autocmd ColorScheme * call BookmarkColor()
        augroup END
        call BookmarkColor()
      ]]
    end,
  },
  { 'lukas-reineke/indent-blankline.nvim', -- Indent guideline
    -- event = "BufEnter",
    version = "2.20.8",
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
        multiline_threshold = 1,
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
        -- scrollview_winblend_gui = 90,
        base = 'right',
        signs_on_startup = {''},
        column = 1
      })
    end
  },
  { 'nmac427/guess-indent.nvim', -- set the indent size automatically
    config = true,
  },
  -- ### UI Interface
  { "SmiteshP/nvim-navic", -- show current code context
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require('nvim-navic').setup({
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
        separator = "  ",
        -- separator = " ⏵ ",
        -- separator = " 》 ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true
      })
      vim.cmd [[
        function! NavicColor()
          highlight NavicSeparator guifg=#4e5876 
        endfunction

        augroup NavicColorGroup
            autocmd!
            autocmd ColorScheme * call NavicColor() 
        augroup END
        call NavicColor() 
      ]]
    end,
  },
  { 'akinsho/bufferline.nvim', -- Bufferline
    enabled = false,
    config = function()
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
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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

      local navic_ok, navic = pcall(require, 'nvim-navic')
      local winbar_cfg = {}
      local inactive_winbar_cfg = {}

      local navic_context = {
        function()
          if navic.is_available() then
            local l = navic.get_location()
            if l ~= '' then
              return l
            end
            return ' '
          else
            return ' '
          end
        end,
        draw_empty = true,
        -- navic.get_location,
        -- cond = navic.is_available,
        padding = { left = 1, right = 0 },
      }
      local filepath = require('filepath')

      local my_filename = require('lualine.components.filename'):extend()
      my_filename.apply_icon = require('lualine.components.filetype').apply_icon
      my_filename.icon_hl_cache = {}
      my_filename.update_status = function(self)
        local super = getmetatable(getmetatable(self).__index)
        if vim.bo.filetype == 'oil' then
          self.options.path = 1
        end
        return super.update_status(self)
      end

      local util = require("onedark.util")

      -- local custom_theme = require'lualine.themes.onedark'
      -- local custom_theme = require'onedark.lualine.themes.onedark'
      -- local c = require('onedark.colors')
      -- local lighterB = 
      -- custom_theme.normal.b.bg = util.lighten(c.bg3, 0.95)
      --
      require('lualine').setup {

        options = {
          icons_enabled = true,
          theme = 'onedark2',
          -- theme = custom_theme,
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
          globalstatus = true,
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
            },
          },
          --[[
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
          --]]
          lualine_c = {
            -- { 'diff', separator = {} },
            navic_context,

          },
          lualine_b = {
            {
              'branch',
              separator = "",
            }, 
            -- {
            -- 'diff', -- git diff status
            -- }
          },
          lualine_x = {
            -- {
              -- filepath.get_path,
              -- padding = { left = 0, right = 0 },
              -- separator = ''
            -- },
            --
            {
              -- 'lsp_progress',
              -- display_components = { { 'title', 'percentage', 'message' } },
              -- spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏', },
              -- separator = {},
              function()
                -- invoke `progress` here.
                return require('lsp-progress').progress()
              end,
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = '' },
              diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.cyan },
              },
              separator = {},
              padding = {right = 0, left = 1},
            },
            {
              function()
                -- return '⌂ ' .. vim.fn.getcwd()
                return ' ' .. vim.fn.getcwd() .. ' '
              end,
              separator = {},
              padding = {right = 0, left = 1},
            },
            -- { require("lsp-progress").progress, },
            -- { require('lsp_spinner').status },
          },
          lualine_y = {
            { 'filetype',
              separator = "",
              padding = {left = 0, right = 0}, -- We don't need space before this
            },
            {
              function()
                -- local msg = 'no lsp'
                local msg = '-'
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    -- return ' ' -- client.name
                    return '⛩' -- client.name
                  end
                end
                return msg
              end,
              -- icon = ' ',
              separator = "",
              padding = {left = 1, right = 1 }, -- We don't need space before this
              -- color = { fg = '#ffffff', gui = 'bold' },
            },
          },
          lualine_z = { 
            { 
              function()
                local hn = vim.loop.os_gethostname()
                if hn == 'Supasorns-MacBook-Pro.local' then
                  return 'MBP'
                elseif hn == 'ssmb.local' then
                  return '⌂'
                  -- return '⌘'
                end
                return hn:gsub("vision", "v")
              end,
              padding = {left = 0, right = 1 }, -- We don't need space before this
            }
          }
        },
        -- tabline = { lualine_c = {navic_context} },
        tabline = {},

        winbar = {
          lualine_a = {},
          lualine_b = {
            {
              my_filename, colored = true,
              cond = function() return vim.bo.filetype == 'oil' end
            },
          },
          lualine_c = {
            -- navic_context
          },
          lualine_x = {
            -- filepath.get_path,
            -- { function() return ' ' end,
              -- separator = {}
            -- } 

            { 
              filepath.get_path,
              padding = { left = 0, right = 0 },
              color = {fg = util.darken(string.format("#%06x", utils.getHl("Comment").foreground), 0.93) }
            }
          },
          lualine_y = {
            {
              my_filename, colored = true,
              -- color = {fg = util.lighten(string.format("#%06x", utils.getHl("Function").foreground), 0.5) }
              -- color = {fg = string.format("#%06x", utils.getHl("Function").foreground) }
              -- separator = {left = '' },
              -- separator = {},
              padding = { left = 1, right = 1 },
              cond = function() return vim.bo.filetype ~= 'oil' end
            },
          },
          lualine_z = {}
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {
          },
          lualine_c = {},
          lualine_x = {
            -- { 
              -- filepath.get_path,
              -- padding = { left = 0, right = 0 },
              -- color = {fg = util.darken(string.format("#%06x", utils.getHl("Comment").foreground), 0.8) }
            -- }
          },
          lualine_y = {
            {
              my_filename, colored = true,
              -- color = {fg = 'Normal' }
              color = {fg = util.darken(string.format("#%06x", utils.getHl("Normal").foreground), 0.8) }
            }
          },
          lualine_z = {}
        },
        -- inactive_winbar = {},
        extensions = {}
      }

      local hl_groups = vim.fn.getcompletion('Navic*', 'highlight')
      local bgcolor = vim.api.nvim_get_hl_by_name('lualine_c_normal', true).background

      for _, group in ipairs(hl_groups) do
        local hl = vim.api.nvim_get_hl_by_name(group, true)
        hl.background = bgcolor
        vim.api.nvim_set_hl(0, group, hl)
      end
      -- vim.api.nvim_set_hl(0, "lualine_b_normal", { bg = 'red'})
      -- vim.api.nvim_set_hl(0, "WinBarPath", { fg = f.getHl("LineNR").fg, bg = bgcolor })


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
  { 'linrongbin16/lsp-progress.nvim',
    -- lazy = true,
    config = function()
      require('lsp-progress').setup {
        client_format = function(client_name, spinner, series_messages)
          if #series_messages == 0 then
            return nil
          end
          return {
            name = client_name,
            body = spinner .. " " .. table.concat(series_messages, ", "),
          }
        end,
        format = function(client_messages)
          --- @param name string
          --- @param msg string?
          --- @return string
          local function stringify(name, msg)
            return msg and string.format("%s %s", name, msg) or name
          end

          local sign = "" -- nf-fa-gear \uf013
          local lsp_clients = vim.lsp.get_clients()
          local messages_map = {}
          for _, climsg in ipairs(client_messages) do
            messages_map[climsg.name] = climsg.body
          end

          if #lsp_clients > 0 then
            table.sort(lsp_clients, function(a, b)
              return a.name < b.name
            end)
            local builder = {}
            for _, cli in ipairs(lsp_clients) do
              if
                type(cli) == "table"
                and type(cli.name) == "string"
                and string.len(cli.name) > 0
              then
                if messages_map[cli.name] then
                  table.insert(builder, stringify(cli.name, messages_map[cli.name]))
                -- else
                  -- table.insert(builder, stringify(cli.name))
                  -- table.insert(builder, '')
                end
              end
            end
            if #builder > 0 then
              -- return sign .. " " .. table.concat(builder, ", ")
              return table.concat(builder, ", ")
            end
          end
          return ""
        end,
      }
    end,
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
  { 'folke/which-key.nvim', -- Show keymaps
    -- event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    cmd = "WhichKey",
  },
  -- ### File browser, FZF, Telescope
  { 'stevearc/oil.nvim', -- file explorer as vim buffer. support ssh
    keys = {
      { "<f3>", ":Oil<CR>", mode = { "n", "v" } },
      { "<f3>", "<esc>:Oil<CR>", mode = { "i" } },
    },
    opts = {
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
    },
  },
  { 'kyazdani42/nvim-tree.lua', -- Directory browser
    keys = {
      { Myleader .. "t", ":NvimTreeToggle %:p:h<cr>", desc="NvimTreeToggle" }
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require 'nvim-tree'.setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = false,
          -- mappings = {
            -- list = {
              -- { key = "u", action = "dir_up" },
            -- },
          -- },
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
    keys = { { Myleader .. "p", ":FZFMru --no-sort<CR>", mode = "n" } },
  },
  { 'ibhagwan/fzf-lua', -- fzf with native preview, etc
    cmd = { "FzfLua" },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { "?", ':lua require("fzf-lua").blines({prompt=" > "})<cr>' },
      { "<s-r>", ':lua require("fzf-lua").command_history({prompt=" > "})<cr>' },
      { Myleader .. "o", ':lua require("fzf-lua").buffers({prompt=" > "})<cr>', mode = "n", desc="buffers"},
      { Myleader .. "f", ':lua require("fzf-lua").files()<cr>', mode = "n", desc="find files"},
      { Myleader .. "/", ':lua require("fzf-lua").grep_project()<cr>', mode = "n", desc="search"},
      { Myleader .. "c", ':lua require("extra").fzf_change_dir()<cr>', mode = "n", desc="change current directory"},
      { "g/", ':lua require("fzf-lua").grep_visual()<cr>', mode = "v", desc="grep current selection"},
      -- { Myleader .. "/", ':lua require("fzf-lua").grep({rg_opts=vim.g.rgmode_rgopt, cwd=vim.fn.getcwd(), search="", fzf_cli_args=""})<cr>', mode = "n", desc="search"},

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
      keymap = {
        fzf = {
          ["å"]       = "toggle-all",
        }
      },
      fzf_opts = {
        ['--layout'] = false,
      },
      buffers = {
        previewer = false,
        headers = {},
        fzf_opts={
          ["--delimiter"]=" ",
          ["--with-nth"]="-1..",
          ["--header-lines"] = false,
        }
        -- fzf_opts = {
          -- ['--layout'] = 'reverse-list',
          -- hide tabnr
          -- ['--delimiter'] = ":",
          -- ["--with-nth"]  = '0',
        -- }
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
      -- { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'marcuscaisey/olddirs.nvim' },
      { 'junegunn/fzf' },
    },
    cmd = { "Telescope" },
    -- keys = { "<f2>", "gr", "<leader>od" },
    keys = {
      {Myleader .. "i", desc="file browser"},
      {Myleader .. "d", desc="old directories"},
    },

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

      map({ 'n' }, Myleader .. "i",
        function() require "telescope".extensions.file_browser.file_browser({
            path = '%:p:h',
            -- previewer = true,
            hidden = true,
            hide_parent_dir = true, grouped = true,
            display_stat = false,
            preview = {
              ls_short = true,
            }
          })
        end)
      map({ 'n' }, Myleader .. "d", require "telescope".extensions.olddirs.picker, {desc = "old directories"})

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
  { 'echasnovski/mini.files',
    keys = {
      { "<f2>", ":lua MiniFiles.open()<CR>", mode = { "n", "v" } },
      { "<f2>", "<esc>:lua MiniFiles.open()<CR>", mode = { "i" } },
    },
    version = '*',
    config = true,
    opts = {
      mappings = {
        go_in_plus = '<enter>',
      },
    },
  },
  -- ### LSP, Treesitter, Tags
  { "jose-elias-alvarez/null-ls.nvim", -- For adding format() to lsp, etc
    keys = {
      { "<leader>f", vim.lsp.buf.format, mode = { "n", "v" }, desc="format code" }
    },
    config = function()
      -- local map = require("utils").map
      -- map(, "<leader>f", vim.lsp.buf.format)
      require("null-ls").setup({
        sources = {
          -- require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.formatting.autopep8.with({
            extra_args = {
              "--indent-size", "2"
            }
          }),
        },
      })
    end
  },
  { 'rmagatti/goto-preview', -- Goto preview with nested!
    -- event = "VeryLazy",
    keys = {
      { "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>" },
      -- { "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>" }
      { "gr", "<cmd>lua vim.lsp.buf.references()<CR>" }
    },
    opts = {
      -- width = 150,
    },
    dependencies = { 'rmagatti/logger.nvim' },

  },
  { "williamboman/mason.nvim", -- Lsp Installer
    cmd = { "Mason", "MasonLog", "MasonInstall", "MasonUninstall" },
    config = true,
  },
  { 'williamboman/mason-lspconfig.nvim', -- Mason-Lsp interface
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed       = { "pyright", "html", "cssls", "eslint", "lua_ls" },
      automatic_installation = true,
    },
  },
  { 'neovim/nvim-lspconfig', -- Lspconfig
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",   -- for capabilities
      "SmiteshP/nvim-navic",    -- you already use this in on_attach
    },
    config = function()
      local lspconfig    = require("lspconfig")
      local mason_lsp    = require("mason-lspconfig")
      local navic        = require("nvim-navic")

      local capabilities = require("cmp_nvim_lsp")
                           .default_capabilities(vim.lsp.protocol
                           .make_client_capabilities())

      local function on_attach(client, bufnr)
        navic.attach(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
      end

      mason_lsp.setup({
        -- If you want Mason to *also* attach servers automatically, add
        -- automatic_setup = true,
        handlers = {
          -- 1️⃣ default for every server -------------------------------
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach    = on_attach,
            })
          end,

          -- 2️⃣ lua_ls override ----------------------------------------
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              on_attach    = on_attach,
              settings     = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                },
              },
            })
          end,

          -- 3️⃣ pyright override ---------------------------------------
          pyright = function()
            lspconfig.pyright.setup({
              capabilities = capabilities,
              on_attach    = on_attach,
              settings     = {
                python = {
                  analysis = {
                    autoSearchPaths        = true,
                    diagnosticMode         = "openFilesOnly",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode       = "off",
                  },
                },
              },
            })
          end,
        },
      })
    end,
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
            if vim.api.nvim_buf_line_count(0) > 5000 or vim.fn.getfsize(vim.fn.expand('%')) > 1024 * 200 then
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
            -- scope_incremental = "<tab>",
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
    opts = {
      position = "right",
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
      },
    }
  },
  { 'kevinhwang91/nvim-bqf', -- make quickfix list fancy, preview, fzf
    -- enabled = false,
    event = "VeryLazy",
    opts = {
    }
  },
  { 'mfussenegger/nvim-dap', -- debugger
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui', -- (Optional: for a nice UI)
      'nvim-neotest/nvim-nio'
    },
    keys = {
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<F4>", function() require("dap").step_out() end, desc = "Toggle Breakpoint" },
      { "<leader>r", function() require("extra").RunDebugFromComment() end,         desc = "Start/Continue Debugging" },
      { "<F5>", function() require("dap").continue() end,         desc = "Start/Continue Debugging" },
      { "<F6>", function() require("dap").step_over() end,        desc = "Step Over" },
      { "<F7>", function() require("dap").step_into() end,        desc = "Step Into" },
    },
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
    cmd = { "Remove", "Delete", "Move", "SudoWrite", "SudoEdit", "Chmod", "Mkdir", "Rename" }
  },
  { 'lambdalisue/vim-suda',
    cmd = { "SudaWrite" }
  },
  { 'wesQ3/vim-windowswap', -- \ww swap two windows
    keys = {{"<leader>ww", desc="swap two windows"}}
  },
  { 'tpope/vim-fugitive', -- For git
    keys = {
      { "<leader>gs", ":Git<cr>", desc="git" },
      { "<leader>gc", ':Git commit -m "auto commit"<cr>', desc="git auto commit" },
      { "<leader>gp", ":Git push<cr>", desc="git push" },
      { "<leader>gq", 'gq :Git commit -m "auto commit" | Git push<cr>', remap = true, desc="git commit + push"},
    },
    cmd = { "Git" },
  },
  { 'sindrets/diffview.nvim', -- for git diff
    cmd = {'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'},

  },

  { 'github/copilot.vim',
    enabled = false,
    keys = { { "<f10>", "<esc>:Copilot<cr>", mode = { "i" } }, { "<f10>", ":Copilot<cr>", mode = { "n", "v" } } },
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      -- vim.g.copilot_filetypes = {
        -- ['*'] = false,
      -- }
      -- vim.g.copilot_tab_fallback = ""
      vim.cmd [[
        imap <silent><script><expr> <c-n> copilot#Accept("\<CR>")
      ]]
    end,
  },
  { 'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<c-n>",
          accept_word = false,
          accept_line = false,
          next = "<c-,>",
          prev = "<c-.>",
          dismiss = "<c-m>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
  },
  { 'CopilotC-Nvim/CopilotChat.nvim',
    enabled = true,
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    keys = {
      { Myleader .. "q",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      }
    },
  },
}
