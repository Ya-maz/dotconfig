local utils = require("yamaz.core.utils")
local snippets = require("yamaz.core.snippets")

-- #1
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (coping) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- -- #2
-- vim.api.nvim_create_autocmd('TermOpen', {
--     desc = 'Custom setting for term',
--     group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
--     callback = function()
--         vim.opt.number = false
--         vim.opt.relativenumber = false
--     end,
-- })

-- #3
vim.api.nvim_create_autocmd("FileType", {
    -- Для JS/TS файлов
    desc = "Apply custom snippets from snippets.lua file",
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        utils.apply_snippets(snippets.snippets)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
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

vim.api.nvim_create_user_command("Gittoql", function()
    -- Получаем список изменённых файлов через git
    local output = vim.fn.systemlist("git status --porcelain | cut -c4-")
    local qf_items = {}
    for _, f in ipairs(output) do
        if f ~= "" then
            table.insert(qf_items, { filename = f, lnum = 1, col = 1, text = "" })
        end
    end
    -- Заполняем quickfix list и открываем
    vim.fn.setqflist(qf_items, "r")
    vim.cmd("copen")
end, {})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
    pattern = { ".env", ".env.*" },
    callback = function()
        vim.bo.filetype = "dosini"
    end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = "active_cursorline",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
