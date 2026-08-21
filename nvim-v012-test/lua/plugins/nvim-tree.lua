-- plugins/nvim-tree.lua
-- ВАЖНО: плагин сейчас у пользователя отключён (`enable = false`),
-- включается через <leader>ee. Оставляем как было.
local M = {}

function M.setup()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
    vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

    nvimtree.setup({
        view = { width = 35, relativenumber = true },
        renderer = {
            indent_markers = { enable = true },
        },
        actions = {
            open_file = { window_picker = { enable = false } },
        },
        filters = { custom = { ".DS_Store" } },
        git = { ignore = false },
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
end

return M