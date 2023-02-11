-- Our lua/utils.lua file
local M = {}
local api = vim.api
local autocmd = vim.api.nvim_create_autocmd


function M.map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    -- print(vim.inspect(options))
    vim.keymap.set(mode, lhs, rhs, options)
end


M.run_without_TSContext = function(f, opts)
  opts = opts or {}
  return function()
    vim.cmd ":TSContextDisable"
    f(opts)
    -- require'hop'.hint_char1()
    vim.cmd ":TSContextEnable"
    if opts["postcmd"] ~= nil then
      vim.api.nvim_feedkeys(opts["postcmd"], '', true)
    end
  end
end

return M
