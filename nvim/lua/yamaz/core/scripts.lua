local utils = require('yamaz.core.utils')
local snippets = require('yamaz.core.snippets')

-- #1
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (coping) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- #2
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Custom setting for term',
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

-- #3
vim.api.nvim_create_autocmd('FileType', {
    -- Для JS/TS файлов
    desc = 'Apply custom snippets from snippets.lua file',
    pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    callback = function()
        utils.apply_snippets(snippets.snippets)
    end
})

-- #4
vim.api.nvim_create_autocmd("Filetype", {
    pattern = "norg",
         callback = function()
        vim.keymap.set("n", "<localleader>n", function()
            print("Neorg mapping!")
        end, { buffer = true, silent = true })
        -- раскрывет все блоки в заметках Neorg
         vim.schedule(function()
            vim.cmd("normal! zR")
        end)
    end,
})
