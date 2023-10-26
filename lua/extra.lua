local M = {}
function GetParents(dir)
  dir = vim.fn.fnamemodify(dir, ':p:h')
  local arr = { dir }

  while true do
    local par = vim.fn.fnamemodify(dir, ':h')
    if par == dir then
      break
    end

    table.insert(arr, par)
    dir = par
  end

  return arr
end

function RgModeFZFLua()
  local gitpath = vim.fn.system('cd ' .. vim.fn.shellescape(vim.fn.expand('%:p:h')) .. ' && git rev-parse --show-toplevel 2> /dev/null'):sub(1, -2)
  local file = vim.fn.expand("%")

  local folders = GetParents(file)

  local list = {" 0:G) git   [" .. gitpath .. "]"}
  local counter = 1
  for _, i in ipairs(folders) do
    local ts = tostring(counter)
    if counter < 10 then
      ts = ' ' .. ts
    end
    local alias = '     '
    if i == gitpath then
      alias = 'git  '
    elseif i == vim.fn.expand('~') then
      alias = 'home '
    end

    table.insert(list, ts .. ':' .. string.char(string.byte('a') + counter - 1) .. ') ' .. alias .. ' [' .. i .. ']')
    counter = counter + 1
  end

  return list
end

M.fzf_change_dir = function(opts)
  local fzf_lua = require'fzf-lua'
  opts = opts or {}
  opts.prompt = "> "
  -- opts.fn_transform = function(x)
    -- return fzf_lua.utils.ansi_codes.magenta(x)
  -- end
  opts.actions = {
    ['default'] = function(selected)
      -- check if there's symbol '[' in selected[1]
      -- if so, then it's a special path and cd to the path inside []
      -- if not, then it's a normal path and cd to selected[1]
      local start, _ = string.find(selected[1], '%[')
      local cd = selected[1]
      if start ~= nil then
        local endd, _ = string.find(selected[1], '%]')
        local path = string.sub(selected[1], start + 1, endd - 1)
        cd = path
      end
      vim.cmd("cd " .. cd)
      -- vim.notify(' ' .. cd, vim.log.levels.INFO, {title="Find Path Cwd"})
    end
  }

  local parents = RgModeFZFLua()
  local olddir = require 'olddirs'.get()

  for _, d in ipairs(olddir) do
    table.insert(parents, d)
  end

  fzf_lua.fzf_exec(parents, opts)
end

return M
