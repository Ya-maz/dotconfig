--vim.opt.guicursor = ""

vim.opt.clipboard = ""
vim.opt.nu = true
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
--
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
--
vim.opt.updatetime = 50
--
vim.opt.colorcolumn = "80"

-- Чтобы Esc после insert mode не "съедался" как Meta (Alt+h/j/k/l и т.п.)
-- если сразу жать навигацию. ttimeoutlen работает только для маппингов
-- типа <Esc>, timeoutlen — для остальных. Уменьшаем, чтобы быстрый
-- Esc + буква не превращался в Alt+буква (иначе harpoon кидает в другой буфер).
vim.opt.ttimeoutlen = 100
vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

-- включить проверку орфографии
-- vim.opt.spell = true
-- vim.opt.spelllang = "en"

