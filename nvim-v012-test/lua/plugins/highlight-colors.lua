-- plugins/highlight-colors.lua
local M = {}

function M.setup()
    vim.opt.termguicolors = true
    pcall(function()
        require("nvim-highlight-colors").setup({
            render = "virtual",
        })
    end)
end

return M