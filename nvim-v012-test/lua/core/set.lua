vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Базовые опции редактора
vim.opt.clipboard = ""
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- Чтобы Esc после insert mode не "съедался" как Meta
vim.opt.ttimeoutlen = 100
vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

-- 0.12: shelltemp по умолчанию false
vim.opt.shelltemp = false

-- 0.12: popup-настройки
vim.opt.pumblend = 0
vim.opt.pumborder = "rounded"

-- WSL/Windows clipboard
vim.g.clipboard = {
    name = "win32yank",
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
}

-- 0.12: DiagnosticSign* через vim.diagnostic.config, sign_define deprecated
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = true,
        border = "rounded",
    },
})
