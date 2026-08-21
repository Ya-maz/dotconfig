-- plugins/hlchunk.lua
local M = {}

function M.setup()
    pcall(function()
        require("hlchunk").setup({
            chunk = { enable = true },
        })
    end)
end

return M