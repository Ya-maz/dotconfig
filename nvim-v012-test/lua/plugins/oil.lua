-- plugins/oil.lua
-- Без изменений по содержанию. Просто оборачиваем в setup().
local M = {}

function M.setup()
    require("oil").setup({
        default_file_explorer = true,
        columns = { "icon", "size" },
        buf_options = { buflisted = false, bufhidden = "hide" },
        win_options = {
            wrap = false,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = false },
        constrain_cursor = "editable",
        watch_for_changes = false,
        use_default_keymaps = true,
        keymaps = {
            ["yp"] = {
                desc = "Copy filepath to system clipboard",
                callback = function()
                    require("oil.actions").copy_entry_path.callback()
                    vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
                end,
            },
        },
        view_options = {
            show_hidden = true,
            is_hidden_file = function(name) return vim.startswith(name, ".") end,
            is_always_hidden = function() return false end,
            natural_order = true,
            case_insensitive = false,
            sort = {
                { "type", "asc" },
                { "name", "asc" },
            },
        },
        float = { padding = 2, max_width = 0, max_height = 0, border = "rounded" },
        preview = { max_width = 0.9, min_width = { 40, 0.4 }, max_height = 0.9, min_height = { 5, 0.1 }, border = "rounded", update_on_cursor_moved = true },
        progress = { max_width = 0.9, min_width = { 40, 0.4 }, max_height = { 10, 0.9 }, min_height = { 5, 0.1 }, border = "rounded" },
        ssh = { border = "rounded" },
        keymaps_help = { border = "rounded" },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M