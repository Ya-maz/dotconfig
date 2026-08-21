-- Подсветка при yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (coping) text",
    group = vim.api.nvim_create_augroup("yamaz-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Кастомные сниппеты для JS/TS
vim.api.nvim_create_autocmd("FileType", {
    desc = "Apply custom JS/TS keymaps (snippets)",
    group = vim.api.nvim_create_augroup("yamaz-js-ts-snippets", { clear = true }),
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        local map_opts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set("n", "<leader>log",
            [[i// eslint-disable-next-line no-console<CR>console.log('%chint', 'background-color: green', params);<CR><Esc>O]],
            vim.tbl_extend("force", map_opts, { desc = "Insert debug console.log" }))
        vim.keymap.set("n", "<leader>arr",
            [[iconst fn = (arguments) => {<CR>return <CR>}<Esc>]],
            vim.tbl_extend("force", map_opts, { desc = "Insert arrow function" }))
    end,
})

-- npm test интеграция (quickfix)
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("yamaz-js-ts-makeprg", { clear = true }),
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
        vim.bo.makeprg = "npm run test"
        vim.bo.errorformat = table.concat({
            [[%E%f:%l:%c\ -\ error\ %m,]],
            [[%Z%l%*\\s%m,]],
            [[%Z%*\\s%p^,]],
            [[%-G%.%#]],
        }, "")
    end,
})

-- Команда :Gittoql
vim.api.nvim_create_user_command("Gittoql", function()
    local output = vim.fn.systemlist("git status --porcelain | cut -c4-")
    local qf_items = {}
    for _, f in ipairs(output) do
        if f ~= "" then
            table.insert(qf_items, { filename = f, lnum = 1, col = 1, text = "" })
        end
    end
    vim.fn.setqflist(qf_items, "r")
    vim.cmd("copen")
end, {})

-- .env как dosini
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
    pattern = { ".env", ".env.*" },
    callback = function()
        vim.bo.filetype = "dosini"
    end,
})

-- cursorline только в активном окне
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = "active_cursorline",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
