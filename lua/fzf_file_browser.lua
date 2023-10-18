_G.fzf_dirs = function(opts)
  local fzf_lua = require'fzf-lua'
  opts = opts or {}
  opts.prompt = "Directories> "

  local cwd = vim.fn.getcwd()
  opts.fn_transform = function(x)
    -- Remove the prefix (cwd) from the directory path
    -- x = x:gsub("^" .. vim.fn.escape(cwd, "/") .. "/", "")
    x = x:gsub("^" .. cwd .. "/", "")
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ['default'] = function(selected)
      -- vim.cmd("cd " .. selected[1])
      fzf_lua.fzf_exec("fd --type d . " .. vim.fn.getcwd() .. "/" .. selected[1], opts)
    end,
    ['ctrl-w'] = { 
      function(selected, opts)
        local prompt_text = opts.prompt_text or ""
        print("selected item:", selected[1])
        print(prompt_text)
      end,
      fzf_lua.actions.resume
      -- Remove the current word in the prompt
      -- local prompt_text = session.prompt_text or ""
      -- print(prompt_text)
      -- local word_start, word_end = string.find(prompt_text, "%f[%w]%w+%f[%W]", 1)
      -- if word_start and word_end then
        -- local new_prompt = string.sub(prompt_text, 1, word_start - 1) .. string.sub(prompt_text, word_end + 1)
        -- session:set_prompt(new_prompt)
      -- end
    }
  }
  fzf_lua.fzf_exec("fd --type d . " .. vim.fn.getcwd(), opts)
end

-- map our provider to a user command ':Directories'
vim.cmd([[command! -nargs=* Directories lua _G.fzf_dirs()]])

-- or to a keybind, both below are (sort of) equal
-- vim.keymap.set('n', '<C-k>', _G.fzf_dirs)
-- vim.keymap.set('n', '<C-k>', '<cmd>lua _G.fzf_dirs()<CR>')

-- We can also send call options directly
-- :lua _G.fzf_dirs({ cwd = <other directory> })
