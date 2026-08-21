-- plugins/colorschema.lua
-- В отличие от lazy.nvim, vim.pack.add() не принимает `config` функции.
-- Каждый плагин конфигурируется ВРУЧНУЮ через require("...").setup().
-- Поэтому этот файл просто ЭКСПОРТИРУЕТ функцию setup(),
-- которая вызывается из init.lua.
local M = {}

function M.setup()
    local fg_gutter = "#627E97"
    require("tokyonight").setup({
        style = "storm",
        on_colors = function(colors)
            colors.fg_gutter = fg_gutter
        end,
    })
    vim.cmd.colorscheme("tokyonight")
end

return M