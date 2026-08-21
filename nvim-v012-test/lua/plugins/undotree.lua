-- plugins/undotree.lua
-- В 0.12 ЕСТЬ ВСТРОЕННЫЙ :Undotree, но mbbill/undotree визуально приятнее
-- и привычнее по keymap'ам. Оставляем.
local M = {}

function M.setup()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
end

return M