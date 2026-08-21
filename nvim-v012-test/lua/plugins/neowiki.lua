-- plugins/neowiki.lua
local M = {}

function M.setup()
    pcall(function()
        require("neowiki").setup({
            wiki_dirs = {
                { name = "Notes", path = "~/notes" },
            },
            discover_nested_roots = true,
            -- Отключаем стандартные keymaps neowiki для перехода по ссылкам,
            -- чтобы не конфликтовать с обычным Vim <CR>.
            keymaps = {
                action_link = "",
                action_link_vsplit = "",
                action_link_split = "",
            },
        })
    end)

    local km = vim.keymap
    km.set("n", "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>", { desc = "Open Wiki" })
    km.set("n", "<leader>wW", "<cmd>lua require('neowiki').open_wiki_floating()<cr>", { desc = "Open Wiki in Floating Window" })
    km.set("n", "<leader>wT", "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>", { desc = "Open Wiki in Tab" })
end

return M