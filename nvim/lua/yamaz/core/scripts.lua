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

