local M = {}

local frames = { "⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏" }
local timer = nil

local function any_building()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ok, building = pcall(vim.api.nvim_buf_get_var, buf, 'building')
    if ok and (building == true or building == 1) then
      return true
    end
  end
  return false
end

function M.start()
  if timer then
    return
  end

  timer = vim.loop.new_timer()
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if not any_building() then
        M.stop()
        vim.cmd("redrawstatus")
        return
      end

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local ok, building = pcall(vim.api.nvim_buf_get_var, buf, 'building')
        if ok and building then
          local ok2, idx = pcall(vim.api.nvim_buf_get_var, buf, 'spinner_index')
          idx = (ok2 and idx or 0)
          idx = (idx % #frames) + 1
          pcall(vim.api.nvim_buf_set_var, buf, 'spinner_index', idx)
        end
      end

      vim.cmd("redrawstatus")
    end)
  )
end

function M.stop()
  if timer then
    if timer:is_active() then timer:stop() end
    if not timer:is_closing() then timer:close() end
    timer = nil
  end
end

function M.spinner_component()
  -- return "a"
  if not vim.b.building then
    return ""
  end
  local i = vim.b.spinner_index or 1
  return frames[i]
end

return M

