-- plugins/spelunker.lua
local M = {}

function M.setup()
    vim.g.spelunker_highlight_type = 2
    vim.g.spelunker_complex_orphan_check = 1
    vim.g.spelunker_max_suggestions = 10
    vim.g.enable_spelunker_vim = 1
    vim.g.spelunker_check_type = 1
    vim.g.spelunker_white_list_for_user = {
        "kamykn", "vimrc", "yamaz", "eslint", "classnames", "guid",
        "rshb", "ILOV", "ILOVItem",
    }
end

return M