-- plugins/dressing.lua
-- В 0.12 часть декораций встроена (vim.ui.select / vim.ui.input), но
-- dressing.nvim по-прежнему полезен для input() и select().
local M = {}

function M.setup()
    require("dressing").setup({
        input = { enabled = true },
        select = { enabled = true, backend = "telescope" },
    })
end

return M