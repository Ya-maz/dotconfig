-- plugins/harpoon.lua
-- В 0.12 + vim.pack мы вручную вызываем setup() и keymap.
local M = {}

function M.setup()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap
    keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    -- <C-F1>...<C-F5> для выбора файлов harpoon.
    -- Ctrl+F, чтобы избежать перехвата Alt+F4 (закрывает терминал в Windows).
    keymap.set("n", "<C-F1>", function() harpoon:list():select(1) end)
    keymap.set("n", "<C-F2>", function() harpoon:list():select(2) end)
    keymap.set("n", "<C-F3>", function() harpoon:list():select(3) end)
    keymap.set("n", "<C-F4>", function() harpoon:list():select(4) end)
    keymap.set("n", "<C-F5>", function() harpoon:list():select(5) end)

    keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end

return M