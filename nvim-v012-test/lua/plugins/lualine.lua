-- plugins/lualine.lua
-- В 0.12 есть встроенный statusline, но lualine гибче.
local M = {}

function M.setup()
    local lualine = require("lualine")

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "horizon",
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = {
                { "filename" },
            },
            lualine_x = {
                { "encoding" },
                { "fileformat" },
                { "filetype" },
            },
        },
        tabline = {},
        extensions = { "fugitive" },
    })
end

return M