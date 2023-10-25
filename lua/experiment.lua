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

function test()
  local parents = GetParents('/Users/supasorn/research/ddpm')
  local olddir = require 'olddirs'.get()

  for _, d in ipairs(olddir) do
    table.insert(parents, d)
  end

  -- Loop through the table and print each element
  for i, parent in ipairs(parents) do
    print(i, parent)
  end
end
