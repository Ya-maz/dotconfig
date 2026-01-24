local utils = require("yamaz.core.utils")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ~/.config/nvim/test_init.lua
-- require('lazy').setup({
-- {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}}
-- })
--
if utils.is_ultra_weak_mode() then
    print("Ultra weak mode enabled! (core only and oil plugin)")
    require("lazy").setup({
        { import = "yamaz.plugins.oil" },
    })
    return
end

if utils.is_weak_mode() then
    -- Легкая конфигурация
    -- Как открыть редактор без lsp, eslint, eslintd (замедляет работу редактора)
    -- nvim --cmd "let g:weak_mode = 1"
    -- Добавлен alias
    -- alias nn='nvim --cmd "let g:weak_mode = 1"'
    print("Weak mode enabled!")
    require("lazy").setup({
        { import = "yamaz.plugins" },
    })
    return
end

-- Обычная конфигурация
-- Добавлен alias
-- alias n='nvim'
print("Normal mode enabled!")
require("lazy").setup({
    { import = "yamaz.plugins" },
    { import = "yamaz.plugins.lsp" }
})
